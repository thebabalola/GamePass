// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {GamePassToken} from "../src/GamePassToken.sol";

contract GamePassTokenTest is Test {
    GamePassToken public token;
    
    address public owner = address(1);
    address public treasury = address(2);
    address public rewardsContract = address(3);
    address public swapContract = address(4);
    address public user1 = address(5);
    address public user2 = address(6);
    
    uint256 constant MAX_SUPPLY = 1_000_000_000 * 10**18;
    uint256 constant TREASURY_INITIAL_SUPPLY = 500_000_000 * 10**18;
    
    function setUp() public {
        vm.startPrank(owner);
        
        token = new GamePassToken(
            "GamePass Token",
            "PASS",
            treasury
        );
        
        vm.stopPrank();
    }
    
    // ============ Initial Supply Tests ============
    
    function test_InitialSupplyMinting() public {
        assertEq(token.totalSupply(), TREASURY_INITIAL_SUPPLY, "Treasury should receive 50% of max supply");
        assertEq(token.balanceOf(treasury), TREASURY_INITIAL_SUPPLY, "Treasury balance should be 50% of max supply");
        assertEq(token.name(), "GamePass Token", "Token name should be correct");
        assertEq(token.symbol(), "PASS", "Token symbol should be correct");
        assertEq(token.MAX_SUPPLY(), MAX_SUPPLY, "Max supply should be 1 billion tokens");
    }
