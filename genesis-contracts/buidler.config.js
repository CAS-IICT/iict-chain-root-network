usePlugin('@nomiclabs/buidler-waffle');
usePlugin('solidity-coverage');

// This is a sample Buidler task. To learn how to create your own go to
// https://buidler.dev/guides/create-task.html
task('accounts', 'Prints the list of accounts', async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(await account.getAddress());
  }
});

usePlugin('@nomiclabs/buidler-truffle5');

// Go to https://buidler.dev/config/ to learn more
module.exports = {
  solc: {
    version: '0.8.0',
    optimizer: {
      enabled: true,
      runs: 200
    }
  },

  paths: {
    sources: './contracts',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts'
  }
};
