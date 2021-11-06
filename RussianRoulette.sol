// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract RussianRoulette {

    address private creator;
    address [] private players;
    address [] private losers;
    uint256 private odds;
    uint256 private playersTurn;
    
    constructor(address conCreate) {
        creator = conCreate; 
        players = new address [] (100); 
        losers = new address [] (10000); 
    }
    
    modifier isCreator() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.
        require(msg.sender == creator, "Caller is not owner");
        _;
    }
    
    modifier newPlayer (address johnCena) {
        require(contains(johnCena, players) && contains(johnCena, losers), "player is dead");
        _;
    }
    
    
    function contains (address search, address[] storage array) private view returns (bool) 
    {
       for (uint i = 0; i < array.length ; i++)
       {
            if (array[i] == search)
            {
             return true; 
            }
       }
       return false; 
    }
    
    function setOdds (uint256 oneInThisMany) public isCreator {
        odds = oneInThisMany; 
    }
    function addPlayer (address player) public newPlayer (player)
    {
         for (uint i = 0; i < players.length; i++)
        {
            if (players[i] == address(0))
            {
              players[i] = player; 
              break; 
            }
        }

    }
    function lose (address player) private 
    {
         for (uint i = 0; i < players.length; i++)
        {
           
           if (players[i] == player)
           {
               for (uint j = 0; i < losers.length; j++)
               {
                   if (losers[j] == address(0))
                   {
                      losers[j] = player; 
                      break; 
                   }
               }
           }
           
            if (players[i] != address(0))
            {
              players[i] = address(0); 
              break; 
            }
         }
    }
    function random() private view returns (uint256) {
      uint256 store =  (block.timestamp + 42);
      store = ((store * (block.timestamp % 98949)*(block.timestamp % 123213)*(block.timestamp % 32))) %odds;
      return store; 
}
    function play () private 
    {
        uint256 rando = random (); 
        if (rando == 1)
           {
                 lose(players[playersTurn]); 
            }
        else 
        {
            playersTurn++; 
        }
        }
    function isALoser (address person) public view returns (bool)
    {
        return contains(person, losers); 
    }

}
