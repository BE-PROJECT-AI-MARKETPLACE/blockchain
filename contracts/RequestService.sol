// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RequestService {
    struct Request {
        string name;
        string email;
        string phoneNumber;
        string serviceTitle;
        string domain;
        string description;
        address requester;
        bool isCompleted;
    }

    Request[] public requests;

    function addRequest(
        string memory _name,
        string memory _email,
        string memory _phoneNumber,
        string memory _serviceTitle,
        string memory _domain,
        string memory _description
    ) public {
        Request memory newRequest = Request({
            name: _name,
            email: _email,
            phoneNumber: _phoneNumber,
            serviceTitle: _serviceTitle,
            domain: _domain,
            description: _description,
            requester: msg.sender,
            isCompleted : false
        });

        requests.push(newRequest);
    }

    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }

    function getRequestsOfUser(uint index) public view returns (
        string memory name,
        string memory email,
        string memory phoneNumber,
        string memory useCase,
        string memory domain,
        string memory description,
        address requester
    ) {
        require(index < requests.length, "Index out of bounds");

        Request storage req = requests[index];
        return (req.name, req.email, req.phoneNumber, req.serviceTitle, req.domain, req.description, req.requester);
    }

    function getAllRequests() public view returns (Request[] memory) {
        return requests;
    }
}
