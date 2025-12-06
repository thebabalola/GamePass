"use client";

import React from "react";
import { useWallet } from "@/src/context/WalletContext";

export const NetworkStatusIndicator: React.FC = () => {
  const { chainId, isCorrectNetwork, isConnected } = useWallet();

  if (!isConnected) {
    return null;
  }

  return (
    <div className="flex items-center gap-2">
      {isCorrectNetwork ? (
        <div className="flex items-center gap-2 px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm">
          <span className="w-2 h-2 bg-green-500 rounded-full"></span>
          <span>Celo Sepolia</span>
        </div>
      ) : (
        <div className="flex items-center gap-2 px-3 py-1 bg-yellow-100 text-yellow-800 rounded-full text-sm">
          <span className="w-2 h-2 bg-yellow-500 rounded-full"></span>
          <span>Wrong Network</span>
        </div>
      )}
    </div>
  );
};

