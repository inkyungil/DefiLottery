//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.11;

contract Lottery{
    
   address  public manager;
   uint     public totalAmount;
   uint     public playerCount;

   struct player {
      address addr;
      uint players_amount;
   }
   
   player[] public  players;
   


    event EventLog(
      address addr,
      uint players_amount,
      uint timestamp 
    );
    
    
    event EventLogWinnner(
      address addr,
      uint players_amount,
      uint timestamp 
    );
    

    constructor()  {
      manager = msg.sender;
      totalAmount = 0;
      playerCount = 0;
    }

    function LotteryApply() payable public {
    require(msg.value > .01 ether, "I don't have enough money");
    
    players.push(player(msg.sender, msg.value));
    
    
    totalAmount += msg.value ;
    playerCount ++ ;
    
    
    emit EventLog( msg.sender, msg.value,  block.timestamp);
    
    }


    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp  , blockhash(block.number) )));
 
    }

    function WinnerSelection() public  payable isManager {
        for(uint i=0; i< playerCount;i++)
        {
        
         if(!payable(players[i].addr).send(players[i].players_amount)) {
            revert();
         }
         
          emit EventLog( players[i].addr, players[i].players_amount ,  block.timestamp);

        }
  
        //´çÃ·ÀÚ ÃßÃ·
        uint index = random() % playerCount;
         if(!payable(players[index].addr).send(msg.value)) {
            revert();
         }else{
	    emit EventLogWinnner( players[index].addr, msg.value ,  block.timestamp);

            clearPlay();
         }
         
    }

    function clearPlay() private
    {
        delete players;
        totalAmount = 0;
        playerCount = 0;
    }
    
    
    
    modifier isManager() {
        require(msg.sender == manager,"It's an admin function.");
        _;
    }


    function getPlayers(uint _idx) public view returns (address, uint ) {
        return (players[_idx].addr, players[_idx].players_amount);
    }


    function getTotal() public view returns(uint ){
        return  playerCount;
    }
    

    function getAmount() public view returns(uint ){
        return  totalAmount;
    }
    

}