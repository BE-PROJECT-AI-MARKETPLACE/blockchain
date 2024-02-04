// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;

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
    mapping (address=> string[]) userHasAccess;
    //map relating service to owner of it;
    mapping(string => address) serviceOwner;

    //function to add Service
    function addService(string memory _service_name,
                        string memory _service_overview,
                        string memory _service_provider, 
                        string memory _service_address,
                        string memory _projectURL,
                        string memory _serviceID,
                        string memory _service_contributors) external{

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
                            // serviceOwner[_service_address] = msg.sender; 
    }

    //function to check if user has access to the service or not.
    // if not access is given
    function giveUserAccess(string memory _service_address) external{
        bool notContains = false;
        for(uint256 i=0;i<userHasAccess[msg.sender].length;i++){
            string memory temp= userHasAccess[msg.sender][i];
            if(keccak256(abi.encodePacked(temp)) == keccak256(abi.encodePacked(_service_address))){
                notContains = true;
            }
        }
        require(notContains,"User already has access to service");
        userHasAccess[msg.sender].push(_service_address);
    }

    // function to get all services owned by a user :)
    function getUserServices() external view returns(Service[] memory){
        Service[] memory userService = new Service[](userHasAccess[msg.sender].length);
        for(uint256 i=0;i<userHasAccess[msg.sender].length;i++){
            string memory addr = userHasAccess[msg.sender][i];
            userService[i] = allService[addr];
        }
        return userService;
    }

    //function to get all available services
    function getAllServices() external view returns(Service[] memory){
        return allServices;
    }

}