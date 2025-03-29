// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

interface IPoints {
  function addSupplyPoints(address user, uint256 points) external;
  function addBorrowPoints(address user, uint256 points) external;
}

contract Points is IPoints {
  mapping(address => bool) internal _allowedAddresses;
  mapping(address => uint256) internal _supplyPoints;
  mapping(address => uint256) internal _borrowPoints;
  address private _owner;

  event PointsUpdated(address user, uint256 pointsSupply, uint256 pointsBorrwo);

  constructor(address owner) {
    _owner = owner;
  }

  function setAllowedAddresses(address addr) external {
    require(_owner == msg.sender, 'Caller is not owner');
    _allowedAddresses[addr] = true;
  }

  function getAllowedAddresses(address addr) external view returns (bool) {
    return _allowedAddresses[addr];
  }

  function addSupplyPoints(address user, uint256 points) external {
    require(_allowedAddresses[msg.sender], 'Unallowed access');

    _supplyPoints[user] += points;
    emit PointsUpdated(user, _supplyPoints[user], _borrowPoints[user]);
  }

  function addBorrowPoints(address user, uint256 points) external {
    require(_allowedAddresses[msg.sender], 'Unallowed access');

    _borrowPoints[user] += points;
    emit PointsUpdated(user, _supplyPoints[user], _borrowPoints[user]);
  }

  function getUserPoints(address user) external view returns (uint256, uint256) {
    return (_supplyPoints[user], _borrowPoints[user]);
  }
}
