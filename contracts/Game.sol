pragma solidity ^0.8.0;

import "./@openzeppelin/contracts/access/AccessControl.sol";


interface ICCL{
    function mint(address to, uint256 amount) external;
}

//THIS CONTRACT MUST BE GIVEN THE MINTER ROLE ON THE CCL CONTRACT!!!!
contract Game is AccessControl{

    bytes32 public constant SERVER_ADMIN = keccak256("SERVER_ADMIN");
    bytes32 public constant SERVER_MANAGER = keccak256("SERVER_MANAGER");
    
    struct Player {
        address wallet;
        string MinecraftUsername;
        bool confirmed;
    }

    mapping(address => Player) public players;

    uint256 initialMintCost = 100;

    constructor(){
        _setRoleAdmin(SERVER_MANAGER, SERVER_ADMIN);
        _setupRole(SERVER_ADMIN, msg.sender);
        _setupRole(SERVER_MANAGER, msg.sender);
    }

    //ONLY THE SERVER CAN CALL THIS FUNCTION
    function giveServerManager(address account) public onlyRole(SERVER_ADMIN){
        grantRole(SERVER_MANAGER, account);
    }

    function compareStrs(string memory a, string memory b) public pure returns(bool){
        return ( keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b)));
    }

    function isNull(string memory str) public pure returns(bool){
        return !(bytes(str).length > 0);
    }

    //Associates wallet address with player struct
    function associatePlayer(string memory mcUsername) public{
        address wallet = msg.sender;
        require(players[wallet].confirmed == false, "Wallet already associated with MC Username.");
        players[wallet].wallet = wallet;
        players[wallet].MinecraftUsername = mcUsername;
    }

    function getAssociatedUsername(address wallet) public view returns(string memory){
        return players[wallet].MinecraftUsername;
    }

    //To call this function, this contract must be given the MINTER role in the CCL Contract
    function mintCCLtoPlayer(address CCLContractAddr, address playerWallet) public onlyRole(SERVER_MANAGER){
        ICCL CCLContract = ICCL(CCLContractAddr);
        CCLContract.mint(playerWallet, initialMintCost);
    }

    //Player confirms in game that the address associated with their user is theirs, server then calls this function
    //ONLY THE SERVER CAN CALL THIS FUNCTION
    function confirmPlayer(address playerWallet, string memory mcUserToConfirm, address CCLContractAddr) public onlyRole(SERVER_MANAGER){
        require(compareStrs(players[playerWallet].MinecraftUsername, mcUserToConfirm), "The MC Username you are trying to confirm is not the one sent.");
        players[playerWallet].confirmed = true;
        mintCCLtoPlayer(CCLContractAddr, playerWallet);
    }

    function isConfirmed(address wallet) public view returns(bool){
        return players[wallet].confirmed;
    }
}