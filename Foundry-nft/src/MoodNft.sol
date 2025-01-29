//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import  {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MoodNft is ERC721 {
    uint256 private s_tokenCounter;
    string private s_happySvg;
    string private s_sadSvg;



    constructor(string memory happySvg, string memory sadSvg)
        ERC721("Mood NFT", "MN") {

            s_tokenCounter = 0;
            s_happySvg = happySvg;
            s_sadSvg = sadSvg;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {

    }
}