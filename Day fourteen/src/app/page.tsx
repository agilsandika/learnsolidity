'tsx'
'use client';

import { useAccount, useReadContract, useWriteContract } from 'wagmi';
import SimpleBankABI from '@/abi/SimpleBank.json';

const CONTRACT_ADDRESS = "0x5FbDB2315678afecb367f032d93F642f64180aa3"; // Contoh alamat lokal

export default function Home() {
  const { address, isConnected } = useAccount();
  const { writeContract } = useWriteContract();

  // Membaca saldo dari contract
  const { data: balance } = useReadContract({
    address: CONTRACT_ADDRESS,
    abi: SimpleBankABI,
    functionName: 'getMyBalance',
    account: address,
  });

  // Fungsi untuk memanggil Deposit dari Frontend
  const handleDeposit = () => {
    writeContract({
      address: CONTRACT_ADDRESS,
      abi: SimpleBankABI,
      functionName: 'deposit',
      value: BigInt(1000000000000000000), // 1 Ether dalam Wei
    });
  };

  return (
    <main style={{ padding: '40px', fontFamily: 'sans-serif' }}>
      <h1>Web3 DApp Dashboard (Day 14)</h1>
      
      {!isConnected ? (
        <p>Silakan hubungkan dompet MetaMask Anda.</p>
      ) : (
        <div>
          <p><strong>Connected Wallet:</strong> {address}</p>
          <p><strong>Saldo Bank Anda:</strong> {balance ? Number(balance) / 1e18 : 0} ETH</p>
          
          <button 
            onClick={handleDeposit}
            style={{ padding: '10px 20px', background: '#4F46E5', color: '#fff', border: 'none', borderRadius: '8px', cursor: 'pointer' }}
          >
            Deposit 1 ETH
          </button>
        </div>
      )}
    </main>
  );
              }
