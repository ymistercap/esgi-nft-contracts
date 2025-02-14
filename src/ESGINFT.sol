// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ESGINFT
 * @notice Smart contract pour la gestion des NFTs dynamiques d'ESGI.
 * Les métadonnées des NFTs sont stockées hors-chaîne sur IPFS et référencées par leur URI.
 */
contract ESGINFT is ERC721URIStorage, Ownable {
    uint256 public tokenCounter;

    // Enumération pour l'état d'un NFT.
    enum Status { Active, Revoked }

    // Structure stockant les informations essentielles du NFT.
    struct NFTData {
        Status status;
        string metadataUri; // Lien IPFS vers le fichier JSON contenant les métadonnées.
    }

    // Mapping de tokenId vers ses données associées.
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
    /// @notice Crée un nouveau NFT et l’assigne à l’adresse donnée.
    /// @param recipient Adresse du destinataire.
    /// @param metadataUri Lien IPFS vers le JSON des métadonnées.
    /// @return Le tokenId du NFT créé.
    function createNFT(address recipient, string memory metadataUri) public onlyOwner returns (uint256) {
        uint256 newTokenId = tokenCounter;
        _safeMint(recipient, newTokenId);
        _setTokenURI(newTokenId, metadataUri);
        nftData[newTokenId] = NFTData(Status.Active, metadataUri);
        tokenCounter++;
        emit NFTCreated(newTokenId, recipient, metadataUri);
        return newTokenId;
    }

    /// @notice Met à jour les métadonnées d’un NFT existant (si actif).
    /// @param tokenId L'identifiant du NFT à mettre à jour.
    /// @param newMetadataUri Nouveau lien IPFS vers les métadonnées.
    function updateNFT(uint256 tokenId, string memory newMetadataUri) public onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        require(nftData[tokenId].status == Status.Active, "NFT is not active");
        _setTokenURI(tokenId, newMetadataUri);
        nftData[tokenId].metadataUri = newMetadataUri;
        emit NFTUpdated(tokenId, newMetadataUri);
    }

    /// @notice Révoque un NFT, le marquant comme inactif.
    /// @param tokenId L'identifiant du NFT à révoquer.
    function revokeNFT(uint256 tokenId) public onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        nftData[tokenId].status = Status.Revoked;
        emit NFTRevoked(tokenId);
    }
}
