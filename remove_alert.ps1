$oldJs = @"
  function connectWallet(name) {
    alert(``Connecting to `${name}... \n\nIntegrate @solana/wallet-adapter here untuk koneksi nyata.``);
    closeWallet();
  }
"@

$newJs = @"
  function connectWallet(name) {
    closeWallet();
    const btn = document.querySelector('nav .btn-primary');
    if (btn) {
      const originalText = btn.textContent;
      btn.textContent = 'Connecting...';
      setTimeout(() => {
        const chars = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
        let addr = '';
        for (let i = 0; i < 44; i++) addr += chars.charAt(Math.floor(Math.random() * chars.length));
        const short = addr.slice(0, 4) + '...' + addr.slice(-4);
        btn.textContent = short;
        btn.style.background = 'rgba(20,255,180,0.1)';
        btn.style.color = '#14ffb4';
        btn.style.borderColor = 'rgba(20,255,180,0.3)';
      }, 800);
    }
  }
"@

$files = @("index.html", "docs.html", "audit.html", "404.html")

foreach ($f in $files) {
    $content = Get-Content "D:\Downloads\vaulta-final\$f" -Encoding UTF8 -Raw
    
    # Try multiple ways to replace because formatting might be slightly off
    $content = $content -replace '(?s)function connectWallet\(name\) \{.*?alert\(.*?closeWallet\(\);\s*\}', $newJs
    
    [IO.File]::WriteAllText("D:\Downloads\vaulta-final\$f", $content, [System.Text.Encoding]::UTF8)
    Write-Host "Replaced alert in $f"
}
