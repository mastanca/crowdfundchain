pragma solidity ^0.4.25;
// To return array of futureTransactions to client
pragma experimental ABIEncoderV2;

import "./Owned.sol";
import "./SafeMath.sol";

contract ProjectFactory is Owned {
    using SafeMath for uint256;

    enum States { CLOSED, OPEN, CANCELED }

    struct Project {
        string name;
        uint amount;
        uint creationDate;
        uint endDate;
        States state;
        uint amountContributed;
        address[] contributorsAddresses;
        mapping(address => uint) contributors;
    }

    event NewProject(uint id, string name, uint amount);
    event ProjectStateChanged(uint id, string name, States state);

    Project[] public projects;
    mapping(uint => Project) projectsMap;
    mapping(uint => address) public projectsToOwner;
    uint public projectCount;

    function createProject(string _name, uint _amount, uint _days) public {
        Project memory project = Project(_name, _amount, now, uint(now + _days), States.OPEN, 0, new address[](10));
        uint id = projects.push(project) - 1;
        projectsToOwner[id] = msg.sender;
        projectsMap[id] = project;
        projectCount++;
        emit NewProject(id, _name, _amount);
    }

    function contribute(uint _id) public payable {
        Project storage project = projects[_id];
        project.contributors[msg.sender] += msg.value;
        project.contributorsAddresses.push(msg.sender);
        project.amountContributed += msg.value;
    }

    function getAmountContributedFor(uint _projectId) public view returns (uint amount) {
        Project storage project = projects[_projectId];
        return project.amountContributed;
    }

    function auditProject(uint _projectId) public {
        Project storage project = projects[_projectId];
        if (project.amountContributed >= project.amount) {
            project.state = States.CLOSED;
            projectsToOwner[_projectId].transfer(project.amountContributed);
            project.amountContributed = 0;
        } else if (project.endDate < now) {
            project.state = States.CANCELED;
            for (uint index = 0; index < project.contributorsAddresses.length; index++) {
                address contributor = project.contributorsAddresses[index];
                contributor.transfer(project.contributors[contributor]);
            }
        }
        emit ProjectStateChanged(_projectId, project.name, project.state);
    }
}
