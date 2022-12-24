import "./Roullette.sol";

contract BetFactory is withBetOptions{
    ERC20 public ERCToken_;

    address public bank_;
    mapping(string => Bet) public squares;

    constructor(){
        uint256 MAX_INT = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
        ERCToken_ = new CustomToken();
        bank_ = address(this);
        uint bl_len = BetList.length;
        for(uint i = 0; i<2; i++){
            squares[BetList[i]] = new Bet(BetMapping[BetList[i]],BetList[i], ERCToken_, bank_);
            ERCToken_.approve(address(squares[BetList[i]]), MAX_INT);
        }
        
        // red = new Bet(BetMapping["red"],"red", ERCToken_, bank_);
        // ERCToken_.approve(address(red), MAX_INT);

        // black = new Bet(BetMapping["black"], "black", ERCToken_, bank_);
        // ERCToken_.approve(address(black), MAX_INT);
    }

    function SendUSD(uint amountSent) public {
        ERCToken_.mint(msg.sender, amountSent);
    }

    function getBankBalance() public view returns(uint){
        return ERCToken_.balanceOf(bank_);
    }

    function getAddress(string memory BetString) public view returns(address){
        return address(squares[BetString]);
    }
    function getBalance() public view returns(uint){
        return ERCToken_.balanceOf(msg.sender);
    } 
}