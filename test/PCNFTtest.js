var PCNFT = artifacts.require("PunchCardNFT");
var assert = require('assert');

contract('PCNFT', function(accounts){
	it("Testing the symbol for PCNFT", function(){
		return PCNFT.deployed()
		.then(function(instance) {		
			return instance.symbol();
		})
		.then(function(symbol){
			assert.equal(symbol, 'PCNFT', "Symbol is not PCNFT");
		})
	});
})
