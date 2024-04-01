const hre = require("hardhat");
const path = require('path');
const fs = require('fs');
const { ethers, JsonRpcProvider } = require("ethers");
const web3 = require('web3');



async function main() {

  const [deployer,payer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address,payer.address);

  // Specify the network to be used (Ganache)
  // const network = "http://127.0.0.1:7545";
  // console.log("Using network:", network);

  const Authentication = await hre.ethers.getContractFactory("Authentication");
  const authenticate = await Authentication.deploy();
  await authenticate.waitForDeployment();
  const AuthenticateAddress = authenticate.target;
  console.log(`Authentication Contract Address: ${AuthenticateAddress}`);

  const AIService = await hre.ethers.getContractFactory("AIService");
  const aiservice = await AIService.deploy();
  await aiservice.waitForDeployment();
  const AIServiceAddress = aiservice.target;
  console.log(` AIService Contract Address: ${AIServiceAddress}`);

  const RequestService = await hre.ethers.getContractFactory("RequestService");
  const requestservice = await RequestService.deploy();
  await requestservice.waitForDeployment();
  const RequestServiceAddress = requestservice.target;
  console.log(` RequestService Contract Address: ${RequestServiceAddress}`);

  const Dai = await hre.ethers.getContractFactory("Dai");
  const dai = await Dai.deploy();
  await dai.waitForDeployment();
  const daiAddress = dai.target;
  console.log("Dai deployed to:", daiAddress);
  await dai.faucet(payer.address, ethers.parseEther("10000"));
  console.log("Faucet successful to address:", payer.address);


  const PaymentProcessor = await hre.ethers.getContractFactory("PaymentProcessor");
  const paymentProcessor = await PaymentProcessor.deploy(deployer.address, daiAddress);
  await paymentProcessor.waitForDeployment();
  const PaymentProcessorAddress = paymentProcessor.target;
  console.log(` Payment Processor Address: ${PaymentProcessorAddress}`);
  console.log("Payer: ",payer.address);

  const contract = {
    AuthenticateAddress,
    AIServiceAddress,
    RequestServiceAddress,
    daiAddress,
    PaymentProcessorAddress,
  };
  const filePath = path.join(__dirname, 'contract-address.json');
  console.log(filePath);
  fs.writeFileSync(filePath, JSON.stringify(contract, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
