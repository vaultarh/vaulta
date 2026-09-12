$js = @"

  // ── CLEAN URL SCROLL ──
  document.querySelectorAll('a[href^="/#"], a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
      const href = this.getAttribute('href');
      const id = href.substring(href.indexOf('#') + 1);
      const target = document.getElementById(id);
      
      if (target) {
        e.preventDefault();
        target.scrollIntoView({ behavior: 'smooth' });
        history.replaceState(null, null, window.location.pathname + window.location.search);
      }
    });
  });

  if (window.location.hash) {
    const target = document.getElementById(window.location.hash.substring(1));
    if (target) {
      setTimeout(() => {
        target.scrollIntoView({ behavior: 'smooth' });
        history.replaceState(null, null, window.location.pathname + window.location.search);
      }, 100);
    }
  }
"@

$files = @("index.html", "app.html", "docs.html", "audit.html", "404.html")

foreach ($f in $files) {
    $content = Get-Content $f -Encoding UTF8 -Raw
    if ($content -notmatch "CLEAN URL SCROLL") {
        $content = $content -replace "(</script>)", "$js`n`$1"
        [IO.File]::WriteAllText("D:\Downloads\vaulta-final\$f", $content, [System.Text.Encoding]::UTF8)
        Write-Host "Injected Clean URL script into $f"
    }
}
