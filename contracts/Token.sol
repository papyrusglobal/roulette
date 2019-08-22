pragma solidity ^0.4.18;

import {Ownable} from "zeppelin-solidity/contracts/ownership/Ownable.sol";
import {BasicToken} from "zeppelin-solidity/contracts/token/ERC20/BasicToken.sol";
import {ERC20Basic} from "zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol";


contract Token is Ownable, BasicToken {
    string public constant name = "Roulette💎chips";
    string public constant symbol = "CHP";
    uint8 public constant decimals = 18;
    uint constant rate = 1000;

    function Token() public {
        mint(owner, 1 ether);
    }

    function cash(uint value) public {
        msg.sender.transfer(burn(value));
    }

    function rescueTokens(address token) public {
        ERC20Basic(token).transfer(owner, ERC20Basic(token).balanceOf(this));
    }

    function () public payable {
        mint(msg.sender, msg.value);
    }

    function mint(address to, uint amount) internal {
        uint tokens = amount.mul(rate);
        totalSupply_ = totalSupply_.add(tokens);
        balances[to] = balances[to].add(tokens);
        emit Mint(to, tokens);
    }

    function burn(uint amount) internal returns (uint) {
        balances[msg.sender] = balances[msg.sender].sub(amount);
        totalSupply_ = totalSupply_.sub(amount);
        emit Burn(msg.sender, amount);
        return amount.div(rate);
   }

    event Mint(address indexed to, uint256 amount);
    event Burn(address indexed burner, uint256 value);
}
