pragma solidity 0.4.19^;

import "./DetailedERC721.sol";

contract PunchCardNFT is DetailedERC721{
	string public name;
	string public symbol;

	uint public totalPunchCards;

	mapping(uint=>address) internal puchCardIdToOwner;
	mapping(uint=>string) internal punchCardIdToMetaData;

	event Transfer(address indexed _from, address indexed _to, uint256 _punchCardId);
	event Approval(address indexed _owner, address indexed _requester, uint256 _punchCardId);

	modifier onlyExtantPunchCards(uint _punchCardId){
		require(ownerOf(_punchCardId) != address(0));
		_;
	}
}