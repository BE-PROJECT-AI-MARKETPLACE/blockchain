// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Strings.sol";
contract Authentication{
    
    //creating a structure for user
    struct User{
        string userID;
        string name;
        string email;
        bytes32 passwordHash;
        bool isLoggedIn;
    }

    mapping(address => User) private users;

    mapping (string => bytes32) emailPasswordMap;

    User[] public allUsers;

    uint256 counter = 1;

    modifier onlyLoggedIn(){
        require(users[msg.sender].isLoggedIn,"User not logged in");
        _;
    }

    function signUp(string calldata _name, string calldata _email,string calldata _password) external{
       require(!users[msg.sender].isLoggedIn,"User already registered");
       bytes32 _passwordHash = keccak256(abi.encodePacked(_password));
       string memory _userID = Strings.toHexString(msg.sender);
       users[msg.sender] = User({
        userID: _userID,
        name: _name,
        email:_email,
        passwordHash : _passwordHash,
        isLoggedIn: false
       });
       emailPasswordMap[_email] = _passwordHash;
       allUsers.push(users[msg.sender]);
       counter++;
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


    function getUserByID(string memory _userID) external view returns (User memory){
        User memory _user ;
        for(uint256 i=0;i<allUsers.length;i++){
            if(keccak256(abi.encodePacked(allUsers[i].userID)) == keccak256(abi.encodePacked(_userID))){
                _user = allUsers[i];
            }
        }
        return _user;
    }
}