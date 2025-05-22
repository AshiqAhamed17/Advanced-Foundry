// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";

contract BinarySearchTest is Test {
    struct Point {
        uint256 timestamp;
    }
    
    struct Data {
        Point[] points;
        uint256 startIndex;
        uint256 endIndex;
    }
    
    Data public data;
    uint256 constant BEFORE_START = type(uint256).max;
    
    // Original vulnerable function
    function binarySearchUnsafe(Data storage _data, uint256 _ts) internal view returns (uint256) {
        uint256 start = _data.startIndex;
        uint256 end = _data.endIndex;
        if (start >= end || _data.points[start].timestamp > _ts) {
            return BEFORE_START;
        }
        while (end > start + 1) {
            uint256 mid = (start + end) >> 1; // VULNERABLE LINE
            if (_data.points[mid].timestamp <= _ts) {
                start = mid;
            } else {
                end = mid;
            }
        }
        return start;
    }
    
    // Fixed safe function
    function binarySearchSafe(Data storage _data, uint256 _ts) internal view returns (uint256) {
        uint256 start = _data.startIndex;
        uint256 end = _data.endIndex;
        if (start >= end || _data.points[start].timestamp > _ts) {
            return BEFORE_START;
        }
        while (end > start + 1) {
            uint256 mid = start + (end - start) / 2; // SAFE CALCULATION
            if (_data.points[mid].timestamp <= _ts) {
                start = mid;
            } else {
                end = mid;
            }
        }
        return start;
    }
    
    function setUp() public {
        // Setup test data with max uint256 values
        data.points.push(Point(1));
        data.points.push(Point(type(uint256).max - 1));
        data.startIndex = 0;
        data.endIndex = 2;
    }
    
    function testOverflowVulnerability() public {
        // Trigger overflow condition
        uint256 searchTs = type(uint256).max - 2;
        
        // Unsafe version will revert due to overflow
        vm.expectRevert();
        binarySearchUnsafe(data, searchTs);
        
        // Safe version works correctly
        uint256 result = binarySearchSafe(data, searchTs);
        assertEq(result, 0); // Should find first index
    }
    
    function testEdgeCases() public {
        // Test empty array case
        Data memory empty;
        empty.startIndex = 0;
        empty.endIndex = 0;
        assertEq(binarySearchSafe(empty, 1), BEFORE_START);
        
        // Test exact match
        uint256 result = binarySearchSafe(data, type(uint256).max - 1);
        assertEq(result, 1);
    }
}