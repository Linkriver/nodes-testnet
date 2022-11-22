//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

/**
 * Request testnet LINK and ETH here: https://faucets.chain.link/
 * Find information on LINK Token Contracts and get the latest ETH and LINK faucets here: https://docs.chain.link/docs/link-token-contracts/
 */

/**
 * THIS IS AN EXAMPLE CONTRACT WHICH USES HARDCODED VALUES FOR CLARITY.
 * PLEASE DO NOT USE THIS CODE IN PRODUCTION.
 */

contract MultiWordConsumer is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    bytes32 private jobId;
    uint256 private fee;

    // multiple params returned in a single oracle response
    uint256 public var0;
    uint256 public var1;
    uint256 public var2;

    event RequestMultipleFulfilled(bytes32 indexed requestId, uint256 var0, uint256 var1, uint256 var2);

    /**
     * @notice Initialize the link token and target oracle
     * @dev The oracle address must be an Operator contract for multiword response
     *
     *
     * Polygon Mumbai Testnet details:
     * Link Token: 0x326C977E6efc84E512bB9C30f76E30c160eD06FB
     * Oracle: 0xd5a5FE4e1a8a41246cE8fBC876270f87aeE281C5 (LinkRiver)
     * jobId: 4850dac153974013b3b26dad6d370038
     *
     */
    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB);
        setChainlinkOracle(0xd5a5FE4e1a8a41246cE8fBC876270f87aeE281C5);
        jobId = '4850dac153974013b3b26dad6d370038';
        fee = 0; 
    }

    /**
     * @notice Request mutiple parameters from the oracle in a single transaction
     * Replace the example parameters with ones appropriate to your needs
     */
    function requestMultipleParameters() public {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfillMultipleParameters.selector
        );
        req.add('urlVar0', 'https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=BTC');
        req.add('pathVar0', 'BTC');
        req.addInt('times', 100000);
        req.add('urlVar1', 'https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD');
        req.add('pathVar1', 'USD');
        req.addInt('times', 100000);
        req.add('urlVar2', 'https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=EUR');
        req.add('pathVar2', 'EUR');
        req.addInt('times', 100000);
        sendChainlinkRequest(req, fee); // MWR API.
    }

    /**
     * @notice Fulfillment function for multiple parameters in a single request
     * @dev This is called by the oracle. recordChainlinkFulfillment must be used.
     */
    function fulfillMultipleParameters(
        bytes32 requestId,
        uint256 var0Response,
        uint256 var1Response,
        uint256 var2Response
    ) public recordChainlinkFulfillment(requestId) {
        emit RequestMultipleFulfilled(requestId, var0Response, var1Response, var2Response);
        var0 = var0Response;
        var1 = var1Response;
        var2 = var2Response;
    }
} 