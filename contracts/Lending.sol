// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
// import "hardhat/console.sol";

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(
        uint256 a,
        uint256 b
    ) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    function _msgSender() internal view returns (address) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/* --------- Access Control --------- */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IERC20 {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

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
    using SafeMath for uint256;

    struct UserInfo {
        address accountAddress; //Account Address
        uint256 lastInterest; //last timestamp that calcuate interest
        mapping(address => uint256) tokenDepositAmount; //deposit amount for token
        mapping(address => uint256) tokenBorrowAmount; //deposit amount for token
        mapping(address => uint256) tokenRewardAmount; //deposit amount for token
        mapping(address => uint256) tokenInterestAmount; //deposit amount for token
        uint256 pekoRewardAmount; //deposit amount for token
    }

    struct UserInfoForDisplay {
        uint256 ethDepositAmount;
        uint256 usdtDepositAmount;
        uint256 ethBorrowAmount;
        uint256 usdtBorrowAmount;
        uint256 ethInterestAmount;
        uint256 usdtInterestAmount;
        uint256 ethRewardAmount;
        uint256 usdtRewardAmount;
        uint256 pekoRewardAmount;
        uint256 ethDepositTotalInUsdtAmount;
        uint256 usdtDepositTotalAmount;
        uint256 ethBorrowTotalInUsdtAmount;
        uint256 usdtBorrowTotalAmount;
        address accountAddress;
    }

    struct PoolInfo {
        uint LTV;
        uint depositApy;
        uint borrowApy;
        uint256 totalAmount;
        uint256 borrowAmount;
    }

    mapping(address => PoolInfo) poolInfos;
    uint256 maxUserIndex;
    mapping(uint256 => UserInfo) userInfos;
    mapping(address => uint256) userInfoIndex;

    address rewardAddress;
    address ethAddress;
    address usdtAddress;
    address poolAddress;
    uint liquidationThreshhold = 30;
    // I am using this decimal when calcuate reward
    uint decimal = 1000000000;

    constructor(
        address _rewardAddress,
        address _ethAdddress,
        address _usdtAddress,
        address _poolAddress
    ) {
        rewardAddress = _rewardAddress;
        ethAddress = _ethAdddress;
        usdtAddress = _usdtAddress;
        poolAddress = _poolAddress;
        // 10 *decimal/(31,536,000 *100) = 30 so 10% = 30
        addPool(ethAddress, 80, 5, 10, 0, 0);
        // 10 *decimal/(31,536,000 *100)
        addPool(usdtAddress, 80, 5, 10, 0, 0);
    }

    // Liquidate max percent
    function setLiquidationThreshhold(uint limit) public {
        liquidationThreshhold = limit;
    }

    function setPoolAddress(address _poolAddress) public {
        poolAddress = _poolAddress;
    }

    function addPool(
        address _tokenAddress,
        uint _LTV,
        uint _depositApy,
        uint _borrowApy,
        uint256 _totalAmount,
        uint256 _borrowAmount
    ) private {
        PoolInfo storage newPoolInfo = poolInfos[_tokenAddress];
        newPoolInfo.LTV = _LTV;
        // 10 *decimal/(31,536,000 *100) = 30 so 10% = 30
        newPoolInfo.depositApy = _depositApy * 3;
        newPoolInfo.borrowApy = _borrowApy * 3;
        newPoolInfo.totalAmount = _totalAmount;
        newPoolInfo.borrowAmount = _borrowAmount;
    }

    // calcuate to usdt amout.
    function calcTokenPrice(
        address _tokenAddress,
        uint256 _amount
    ) public view returns (uint256) {
        if (_tokenAddress == usdtAddress) return _amount;
        else {
            // uint256 price = getEthValue(poolAddress,ethAddress,usdtAddress);
            uint256 price = 1000_000000000000000000;
            return (price * _amount).div(10 ** 30);
            // return getEthValue(poolAddress,ethAddress,usdtAddress);
        }
    }

    function getEthValue(
        address _pool,
        address _weth,
        address _usdc
    ) public view returns (uint256) {
        uint256 wethReserve = IERC20(_weth).balanceOf(_pool);
        uint256 usdcReserve = IERC20(_usdc).balanceOf(_pool);
        uint256 usdcDecimals = IERC20(_usdc).decimals();
        //   uint256 ethPrice_ = usdcReserve.mul(10 ** (36 - usdcDecimals)).div(wethReserve);
        uint256 ethPrice_ = usdcReserve.mul(10 ** (36 - usdcDecimals)).div(
            wethReserve
        );
        return ethPrice_;
    }

    // calcuate interest and reward for user.
    function calcuateUser(address _account) private {
        require(userInfoIndex[_account] > 0, "User should deposit before");
        UserInfo storage currentUserInfo = userInfos[userInfoIndex[_account]];
        uint256 lastTimestamp = currentUserInfo.lastInterest;
        uint256 timeDelta = block.timestamp - lastTimestamp;


        // calculate eth
        currentUserInfo.pekoRewardAmount += calcTokenPrice(ethAddress,(currentUserInfo.tokenDepositAmount[ethAddress] * poolInfos[ethAddress].depositApy * timeDelta) / decimal);
        currentUserInfo.tokenRewardAmount[ethAddress] +=
            (currentUserInfo.tokenDepositAmount[ethAddress] *
                poolInfos[ethAddress].depositApy *
                timeDelta) /
            decimal;
        currentUserInfo.tokenInterestAmount[ethAddress] +=
            (currentUserInfo.tokenBorrowAmount[ethAddress] *
                poolInfos[ethAddress].borrowApy *
                timeDelta) /
            decimal;

        // calculate usdt
        currentUserInfo.pekoRewardAmount += calcTokenPrice(usdtAddress,(currentUserInfo.tokenDepositAmount[usdtAddress] * poolInfos[usdtAddress].depositApy * timeDelta) / decimal);
        currentUserInfo.tokenRewardAmount[usdtAddress] +=
            (currentUserInfo.tokenDepositAmount[usdtAddress] *
                poolInfos[usdtAddress].depositApy *
                timeDelta) /
            decimal;
        currentUserInfo.tokenInterestAmount[usdtAddress] +=
            (currentUserInfo.tokenBorrowAmount[usdtAddress] *
                poolInfos[usdtAddress].borrowApy *
                timeDelta) /
            decimal;

        currentUserInfo.lastInterest = block.timestamp;
    }

    function clearUser(address _account) private {
        require(userInfoIndex[_account] > 0, "User should deposit before");
        UserInfo storage currentUserInfo = userInfos[userInfoIndex[_account]];
        // calculate eth
        currentUserInfo.tokenDepositAmount[ethAddress] = 0;
        currentUserInfo.tokenBorrowAmount[ethAddress] = 0;
        currentUserInfo.tokenRewardAmount[ethAddress] = 0;
        currentUserInfo.tokenInterestAmount[ethAddress] = 0;

        // calculate eth
        currentUserInfo.tokenDepositAmount[usdtAddress] = 0;
        currentUserInfo.tokenBorrowAmount[usdtAddress] = 0;
        currentUserInfo.tokenRewardAmount[usdtAddress] = 0;
        currentUserInfo.tokenInterestAmount[usdtAddress] = 0;

        currentUserInfo.pekoRewardAmount = 0;
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
            calcuateUser(msg.sender);
        }
        UserInfo storage currentUserInfo = userInfos[userIndex];
        currentUserInfo.accountAddress = msg.sender;
        currentUserInfo.lastInterest = block.timestamp;

        currentUserInfo.tokenDepositAmount[_tokenAddress] += _amount;
        if (_tokenAddress == usdtAddress) {
            require(
                IERC20(usdtAddress).transferFrom(
                    msg.sender,
                    address(this),
                    _amount
                ),
                "deposit failed"
            );
            poolInfos[usdtAddress].totalAmount += _amount;
        } else {
            poolInfos[ethAddress].totalAmount += _amount;
        }
    }

    // calc collateral in usd
    function collateral(address _account) public returns (uint256) {
        calcuateUser(_account);
        UserInfo storage currentUserInfo = userInfos[userInfoIndex[_account]];
        uint256 ethCollateral = calcTokenPrice(
            ethAddress,
            currentUserInfo.tokenRewardAmount[ethAddress] +
                currentUserInfo.tokenDepositAmount[ethAddress]
        );
        uint256 usdtCollateral = calcTokenPrice(
            usdtAddress,
            currentUserInfo.tokenRewardAmount[usdtAddress] +
                currentUserInfo.tokenDepositAmount[usdtAddress]
        );
        return ethCollateral + usdtCollateral;
    }

    // calc borrow in usd
    function debt(address _account) public returns (uint256) {
        calcuateUser(_account);
        UserInfo storage currentUserInfo = userInfos[userInfoIndex[_account]];
        uint256 ethDebt = calcTokenPrice(
            ethAddress,
            currentUserInfo.tokenInterestAmount[ethAddress] +
                currentUserInfo.tokenBorrowAmount[ethAddress]
        );
        uint256 usdtDebt = calcTokenPrice(
            usdtAddress,
            currentUserInfo.tokenInterestAmount[usdtAddress] +
                currentUserInfo.tokenBorrowAmount[usdtAddress]
        );
        return ethDebt + usdtDebt;
    }

    // borrow
    function borrow(address _tokenAddress, uint256 _amount) public {
        require(_amount > 0, "can't borrow 0");
        uint256 userIndex = userInfoIndex[msg.sender];
        require(userIndex > 0, "User index should be bigger than 0.");
        UserInfo storage currentUserInfo = userInfos[userIndex];

        uint256 accountCollateral = collateral(msg.sender);
        uint256 accountDebt = debt(msg.sender);
        require(
            accountCollateral >= accountDebt,
            "You donot have any collateral."
        );

        uint256 borrowAmount = calcTokenPrice(_tokenAddress, _amount);
        uint LTV = poolInfos[_tokenAddress].LTV;
        require(
            (accountCollateral * LTV) / 100 > borrowAmount + accountDebt,
            "Please deposit more."
        );

        currentUserInfo.tokenBorrowAmount[_tokenAddress] += _amount;
        calcuateUser(msg.sender);

        if (_tokenAddress == ethAddress) {
            (bool sent, ) = payable(msg.sender).call{value: _amount}("");
            require(sent, "failed to send eth interest.");
            poolInfos[ethAddress].borrowAmount += _amount;
        } else {
            IERC20(usdtAddress).transfer(msg.sender, _amount);
            poolInfos[usdtAddress].borrowAmount += _amount;
        }
    }

    function repay(address _tokenAddress, uint256 _amount) public payable {
        calcuateUser(msg.sender);
        require(_amount > 0, "can't repay 0");
        uint256 userIndex = userInfoIndex[msg.sender];
        require(userIndex > 0, "User index should be bigger than 0.");
        UserInfo storage currentUserInfo = userInfos[userIndex];

        require(
            _amount > currentUserInfo.tokenInterestAmount[_tokenAddress],
            "Repay need to be bigger than debt"
        );
        currentUserInfo.tokenBorrowAmount[_tokenAddress] -= _amount;
        if (_tokenAddress == usdtAddress) {
            require(
                IERC20(usdtAddress).transferFrom(
                    msg.sender,
                    address(this),
                    _amount
                ),
                "Repay failed"
            );
            poolInfos[usdtAddress].borrowAmount -= _amount;
        } else {
            require(msg.value >= _amount, "Please pay more.");
            poolInfos[ethAddress].borrowAmount -= _amount;
        }
        calcuateUser(msg.sender);
    }

    function withdraw(address _tokenAddress, uint256 _amount) public {
        require(_amount > 0, "can't withdraw 0");
        uint256 userIndex = userInfoIndex[msg.sender];
        require(userIndex > 0, "User index should be bigger than 0.");
        UserInfo storage currentUserInfo = userInfos[userIndex];
        calcuateUser(msg.sender);

        uint256 accountCollateral = collateral(msg.sender);
        uint256 accountDebt = debt(msg.sender);
        require(
            (accountCollateral * poolInfos[_tokenAddress].LTV) / 100 >
                accountDebt + calcTokenPrice(_tokenAddress, _amount),
            "Withdraw failed.You donot have any collateral."
        );

        currentUserInfo.tokenRewardAmount[_tokenAddress] = 0;
        currentUserInfo.tokenDepositAmount[_tokenAddress] -= _amount;

        if (_tokenAddress == ethAddress) {
            (bool sent, ) = payable(msg.sender).call{
                value: currentUserInfo.tokenRewardAmount[_tokenAddress] +
                    _amount
            }("");
            require(sent, "failed to send eth interest.");
        } else {
            IERC20(usdtAddress).transfer(
                msg.sender,
                currentUserInfo.tokenRewardAmount[_tokenAddress] + _amount
            );
        }
    }

    function liquidate(address _account) public payable {
        uint256 userIndex = userInfoIndex[_account];
        require(userIndex > 0, "User index should be bigger than 0.");
        UserInfo storage currentUserInfo = userInfos[userIndex];

        uint256 accountCollateral = collateral(_account);
        uint256 accountDebt = debt(_account);
        uint256 riskFact = (accountDebt* 100 * 100).div(accountCollateral * 90) ;
        require(
            riskFact > liquidationThreshhold,
            "This is not enabled liquidation"
        );

        // if depost eth so liquidator need to send token
        
        uint256 ethSupplyAmount = currentUserInfo.tokenDepositAmount[ethAddress] + currentUserInfo.tokenRewardAmount[ethAddress];
        uint256 usdtSupplyAmount = currentUserInfo.tokenDepositAmount[usdtAddress] + currentUserInfo.tokenRewardAmount[usdtAddress];

        uint256 ethBorrowAmount = currentUserInfo.tokenBorrowAmount[ethAddress] + currentUserInfo.tokenInterestAmount[ethAddress];
        uint256 usdtBorrowAmount = currentUserInfo.tokenBorrowAmount[usdtAddress] + currentUserInfo.tokenInterestAmount[usdtAddress];

        require (msg.value > ethBorrowAmount.div(10000) * 9999,"Not enough eth");
        require(
            IERC20(usdtAddress).transferFrom(
                msg.sender,
                address(this),
                usdtBorrowAmount.div(10000) * 9999
            ),
            "deposit failed"
        );
        
        (bool sent, ) = payable(msg.sender).call{
            value: ethSupplyAmount
        }("");
        require(sent, "failed to send eth.");
        
        IERC20(usdtAddress).transfer(
            msg.sender,
            usdtSupplyAmount
        );
        
        IERC20(rewardAddress).transfer(
            msg.sender,
            currentUserInfo.pekoRewardAmount
        );

        clearUser(_account);
    }


    function claimPeko() public {
        uint256 userIndex = userInfoIndex[msg.sender];
        require(userIndex > 0, "User index should be bigger than 0.");
        UserInfo storage currentUserInfo = userInfos[userIndex];
        calcuateUser(msg.sender);
        IERC20(rewardAddress).transfer(
            msg.sender,
            currentUserInfo.pekoRewardAmount
        );
        currentUserInfo.pekoRewardAmount = 0;
    }

    function fetchUserInfo(
        uint256 _userindex
    ) private view returns (UserInfoForDisplay memory) {
        if (_userindex > 0) {
            UserInfo storage currentUserInfo = userInfos[_userindex];
            UserInfoForDisplay
                memory currentUserInfoForDisplay = UserInfoForDisplay(
                    currentUserInfo.tokenDepositAmount[ethAddress],
                    currentUserInfo.tokenDepositAmount[usdtAddress],
                    currentUserInfo.tokenBorrowAmount[ethAddress],
                    currentUserInfo.tokenBorrowAmount[usdtAddress],
                    currentUserInfo.tokenInterestAmount[ethAddress],
                    currentUserInfo.tokenInterestAmount[usdtAddress],
                    currentUserInfo.tokenRewardAmount[ethAddress],
                    currentUserInfo.tokenRewardAmount[usdtAddress],
                    currentUserInfo.pekoRewardAmount,
                    calcTokenPrice(
                        ethAddress,
                        currentUserInfo.tokenDepositAmount[ethAddress] +
                            currentUserInfo.tokenRewardAmount[ethAddress]
                    ),
                    calcTokenPrice(
                        usdtAddress,
                        currentUserInfo.tokenDepositAmount[usdtAddress] +
                            currentUserInfo.tokenRewardAmount[usdtAddress]
                    ),
                    calcTokenPrice(
                        ethAddress,
                        currentUserInfo.tokenBorrowAmount[ethAddress] +
                            currentUserInfo.tokenInterestAmount[ethAddress]
                    ),
                    calcTokenPrice(
                        usdtAddress,
                        currentUserInfo.tokenBorrowAmount[usdtAddress] +
                            currentUserInfo.tokenInterestAmount[usdtAddress]
                    ),
                    currentUserInfo.accountAddress
                );
            return currentUserInfoForDisplay;
        } else {
            return
                UserInfoForDisplay(
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    0,
                    msg.sender
                );
        }
    }

    function getUserInfo(
        address _account
    ) public view returns (UserInfoForDisplay memory) {
        uint256 userIndex = userInfoIndex[_account];
        UserInfoForDisplay memory userInfoDisplay = fetchUserInfo(userIndex);
        return userInfoDisplay;
    }

    function listUserInfo() public view returns (UserInfoForDisplay[] memory) {
        UserInfoForDisplay[] memory userList = new UserInfoForDisplay[](
            maxUserIndex
        );
        for (uint256 i = 1; i < maxUserIndex + 1; i++) {
            userList[i - 1] = (fetchUserInfo(i));
        }
        return userList;
    }

    function getMarketInfo() public view returns (uint256, uint256) {
        PoolInfo storage ethPool = poolInfos[ethAddress];
        PoolInfo storage usdtPool = poolInfos[usdtAddress];
        return (
            calcTokenPrice(ethAddress, ethPool.totalAmount) +
                usdtPool.totalAmount,
            calcTokenPrice(ethAddress, ethPool.borrowAmount) +
                usdtPool.borrowAmount
        );
    }

    function getPoolInfo(address _poolAddress) public view returns (PoolInfo memory poolInfo) {
        PoolInfo memory currentPool = poolInfos[_poolAddress];
        currentPool.depositApy =  currentPool.depositApy.div(3);
        currentPool.borrowApy =  currentPool.borrowApy.div(3);
        return currentPool;
    }

    receive() external payable {}

    fallback() external payable {}
}
