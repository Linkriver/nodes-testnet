// SPDX-License-Identifier: MIT
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
contract APIConsumer is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    bool public value;
    bytes32 private jobId;
    uint256 private fee;

    event RequestValue(bytes32 indexed requestId, bool value);

    /**
     * @notice Initialize the link token and target oracle
     *
     * Avalanche Fuji Testnet details:
     * Link Token: 0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846
     * Oracle: 0xd5a5FE4e1a8a41246cE8fBC876270f87aeE281C5 (LinkRiver)
     * jobId: 9c04c42591244bb59d085af801d04b43
     *
     */
    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkToken(0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846);
        setChainlinkOracle(0xd5a5FE4e1a8a41246cE8fBC876270f87aeE281C5);
        jobId = "9c04c42591244bb59d085af801d04b43";
        fee = 0; 
    }

    /**
     * Create a Chainlink request to retrieve API response and find the target
     * data.
     * Replace the example parameters with ones appropriate to your needs.
     */
    function requestValue() public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        // Set the URL to perform the GET request on
        req.add(
            "get",
            "YOUR_URL"
        );

        req.add("path", "YOUR,PATH");

        // Sends the request
        return sendChainlinkRequest(req, fee);
    }

    /**
     * Receive the response in the form of bool
     */
    function fulfill(
        bytes32 _requestId,
        bool _value
    ) public recordChainlinkFulfillment(_requestId) {
        emit RequestValue(_requestId, _value);
        value = _value;
    }

    /**
     * Allow withdraw of Link tokens from the contract
     */
    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(
            link.transfer(msg.sender, link.balanceOf(address(this))),
            "Unable to transfer"
        );
    }
}
