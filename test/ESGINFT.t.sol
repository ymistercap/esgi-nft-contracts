// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ESGINFT.sol";

contract ESGINFTTest is Test {
    ESGINFT public nft;

    function setUp() public {
        nft = new ESGINFT();
    }

    function testCreateNFT() public {
        address recipient = address(0x1);
        uint256 tokenId = nft.createNFT(recipient, "ipfs://exampleCID");
        assertEq(tokenId, 0);
        (ESGINFT.Status status, ) = nft.nftData(tokenId);
        assertEq(uint(status), uint(ESGINFT.Status.Active));
    }

    function testUpdateNFT() public {
        address recipient = address(0x1);
        uint256 tokenId = nft.createNFT(recipient, "ipfs://oldCID");
        nft.updateNFT(tokenId, "ipfs://newCID");
        (, string memory uri) = nft.nftData(tokenId);
        assertEq(uri, "ipfs://newCID");
    }

    function testRevokeNFT() public {
        address recipient = address(0x1);
        uint256 tokenId = nft.createNFT(recipient, "ipfs://exampleCID");
        nft.revokeNFT(tokenId);
        (ESGINFT.Status status, ) = nft.nftData(tokenId);
        assertEq(uint(status), uint(ESGINFT.Status.Revoked));
    }

}
