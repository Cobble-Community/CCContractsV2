pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/access/AccessControl.sol";

/*
interface CCL{
    function mint(address to, uint256 amount) external;
}*/

//THIS CONTRACT MUST BE GIVEN THE MINTER ROLE ON THE CCL CONTRACT!!!!
contract Game is AccessControl{

    bytes32 public constant ONLY_SERVER = keccak256("ONLY_SERVER");

    struct Player {
        address wallet;
        string MinecraftUsername;
        bool confirmed;
    }

    mapping(address => Player) public players;

    uint256 initialMint = 100;

    constructor(){}

    function compareStrs(string memory a, string memory b) public pure returns(bool){
        return ( keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b)));
    }

    //Associates wallet address with player struct
    function associatePlayer(address wallet, string memory mcUsername) public{
        require(msg.sender == wallet);
        players[wallet].wallet = wallet;
        players[wallet].MinecraftUsername = mcUsername;
        players[wallet].confirmed = false;
    }

    //Player confirms in game that the address associated with their user is theirs, server then calls this function
    function confirmPlayer(address wallet, string memory mcUserToConfirm) private onlyRole(ONLY_SERVER){
        require(compareStrs(players[wallet].MinecraftUsername, mcUserToConfirm));
        players[wallet].confirmed = true;
    }

    //To call this function, this contract must be given the MINTER role in the CCL Contract
    function mintCCLtoPlayer(address CCLContractAddr, address playerWallet) private{
        /*CCL CCLContract = CCL(CCLContractAddr);
        CCLContract.mint(playerWallet, initialMint);*/
    }
}