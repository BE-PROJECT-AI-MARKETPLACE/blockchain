// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Strings.sol";

contract Authentication {
    //creating a structure for user
    struct User {
        address userID;
        string name;
        string email;
        bytes32 passwordHash;
        bool isLoggedIn;
    }

    mapping(address => User) private users;

    mapping(string => bytes32) emailPasswordMap;

    User[] public allUsers;

    uint256 counter = 1;

    modifier onlyLoggedIn() {
        require(users[msg.sender].isLoggedIn, "User not logged in");
        _;
    }

    function signUp(
        string calldata _name,
        string calldata _email,
        string calldata _password
    ) external {
        require(!users[msg.sender].isLoggedIn, "User already registered");
        bytes32 _passwordHash = keccak256(abi.encodePacked(_password));
        //string memory _userID = addressToString(msg.sender);
        users[msg.sender] = User({
            userID: msg.sender,
            name: _name,
            email: _email,
            passwordHash: _passwordHash,
            isLoggedIn: false
        });
        emailPasswordMap[_email] = _passwordHash;
        allUsers.push(users[msg.sender]);
        counter++;
    }

    function getAllUsers() external view returns (User[] memory) {
        return allUsers;
    }

    function login(string calldata _email, string calldata _password)
        external
        returns (string memory)
    {
        // add check for non existing user and ask to register
        string memory message = "";
        if (
            keccak256(abi.encodePacked(_password)) == emailPasswordMap[_email]
        ) {
            users[msg.sender].isLoggedIn = true;
            message = "User Login Complete";
        } else {
            message = "Incorrect Credentials";
        }
        return message;
    }

    function logout() external onlyLoggedIn {
        users[msg.sender].isLoggedIn = false;
    }

    function isUserLoggedIn(address _user) external view returns (bool) {
        return users[_user].isLoggedIn;
    }
 function addressToString(address _address) internal pure returns (string memory) {
        bytes32 value = bytes32(uint256(uint160(_address)));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
        }
        return string(str);
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
    function getUserByID(address _userID) external view returns (User memory)
    {
        return users[_userID];
    }
}
