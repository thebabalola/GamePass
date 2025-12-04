// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {GamePassSwap} from "../src/GamePassSwap.sol";
import {GamePassToken} from "../src/GamePassToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Mock ERC20 token for testing cUSD
contract MockERC20 is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {}
    
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract GamePassSwapTest is Test {
    GamePassSwap public swap;
    GamePassToken public token;
    MockERC20 public cusd;
    
    address public owner = address(1);
    address public treasury = address(2);
    address public buyer = address(3);
    address public user1 = address(4);
    
    uint256 constant ONE_CELO = 1 ether;
    uint256 constant THIRTY_PASS = 30 * 10**18;
    
    function setUp() public {
        vm.startPrank(owner);
        
        // Deploy GamePassToken
        token = new GamePassToken("GamePass Token", "PASS", treasury);
        
        // Deploy mock cUSD
        cusd = new MockERC20("Celo Dollar", "cUSD");
        
        // Deploy GamePassSwap
        swap = new GamePassSwap(address(token), address(cusd));
        
        // Set swap contract in token
        token.setSwapContract(address(swap));
        
        vm.stopPrank();
        
        // Give buyer some cUSD
        vm.prank(owner);
        cusd.mint(buyer, 1000 ether);
    }
    
    // ============ CELO Purchase Tests ============
    
    function test_BuyTokensWithCELO() public {
        uint256 celoAmount = 1 ether; // 1 CELO
        uint256 expectedPass = THIRTY_PASS; // 30 PASS tokens
        
        vm.deal(buyer, celoAmount);
        
        vm.startPrank(buyer);
        swap.buyTokens{value: celoAmount}();
        vm.stopPrank();
        
        assertEq(token.balanceOf(buyer), expectedPass, "Buyer should receive 30 PASS tokens");
    }

