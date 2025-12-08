// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {GamePassRewards} from "../src/GamePassRewards.sol";
import {GamePassToken} from "../src/GamePassToken.sol";

contract GamePassRewardsTest is Test {
    GamePassRewards public rewards;
    GamePassToken public token;
    
    address public owner = address(1);
    address public backend = address(2);
    address public treasury = address(3);
    address public player1 = address(4);
    address public player2 = address(5);
    address public player3 = address(6);
    address public player4 = address(7);
    
    uint256 public constant MIN_SCORE_THRESHOLD = 10;
    uint256 public constant PRIZE_POOL_AMOUNT = 1000 * 10**18; // 1000 PASS tokens
    
    function setUp() public {
        vm.startPrank(owner);
        
        // Deploy GamePassToken
        token = new GamePassToken("GamePass Token", "PASS", treasury);
        
        // Deploy GamePassRewards
        rewards = new GamePassRewards(address(token), backend, MIN_SCORE_THRESHOLD);
        
        // Set rewards contract in token
        token.setRewardsContract(address(rewards));
        
        vm.stopPrank();
    }
    
    // ============ Score Submission Tests ============
    
    function test_SubmitScore_FromBackend() public {
        uint256 score = 100;
        
        vm.prank(backend);
        rewards.submitScore(player1, score);
        
        assertEq(rewards.getLeaderboardLength(), 1, "Leaderboard should have 1 entry");
        assertEq(rewards.playerIndex(player1), 1, "Player1 should be at index 1");
        
        GamePassRewards.LeaderboardEntry memory entry = rewards.getLeaderboardEntry(0);
        assertEq(entry.player, player1, "Player should match");
        assertEq(entry.score, score, "Score should match");
        assertEq(entry.claimed, false, "Should not be claimed");
    }
    
    function test_SubmitScore_MultiplePlayers() public {
        vm.startPrank(backend);
        rewards.submitScore(player1, 100);
        rewards.submitScore(player2, 200);
        rewards.submitScore(player3, 150);
        vm.stopPrank();
        
        assertEq(rewards.getLeaderboardLength(), 3, "Leaderboard should have 3 entries");
        
        // Should be sorted: player2 (200), player3 (150), player1 (100)
        GamePassRewards.LeaderboardEntry memory first = rewards.getLeaderboardEntry(0);
        assertEq(first.player, player2, "First should be player2");
        assertEq(first.score, 200, "First score should be 200");
        
        GamePassRewards.LeaderboardEntry memory second = rewards.getLeaderboardEntry(1);
        assertEq(second.player, player3, "Second should be player3");
        assertEq(second.score, 150, "Second score should be 150");
        
        GamePassRewards.LeaderboardEntry memory third = rewards.getLeaderboardEntry(2);
        assertEq(third.player, player1, "Third should be player1");
        assertEq(third.score, 100, "Third score should be 100");
    }
    
    function test_SubmitScore_UpdateExistingPlayer() public {
        vm.startPrank(backend);
        rewards.submitScore(player1, 100);
        rewards.submitScore(player1, 200); // Higher score
        vm.stopPrank();
        
        assertEq(rewards.getLeaderboardLength(), 1, "Leaderboard should still have 1 entry");
        GamePassRewards.LeaderboardEntry memory entry = rewards.getLeaderboardEntry(0);
        assertEq(entry.score, 200, "Score should be updated to 200");
    }
    
    function test_RevertWhen_SubmitScore_NotFromBackend() public {
        vm.prank(player1);
        vm.expectRevert("Only backend can submit scores");
        rewards.submitScore(player1, 100);
    }
    
    function test_RevertWhen_SubmitScore_BelowMinimum() public {
        vm.prank(backend);
        vm.expectRevert("Score below minimum threshold");
        rewards.submitScore(player1, MIN_SCORE_THRESHOLD - 1);
    }
    
    function test_RevertWhen_SubmitScore_ZeroAddress() public {
        vm.prank(backend);
        vm.expectRevert("Player cannot be zero address");
        rewards.submitScore(address(0), 100);
    }
    
    function test_RevertWhen_SubmitScore_LowerScore() public {
        vm.startPrank(backend);
        rewards.submitScore(player1, 200);
        vm.expectRevert("New score must be higher");
        rewards.submitScore(player1, 100);
        vm.stopPrank();
    }
}

