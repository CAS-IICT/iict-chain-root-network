module.exports = {
    contracts_directory: './contracts',
    compilers: {
        solc: {
            version: '^0.8.0',
            optimizer: {
                enabled: true,
                runs: 200
            }
        }
    }
}
