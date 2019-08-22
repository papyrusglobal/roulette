const TestRoulette = artifacts.require('TestRoulette');

contract('Roulette', async ([owner, player1, player2]) => {
  const rate = 1000;
  const finney = 10 ** 15;
  const ether = 1000 * finney;
  let roulette;

  before(async () => {
    roulette = await TestRoulette.deployed();
  });

  it("payout formula test", async () => {
    assert.equal(await roulette.testPayout(1), 36);
    assert.equal(await roulette.testPayout(2), 18);
    assert.equal(await roulette.testPayout(3), 12);
    assert.equal(await roulette.testPayout(18), 2);
    assert.equal(await roulette.testPayout(19), 1);
  });

  it("betsCount test", async () => {
    assert.equal((await roulette.testBetsCount(0)).valueOf(), 0);
    assert.equal((await roulette.testBetsCount(1)).valueOf(), 1);
    assert.equal((await roulette.testBetsCount(7)).valueOf(), 3);
    assert.equal((await roulette.testBetsCount(255)).valueOf(), 8);
    assert.equal((await roulette.testBetsCount(1025)).valueOf(), 2);
  });

  it("play with tokens", async() => {
    assert.equal((await roulette.balanceOf.call(player1)).valueOf(), 0);
    assert.equal((await roulette.balanceOf.call(player2)).valueOf(), 0);
    assert.equal((await roulette.balanceOf.call(owner)).valueOf(), 1 * ether * rate);
  });

  it("ping-pong tokens", async() => {
    await roulette.sendTransaction({ from: owner, value: 1 * ether });
    assert.equal((await roulette.balanceOf.call(owner)).valueOf(), 2 * ether * rate);
    await roulette.transfer.sendTransaction(player1, 1 * ether * rate, { from: owner });
    assert.equal((await roulette.balanceOf.call(player1)).valueOf(), 1 * ether * rate);
    assert.equal((await roulette.balanceOf.call(player2)).valueOf(), 0);
    assert.equal((await roulette.balanceOf.call(owner)).valueOf(), 1 * ether * rate);
    await roulette.cash.sendTransaction(1 * ether * rate, { from: player1 } );
    assert.equal((await roulette.balanceOf.call(player1)).valueOf(), 0);
  });

  it("send 1 ether", async() => {
    await roulette.sendTransaction({ from: owner, value: 1 * ether });
    assert.equal((await roulette.balanceOf.call(owner)).valueOf(), 2 * ether * rate);
  });

  it("bet on zero and win", async() => {
    const balance = await web3.eth.getBalance(player1);
    await roulette.play.sendTransaction(1, { from: player1, value: 10 * finney });
    await roulette.testWin.sendTransaction(0, { from: owner });
    await roulette.withdraw.sendTransaction({ from: player1 });
    assert(await web3.eth.getBalance(player1), balance * 35);
  });

  it("bet on 1-2-3 and win, verify", async() => {
    const balance = await web3.eth.getBalance(player2);
    assert(await roulette.watch.call({ from: player2 }), [255, 0, false]);
    await roulette.play.sendTransaction(1, { from: player2, value: 2 * finney });
    assert(await roulette.watch.call({ from: player2 }), [0, 0, false]);
    await roulette.testWin.sendTransaction(1, { from: owner });
    assert(await roulette.watch.call({ from: player2 }), [3, 1, true]);
    await roulette.withdraw.sendTransaction({ from: player2 });
    assert(await web3.eth.getBalance(player2), balance * 11);
  });
});
