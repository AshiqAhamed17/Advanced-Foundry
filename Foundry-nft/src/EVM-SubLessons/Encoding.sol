//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// For the cheatsheet, check out the docs: https://docs.soliditylang.org/en/v0.8.13/cheatsheet.html?highlight=encodewithsignature

contract Encoding {

    function combineStrings() public pure returns (string memory) {
        return string(abi.encodePacked("Hi", "There!!!"));
    }

    function encodeNumber() public pure returns(bytes memory) {
        bytes memory num = abi.encode(7);
        return num;
    }

    function encodeString() public pure returns (bytes memory){
        bytes memory str = abi.encode("String from Encode");
        return str;
    }

    function encodeStringPacked() public pure returns (bytes memory) {
        bytes memory str = abi.encodePacked("String from EncodePacked");
        return str;
    }

    function decodeString() pure public returns (string memory) {
        string memory res = abi.decode(encodeString(), (string));
        return res;
    }

    function multiEncode() pure public returns (bytes memory) {
        bytes memory str = abi.encode("First str", "Second Str");
        return str;
    }

    function multiDecode() pure public returns (string memory, string memory) {
        (string memory str1, string memory str2) = abi.decode(multiEncode(), (string, string));
        return (str1, str2);
    }

    function multiEncodePacked() pure public returns (bytes memory) {
        bytes memory str = abi.encodePacked("First str", "Second Str");
        return str;
    }

    // @Note this doesn't work
    //  function multiDecodePacked() pure public returns (string memory) {
    //     (string memory str1, string memory str2) = abi.decode(multiEncodePacked(), (string, string));
    //     return (str1, str2);
    // }

    function multiStringCastPacked() pure public returns (string memory) {
        string memory str = string(multiEncodePacked());
        return str;
    }

    function withdraw(address addr) public {
        (bool success, ) =  addr.call{value: address(this).balance}("");
        require(success, "Transfer Failed");
    }


}