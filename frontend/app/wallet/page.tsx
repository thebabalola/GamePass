"use client";

import React from "react";
import { WalletConnectPage } from "@/src/components/WalletConnectPage";
import { WalletInfoDisplay } from "@/src/components/WalletInfoDisplay";
import { NetworkStatusIndicator } from "@/src/components/NetworkStatusIndicator";
import { ConnectionStatus } from "@/src/components/ConnectionStatus";
import { useWallet } from "@/src/context/WalletContext";

export default function WalletPage() {
  const { isConnected } = useWallet();

  return (
    <div className="min-h-screen p-4">
      <ConnectionStatus />
      <div className="max-w-2xl mx-auto">
        <h1 className="text-4xl font-bold mb-8 text-center">Wallet Connection</h1>
        
        <div className="mb-6">
          <NetworkStatusIndicator />
        </div>

        {isConnected ? (
          <WalletInfoDisplay />
        ) : (
          <WalletConnectPage />
        )}
      </div>
    </div>
  );
}

