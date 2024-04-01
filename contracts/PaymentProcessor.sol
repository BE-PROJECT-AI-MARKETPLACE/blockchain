// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PaymentProcessor {
    address public admin;
    IERC20 public dai;

    event PaymentDone(address payer, uint amount, uint paymentId, uint date);

    constructor(address adminAddress, address daiAddress) {
        admin = adminAddress;
        dai = IERC20(daiAddress);
    }
    struct XYZ{
        address a;
        address b;
        uint amount;
        uint256 balSender;
        uint256 balAdmin;
        // bool status;
    }
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

    function getApproval(string memory sender, uint amount) external returns (address){
        address adr = stringToAddress(sender);
        return adr;
    }
    function pay(uint amount, uint paymentId, string memory sender) external returns (bool) {
    address adr = stringToAddress(sender);
    bool status = dai.transfer(adr,amount);
    emit PaymentDone(adr, amount, paymentId, block.timestamp);
    // return status;

            // XYZ memory xyz = XYZ({a : adr,b : admin, amount : amount,balSender : dai.balanceOf(adr), balAdmin:dai.balanceOf(admin)});
        // return xyz;
}

}
