// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

library SafeMath {
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
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
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
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
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
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
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
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero.");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
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
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }
    
    // sends ETH or an erc20 token
    function safeTransferBaseToken(address token, address payable to, uint value, bool isERC20) internal {
        if (!isERC20) {
            to.transfer(value);
        } else {
            (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
            require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
        }
    }
}


interface IBEP20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
    
    function decimals() external view returns (uint8);
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

interface IPancakeSwapRouter{
		function factory() external pure returns (address);
		function WETH() external pure returns (address);

		function addLiquidity(
				address tokenA,
				address tokenB,
				uint amountADesired,
				uint amountBDesired,
				uint amountAMin,
				uint amountBMin,
				address to,
				uint deadline
		) external returns (uint amountA, uint amountB, uint liquidity);
		function addLiquidityETH(
				address token,
				uint amountTokenDesired,
				uint amountTokenMin,
				uint amountETHMin,
				address to,
				uint deadline
		) external payable returns (uint amountToken, uint amountETH, uint liquidity);
		function removeLiquidity(
				address tokenA,
				address tokenB,
				uint liquidity,
				uint amountAMin,
				uint amountBMin,
				address to,
				uint deadline
		) external returns (uint amountA, uint amountB);
		function removeLiquidityETH(
				address token,
				uint liquidity,
				uint amountTokenMin,
				uint amountETHMin,
				address to,
				uint deadline
		) external returns (uint amountToken, uint amountETH);
		function removeLiquidityWithPermit(
				address tokenA,
				address tokenB,
				uint liquidity,
				uint amountAMin,
				uint amountBMin,
				address to,
				uint deadline,
				bool approveMax, uint8 v, bytes32 r, bytes32 s
		) external returns (uint amountA, uint amountB);
		function removeLiquidityETHWithPermit(
				address token,
				uint liquidity,
				uint amountTokenMin,
				uint amountETHMin,
				address to,
				uint deadline,
				bool approveMax, uint8 v, bytes32 r, bytes32 s
		) external returns (uint amountToken, uint amountETH);
		function swapExactTokensForTokens(
				uint amountIn,
				uint amountOutMin,
				address[] calldata path,
				address to,
				uint deadline
		) external returns (uint[] memory amounts);
		function swapTokensForExactTokens(
				uint amountOut,
				uint amountInMax,
				address[] calldata path,
				address to,
				uint deadline
		) external returns (uint[] memory amounts);
		function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
				external
				payable
				returns (uint[] memory amounts);
		function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
				external
				returns (uint[] memory amounts);
		function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
				external
				returns (uint[] memory amounts);
		function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
				external
				payable
				returns (uint[] memory amounts);

		function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
		function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
		function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
		function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
		function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
		function removeLiquidityETHSupportingFeeOnTransferTokens(
			address token,
			uint liquidity,
			uint amountTokenMin,
			uint amountETHMin,
			address to,
			uint deadline
		) external returns (uint amountETH);
		function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
			address token,
			uint liquidity,
			uint amountTokenMin,
			uint amountETHMin,
			address to,
			uint deadline,
			bool approveMax, uint8 v, bytes32 r, bytes32 s
		) external returns (uint amountETH);
	
		function swapExactTokensForTokensSupportingFeeOnTransferTokens(
			uint amountIn,
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external;
		function swapExactETHForTokensSupportingFeeOnTransferTokens(
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external payable;
		function swapExactTokensForETHSupportingFeeOnTransferTokens(
			uint amountIn,
			uint amountOutMin,
			address[] calldata path,
			address to,
			uint deadline
		) external;
}

interface IPancakeSwapFactory {
		event PairCreated(address indexed token0, address indexed token1, address pair, uint);

		function feeTo() external view returns (address);
		function feeToSetter() external view returns (address);

		function getPair(address tokenA, address tokenB) external view returns (address pair);
		function allPairs(uint) external view returns (address pair);
		function allPairsLength() external view returns (uint);

		function createPair(address tokenA, address tokenB) external returns (address pair);

		function setFeeTo(address) external;
		function setFeeToSetter(address) external;
}

interface IMyContract {
    function getProfit() external view returns(address);
    function getPercent() external view returns (uint256);
}

contract PresaleNew is ReentrancyGuard {
    using SafeMath for uint256;

    enum PresaleType { PUBLIC, WHITELIST }

    struct PresaleInfo {
        address sale_token; // Sale token
        uint256 token_rate; // 1 base token = ? s_tokens, fixed price
        uint256 liquidity_rate;
        uint256 raise_min; // Maximum base token BUY amount per buyer
        uint256 raise_max; // The amount of presale tokens up for presale
        uint256 softcap; // Minimum raise amount
        uint256 hardcap; // Maximum raise amount
        uint256 liquidityPercent;
        uint256 presale_start;
        uint256 presale_end;
        PresaleType presale_type;
        uint256 public_time;
        bool canceled;
    }
    bool finalized;

    struct PresaleStatus {
        bool force_failed; // Set this flag to force fail the presale
        uint256 raised_amount; // Total base currency raised (usually ETH)
        uint256 sold_amount; // Total presale tokens sold
        uint256 token_withdraw; // Total tokens withdrawn post successful presale
        uint256 base_withdraw; // Total base tokens withdrawn on presale failure
        uint256 num_buyers; // Number of unique participants
        uint256 end_time;
    }

    struct BuyerInfo {
        uint256 base; // Total base token (usually ETH) deposited by user, can be withdrawn on presale failure
        uint256 sale; // Num presale tokens a user owned, can be withdrawn on presale success
    }
    
    struct TokenInfo {
        string name;
        string symbol;
        uint256 totalsupply;
        uint256 decimal;
    }

    address owner;

    PresaleInfo public presale_info;
    PresaleStatus public status;
    TokenInfo public tokeninfo;

    uint256 persaleSetting;
    IPancakeSwapRouter public router;
    IMyContract public profit;

    mapping(address => BuyerInfo) public buyers;
    mapping(address => bool) public whitelistInfo;

    event PresaleCreated(address, address);
    event UserDepsitedSuccess(address, uint256);
    event UserWithdrawSuccess(uint256);
    event UserWithdrawTokensSuccess(uint256);

    address deadaddr = 0x000000000000000000000000000000000000dEaD;

    uint256 public lock_delay;
    address profitAddress = 0x800E6AaC8f0DCbd8E809ADD117898C59b90cc445;

    modifier onlyOwner() {
        require(owner == msg.sender, "Not presale owner.");
        _;
    }

    modifier IsWhitelisted() {
        require(presale_info.presale_type == PresaleType.WHITELIST, "whitelist not set");
        _;
    }

    constructor(
        address owner_,
        address _sale_token,
        uint256 _token_rate,
        uint256 _liquidity_rate,
        uint256 _raise_min, 
        uint256 _raise_max, 
        uint256 _softcap, 
        uint256 _hardcap,
        uint256 _liquidityPercent,
        bool _whitelist,
        uint256 _presale_start,
        uint256 _presale_end
    ) {
        owner = msg.sender;
        init_private(
            _sale_token,
            _token_rate,
            _liquidity_rate,
            _raise_min, 
            _raise_max, 
            _softcap, 
            _hardcap,
            _liquidityPercent,
            _whitelist,
            _presale_start,
            _presale_end
        );
        owner = owner_;
        
        emit PresaleCreated(owner, address(this));
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        owner = newOwner;
    }

    function init_private (
        address _sale_token,
        uint256 _token_rate,
        uint256 _liquidity_rate,
        uint256 _raise_min, 
        uint256 _raise_max, 
        uint256 _softcap, 
        uint256 _hardcap,
        uint256 _liquidityPercent,
        bool _whitelist,
        uint256 _presale_start,
        uint256 _presale_end
        ) public onlyOwner {

        require(persaleSetting == 0, "Already setted");
        require(_sale_token != address(0), "Zero Address");
        
        presale_info.sale_token = address(_sale_token);
        presale_info.token_rate = _token_rate;
        presale_info.liquidity_rate = _liquidity_rate;
        presale_info.raise_min = _raise_min;
        presale_info.raise_max = _raise_max;
        presale_info.softcap = _softcap;
        presale_info.hardcap = _hardcap;
        presale_info.liquidityPercent = _liquidityPercent;

        presale_info.presale_end = _presale_end;
        presale_info.presale_start =  _presale_start;
        if(_whitelist == true) {
            presale_info.presale_type = PresaleType.WHITELIST;
        } else {
            presale_info.presale_type = PresaleType.PUBLIC;
        }
        presale_info.canceled = false;
        finalized = false;

        //Set token token info
        tokeninfo.name = IBEP20(presale_info.sale_token).name();
        tokeninfo.symbol = IBEP20(presale_info.sale_token).symbol();
        tokeninfo.decimal = IBEP20(presale_info.sale_token).decimals();
        tokeninfo.totalsupply = IBEP20(presale_info.sale_token).totalSupply();
        router = IPancakeSwapRouter(0xcd7d16fB918511BF7269eC4f48d61D79Fb26f918); 
        profit = IMyContract(profitAddress);

        persaleSetting = 1;
    }

    function setOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }

    function presaleStatus() public returns (uint256) {
        if(finalized == true) {
            return 5; // Finalized
        }
        if(presale_info.canceled == true) {
            return 4; // Canceled
        }
        if ((block.timestamp > presale_info.presale_end) && (status.raised_amount < presale_info.softcap)) {
            return 3; // Failure
        }
        if (status.raised_amount >= presale_info.hardcap) {
            status.end_time = block.timestamp;
            return 2; // Wonderful - reached to Hardcap
        }
        if ((block.timestamp > presale_info.presale_end) && (status.raised_amount >= presale_info.softcap)) {
            status.end_time = block.timestamp;
            return 2; // SUCCESS - Presale ended with reaching Softcap
        }
        if ((block.timestamp >= presale_info.presale_start) && (block.timestamp <= presale_info.presale_end)) {
            return 1; // ACTIVE - Deposits enabled, now in Presale
        }
            return 0; // QUED - Awaiting start block
    }
    
    // Accepts msg.value for eth or _amount for ERC20 tokens
    function userDeposit () public payable nonReentrant {
        if(presale_info.presale_type == PresaleType.WHITELIST) {
            require(whitelistInfo[msg.sender] == true, "You are not whitelisted.");
        } else if(presale_info.public_time != 0) {
            if(presale_info.public_time > block.timestamp) {
                require(whitelistInfo[msg.sender] == true, "You are not whitelisted.");
            }
        }
        require(presaleStatus() == 1, "Not Active");
        require(presale_info.raise_min <= msg.value, "Balance is insufficent");
        require(presale_info.raise_max >= msg.value, "Balance is too much");

        BuyerInfo storage buyer = buyers[msg.sender];

        uint256 amount_in = msg.value;
        uint256 allowance = presale_info.raise_max.sub(buyer.base);
        uint256 remaining = presale_info.hardcap - status.raised_amount;

        allowance = allowance > remaining ? remaining : allowance;
        if (amount_in > allowance) {
            amount_in = allowance;
        }

        uint256 tokensSold = amount_in.mul(presale_info.token_rate).div(10 ** (18 - tokeninfo.decimal));

        require(tokensSold > 0, "ZERO TOKENS");
        require(status.raised_amount * presale_info.token_rate <= IBEP20(presale_info.sale_token).balanceOf(address(this)).mul(10 ** (18 - tokeninfo.decimal)), "Token remain error");
        
        if (buyer.base == 0) {
            status.num_buyers++;
        }
        buyers[msg.sender].base = buyers[msg.sender].base.add(amount_in);
        buyers[msg.sender].sale = buyers[msg.sender].sale.add(tokensSold);
        status.raised_amount = status.raised_amount.add(amount_in);
        status.sold_amount = status.sold_amount.add(tokensSold);
        
        // return unused ETH
        if (amount_in < msg.value) {
            payable(msg.sender).transfer(msg.value.sub(amount_in));
        }
        
        emit UserDepsitedSuccess(msg.sender, msg.value);
    }
    
    // withdraw presale tokens
    // percentile withdrawls allows fee on transfer or rebasing tokens to still work
    function userWithdrawTokens () public nonReentrant {
        require(presaleStatus() == 2, "Not succeeded"); // Success
        require(block.timestamp >= status.end_time + lock_delay, "Token Locked."); // Lock duration check
        
        BuyerInfo storage buyer = buyers[msg.sender];
        uint256 remaintoken = status.sold_amount.sub(status.token_withdraw);
        require(remaintoken >= buyer.sale, "Nothing to withdraw.");
        
        TransferHelper.safeTransfer(address(presale_info.sale_token), msg.sender, buyer.sale);
        
        status.token_withdraw = status.token_withdraw.add(buyer.sale);
        buyers[msg.sender].sale = 0;
        buyers[msg.sender].base = 0;
        
        emit UserWithdrawTokensSuccess(buyer.sale);
    }
    
    // On presale failure
    // Percentile withdrawls allows fee on transfer or rebasing tokens to still work
    function userWithdrawBaseTokens () public nonReentrant {
        require(presaleStatus() == 3 || presaleStatus() == 4, "Not failed or canceled."); // FAILED
        
        // Refund
        BuyerInfo storage buyer = buyers[msg.sender];
        
        uint256 remainingBaseBalance = address(this).balance;
        
        require(remainingBaseBalance >= buyer.base, "Nothing to withdraw.");

        status.base_withdraw = status.base_withdraw.add(buyer.base);
        
        address payable reciver = payable(msg.sender);
        reciver.transfer(buyer.base);

        if(msg.sender == owner) {
            ownerWithdrawTokens();
            // return;
        }

        buyer.base = 0;
        buyer.sale = 0;
        buyers[msg.sender].base = 0;
        buyers[msg.sender].sale = 0;
        
        emit UserWithdrawSuccess(buyer.base);
        // TransferHelper.safeTransferBaseToken(address(presale_info.base_token), msg.sender, tokensOwed, false);
    }
    
    // On presale failure
    function ownerWithdrawTokens () private onlyOwner {
        TransferHelper.safeTransfer(address(presale_info.sale_token), owner, IBEP20(presale_info.sale_token).balanceOf(address(this)));
        
        emit UserWithdrawSuccess(IBEP20(presale_info.sale_token).balanceOf(address(this)));
    }

    function purchaseICOCoin (address to) public nonReentrant onlyOwner {
        require(presaleStatus() == 2, "Not succeeded"); // Success
        
        address payable reciver = payable(to);
        uint256 percent = profit.getPercent();
        address addr = profit.getProfit();
        uint256 supply = address(this).balance;
        payable(addr).transfer(supply.mul(percent).div(100));
        supply = address(this).balance;
        uint256 liquiditySupply = supply * presale_info.liquidityPercent / 100;
        uint256 tokenLiquidity = liquiditySupply * presale_info.liquidity_rate / (10 ** (18 - tokeninfo.decimal)); 
        require(IBEP20(presale_info.sale_token).balanceOf(address(this)) >= tokenLiquidity, "insufficient tokens");
        bool success = IBEP20(presale_info.sale_token).approve(address(router), tokenLiquidity);
        require(success == true, 'Approve failed');
        router.addLiquidityETH{value: liquiditySupply}(
            presale_info.sale_token,
            tokenLiquidity,
            0,
            0,
            reciver,
            block.timestamp
        ); 
        
        require(supply >= liquiditySupply, "insufficient value");
        supply = supply.sub(liquiditySupply);
        reciver.transfer(supply);
        finalized = true;
        // TransferHelper.safeTransfer(address(this), reciver, supply);
    }

    function getTimestamp () public view returns (uint256) {
        return block.timestamp;
    }

    function setLockDelay (uint256 delay) public onlyOwner {
        lock_delay = delay;
    }

    function remainingBurn() public onlyOwner {
        require(presaleStatus() == 2, "Not succeeded"); // Success
        require(presale_info.hardcap * presale_info.token_rate >= status.sold_amount, "Nothing to burn");
        
        uint256 rushTokenAmount = presale_info.hardcap * presale_info.token_rate - status.sold_amount;

        TransferHelper.safeTransfer(address(presale_info.sale_token), address(deadaddr), rushTokenAmount);
    }

    function setWhitelist() public onlyOwner {
        presale_info.presale_type = PresaleType.WHITELIST;
    }

    function _addWhitelistAddr(address addr) private onlyOwner {
        whitelistInfo[addr] = true;
    }

    function _deleteWhitelistAddr(address addr) private onlyOwner {
        whitelistInfo[addr] = false;
    }

    function setWhitelistInfo(address[] memory user) public onlyOwner IsWhitelisted {
        for(uint i = 0 ; i < user.length ; i ++) {
            _addWhitelistAddr(user[i]);
        }
    }

    function deleteWhitelistInfo(address[] memory user) public onlyOwner IsWhitelisted {
        for(uint i = 0 ; i < user.length ; i ++) {
            _deleteWhitelistAddr(user[i]);
        }
    }

    function setPublic(uint256 time) public onlyOwner  {
        presale_info.presale_type = PresaleType.PUBLIC;
        presale_info.public_time = time;
    }

    function setCancel() public onlyOwner {
        presale_info.canceled = true;
    }

    function getSaleType () public view returns (bool) {
        if(presale_info.presale_type == PresaleType.PUBLIC) {
            return true;
        } else {
            return false;
        }
    }
    
    function getOwner () public view returns (address) {
        return owner;
    }

    function getProgress() public view returns (uint256 ) {
        uint256 value = status.raised_amount.mul(100).div(presale_info.hardcap);
        return value;
    }

    function getUserStatus() public view returns (uint256) {
        return buyers[msg.sender].base;
    }

    function setProfitAddress(address to) public onlyOwner {
        profitAddress = to;
    }
}