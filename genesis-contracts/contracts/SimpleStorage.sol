//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract SimpleStorage {
  uint256 public storedData;

  constructor(uint256 initVal) {
    storedData = initVal;
  }

  function set(uint256 x) public {
    storedData = x;
  }

  function get() public view returns (uint256 retVal) {
    return storedData;
  }
}
