pragma solidity^0.4.21;

contract ZperMultiSigWallet {

	uint8 public	totalCosigner;
	uint8 public	votedFor;
	uint8 public	minimum;
	uint256 public lastVoteNo;

	mapping (address => bool) public cosigner;
	mapping (address => uint256) public vote;

	uint8 private transactionType; 
	address private transactionTo;
	uint256 private amount;

	address private voteOwner;
	// 1: transfer ETH
	// 2: change minimum
	// 3: add cosigner
	// 4: delete cosigner

	event InitiateVote(uint8 txtype, address to, uint256 amount);
	event VoteCanceled(address owner);
	event VoteAccomplished(uint8 txtype, address to, uint256 amount);

	modifier onlyCosigner() {
		require(cosigner[msg.sender]);
		_;
	}

	constructor (address[] _cosigner, uint8 _minimum) public {
		require((_cosigner.length > _minimum  || _cosigner.length == 2) && _minimum >= 2);
		for(uint256 i = 0; i < _cosigner.length; i++){
			cosigner[_cosigner[i]] = true;
		}

		totalCosigner = uint8(_cosigner.length);
		minimum = _minimum;
		votedFor = 0;
		lastVoteNo = 0;
	}

	function () external payable {
	}

	function initiateVote(uint8 _type, address _to, uint256 _amount) internal {
		require(votedFor == 0);

		transactionType = _type;
		transactionTo = _to;
		amount = _amount;
		voteOwner = msg.sender;

		votedFor = 1;
		vote[msg.sender] = lastVoteNo + 1;
		emit InitiateVote(_type, _to, _amount);
	}

	function cancelVote() public {
		require(votedFor > 0);
		require(voteOwner == msg.sender);

		emit VoteCanceled(msg.sender);

		txFinished();
	}


	function transferOwnership (address _newCosigner) onlyCosigner public {
		cosigner[msg.sender] = false;
		cosigner[_newCosigner] = true;
	}
	
	function transferFunds (address _to, uint256 _amount) onlyCosigner external {
		initiateVote(1, _to, _amount);
	}
	function changeMinimum (uint8 _minimum) onlyCosigner external {
		require(_minimum >= 2 && 
				(_minimum < totalCosigner || (totalCosigner == 2 && _minimum == 2)));
		initiateVote(2, address(0), uint256(_minimum));
	}

	function addCosigner (address _newCosigner) onlyCosigner external {
		initiateVote(3, _newCosigner, 0);
	}

	function deleteCosigner (address _cosigner) onlyCosigner external {
		require(totalCosigner >= 3);
		initiateVote(4, _cosigner, 0);
	}

	function voteFor() onlyCosigner public returns(bool) {
		require(votedFor > 0);
		require(vote[msg.sender] <= lastVoteNo);

		votedFor++;
		vote[msg.sender] = lastVoteNo + 1;

		if(votedFor >= minimum) {
			if(transactionType == 1) {						// transfer funds
				transactionTo.transfer(amount);
			}
			else if (transactionType == 2) {				// change minimum
				minimum = uint8(amount);
			}
			else if (transactionType == 3) {				// add cosigner
				cosigner[transactionTo] = true;
				totalCosigner++;
			}
			else if (transactionType == 4) {				// delete cosigner
				cosigner[transactionTo] = false;
				totalCosigner--;
				if(totalCosigner <= minimum)
					minimum = totalCosigner - 1;
			}
			txFinished();
			emit VoteAccomplished(transactionType, transactionTo, amount);
		}
	}

	// must be included in transaction function's end
	function txFinished() internal {
		votedFor = 0;
		lastVoteNo++;
	}

}
