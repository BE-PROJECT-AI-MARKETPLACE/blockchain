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
        address service_address;
        ProjectDetails service_details;
    }

    //array that stores all the services
    Service[] public allServices;
    // map relating address to the service
    mapping (address => Service) public allService;
    //map relating which user has access to which service 
    mapping (address=> address[]) userHasAccess;

    //function to add Service
    function addService(string calldata _service_name,
                        string calldata _service_overview,
                        string calldata _service_provider, 
                        address _service_address,
                        string calldata _projectURL,
                        string calldata _serviceID,
                        string calldata _service_contributors) external{

                            ProjectDetails memory newProjectdetails = ProjectDetails(
                                _projectURL,
                                _serviceID,
                                _service_contributors
                            );
                            Service memory newService = Service(
                                _service_name,
                                _service_overview,
                                _service_provider,
                                _service_address,
                                newProjectdetails);
                                allServices.push(newService);
                                allService[_service_address] = newService;
    }

    //function to check if user has access to the service or not.
    // if not access is given
    function giveUserAccess(address _service_address) external{
        bool notContains = false;
        for(uint256 i=0;i<userHasAccess[msg.sender].length;i++){
            if(userHasAccess[msg.sender][i] == _service_address){
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
            address addr = userHasAccess[msg.sender][i];
            userService[i] = allService[addr];
        }
        return userService;
    }

    // //function to get all available services
    // function getAllServices() external view returns(Service[] memory){
    //     return allServices;
    // }

}