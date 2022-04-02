pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/* demo https://testnet.bscscan.com/address/0xf083ff72350f2dc1c8bd5b8c966dc8fb4cf078db*/
contract airdrop is ERC20, Ownable {

    using ECDSA for bytes32;

    bytes32 public root;

    mapping(address => bool) claimed;

    constructor() ERC20("Airdrop", "AIR"){

    }

    function hasClaimed(address _address) public view returns (bool){

        return claimed[_address];
    }


    function setMerkleRoot(bytes32 _root) external onlyOwner {

        root = _root;

    }

    function claim(address _address, uint256 _amount, bytes32[] calldata _proofs) external {

        require(claimed[_address] == false, "has claimed!");

        bytes32 _leaf = keccak256(abi.encodePacked(_address, _amount));
        bool verify = MerkleProof.verify(_proofs, root, _leaf);

        require(verify, "verify fail");

        claimed[_address] = true;

        _mint(_address, _amount);

    }

    function claim1(address _address, uint256 _amount, bytes memory _signature) external {

        require(claimed[_address] == false, "has claimed!");

        require(checkSignature(_signature), "verify fail");

        claimed[_address] = true;

        _mint(_address, _amount);

    }

    function checkSignature(bytes memory _signature) public view returns (bool){

        bytes32 messageHash = keccak256(abi.encodePacked(address(this), msg.sender));
        address signer = messageHash.toEthSignedMessageHash().recover(_signature);

        return owner() == signer;

    }


}
