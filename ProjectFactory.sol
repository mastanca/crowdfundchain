pragma solidity ^0.4.25;

import "./Owned.sol";
import "./SafeMath.sol";

contract ProjectFactory is Ownable {
    using SafeMath for uint256;

    enum States { CLOSE, OPEN, CANCELED }

    struct Project {
        string name;
        uint amount;
        uint creationDate;
        uint endDate;
        States states;
        address[] contributorsAddresses;
        mapping(address => uint) contributors;
    }

    event NewProject(uint id, string name, uint amount);

    Project[] public projects;
    mapping(uint => address) public projectsToOwner;
    mapping(address => uint) ownerProjectsCount;

    function createProject(string _name, uint _amount, uint _days) public {
        uint id = Projects.push(Project(_name, _amount, now, uint(now + _days), OPEN)) - 1;
        projectsToOwner[id] = msg.sender;
        ownerProjectsCount[msg.sender]++;
        emit NewProject(id, _name, _amount);
    }
}
