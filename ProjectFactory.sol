pragma solidity ^0.4.25;

import "./Owned.sol";
import "./SafeMath.sol";

contract ProjectFactory is Owned {
    using SafeMath for uint256;

    enum States { CLOSE, OPEN, CANCELED }

    struct Project {
        string name;
        uint amount;
        uint creationDate;
        uint endDate;
        States state;
        address[] contributorsAddresses;
        mapping(address => uint) contributors;
    }

    event NewProject(uint id, string name, uint amount);

    Project[] public projects;
    mapping(uint => address) public projectsToOwner;
    mapping(address => uint) ownerProjectsCount;

    function createProject(string _name, uint _amount, uint _days) public {
        uint id = projects.push(Project(_name, _amount, now, uint(now + _days), States.OPEN, new address[](10))) - 1;
        projectsToOwner[id] = msg.sender;
        ownerProjectsCount[msg.sender]++;
        emit NewProject(id, _name, _amount);
    }
}
