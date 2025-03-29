// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

import {AggregatorInterface} from '../dependencies/chainlink/AggregatorInterface.sol';

contract wOSAggregator is AggregatorInterface {
  // int256 private _latestAnswer;
  AggregatorInterface private SUSDAggregator;
  AggregatorInterface private wOSOSAggregator;

  constructor(address _wOSOSAggregator, address _SUSDAggregator) {
    require(_wOSOSAggregator != address(0), "Invalid wOSOSAggregator address");
    require(_SUSDAggregator != address(0), "Invalid SUSDAggregator address");
    wOSOSAggregator = AggregatorInterface(_wOSOSAggregator);
    SUSDAggregator = AggregatorInterface(_SUSDAggregator);
    // _latestAnswer = initialAnswer;
    // emit AnswerUpdated(initialAnswer, 0, block.timestamp);
  }

  function latestAnswer() external view returns (int256) {
    int256 wOSOSPrice = wOSOSAggregator.latestAnswer();
    int256 SUSDPrice = SUSDAggregator.latestAnswer();
    if (wOSOSPrice <= 0 || SUSDPrice <= 0) {
      revert('Invalid price feed data');
    }
    int256 _latestAnswer = (wOSOSPrice * SUSDPrice) / (10 ** 18);
    
    return _latestAnswer;
  }

  // function getTokenType() external pure returns (uint256) {
  //   return 1;
  // }

  function decimals() external pure returns (uint8) {
    return 8;
  }

  function latestTimestamp() external view returns (uint256) {
    uint256 timeOS = wOSOSAggregator.latestTimestamp();
    uint256 timeSUSD = SUSDAggregator.latestTimestamp();
    return timeOS < timeSUSD ? timeOS : timeSUSD;
  }

  function latestRound() public view returns (uint256) {
    uint256 roundOS = wOSOSAggregator.latestRound();
    uint256 roundSUSD = SUSDAggregator.latestRound();
    return roundOS < roundSUSD ? roundOS : roundSUSD;
  }

  function getAnswer(uint256 roundId) external view returns (int256) {
    return SUSDAggregator.getAnswer(roundId);
  }

  function getTimestamp(uint256 roundId) external view returns (uint256) {
    return SUSDAggregator.getTimestamp(roundId);
  }
}
