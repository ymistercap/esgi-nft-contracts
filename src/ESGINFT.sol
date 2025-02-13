// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ESGINFT is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;

    enum Status { Active, Revoked }
    struct NFTData {
        Status status;
        string metadataUri;
    }

    mapping(uint256 => NFTData) public nftData;

    event NFTCreated(uint256 indexed tokenId, address indexed owner, string metadataUri);
    event NFTUpdated(uint256 indexed tokenId, string newMetadataUri);
    event NFTRevoked(uint256 indexed tokenId);

    constructor() ERC721("ESGI NFT", "ESGINFT") Ownable(msg.sender) {
        tokenCounter = 0;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }

    /// @notice Crée un nouveau NFT et l’assigne à l’adresse donnée
    function createNFT(address recipient, string memory metadataUri) public onlyOwner returns (uint256) {
        uint256 newTokenId = tokenCounter;
        _safeMint(recipient, newTokenId);
        _setTokenURI(newTokenId, metadataUri);
        nftData[newTokenId] = NFTData(Status.Active, metadataUri);
        tokenCounter++;
        emit NFTCreated(newTokenId, recipient, metadataUri);
        return newTokenId;
    }

    /// @notice Met à jour le metadata d’un NFT existant (si actif)
    function updateNFT(uint256 tokenId, string memory newMetadataUri) public onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        require(nftData[tokenId].status == Status.Active, "NFT is not active");
        _setTokenURI(tokenId, newMetadataUri);
        nftData[tokenId].metadataUri = newMetadataUri;
        emit NFTUpdated(tokenId, newMetadataUri);
    }

    /// @notice Révoque un NFT, le marquant comme inactif
    function revokeNFT(uint256 tokenId) public onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        nftData[tokenId].status = Status.Revoked;
        emit NFTRevoked(tokenId);
    }
}
