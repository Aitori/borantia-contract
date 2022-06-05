const hre = require("hardhat");
const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("Borantia");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // const owner = hre.ethers.getSigners();
  // const sampleMetadata = {
  //   title: "Sample Borantia",
  //   organization: "Sample Borantia Organization",
  //   description: "Sample Description",
  //   imageUrl: "Sample Image",
  //   eventDate: 2309840239,
  // };
  // const cc = nftContract.attach(nftContract.address);
  // cc.registerBorantia(
  //   "0xdD2FD4581271e230360230F9337D5c0430Bf44C0",
  //   sampleMetadata
  // );
  // cc.registerBorantia(
  //   "0xdD2FD4581271e230360230F9337D5c0430Bf44C0",
  //   sampleMetadata
  // );
  // cc.registerBorantia(
  //   "0xdD2FD4581271e230360230F9337D5c0430Bf44C0",
  //   sampleMetadata
  // );

  // cc.addVolunteers(1, [
  //   "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a",
  //   "0x90F79bf6EB2c4f870365E785982E1f101E93b906",
  // ]);

  // const tVolunteer = await cc.getVolunteerList(0);
  // console.log(tVolunteer);

  // const ttData = await cc.getMetadata(1);
  // console.log(ttData);

  // cc.claimBorantia(1, "0xFABB0ac9d68B0B445fB7357272Ff202C5651694a", 10);
  // const ttVolunteer = await cc.getVolunteerList(0);
  // console.log(ttVolunteer);
  // const bb = await cc.balanceOf("0xFABB0ac9d68B0B445fB7357272Ff202C5651694a", 0);
  // console.log(bb);
};

const runMain = async () => {
  try {
    await main();
  } catch (error) {
    console.log(error);
  }
};

runMain();
