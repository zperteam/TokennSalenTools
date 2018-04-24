pragma solidity ^0.4.18;

contract refund {

	address public owner;

	event Transfer(address indexed _to, uint256 _value);

	function refund (address _owner) public {
		require(_owner != address(0));
		owner = _owner;
	}

	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}

	function () external payable  {
	}

	function batchTransfer(address[] _tos, uint256[] _amount) onlyOwner public returns (bool) {
		require(_tos.length == _amount.length);
		uint i;

		for(i = 0; i < _tos.length; i++) {
			_tos[i].transfer(_amount[i]);
			emit Transfer(_tos[i], _amount[i]);
		}

		return true;
	}

}
