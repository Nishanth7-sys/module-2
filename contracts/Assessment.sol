// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Assessment {
    address payable public owner;
    uint256 public balance;

    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);

    constructor(uint initBalance) payable {
        owner = payable(msg.sender);
        balance = initBalance;
    }

    function getBalance() public view returns(uint256){
        return balance;
    }

    function deposit(uint256 _amount) public payable {
        uint _previousBalance = balance;

        // make sure this is the owner
        require(msg.sender == owner, "You are not the owner of this account");

        // perform transaction
        balance += _amount;

        // assert transaction completed successfully
        assert(balance == _previousBalance + _amount);

        // emit the event
        emit Deposit(_amount);
    }

    // custom error
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    function withdraw(uint256 _withdrawAmount) public {
        require(msg.sender == owner, "You are not the owner of this account");
        uint _previousBalance = balance;
        if (balance < _withdrawAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: _withdrawAmount
            });
        }

        // withdraw the given amount
        balance -= _withdrawAmount;

        // assert the balance is correct
        assert(balance == (_previousBalance - _withdrawAmount));

        // emit the event
        emit Withdraw(_withdrawAmount);
    }

    function calculateBitcoinReturns(uint256 investmentAmount, uint256 initialPrice, uint256 investmentYear, uint256 currentYear, uint256 currentPrice) public pure returns (uint256 profit, uint256 annualizedReturn) {
        uint256 yearsPassed = currentYear - investmentYear;
        uint256 bitcoinPurchased = investmentAmount / initialPrice;
        uint256 currentInvestmentValue = bitcoinPurchased * currentPrice;
        uint256 investmentValueAtStartYear = bitcoinPurchased * initialPrice;
        profit = currentInvestmentValue - investmentValueAtStartYear;
        annualizedReturn = profit / yearsPassed;
    }

    function generateSecurityQuestion() public view returns (string memory) {
        uint256 firstNumber = uint256(blockhash(block.number - 1)) % 10;
        uint256 secondNumber = uint256(blockhash(block.number - 2)) % 10;
        return string(abi.encodePacked("Please solve: ", toString(firstNumber), " + ", toString(secondNumber)));
    }

    function toString(uint256 _value) internal pure returns (string memory) {
        if (_value == 0) {
            return "0";
        }
        uint256 temp = _value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (_value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(_value % 10)));
            _value /= 10;
        }
        return string(buffer);
    }
}
