// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Merkle {

    function verify(bytes32 _root, address _address, uint256 _amount, bytes32[] calldata _proofs) public pure returns (bool) {
        bytes32 _leaf = keccak256(abi.encodePacked(_address, _amount));
        bool _verify = MerkleProof.verify(_proofs, _root, _leaf);
        return _verify;
    }

}
