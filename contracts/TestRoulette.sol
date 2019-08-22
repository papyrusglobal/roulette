pragma solidity ^0.4.19;

import "./Roulette.sol";


contract TestRoulette is Roulette {
    uint currentBlock = 1000;
    uint8 currentScore = 22;

    function winScore(uint) internal view returns(uint8) {
        return currentScore;
    }

    function blockNumber() internal view returns(uint) {
        return currentBlock;
    }

    function testPayout(uint8 betsNumber) public pure returns(uint8) {
        return payout(betsNumber);
    }

    function testBetsCount(uint mask) public pure returns(uint8) {
        return betsCount(mask);
    }

    function testMask(uint8 score) public pure returns(uint) {
        return mask(score);
    }

    function testWin(uint8 score) public {
        currentScore = score;
        currentBlock += 3;
    }

    function test() public view returns(uint, uint8, bytes32) {
        return (
            block.number,
            winScore(block.number - 3),
            block.blockhash(block.number - 1));
    }
}
