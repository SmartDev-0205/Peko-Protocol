//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;
pragma experimental ABIEncoderV2;

// import "hardhat/console.sol";

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

contract Claimable is Ownable {
    // 0: Pending 1: private sale 2: public sale 3 : stop sale
    uint public saleIndex = 0;

    /*
     * @dev stop sale
     */
    function stopSale() external onlyOwner {
        saleIndex = 3;
    }

    /*
     * @dev withdraw reward token or usdt
     * @param tokenAddress : Token address
     */
    function claimToken(
        address tokenAddress,
        uint256 amount
    ) external onlyOwner {
        IERC20(tokenAddress).transfer(owner(), amount);
    }

    /*
     * @dev withdraw ETH
     */
    function claimETH(uint256 amount) external onlyOwner {
        (bool sent, ) = owner().call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}

contract IDO is Claimable {
    using SafeMath for uint256;
    event Buy(address to, uint256 amount);
    event Claim(address to, uint256 amount);
    mapping(address => bool) whitelistCheck; //Check if address is in whitelist
    // private sale hardcap 53 eth
    // 0.01 eth to 10eth
    uint256 privateSaleHardcap = 53 * 1e18;
    uint256 minETHAmount = 1e16;
    uint256 maxETHAmount = 1e19;

    // public sale hardcap 65 eth
    uint256 publicSaleHardcap = 65 * 1e18;

    // token price 1 token   = tokenPrice ETH
    uint256 tokenPrice;

    uint256 public privateSaleTotalSaled = 0;
    uint256 public privateSaleAllocation = 5035000 * 1e6;
    uint256 public publicSaleTotalSaled = 0;
    uint256 public publicSaleAllocation = 4940000 * 1e6;

    address rewardAddress;

    mapping(address => uint256) public userRewards;
    mapping(address => uint256) public userDeposited;

    constructor(address _rewardAddress) {
        // 1 token  = 53e18/5000000 * 1e6 =  10,600,000 wei
        tokenPrice = privateSaleHardcap.div(privateSaleAllocation);
        rewardAddress = _rewardAddress;
    }

    // -------- Owner Functions ----------

    /*
     * @dev reset token price
     * @Param _price: set price with
     */
    function resetPrice(uint256 _price) public onlyOwner {
        tokenPrice = _price;
    }

    /*
     * @dev start sale
     * @dev 1: private sale,2:public sale
     * @param _saleIndex : sale index
     */
    function startSale(uint _saleIndex) external onlyOwner {
        saleIndex = _saleIndex;
        if (saleIndex == 1) {
            tokenPrice = privateSaleHardcap.div(privateSaleAllocation);
        } else if (saleIndex == 2) {
            tokenPrice = publicSaleHardcap.div(publicSaleAllocation);
        }
    }

    function addToWhitelist(
        address[] memory addressesToAdd
    ) external onlyOwner {
        for (uint i = 0; i < addressesToAdd.length; i++) {
            whitelistCheck[addressesToAdd[i]] = true;
        }
    }

    // ---------- owner functions end ----------------

    /*
     * @dev calcuate token admoutn from eth
     * @Param _ethAmount: eth amount
     */
    function calcTokenAmount(
        uint256 _ethAmount
    ) public returns (uint256 amount) {
        // calculate price for only public sale
        if (
            saleIndex == 2 &&
            (publicSaleTotalSaled + _ethAmount) > publicSaleHardcap
        ) {
            tokenPrice = (publicSaleTotalSaled + _ethAmount).div(
                publicSaleAllocation
            );
            resetPrice(tokenPrice);
        }
        amount = (_ethAmount).div(tokenPrice);
    }

    /*
     * @dev buy token from eth
     * @dev on private sale 0.01 - 10 eth for only whitelist addresses
     * @dev on private sale Check for hardcap
     */
    function buy() public payable {
        require(saleIndex > 0 && saleIndex < 3, "Not allowed to buy now.");
        if (saleIndex == 1) {
            require(
                maxETHAmount >= (userDeposited[_msgSender()] + msg.value) &&
                    (userDeposited[_msgSender()] + msg.value) >= minETHAmount &&
                    whitelistCheck[msg.sender],
                "Amount is allowed 0.01 eth to 10 eth for only listed address."
            );
            require(
                privateSaleHardcap >= (privateSaleTotalSaled + msg.value),
                "Cannot buy this amount"
            );
        }

        uint256 amount = calcTokenAmount(msg.value);
        if (saleIndex == 1) {
            privateSaleTotalSaled += msg.value;
        } else {
            publicSaleTotalSaled += msg.value;
        }
        (bool sent, ) = owner().call{value: msg.value}("");
        require(sent, "Failed to send Ether");
        userRewards[_msgSender()] += amount;
        userDeposited[_msgSender()] += msg.value;
    }

    function claimRewardToken() public {
        require(userRewards[_msgSender()] >= 0, "Please buy token.");
        IERC20(rewardAddress).transfer(msg.sender, userRewards[_msgSender()]);
        userRewards[_msgSender()] = 0;
        emit Claim(msg.sender, userRewards[_msgSender()]);
    }

    function getClaimAmount(
        address userAddress
    ) public view returns (uint256 claimAmount) {
        claimAmount = userRewards[userAddress];
    }

    function getPrice() public view returns (uint256 price) {
        price = tokenPrice;
    }

    receive() external payable {
        buy();
    }

    fallback() external payable {
        buy();
    }
}
