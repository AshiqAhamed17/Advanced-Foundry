// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract SsNFT is ERC721URIStorage{
    uint256 private _tokenIdCounter;

    constructor() ERC721("SydneyS", "SS") {}

    function mintNFT(address recipient, string memory tokenURI) public returns(uint256) {
        uint256 newTokenId = _tokenIdCounter;
        _mint(recipient, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
        _tokenIdCounter++;
        return newTokenId;
    }

}

