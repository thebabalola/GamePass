"use client";

import React, { createContext, useContext, useState, useEffect, ReactNode } from "react";
import { createThirdwebClient } from "thirdweb";
import { connect, disconnect } from "thirdweb/wallets";
import { defineChain } from "thirdweb/chains";

// Celo Sepolia chain configuration
const CELO_SEPOLIA_CHAIN_ID = 11142220;

export const celoSepoliaChain = defineChain({
  id: CELO_SEPOLIA_CHAIN_ID,
  name: "Celo Sepolia",
  nativeCurrency: {
    name: "CELO",
    symbol: "CELO",
    decimals: 18,
  },
  rpc: "https://sepolia-forno.celo.org",
});

