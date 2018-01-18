pragma solidity 0.4.19^;

import "./DetailedERC721.sol";

contract PunchCardNFT is DetailedERC721{
	string public name;
	string public symbol;

	uint public totalPunchCards;

	mapping(uint=>address) internal puchCardIdToOwner;
	mapping(uint=>string) internal punchCardIdToMetaData;
	mapping(address=>uint[]) internal ownerToTokensOwned;
	mapping(uint[]=>address)

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
		return ownerToTokensOwned[_owner].length;
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
		requrie(_to !== address(0));

		_clearApprovalAndTransfer(_from, _to, _tokenId);

		Approval(_from, 0, _tokenId);
		Transfer(_from, _to, _tokenId);
	}
}