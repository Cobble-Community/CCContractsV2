const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Game", function () {

    it("Should deploy game", async function () {
        const [owner] = await ethers.getSigners();
        const Game = await ethers.getContractFactory("Game");
        const game = await Game.deploy();
        await game.deployed();
        expect(game).not.null;
    });

    it("Should deploy ccl", async function () {
        const CCL = await ethers.getContractFactory("CCL");
        const ccl = await CCL.deploy();
        await ccl.deployed();
        expect(ccl).not.null;
    });
    
    it("Test compare same string", async function() {
        const [owner] = await ethers.getSigners();

        const Game = await ethers.getContractFactory("Game");
        const game = await Game.deploy();
        await game.deployed();
        const CCL = await ethers.getContractFactory("CCL");
        const ccl = await CCL.deploy();
        await ccl.deployed();

        const compareStr = await game.compareStrs("green", "green");
        expect(compareStr).to.be.true;
    });

    it("Test compare different Strings", async function() {
        const [owner] = await ethers.getSigners();

        const Game = await ethers.getContractFactory("Game");
        const game = await Game.deploy();
        await game.deployed();
        const CCL = await ethers.getContractFactory("CCL");
        const ccl = await CCL.deploy();
        await ccl.deployed();

        const compareStr = await game.compareStrs("green", "notGreen");
        expect(compareStr).to.be.false;
    });

    it("Test isNull, null string", async function(){
        const [owner] = await ethers.getSigners();

        const Game = await ethers.getContractFactory("Game");
        const game = await Game.deploy();
        await game.deployed();
        const CCL = await ethers.getContractFactory("CCL");
        const ccl = await CCL.deploy();
        await ccl.deployed();

        const isNullStr = await game.isNull("");
        expect(isNullStr).to.be.true;
    });

    it("Test isNull, non-null string", async function(){
        const [owner] = await ethers.getSigners();

        const Game = await ethers.getContractFactory("Game");
        const game = await Game.deploy();
        await game.deployed();
        const CCL = await ethers.getContractFactory("CCL");
        const ccl = await CCL.deploy();
        await ccl.deployed();

        const isNullStr = await game.isNull("NotNull");
        expect(isNullStr).to.be.false;
    });

    it("Should emit RoleGranted event on giveServerAdmin call.", async function(){
        const [owner, addr1] = await ethers.getSigners();

        const Game = await ethers.getContractFactory("Game");
        const game = await Game.deploy();
        await game.deployed();
        const CCL = await ethers.getContractFactory("CCL");
        const ccl = await CCL.deploy();
        await ccl.deployed();

        //console.log("owner.address: "+owner.address);
        //console.log("addr1.address: "+addr1.address);
        await expect(game.giveServerManager(addr1.address)).to.emit(game, "RoleGranted");
    });

    it("Should mint 1000000 tokens to owner", async function(){
        const [owner] = await ethers.getSigners();
        const CCL = await ethers.getContractFactory("CCL");
        const ccl = await CCL.deploy();
        await ccl.deployed();

        await ccl.mint(owner.address, 1000000);

        expect(await ccl.balanceOf(owner.address)/(10**18)).to.equal(1000000);
    });

    it("Should associate username to wallet and Player struct", async function(){
        const [owner] = await ethers.getSigners();

        const Game = await ethers.getContractFactory("Game");
        const game = await Game.deploy();
        await game.deployed();
        const CCL = await ethers.getContractFactory("CCL");
        const ccl = await CCL.deploy();
        await ccl.deployed();

        await game.associatePlayer("greenpeppers100");
        expect(await game.getAssociatedUsername(owner.address)).to.equal("greenpeppers100");
    });

    it("Should fail to mint CCL from game contract", async function() {
        const [owner] = await ethers.getSigners();

        const Game = await ethers.getContractFactory("Game");
        const game = await Game.deploy();
        await game.deployed();
        const CCL = await ethers.getContractFactory("CCL");
        const ccl = await CCL.deploy();
        await ccl.deployed();

       await expect(game.mintCCLtoPlayer(ccl.address, owner.address)).to.be.reverted;
        
    });

    it("Should mint CCL from game contract", async function() {
        const [owner] = await ethers.getSigners();

        const Game = await ethers.getContractFactory("Game");
        const game = await Game.deploy();
        await game.deployed();
        const CCL = await ethers.getContractFactory("CCL");
        const ccl = await CCL.deploy();
        await ccl.deployed();

        await ccl.giveMinterRole(game.address);
        await game.mintCCLtoPlayer(ccl.address, owner.address);
        expect(await ccl.balanceOf(owner.address)/(10**18)).to.equal(100);
    });

    
    it("Should associate username to wallet, confirm player, and mint 100 tokens to associated wallet", async function(){
        const [owner] = await ethers.getSigners();

        const Game = await ethers.getContractFactory("Game");
        const game = await Game.deploy();
        await game.deployed();
        const CCL = await ethers.getContractFactory("CCL");
        const ccl = await CCL.deploy();
        await ccl.deployed();

        await ccl.giveMinterRole(game.address);

        await game.associatePlayer("greenpeppers100");
        expect(await game.getAssociatedUsername(owner.address)).to.equal("greenpeppers100");

        await game.confirmPlayer(owner.address, "greenpeppers100", ccl.address);
        expect(await game.isConfirmed(owner.address)).to.be.true;
        expect(await ccl.balanceOf(owner.address)/(10**18)).to.equal(100);
    });

});