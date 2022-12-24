pragma solidity ^0.8.0;

// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol";
import "./ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract CustomToken is ERC20("Token","TOK"){
    constructor(){
        _mint(msg.sender, 100 * (10 ** 18));
    }
}

contract withBetOptions{
    // enum BetOption{N1,N2,N3,N4,N5,N6,N7,N8,N9,N10,N11,N12,N13,N14,N15,N16,N17,N18,N19,N20,N21,N22,N23,N24,N25,N26,N27,N28,N29,
    //                 N30, N31, N32, N33, N34, N35, N36, RED, BLACK, EVEN, ODD, HIGH, LOW, COLUMN_1, COLUMN_2, COLUMN_3, DOZEN_1, DOZEN_2, 
    //                 DOZEN_3}
    string[] BetList = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16",
                        "17","18","19","20","21","22","23","24","25","26","27","28","29",
                        "30", "31", "32", "33", "34", "35", "36", "RED", "BLACK", "EVEN", "ODD", "HIGH", 
                        "LOW", "COLUMN_1", "COLUMN_2", "COLUMN_3", "DOZEN_1", "DOZEN_2", "DOZEN_3"];
    mapping(string => uint) BetMapping;
    constructor(){
        uint bl_len = BetList.length;
        for(uint i = 0; i< bl_len;i++){
            if(i < 35){
                BetMapping[BetList[i]] = 36;
            } else if( i< 41){
                BetMapping[BetList[i]] = 1;
            } else {
                BetMapping[BetList[i]] = 2;
            }
        }
    }
}

contract Bet{
    struct better{
        address addr;
        uint stake;
    }

    ERC20 public ERCToken;
    uint payout_;
    address public owner_;
    address public bank_;
    string name_;
    uint subnum;
    mapping(uint => better) subscribers_;

    constructor(uint payout, string memory name, ERC20 ERCToken_, address bank){
        payout_ = payout;
        name_ = name;
        owner_ = msg.sender;
        ERCToken = ERCToken_;
        bank_ = bank;
        subnum = 0;
    }

    function subscribe(uint s) public{
        require(ERCToken.balanceOf(msg.sender) >= s, "Insufficient funds for make a bet" );
        better memory b;
        b.addr = msg.sender;
        b.stake = s;
        subscribers_[subnum] = b;
        subnum = subnum+1;
    } 

    function winningBet() public {
        for(uint i = 0; i<subnum; i++){
            require(ERCToken.balanceOf(bank_) > subscribers_[i].stake*payout_, "We're Broke");
            ERCToken.transferFrom(bank_, subscribers_[i].addr, subscribers_[i].stake*payout_);
            delete subscribers_[i];
        }
        subnum = 0;
    }

    function allowance() public view returns (uint){
        return ERCToken.allowance(bank_, address(this));
    }

    function getTokenAddress() public view returns (address){
        return address(ERCToken);
    }

    function losingBet() public{
       for(uint i = 0; i<subnum; i++){
            ERCToken.transferFrom(subscribers_[i].addr, bank_, subscribers_[i].stake);
            delete subscribers_[i];
        }       
        subnum = 0; 
    }

    function getOwner() public view returns(address){
        return owner_;
    }

    function checkBalance() public view returns(uint) {
        return ERCToken.balanceOf(msg.sender);
    }

    function Result(bool res) public {
        if(res==true){
            winningBet();
        } else {
            losingBet();
        }
    }
}