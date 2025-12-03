// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title GamePassGem
 * @dev ERC721 NFT contract for GamePass play-to-earn game
 * Compatible with Celo network
 * NFTs are referred to as "GEMS" in the game
 */
contract GamePassGem is ERC721URIStorage, Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

