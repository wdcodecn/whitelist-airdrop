// const ethers = require("ethers");
const Web3 = require("web3");

var web3 = new Web3();

// 每次部署后修改对应合约地址在执行签名
// 要签名的合约地址
let contract = "";

// 要签名的白名单地址
let whiteList = [
    "",
    "",
]

let result =[]

for (let address of whiteList) {

    // let messageHash = ethers.utils.solidityKeccak256(['address', 'address'], [contract,address ])

    let sha3 = web3.utils.soliditySha3(contract,address);

    let sign = web3.eth.accounts.sign(sha3, ""); // 请填写合约owner的私钥

    console.log(address,'签名数据:',sign.signature);
    result[address] = sign.signature
}

console.log(result);
