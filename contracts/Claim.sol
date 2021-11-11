pragma solidity ^0.8.0;

import "./@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./@openzeppelin/contracts/utils/Counters.sol";

contract Claim is ERC721, ERC721URIStorage, ERC721Enumerable{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    event ClaimMint(address minter, uint256 newClaimId);

    constructor() ERC721("Claim", "CLM"){}

    function safeMintClaim(address player, string memory tURI) public returns (uint256) {
        _tokenIds.increment();

        uint256 newClaimId = _tokenIds.current();
        _safeMint(player, newClaimId);
        _setTokenURI(newClaimId, tURI);
        emit ClaimMint(msg.sender, newClaimId);
        return newClaimId;
    }


    //These are just required override functions because, ERC721, ERC721URIStorage & ERC721Enumerable all have these.
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

}