pragma solidity 0.4.18;

import "./DetailedERC721.sol";

contract PunchCardNFT is DetailedERC721{
	string public name;
	string public symbol = 'PCNFT';

	uint public totalPunchCards;

	mapping(uint=>address) internal punchCardIdToOwner;
	mapping(uint=>string) internal punchCardIdToMetaData;
	mapping(address=>uint[]) internal ownerToPunchCardsOwned;
	mapping(uint=>uint) internal punchCardIdToOwnerArrayIndex;
	mapping (uint=>address) internal punchCardIdToApprovedAddress;
	
	/* ERC721 events */
	event Transfer(address indexed _from, address indexed _to, uint256 _punchCardId);
	event Approval(address indexed _owner, address indexed _requester, uint256 _punchCardId);

	//Only punch cards in existance
	modifier onlyExtantPunchCards(uint _punchCardId){
		require(_ownerOf(_punchCardId) != address(0));
		_;
	}

	/* ERC721 public functions */
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
		return _getApproved(_tokenId);
	}

	/*transfer the NFT _tokenId from _from to _to*/
	function transferFrom(address _from, address _to, uint _tokenId) public onlyExtantPunchCards(_tokenId){
		require(getApproved(_tokenId) == msg.sender);
		require(_ownerOf(_tokenId) == _from);
		require(_to != address(0));

		_clearApprovalAndTransfer(_from, _to, _tokenId);

		Approval(_from, 0, _tokenId);
		Transfer(_from, _to, _tokenId);
	}

	function transfer(address _to, uint _tokenId) public onlyExtantPunchCards(_tokenId){
		require(_ownerOf(_tokenId) == msg.sender);
		require(_to != address(0));

		_clearApprovalAndTransfer(msg.sender, _to, _tokenId);

		Approval(msg.sender, _to, _tokenId);
		Transfer(msg.sender, _to, _tokenId);
	}

	function tokenOfOwnerByIndex(address _owner, uint _index) public view returns(uint _tokenId){
		return _getTokenOfOwnerByIndex(_owner, _index);
	}

	/*private functions*/
	function _ownerOf(uint _tokenId) internal view returns(address){
		return punchCardIdToOwner[_tokenId];
	}

	function _approve(address _to, uint _tokenId) internal{
		punchCardIdToApprovedAddress[_tokenId] = _to;
	}

	function _getApproved(uint _tokenId) internal view returns(address){
		return punchCardIdToApprovedAddress[_tokenId];
	}

	function _getTokenOfOwnerByIndex(address _owner, uint _index) private view returns(uint _tokenId){
		return ownerToPunchCardsOwned[_owner][_index];
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

	function _setTokenOwner(uint _tokenId, address _to) internal{
		punchCardIdToOwner[_tokenId] = _to;
	}

	function _addTokenToOwnersList(address _owner,  uint _tokenId) internal{
		ownerToPunchCardsOwned[_owner].push(_tokenId);
		punchCardIdToOwnerArrayIndex[_tokenId] = ownerToPunchCardsOwned[_owner].length - 1;
	}

	function getOwnerTokens(address _owner) public view returns(uint[]){
		return ownerToPunchCardsOwned[_owner];
	}

	function _getOwnerTokens(address _owner) internal view returns(uint[]){
		return ownerToPunchCardsOwned[_owner];
	}

	function _getSymbol() internal view returns(string){
		return symbol;
	}

}