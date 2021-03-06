pragma solidity 0.4.18;

import "./ERC721.sol";

contract DetailedERC721 is ERC721 {
    function name() public view returns (string _name);
    function symbol() public view returns (string _symbol);
    //function tokenMetadata(uint _tokenId) public view returns (string _infoUrl);
    function tokenOfOwnerByIndex(address _owner, uint _index) public view returns (uint _tokenId);
}
