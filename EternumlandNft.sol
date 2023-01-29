// SPDX-License-Identifier: MIT LICENSE

//Dracore Version

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

pragma solidity ^0.8.4;

contract EternumlandNft is ERC721Enumerable, Ownable {

    
    using Strings for uint256;
    string public baseURI;
    string public baseExtension = ".json";
    uint256 public maxSupply = 6000;
    uint256 public maxMintAmount = 10;
    bool public paused = false;
    uint8 public friendPer = 10;
    uint256 private mintPermit;
    
    constructor() ERC721("Eternumland NFT", "ETRNLD") {}

    function _baseURI() internal view virtual override returns (string memory) {
    return "ipfs://QmPk1boUFfzhAoEzTfrp7iLs2Zk1Lo53aSMEeGnpDSu3gB/";

    }
    
    function mint(address _to, uint256 _mintAmount, address _code, uint256 _mintPermissions) public payable {
            uint256 supply = totalSupply();
            require(!paused);
            require(_mintAmount > 0);
            require(_mintAmount <= maxMintAmount);
            require(supply + _mintAmount <= maxSupply);
            require(_mintPermissions == mintPermit);
        
            for (uint256 i = 1; i <= _mintAmount; i++) {
                _safeMint(_to, supply + i);
            
            payable(_code).transfer(msg.value / 100 * friendPer);
            }
    }


       function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
        {
            uint256 ownerTokenCount = balanceOf(_owner);
            uint256[] memory tokenIds = new uint256[](ownerTokenCount);
            for (uint256 i; i < ownerTokenCount; i++) {
                tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
            }
            return tokenIds;
        }
    
        
        function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory) {
            require(
                _exists(tokenId),
                "ERC721Metadata: URI query for nonexistent token"
                );
                
                string memory currentBaseURI = _baseURI();
                return
                bytes(currentBaseURI).length > 0 
                ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
                : "";
        }
        // only owner
        
        function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
            maxMintAmount = _newmaxMintAmount;
        }
        
        function setBaseURI(string memory _newBaseURI) public onlyOwner() {
            baseURI = _newBaseURI;
        }
        
        function setBaseExtension(string memory _newBaseExtension) public onlyOwner() {
            baseExtension = _newBaseExtension;
        }
        
        function setmintPermit(uint256 _setmintPermit) public onlyOwner() {
            mintPermit = _setmintPermit;
        }
        
        function setFriendPer(uint8 _percentage) public onlyOwner {
             require(_percentage <= 100);
             friendPer = _percentage;
        }
        function pause(bool _state) public onlyOwner() {
            paused = _state;
        }
        
        function withdraw() public payable onlyOwner() {
            require(payable(msg.sender).send(address(this).balance));
        }
}


