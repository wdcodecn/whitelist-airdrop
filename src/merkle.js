let fs = require("fs");
let BN = require("bignumber.js");

let {MerkleTree} = require('merkletreejs');
let keccak256 = require('keccak256');
let ethers = require('ethers');


// 要签名的白名单地址
let address = [
    "",
    "",
]

// 要签名的空投代币数量 400 后跟18个0
let AMOUNT = ethers.utils.parseEther('400').toString()

// console.log(ethers.utils.parseEther('400').toString());

let users = {}

address.map((item) => {
    users[item] = AMOUNT;
})

// console.log(users);

// 开始生成默克尔树


// 1. 生成叶子节点
let leafs = []
for (let item in users) {

    // solidity keccak256(abi.encodePacked())
    let leaf = ethers.utils.solidityKeccak256(['address', 'uint256'], [item, users[item]])

    leafs.push(leaf)
}


// console.log({leafs});

// 2. 生成树根
let tree = new MerkleTree(leafs, keccak256, {sort: true})

console.log("root: ", tree.getHexRoot())

// 3. 生成叶子 proof
let proofs = []
leafs.map(item=>{
    // console.log(item);
    // console.log("proof: ", tree.getHexProof(item))
    proofs[item] = tree.getHexProof(item);
})
// console.log({proofs});


let results =[]
for (let i in address) {
    // console.log(i)
    results.push([
        address[i],
        AMOUNT,
        proofs[leafs[i]]
    ])
}
console.log(JSON.stringify(results,null,2));


fs.writeFileSync("merkle.json",JSON.stringify(results,null,2))


