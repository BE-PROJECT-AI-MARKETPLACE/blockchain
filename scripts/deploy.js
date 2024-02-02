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

  const contract = {
    AuthenticateAddress,
    AIServiceAddress
  };
  const filePath = path.join(__dirname, 'contract-address.json');
  console.log(filePath);
  fs.writeFileSync(filePath, JSON.stringify(contract, null, 2));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
