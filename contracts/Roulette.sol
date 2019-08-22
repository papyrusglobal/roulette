pragma solidity ^0.4.18;

import {Token} from "./Token.sol";


contract RouletteInterface {
    function play(uint mask) public payable;
    function playWithChips(uint mask, uint coinsBet) public;
    function withdraw() public;
    function watch() public view returns(uint8, uint8, bool);
    function balanceOf(address who) public view returns (uint);
    function cash(uint tokens) public;
}


contract Roulette is RouletteInterface, Token {
    struct TheBet {
        uint block;
        uint mask;
        uint stake;
    }
    mapping(address => TheBet) public bets;

    function play(uint mask) public payable {
        makeBet(mask, msg.value);
    }

    function playWithChips(uint mask, uint coinsBet) public {
        makeBet(mask, burn(coinsBet));
    }

    function withdraw() public {
        TheBet storage theBet = bets[msg.sender];
        require(blockNumber() - theBet.block >= 3);
        require(blockNumber() - theBet.block < 256);
        if (isWon(theBet)) {
            uint value = theBet.stake * payout(betsCount(theBet.mask));
            if (address(this).balance >= value) {
                msg.sender.transfer(value);
            } else {
                mint(msg.sender, value);
            }
        }
        delete bets[msg.sender];
    }

    function adminWithdraw(uint val) onlyOwner public {
        owner.transfer(val);
    }

    function adminDestruct() onlyOwner public {
        selfdestruct(owner);
    }

    function watch() public view returns(uint8, uint8, bool) {
        uint diff = blockNumber() - bets[msg.sender].block;
        if (diff > 256) {
            return (255, 0, false);
        } else if (diff >= 3) {
            uint8 score = winScore(bets[msg.sender].block);
            return (uint8(diff), score, isWon(bets[msg.sender]));
        } else {
            return (uint8(diff), 0, false);
        }
    }

    function makeBet(uint mask, uint value) internal {
        TheBet storage theBet = bets[msg.sender];
        require(
            theBet.block == 0 ||
            blockNumber() - theBet.block > 256 ||
            !isWon(theBet)
        );
        bets[msg.sender] = TheBet(blockNumber(), mask, value);
    }

    function payout(uint8 betsNumber) internal pure returns(uint8) {
        return 36 / betsNumber;
    }

    function betsCount(uint mask) internal pure returns(uint8 count) {
        for (count = 0; mask != 0; ++count) {
            mask &= mask - 1;
        }
    }

    function mask(uint8 score) internal pure returns(uint) {
        return uint(1) << score;
    }

    function isWon(TheBet storage theBet) internal view returns(bool) {
        return mask(winScore(theBet.block)) & theBet.mask != 0;
    }

    function winScore(uint blockNum) internal view returns(uint8) {
        return uint8(uint(block.blockhash(blockNum) ^
                          block.blockhash(blockNum + 1) ^
                          block.blockhash(blockNum + 2)) % 37);
    }

    function blockNumber() internal view returns(uint) {
        return block.number;
    }
}
