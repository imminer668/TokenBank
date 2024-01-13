// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Ownable {
    address private _owner;

    error invalidAddress(address _owner);
    error transferFailed(address _address);
    //dev The caller account is not authorized to perform an operation
    error ownableUnauthorizedAccount(address account);
    error OwnableInvalidOwner(address owner);
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert invalidAddress(address(0));
        }
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        if (owner() != msg.sender) {
            revert ownableUnauthorizedAccount(msg.sender);
        }
    }

    //Transfers ownership of the contract to a new account (`newOwner`),Can only be called by the current owner.
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) revert OwnableInvalidOwner(address(0));
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        //emit important even
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IMyERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

contract TokenBank is Ownable {
    IMyERC20 public depositToken;
    // User address => depositToken,depositAmount
    mapping(address => uint256) public userDepositAmount;

    // Total depositToken
    uint256 public depositTotalAmount;
    //error balance too low tips
    error BalanceTooLow(address account);

    //error deposit eth too few tips
    error AmountTooLow(uint256 eth);

    constructor(address initialOwner, address _depositToken)
        Ownable(initialOwner)
    {
        depositToken = IMyERC20(_depositToken);
    }

    //deposit amount must be greater than 0
    modifier AmountLimit(uint256 _amount) {
        if (_amount <= 0 || depositToken.balanceOf(msg.sender) <= 0)
            revert AmountTooLow(_amount);
        _;
    }

    function deposit(uint256 _amount) public{
        //
        depositToken.transferFrom(msg.sender,address(this), _amount);
        userDepositAmount[msg.sender] += _amount;
        depositTotalAmount += _amount;
    }

    function withdraw(address payable _recipient, uint256 _amount)
        public
        onlyOwner
    {
        if (_recipient == address(0)) revert invalidAddress(address(0));
        if (_amount <= 0 || _amount > depositTotalAmount) revert AmountTooLow(_amount);
        depositToken.transfer(_recipient, _amount);
        depositTotalAmount = depositTotalAmount - _amount;
    }

    function withdrawEth(address payable _recipient, uint256 _amount)
        public
        onlyOwner
    {
        if (_recipient == address(0)) revert invalidAddress(address(0));
        if (_amount <= 0 || _amount > address(this).balance)
            revert AmountTooLow(_amount);

        (bool success, ) = _recipient.call{value: _amount}("");
        if (!success) revert transferFailed(_recipient);
    }


    receive() external payable {}
}
