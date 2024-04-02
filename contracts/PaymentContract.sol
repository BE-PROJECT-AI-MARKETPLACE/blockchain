// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentContract {
    struct Payment {
        address payable buyer;
        address payable seller;
        uint256 amount;
    }

    Payment[] public payments;

    event PaymentReceived(address indexed seller, address indexed buyer, uint256 amount);


    function stringToAddress(string memory _address) internal pure returns (address) {
        bytes memory b = bytes(_address);
        require(b.length == 42 && b[0] == '0' && (b[1] == 'x' || b[1] == 'X'), "Invalid address format");

        uint result = 0;
        for (uint i = 2; i < b.length; i++) {
            uint char = uint(uint8(b[i]));
            if (char >= 48 && char <= 57) {
                result = result * 16 + (char - 48);
            } else if (char >= 65 && char <= 70) {
                result = result * 16 + (char - 55);
            } else if (char >= 97 && char <= 102) {
                result = result * 16 + (char - 87);
            } else {
                revert("Invalid character");
            }
        }
        return address(uint160(result));
    }


    function pay(string memory seller) external payable {
        address payable _seller = payable(stringToAddress(seller));
        require(_seller != address(0), "Invalid seller address");
        require(msg.value > 0, "Payment must be greater than 0 wei");
         Payment memory payment = Payment(payable(msg.sender), _seller, msg.value);
        payments.push(payment);
        _seller.transfer(msg.value); // Directly transfer the amount to the seller
        emit PaymentReceived(_seller, msg.sender, msg.value);
    }
}
