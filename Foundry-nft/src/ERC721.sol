//SPDX-LICENSE-Identifier: MIT
pragma solidity ^0.8.18;

contract ERC721 {

    mapping(uint256 id => address owner ) public ownerOf;
    mapping(address owner => uint256 balance) public balanceOf;
    mapping(address owner => mapping(address operator => bool)) private _isApprovedForAll;
    mapping(uint256 id => address approvedForId) public getApproved;

    event Transfer(address indexed from, address indexed to,  uint256 indexed id);
    event ApproveForAll(address indexed owner, address indexed operator, bool approved);
    event Approval(address indexed owner, address indexed spender, address indexed id);

    function mint(address owner, uint256 id) public {

        require(ownerOf[id] == address(0), "Already Minted");
        ownerOf[id] = owner;
        balanceOf[owner]++;

        emit Transfer(address(0), owner, id);
    }

    function transferFrom(address from, address to, uint256 id) external payable{
        require(
        ownerOf[id] == msg.sender || 
        _isApprovedForAll[from][msg.sender] || 
        getApproved[id] == msg.sender, 
        "Transfer Not Allowed"
    );
        
        getApproved[id] = address(0);
        ownerOf[id] = to;
        balanceOf[from]--;
        balanceOf[to]++;
        emit Transfer(from, to, id);
    }

    function setApprovalForAll(address operator, bool approved) external payable {
        require(operator != address(0), "Invalid address");
        _isApprovedForAll[msg.sender][operator] = approved;

        emit ApproveForAll(msg.sender, operator, approved);
    }


}