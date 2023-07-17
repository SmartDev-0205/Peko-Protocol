/**
 *Submitted for verification at Etherscan.io on 2023-06-08
*/

//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;
interface Aggregator {
    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

contract Price {
    address aggregatorInterface = 0x245e775A46B1AADacBd48279Cf0731CF186Cf2b2;

    /**
     * @dev To get latest ETH price in 10**18 format
     */

    constructor(
    ) {
    }
    function getLatestPrice() public view returns (uint256) {
        (, int256 ethPrice, , , ) = Aggregator(aggregatorInterface).latestRoundData();
        ethPrice = (ethPrice * (10 ** 10));
        return uint256(ethPrice);
    }

}