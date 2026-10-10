// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTMarketplace {
    struct Listing {
        address seller;
        uint256 price;
    }

    // Mapping dari alamat NFT -> Token ID -> Data Listing
    mapping(address => mapping(uint256 => Listing)) public listings;

    event ItemListed(address indexed nftAddress, uint256 indexed tokenId, uint256 price, address seller);
    event ItemSold(address indexed nftAddress, uint256 indexed tokenId, uint256 price, address buyer);

    /// @notice Mendaftarkan NFT untuk dijual
    function listItem(address _nftAddress, uint256 _tokenId, uint256 _price) external {
        require(_price > 0, "Price must be greater than zero");
        
        IERC721 nft = IERC721(_nftAddress);
        require(nft.ownerOf(_tokenId) == msg.sender, "Not the owner");
        require(nft.getApproved(_tokenId) == address(this), "Marketplace not approved");

        listings[_nftAddress][_tokenId] = Listing({
            seller: msg.sender,
            price: _price
        });

        emit ItemListed(_nftAddress, _tokenId, _price, msg.sender);
    }

    /// @notice Membeli NFT yang terdaftar
    function buyItem(address _nftAddress, uint256 _tokenId) external payable {
        Listing memory listedItem = listings[_nftAddress][_tokenId];
        require(listedItem.price > 0, "Item not for sale");
        require(msg.value >= listedItem.price, "Insufficient payment");

        // Hapus listing sebelum transfer untuk mencegah reentrancy
        delete listings[_nftAddress][_tokenId];

        // Transfer pembayaran ke penjual
        (bool success, ) = payable(listedItem.seller).call{value: listedItem.price}("");
        require(success, "Transfer failed");

        // Transfer NFT ke pembeli
        IERC721(_nftAddress).safeTransferFrom(listedItem.seller, msg.sender, _tokenId);

        emit ItemSold(_nftAddress, _tokenId, listedItem.price, msg.sender);
    }
}
