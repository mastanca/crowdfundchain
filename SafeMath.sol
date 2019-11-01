pragma solidity ^0.4.25;

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(
            c >= a, "Invalid result"
            );
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(
            b <= a,
            "Second param should be lte the first one"
            );
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(
            a == 0 || c / a == b,
            "Invalid result"
            );
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(
            b > 0,
            "Zero division"
            );
        c = a / b;
    }
}
