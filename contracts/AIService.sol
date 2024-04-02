// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract AIService{

    struct ProjectDetails{
        string projectURL;
        string serviceID;
        string service_contributors;
    }

    struct Service{
        string service_name;
        string service_overview;
        string service_provider;
        string service_address;
        ProjectDetails service_details;
    }

    //array that stores all the services
    Service[] public allServices;
    // map relating address to the service
    mapping (string => Service) public allService;
    //map relating which user has access to which service 
    mapping (address => string[]) userHasAccess;
    //map relating service to owner of it;
    mapping(string => address) serviceOwner;

    mapping(string => Service) public allServiceByName ;

    mapping(address => Service[]) owner;
    mapping (string => string) nameAddress;

    uint256 counter = 1;
    //function to add Service
    function addService(string memory _service_name,
                        string memory _service_overview,
                        string memory _service_provider, 
                        string memory _service_address,
                        string memory _projectURL,
                         
                        string memory _service_contributors) external{

                            string memory _serviceID = Strings.toString(counter);
                            ProjectDetails memory newProjectDetails = ProjectDetails(
                                            _projectURL,
                                            _serviceID,
                                            _service_contributors
                                        );
                            Service memory newService = Service(
                                            _service_name,
                                            _service_overview,
                                            _service_provider,
                                            _service_address,
                                            newProjectDetails
                                        );
                            allServices.push(newService);
                            allService[_service_address] = newService;
                            allServiceByName[_service_name] = newService;
                            serviceOwner[_service_name] = msg.sender;
                            owner[msg.sender].push(newService);
                            nameAddress[_service_name] = _service_address;
                            counter+=1; 
    }

    //function to check if user has access to the service or not.
    // if not access is given
    function giveUserAccess(string memory _service_name) external{
        // bool notContains = false;
        // for(uint256 i=0;i<userHasAccess[msg.sender].length;i++){
        //     string memory temp= userHasAccess[msg.sender][i];
        //     if(keccak256(abi.encodePacked(temp)) == keccak256(abi.encodePacked(_service_name))){
        //         notContains = true;
        //     }
        // }
        // require(notContains,"User already has access to service");
        userHasAccess[msg.sender].push(_service_name);
    }

    // function to get all services owned by a user :)
    function getUserServices() external view returns(Service[] memory){
        Service[] memory userService = new Service[](userHasAccess[msg.sender].length);
        for(uint256 i=0;i<userHasAccess[msg.sender].length;i++){
            string memory addr = userHasAccess[msg.sender][i];
            userService[i] = allServiceByName[addr];
        }
        return userService;
    }

    //function to get all available services
    function getAllServices() external view returns(Service[] memory){
        return allServices;
    }

    function getService(string memory service_id) external view returns(Service memory){
        Service memory ser;
        for(uint256 i=0;i<allServices.length;i++){
            if(keccak256(abi.encodePacked(allServices[i].service_details.serviceID)) == keccak256(abi.encodePacked(service_id))){
                ser = allServices[i];
            }
        }
        return ser;
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
    function getOwnerAddress(string memory _service_name) external view returns (string memory){
        return addressToString(serviceOwner[_service_name]);
    }

    function getOwnersServices() external view returns(Service[] memory){
        Service[] memory ownerService = new Service[](owner[msg.sender].length);
        for(uint256 i=0;i<owner[msg.sender].length;i++){
            ownerService[i] = owner[msg.sender][i];
        }
        return ownerService;
    }

    function getAddressByName(string memory _service_name) external view returns (string memory){
        return nameAddress[_service_name];
    }
}