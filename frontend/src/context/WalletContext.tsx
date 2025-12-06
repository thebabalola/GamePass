"use client";

import React, { createContext, useContext, useState, useEffect, ReactNode } from "react";
import { createThirdwebClient, getAccount, getContract, readContract } from "thirdweb";
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

interface WalletContextType {
  address: string | undefined;
  balance: string;
  chainId: number | undefined;
  isConnected: boolean;
  isConnecting: boolean;
  error: string | null;
  connectWallet: (walletId: string) => Promise<void>;
  disconnectWallet: () => Promise<void>;
  switchNetwork: () => Promise<void>;
}

const WalletContext = createContext<WalletContextType | undefined>(undefined);

export const useWallet = () => {
  const context = useContext(WalletContext);
  if (!context) {
    throw new Error("useWallet must be used within WalletProvider");
  }
  return context;
};

interface WalletProviderProps {
  children: ReactNode;
  clientId: string;
}

export const WalletProvider: React.FC<WalletProviderProps> = ({ children, clientId }) => {
  const [address, setAddress] = useState<string | undefined>();
  const [balance, setBalance] = useState<string>("0");
  const [chainId, setChainId] = useState<number | undefined>();
  const [isConnected, setIsConnected] = useState(false);
  const [isConnecting, setIsConnecting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const client = createThirdwebClient({ clientId });

  // Initialize wallet connection state
  useEffect(() => {
    // Check for existing wallet connection
    const checkConnection = async () => {
      try {
        const account = getAccount({ client });
        if (account) {
          setAddress(account.address);
          setChainId(account.chain?.id);
          setIsConnected(true);
        }
      } catch (err) {
        // No existing connection
      }
    };

    checkConnection();
  }, [client]);

  const connectWallet = async (walletId: string) => {
    setIsConnecting(true);
    setError(null);

    try {
      const wallet = connect({ client, walletId });
      const account = await wallet.getAccount();
      
      setAddress(account.address);
      setChainId(account.chain?.id);
      setIsConnected(true);
    } catch (err: any) {
      setError(err.message || "Failed to connect wallet");
      setIsConnected(false);
    } finally {
      setIsConnecting(false);
    }
  };

  const disconnectWallet = async () => {
    try {
      await disconnect({ client });
      setAddress(undefined);
      setBalance("0");
      setChainId(undefined);
      setIsConnected(false);
      setError(null);
    } catch (err: any) {
      setError(err.message || "Failed to disconnect wallet");
    }
  };

  const switchNetwork = async () => {
    try {
      // Network switching logic will be implemented
      setError(null);
    } catch (err: any) {
      setError(err.message || "Failed to switch network");
    }
  };

  // Fetch balance when address or chainId changes
  useEffect(() => {
    const fetchBalance = async () => {
      if (!address || !chainId) {
        setBalance("0");
        return;
      }

      try {
        // Balance fetching logic will be implemented
        setBalance("0");
      } catch (err) {
        setBalance("0");
      }
    };

    fetchBalance();
  }, [address, chainId]);

  return (
    <WalletContext.Provider
      value={{
        address,
        balance,
        chainId,
        isConnected,
        isConnecting,
        error,
        connectWallet,
        disconnectWallet,
        switchNetwork,
      }}
    >
      {children}
    </WalletContext.Provider>
  );
};

