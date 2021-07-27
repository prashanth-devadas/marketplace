// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";


contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address marketplaceAddress;
    
    constructor (address _marketplaceAddress) ERC721("Prashanth's Digital market place", "PDM"){
        marketplaceAddress = _marketplaceAddress; 
    }
    
    function createToken(string memory tokenURI) public returns (uint){
        _tokenIds.increment();
        uint newItemId = _tokenIds.current();   
        
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        setApprovalForAll(marketplaceAddress, true);
        return newItemId;
    }
}


contract NFTMarket is ReentrancyGuard {

    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;
    
    struct MarketItem {
        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
    }
    
    mapping(uint256 => MarketItem) private idToMarketItem;
    
    event MarketItemCreated(
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price
    );
    
    
    function createMarketItem(
        address nftContract,
        uint256 tokenId,
        uint256 tokenPrice
    )   public payable nonReentrant {
        require(tokenPrice > 0, "Price must be at least 1 wei");
        
        
        _itemIds.increment();
        uint256 itemId = _itemIds.current();
        
        idToMarketItem[itemId] = MarketItem(
                itemId,
                nftContract,
                tokenId,
                payable(msg.sender),
                payable(address(0)),
                tokenPrice
        );
        
        
        
        // emit MarketItemCreated(
        //     itemId,
        //     nftContract,
        //     tokenId,
        //     msg.sender,
        //     address(0),
        //     tokenPrice
        // );
        
    }
    
}