$files = @("index.html", "app.html", "docs.html", "audit.html", "404.html")

# 1. Update connectWallet (for index, docs, audit, 404)
$newConnectWallet = @"
  async function connectWallet(name) {
    closeWallet();
    const btn = document.querySelector('nav .btn-primary, .nav-right .btn-primary');
    if (!btn) return;
    
    btn.textContent = 'Connecting...';
    try {
      let pubKey = '';
      if (name === 'Phantom' && window.solana && window.solana.isPhantom) {
        const resp = await window.solana.connect();
        pubKey = resp.publicKey.toString();
      } else if (name === 'Solflare' && window.solflare && window.solflare.isSolflare) {
        await window.solflare.connect();
        pubKey = window.solflare.publicKey.toString();
      } else {
        // Fallback simulation if extension not installed
        await new Promise(r => setTimeout(r, 800));
        const chars = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
        for (let i = 0; i < 44; i++) pubKey += chars.charAt(Math.floor(Math.random() * chars.length));
      }
      
      const short = pubKey.slice(0, 4) + '...' + pubKey.slice(-4);
      btn.textContent = short;
      btn.style.background = 'rgba(20,255,180,0.1)';
      btn.style.color = '#14ffb4';
      btn.style.borderColor = 'rgba(20,255,180,0.3)';
    } catch (err) {
      btn.textContent = 'CONNECT WALLET';
      console.error('Wallet connection failed:', err);
    }
  }
"@

# 2. Update simulateWalletConnect (for app.html)
$newAppConnect = @"
  async function simulateWalletConnect(walletName) {
    const statusEl = document.getElementById('status-' + walletName);
    const originalText = statusEl ? statusEl.textContent : '';
    if (statusEl) statusEl.textContent = 'Connecting...';
    
    try {
      let addr = '';
      if (walletName === 'Phantom' && window.solana && window.solana.isPhantom) {
        const resp = await window.solana.connect();
        addr = resp.publicKey.toString();
      } else if (walletName === 'Solflare' && window.solflare && window.solflare.isSolflare) {
        await window.solflare.connect();
        addr = window.solflare.publicKey.toString();
      } else {
        // Fallback simulation
        await new Promise(r => setTimeout(r, 800));
        const chars = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
        for (let i = 0; i < 44; i++) addr += chars.charAt(Math.floor(Math.random() * chars.length));
      }
      
      walletAddress = addr;
      walletConnected = true;
      currentChainId = 'solana-mainnet';
      
      updateWalletUI();
      closeWalletModal();
      
      showBanner('success', '✓ Connected to Solana Mainnet via ' + walletName + '. Ready to deposit.');
      document.getElementById('switchNetworkBtn').style.display = 'none';
      document.getElementById('walletNetwork').className = 'wallet-network';
      document.getElementById('walletNetwork').textContent = 'Solana Mainnet ✓';
      if (statusEl) statusEl.textContent = originalText;
    } catch (err) {
      if (statusEl) statusEl.textContent = 'Failed';
      setTimeout(() => { if (statusEl) statusEl.textContent = originalText; }, 2000);
    }
  }
"@

foreach ($f in $files) {
    $content = Get-Content "D:\Downloads\vaulta-final\$f" -Encoding UTF8 -Raw
    
    # Remove Discord links
    $content = $content -replace '(?i)<a[^>]*href="https://discord\.gg/vaulta"[^>]*>.*?</a>\s*', ''
    $content = $content -replace '(?i)<a[^>]*href=".*?discord.*?"[^>]*>.*?</a>\s*', ''
    
    # Replace connectWallet
    if ($content -match '(?s)function connectWallet\(name\).*?\}, 800\);\s*\}\s*\}') {
        $content = $content -replace '(?s)function connectWallet\(name\).*?\}, 800\);\s*\}\s*\}', $newConnectWallet
    }

    # Replace simulateWalletConnect
    if ($content -match '(?s)function simulateWalletConnect\(walletName\).*?\}, 800\);\s*\}') {
        $content = $content -replace '(?s)function simulateWalletConnect\(walletName\).*?\}, 800\);\s*\}', $newAppConnect
    }
    
    [IO.File]::WriteAllText("D:\Downloads\vaulta-final\$f", $content, [System.Text.Encoding]::UTF8)
    Write-Host "Processed $f"
}
