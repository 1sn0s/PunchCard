pragma solidity 0.4.19^;

import "./DetailedERC721.sol";

contract PunchCardNFT is DetailedERC721{
	string public name;
	string public symbol;

	uint public totalPunchCards;

	mapping(uint=>address) internal puchCardIdToOwner;
	mapping(uint=>string) internal punchCardIdToMetaData;
	mapping(address=>uint[]) internal ownerToPunchCardsOwned;
	mapping(uint=>uint) internal punchCardIdToOwnerArrayIndex;
	mapping (uint=>address) internal punchCardIdToApprovedAddress;
	

	event Transfer(address indexed _from, address indexed _to, uint256 _punchCardId);
	event Approval(address indexed _owner, address indexed _requester, uint256 _punchCardId);

	modifier onlyExtantPunchCards(uint _punchCardId){
		require(ownerOf(_punchCardId) != address(0));
		_;
	}

	function totalSupply() public view returns(uint256){
		return  totalPunchCards;
	}

	function balanceOf(address _owner) public view returns(uint256){
		return ownerToPunchCardsOwned[_owner].length;
	}

	function ownerOf(uint _tokenId) public view returns(address){
		return _ownerOf(_tokenId);
	}

	function approve(address _to, uint _tokenId) public onlyExtantPunchCards(_tokenId){
		require(msg.sender == _ownerOf(_tokenId));
		require(msg.sender != _to);

		_approve(_to, _tokenId);
		Approval(msg.sender, _to, _tokenId);
	}

	function getApproved(uint _tokenId) public view returns(address _approved){
		_getApproved(uint _tokenId);
	}

	//transfer the NFT _tokenId from _from to _to
	function transferFrom(address _from, address _to, uint _tokenId) public onlyExtantPunchCards(_tokenId){
		require(getApproved(_tokenId) == msg.sender);
		require(ownerof(_tokenId) == _from);
		require(_to !== address(0));

		_clearApprovalAndTransfer(_from, _to, _tokenId);

		Approval(_from, 0, _tokenId);
		Transfer(_from, _to, _tokenId);
	}

	function transfer(address _to, uint _tokenId) public onlyExtantPunchCards(_tokenId){
		require(ownerof(_tokenId) == msg.sender);
		require(_to != address(0));

		_clearApprovalAndTransfer(msg.sender, _to, _tokenId);

		Approval(msg.sender, _to, _tokenId);
		Transfer(msg.sender, _to, _tokenId);
	}

	function getTokenOfOwnerByIndex(address _owner, uint _index) public view returns(uint _tokenId){
		_getTokenOfOwnerByIndex(_owner, _index);
	}

	function _getTokenOfOwnerByIndex(address _owner, uint _index) private view returns(uint _tokenId){
		return ownerToPunchCardsOwned[_index];
	}	

	function _clearApprovalAndTransfer(address _from, address _to, uint _tokenId) internal{
		_clearTokenApproval(_tokenId);
		_removeTokenFromOwnersList(_from, _tokenId);
		_setTokenOwner(_tokenId, _to);
		_addTokenToOwnersList(_to, _tokenId);
	}

	function _clearTokenApproval(uint _tokenId) internal{
		punchCardIdToApprovedAddress[_tokenId] = address(0);
	}

	function _removeTokenFromOwnersList(address _owner, uint _tokenId) internal{
		uint length = ownerToPunchCardsOwned[_owner].length;
		uint index = punchCardIdToOwnerArrayIndex[_tokenId];
		uint swapPunchCardId = ownerToPunchCardsOwned[_owner][length - 1];

		ownerToPunchCardsOwned[_owner][index] = swapPunchCardId;
		punchCardIdToOwnerArrayIndex[swapPunchCardId] = index;

		delete ownerToPunchCardsOwned[_owner][length - 1];
		ownerToPunchCardsOwned[_owner].length--;
	}

	function _setTokenOwner(uint _tokenId, address _to){
		punchCardIdToOwner[_tokenId] = _to;
	}

	function _addTokenToOwnersList(address _owner,  uint _tokenId) internal view{
		ownerToPunchCardsOwned[_owner].push(_tokenId);
		punchCardIdToOwnerArrayIndex[_tokenId] = ownerToPunchCardsOwned.length - 1;
	}

	function _getApproved(uint _tokenId) internal view{
		punchCardIdToApprovedAddress[_tokenId];
	}

	function getOwnerTokens(address _owner) public view returns(uint[]){
		ownerToPunchCardsOwned[_owner];
	}

	function _getOwnerTokens(address _owner) internal view returns(uint[]){
		ownerToPunchCardsOwned[_owner];
	}
}