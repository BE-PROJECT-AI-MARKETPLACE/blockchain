const hre = require("hardhat");
const path = require('path');
const fs  = require('fs');

async function main() {

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

  const contract = {
    AuthenticateAddress,
    AIServiceAddress,
    RequestServiceAddress,
  };
  const filePath = path.join(__dirname, 'contract-address.json');
  console.log(filePath);
  fs.writeFileSync(filePath, JSON.stringify(contract, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
