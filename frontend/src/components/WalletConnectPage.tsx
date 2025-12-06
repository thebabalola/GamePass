"use client";

import React from "react";
import { useWallet } from "@/src/context/WalletContext";

export const WalletConnectPage: React.FC = () => {
  const { connectWallet, isConnecting, error } = useWallet();

  const handleConnectMetaMask = () => {
    connectWallet("io.metamask");
  };

  const handleConnectWalletConnect = () => {
    connectWallet("walletConnect");
  };

  const handleConnectMiniPay = () => {
    connectWallet("minipay");
  };

  return (
    <div className="flex flex-col items-center justify-center min-h-screen p-4">
      <div className="w-full max-w-md space-y-6">
        <h1 className="text-3xl font-bold text-center">Connect Your Wallet</h1>
        
        <div className="space-y-4">
          <button
            onClick={handleConnectMetaMask}
            disabled={isConnecting}
            className="w-full px-6 py-4 rounded-lg border border-gray-300 hover:bg-gray-50 disabled:opacity-50"
          >
            MetaMask
          </button>
          
          <button
            onClick={handleConnectWalletConnect}
            disabled={isConnecting}
            className="w-full px-6 py-4 rounded-lg border border-gray-300 hover:bg-gray-50 disabled:opacity-50"
          >
            WalletConnect
          </button>
          
          <button
            onClick={handleConnectMiniPay}
            disabled={isConnecting}
            className="w-full px-6 py-4 rounded-lg border border-gray-300 hover:bg-gray-50 disabled:opacity-50"
          >
            MiniPay
          </button>
        </div>

        {error && (
          <div className="p-4 bg-red-50 border border-red-200 rounded-lg text-red-700">
            {error}
          </div>
        )}

        {isConnecting && (
          <div className="text-center text-gray-600">
            Connecting...
          </div>
        )}
      </div>
    </div>
  );
};

