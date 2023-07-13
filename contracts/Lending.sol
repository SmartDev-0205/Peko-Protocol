// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Claimable is Ownable {
    function claimToken(
        address tokenAddress,
        uint256 amount
    ) external onlyOwner {
        IERC20(tokenAddress).transfer(owner(), amount);
    }

    function claimETH(uint256 amount) external onlyOwner {
        (bool sent, ) = owner().call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}

contract Lending is Claimable {
    struct Position {
        mapping(address => uint256) tokenColAmount; //deposit amount for token
        mapping(address => uint256) tokenDebtAmount; //borrow amount for token
    }

    struct UserInfo {
        Position position;
        uint256 lastInterest; //last timestamp that calcuate interest
    }

    struct UserInfoForDisplay {
        uint256 ehtColAmount;
        uint256 ehtDebtAmount;
        uint256 usdtColAmount;
        uint256 usdtDebtAmount;
    }

    struct Interest {
        uint ethColAmount;
        uint usdtColAmount;
        uint pekoAmount;
    }

    struct PoolInfo {
        uint rate;
        uint LTV;
        uint depositApy;
        uint borrowApy;
        uint256 totalAmount;
        uint256 borrowAmount;
        // uint256 maxIndex;
        // mapping(uint256 => Position) positions;
        // mapping(address => uint256) positionsIndex;
    }

    mapping(address => PoolInfo) poolInfos;
    uint256 maxUserIndex;
    mapping(uint256 => UserInfo) userInfos;
    mapping(address => uint256) userInfoIndex;

    address rewardAddress;
    address ethAddress;
    address usdtAddress;
    uint liquidationThreshhold = 90;
    uint decimal = 1000000;

    // ---------------------------------------------------------------------
    // EVENTS
    // ---------------------------------------------------------------------

    // ---------------------------------------------------------------------
    // CONSTRUCTOR
    // ---------------------------------------------------------------------
    constructor(
        address _rewardAddress,
        address _ethAdddress,
        address _usdtAddress
    ) {
        rewardAddress = _rewardAddress;
        ethAddress = _ethAdddress;
        usdtAddress = _usdtAddress;
        addPool(ethAddress, 1, 50, 4, 4, 0, 0);
        addPool(usdtAddress, 1, 50, 4, 4, 0, 0);
    }

    function addPool(
        address _tokenAddress,
        uint _rate,
        uint _LTV,
        uint _depositApy,
        uint _borrowApy,
        uint256 _totalAmount,
        uint256 _borrowAmount
    ) private {
        PoolInfo storage newPoolInfo = poolInfos[_tokenAddress];
        newPoolInfo.rate = _rate;
        newPoolInfo.LTV = _LTV;
        newPoolInfo.depositApy = _depositApy;
        newPoolInfo.borrowApy = _borrowApy;
        newPoolInfo.totalAmount = _totalAmount;
        newPoolInfo.borrowAmount = _borrowAmount;
    }

    function calcTokenPrice(
        address _tokenAddress
    ) public view returns (uint256) {
        if (_tokenAddress == usdtAddress) return 1;
        else {
            return 1000;
        }
    }

    function calcCollater() public view returns (uint256) {
        uint256 userIndex = userInfoIndex[msg.sender];
        require(userIndex > 0, "User index should be bigger than 0.");
        UserInfo storage user = userInfos[userIndex];

        Position storage position = user.position;
        // eth deposit to usdt amount
        uint256 ethCollater = position.tokenColAmount[ethAddress] *
            calcTokenPrice(ethAddress);
        // usdt deposit to usdt amount
        uint256 usdtCollater = position.tokenColAmount[usdtAddress] *
            calcTokenPrice(usdtAddress);
        return ethCollater + usdtCollater;
    }

    function calcDebt() public view returns (uint256) {
        uint256 userIndex = userInfoIndex[msg.sender];
        require(userIndex > 0, "User index should be bigger than 0.");
        UserInfo storage user = userInfos[userIndex];

        Position storage position = user.position;
        // eth deposit to usdt amount
        uint256 ethDebt = position.tokenDebtAmount[ethAddress] *
            calcTokenPrice(ethAddress);
        // usdt deposit to usdt amount
        uint256 usdtDebt = position.tokenDebtAmount[ethAddress] *
            calcTokenPrice(ethAddress);
        return ethDebt + usdtDebt;
    }

    function calcuateInterest() public view returns (Interest memory) {
        uint256 userIndex = userInfoIndex[msg.sender];
        require(userIndex > 0, "User index should be bigger than 0.");
        UserInfo storage user = userInfos[userIndex];

        Interest memory interest = Interest({
            ethColAmount: 0,
            usdtColAmount: 0,
            pekoAmount: 0
        });
        Position storage position = user.position;
        // calu interest
        PoolInfo storage ethPool = poolInfos[ethAddress];
        PoolInfo storage usdtPool = poolInfos[usdtAddress];
        if (position.tokenColAmount[ethAddress] > 0) {
            interest.ethColAmount +=
                (position.tokenColAmount[ethAddress] * ethPool.depositApy) /
                decimal;
            interest.pekoAmount +=
                (position.tokenColAmount[ethAddress] * ethPool.depositApy) /
                decimal;
        } else {
            interest.usdtColAmount +=
                (position.tokenColAmount[usdtAddress] * usdtPool.depositApy) /
                decimal;
            interest.pekoAmount +=
                (position.tokenColAmount[usdtAddress] * usdtPool.depositApy) /
                decimal;
        }
        return interest;
    }

    function liquidityInterest(address _account) private {
        Interest memory interest = calcuateInterest();
        if (interest.ethColAmount > 0) {
            (bool sent, ) = payable(_account).call{
                value: interest.ethColAmount
            }("");
            require(sent, "failed to send eth interest.");
        } else if (interest.usdtColAmount > 0) {
            IERC20(usdtAddress).transfer(_account, interest.usdtColAmount);
        }

        if (interest.pekoAmount > 0) {
            IERC20(rewardAddress).transfer(_account, interest.pekoAmount);
        }
        uint256 userIndex = userInfoIndex[_account];
        require(userIndex > 0, "User index should be bigger than 0.");
        userInfos[userIndex].lastInterest = block.timestamp;
    }

    function deposit(address _tokenAddress, uint256 _amount) public payable {
        require(_amount > 0, "can't deposit 0");
        uint256 userIndex = 0;
        if (userInfoIndex[msg.sender] == 0) {
            maxUserIndex += 1;
            userIndex = maxUserIndex;
            userInfoIndex[msg.sender] = userIndex;
        } else {
            userIndex = userInfoIndex[msg.sender];
            liquidityInterest(msg.sender);
        }
        UserInfo storage currentUserInfo = userInfos[userIndex];
        require(
            currentUserInfo.position.tokenDebtAmount[_tokenAddress] == 0,
            "Please repay token first."
        );
        currentUserInfo.position.tokenColAmount[_tokenAddress] += _amount;
        if (_tokenAddress == usdtAddress) {
            require(
                IERC20(usdtAddress).transferFrom(
                    msg.sender,
                    address(this),
                    _amount
                ),
                "deposit failed"
            );
        }
    }

    function borrow(address _tokenAddress, uint256 _amount) public {
        require(_amount > 0, "can't borrow 0");
        uint256 userIndex = userInfoIndex[msg.sender];
        require(userIndex > 0, "User index should be bigger than 0.");
        UserInfo storage currentUserInfo = userInfos[userIndex];
        require(
            currentUserInfo.position.tokenColAmount[_tokenAddress] == 0,
            "Please withdraw token first."
        );

        uint256 borrowAmountToUsdt = calcTokenPrice(_tokenAddress) * _amount;
        uint256 userCol = calcCollater() - calcDebt();
        uint LTV = poolInfos[_tokenAddress].LTV;
        require(
            (userCol * LTV) / 100 > borrowAmountToUsdt,
            "Please deposit more."
        );
        currentUserInfo.position.tokenDebtAmount[_tokenAddress] += _amount;

        if (_tokenAddress == ethAddress) {
            (bool sent, ) = payable(msg.sender).call{value: _amount}("");
            require(sent, "failed to send eth interest.");
        } else {
            IERC20(usdtAddress).transfer(msg.sender, _amount);
        }
    }

    function repay(address _tokenAddress, uint256 _amount) public payable {
        require(_amount > 0, "can't repay 0");
        uint256 userIndex = userInfoIndex[msg.sender];
        require(userIndex > 0, "User index should be bigger than 0.");
        UserInfo storage currentUserInfo = userInfos[userIndex];
        currentUserInfo.position.tokenDebtAmount[_tokenAddress] -= _amount;
        if (_tokenAddress == usdtAddress) {
            require(
                IERC20(usdtAddress).transferFrom(
                    msg.sender,
                    address(this),
                    _amount
                ),
                "deposit failed"
            );
        } else {
            require(msg.value >= _amount, "Please pay more.");
        }
    }

    function withdraw(address _tokenAddress, uint256 _amount) public {
        require(_amount > 0, "can't withdraw 0");
        uint256 userIndex = userInfoIndex[msg.sender];
        require(userIndex > 0, "User index should be bigger than 0.");
        UserInfo storage currentUserInfo = userInfos[userIndex];
        uint256 withdrawAmountToUsdt = calcTokenPrice(_tokenAddress) * _amount;
        uint256 userCol = calcCollater() - calcDebt();
        uint LTV = poolInfos[_tokenAddress].LTV;
        if (calcDebt() > 0) {
            require(
                (userCol * LTV) / 100 >= withdrawAmountToUsdt,
                "Withdraw failed.Plesae repay first"
            );
        } else {
            require(
                calcCollater() >= withdrawAmountToUsdt,
                "Withdraw failed.Plesae repay first"
            );
        }

        currentUserInfo.position.tokenColAmount[_tokenAddress] -= _amount;
        if (_tokenAddress == ethAddress) {
            (bool sent, ) = payable(msg.sender).call{value: _amount}("");
            require(sent, "failed to send eth interest.");
        } else {
            IERC20(usdtAddress).transfer(msg.sender, _amount);
        }
    }

    function liquidate(address _account) public payable {
        uint256 userIndex = userInfoIndex[_account];
        require(userIndex > 0, "User index should be bigger than 0.");
        UserInfo storage currentUserInfo = userInfos[userIndex];
        // if depost eth
        if (currentUserInfo.position.tokenColAmount[ethAddress] > 0) {
            (bool sent, ) = payable(msg.sender).call{
                value: currentUserInfo.position.tokenColAmount[ethAddress]
            }("");
            require(sent, "failed to send eth.");
            require(
                IERC20(usdtAddress).transferFrom(
                    msg.sender,
                    address(this),
                    currentUserInfo.position.tokenDebtAmount[usdtAddress]
                ),
                "deposit failed"
            );
        } else {
            IERC20(usdtAddress).transfer(
                msg.sender,
                currentUserInfo.position.tokenColAmount[usdtAddress]
            );
        }
        liquidityInterest(_account);
    }

    function fetchUserInfo(
        uint256 _userindex
    ) private view returns (UserInfoForDisplay memory) {
        if (_userindex > 0) {
            UserInfo storage currentUserInfo = userInfos[_userindex];
            UserInfoForDisplay
                memory currentUserInfoForDisplay = UserInfoForDisplay(
                    currentUserInfo.position.tokenColAmount[ethAddress],
                    currentUserInfo.position.tokenDebtAmount[ethAddress],
                    currentUserInfo.position.tokenColAmount[usdtAddress],
                    currentUserInfo.position.tokenDebtAmount[usdtAddress]
                );
            return currentUserInfoForDisplay;
        }
        return UserInfoForDisplay(0, 0, 0, 0);
    }

    function getUserInfo() public view returns (UserInfoForDisplay memory) {
        uint256 userIndex = userInfoIndex[msg.sender];
        return fetchUserInfo(userIndex);
    }

    function listUserInfo() public view returns (UserInfoForDisplay[] memory) {
        UserInfoForDisplay[] memory userList = new UserInfoForDisplay[](
            maxUserIndex
        );
        for (uint256 i = 0; i < maxUserIndex; i++) {
            userList[i] = (fetchUserInfo(i));
        }
        return userList;
    }

    receive() external payable {}

    fallback() external payable {}
}
