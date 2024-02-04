// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Authentication{
    
    //creating a structure for user
    struct User{
        string name;
        string email;
        bytes32 passwordHash;
        bool isLoggedIn;
    }

    mapping(address => User) private users;

    mapping (string => bytes32) emailPasswordMap;

    User[] public allUsers;

    modifier onlyLoggedIn(){
        require(users[msg.sender].isLoggedIn,"User not logged in");
        _;
    }

    function signUp(string calldata _name, string calldata _email,string calldata _password) external{
       require(!users[msg.sender].isLoggedIn,"User already registered");
       bytes32 _passwordHash = keccak256(abi.encodePacked(_password));
       users[msg.sender] = User({
        name: _name,
        email:_email,
        passwordHash : _passwordHash,
        isLoggedIn: false
       });
       emailPasswordMap[_email] = _passwordHash;
       allUsers.push(users[msg.sender]);
    }

    function getAllUsers() external view returns(User[] memory){
        return allUsers;
    }

    function login(string calldata _email,string calldata _password) external returns (string memory){
        // add check for non existing user and ask to register
        string memory message= "";
        if(keccak256(abi.encodePacked(_password)) == emailPasswordMap[_email]){
              users[msg.sender].isLoggedIn = true;
            message = "User Login Complete";
        }else{
           message = "Incorrect Credentials";
        }
        return message;
        
    }

    function logout() external onlyLoggedIn{
        users[msg.sender].isLoggedIn = false;
    }

    function isUserLoggedIn(address _user) external view returns (bool){
        return users[_user].isLoggedIn;
    }
}