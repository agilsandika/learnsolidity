// SPDX-License-Identifier: MIT
pragma solidity ^0.8.37;

import "forge-std/Test.sol";
import "../src/MyNFT.sol";
import "../src/NFTMarketplace.sol";

contract NFTMarketTest is Test {
    MyNFT public nft;
    NFTMarketplace public market;

    address public owner = address(0x1);
    address public buyer = address(0x2);

    function setUp() public {
        vm.startPrank(owner);
        nft = new MyNFT();
        market = new NFTMarketplace();
        vm.stopPrank();

        vm.deal(buyer, 10 ether);
    }

    function test_MintAndBuyNFT() public {
        // 1. Owner mint NFT ke dirinya sendiri
        vm.prank(owner);
        uint256 tokenId = nft.mintNFT(owner, "ipfs://QmExampleURI");
        assertEq(nft.ownerOf(tokenId), owner);

        // 2. Owner approve marketplace untuk memindahkan NFT
        vm.prank(owner);
        nft.approve(address(market), tokenId);

        // 3. Owner list NFT dengan harga 1 Ether
        vm.prank(owner);
        market.listItem(address(nft), tokenId, 1 ether);

        // 4. Buyer membeli NFT
        vm.prank(buyer);
        market.buyItem{value: 1 ether}(address(nft), tokenId);

        // Validasi: Kepemilikan NFT berpindah ke buyer
        assertEq(nft.ownerOf(tokenId), buyer);
    }
}
