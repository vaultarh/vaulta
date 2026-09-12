$index = Get-Content "index.html" -Encoding UTF8 -Raw

# Extract Fonts
$fontsMatch = [regex]::Match($index, "(?s)<link[^>]*fonts\.googleapis\.com[^>]*>").Value

# Extract Nav
$navMatch = [regex]::Match($index, "(?s)<nav>.*?</nav>").Value
$navMatch = $navMatch -replace 'href="#how"', 'href="/#how"'
$navMatch = $navMatch -replace 'href="#vaults"', 'href="/#vaults"'
$navMatch = $navMatch -replace 'href="#ai"', 'href="/#ai"'
$navMatch = $navMatch -replace 'href="#security"', 'href="/#security"'
$navMatch = $navMatch -replace 'href="#roadmap"', 'href="/#roadmap"'

# Extract Footer
$footerMatch = [regex]::Match($index, "(?s)<footer>.*?</footer>").Value

# Extract Modal
$modalMatch = [regex]::Match($index, "(?s)<div class=`"modal-overlay`" id=`"walletModal`".*?</div>\s*</div>\s*</div>").Value

# Extract Script (just match WALLET MODAL loosely)
$scriptMatch = [regex]::Match($index, "(?s)<script>.*?WALLET MODAL.*?</script>").Value

# Extract CSS root variables
$styleMatch = [regex]::Match($index, "(?s)<style>(.*?)</style>").Groups[1].Value
$rootVars = [regex]::Match($styleMatch, "(?s)(:root\s*\{.*?\})").Value

$files = @("app.html", "docs.html", "audit.html", "404.html")

foreach ($f in $files) {
    if (Test-Path $f) {
        $content = Get-Content $f -Encoding UTF8 -Raw
        
        # Replace Fonts
        $content = $content -replace "(?s)<link[^>]*fonts\.googleapis\.com[^>]*>", $fontsMatch
        
        # Replace Nav
        if ($content -match "(?s)<nav>.*?</nav>") {
            $content = $content -replace "(?s)<nav>.*?</nav>", $navMatch
        } else {
            $content = $content -replace "(?i)<body>", ("<body>`n" + $navMatch)
        }
        
        # Replace Footer
        if ($content -match "(?s)<footer>.*?</footer>") {
            $content = $content -replace "(?s)<footer>.*?</footer>", $footerMatch
        } else {
            $content = $content -replace "(?i)</body>", ("`n" + $footerMatch + "`n</body>")
        }
        
        # Add Modal
        if (-not ($content -match "id=`"walletModal`"")) {
             $content = $content -replace "(?i)</body>", ("`n" + $modalMatch + "`n</body>")
        }
        
        # Add Script for wallet
        if ($scriptMatch -ne "" -and -not ($content -match "function openWallet")) {
             $content = $content -replace "(?i)</body>", ("`n" + $scriptMatch + "`n</body>")
        }
        
        # Replace Root Vars
        if ($content -match "(?s):root\s*\{.*?\}") {
            $content = $content -replace "(?s):root\s*\{.*?\}", $rootVars
        }
        
        # Add CSS sections from full_style roughly using regex without special chars
        
        # Nav
        $navStyleRegex = "(?s)/\* [^\*]*NAV [^\*]* \*/.*?/\* [^\*]* \*/"
        $navStyleMatch = [regex]::Match($styleMatch, $navStyleRegex).Value
        if ($navStyleMatch) {
            # Trim the last comment
            $idx = $navStyleMatch.LastIndexOf("/*")
            if ($idx -gt 0) { $navStyle = $navStyleMatch.Substring(0, $idx) } else { $navStyle = $navStyleMatch }
            
            if (-not ($content -match "/* .* NAV .* */")) {
                $content = $content -replace "</style>", ("`n" + $navStyle + "`n</style>")
            }
        }
        
        # Footer
        $footerStyleRegex = "(?s)/\* [^\*]*FOOTER [^\*]* \*/.*?/\* [^\*]* \*/"
        $footerStyleMatch = [regex]::Match($styleMatch, $footerStyleRegex).Value
        if ($footerStyleMatch) {
            $idx = $footerStyleMatch.LastIndexOf("/*")
            if ($idx -gt 0) { $footerStyle = $footerStyleMatch.Substring(0, $idx) } else { $footerStyle = $footerStyleMatch }
            if (-not ($content -match "/* .* FOOTER .* */")) {
                $content = $content -replace "</style>", ("`n" + $footerStyle + "`n</style>")
            }
        }
        
        # Modal
        $modalStyleRegex = "(?s)/\* [^\*]*WALLET MODAL [^\*]* \*/.*?/\* [^\*]* \*/"
        $modalStyleMatch = [regex]::Match($styleMatch, $modalStyleRegex).Value
        if ($modalStyleMatch) {
            $idx = $modalStyleMatch.LastIndexOf("/*")
            if ($idx -gt 0) { $modalStyle = $modalStyleMatch.Substring(0, $idx) } else { $modalStyle = $modalStyleMatch }
            if (-not ($content -match "/* .* WALLET MODAL .* */")) {
                $content = $content -replace "</style>", ("`n" + $modalStyle + "`n</style>")
            }
        }

        # Some minor body background fixes
        $content = $content -replace "body\s*\{\s*background:.*?;", "body { background: var(--bg);"
        
        # Overwrite file
        [IO.File]::WriteAllText("D:\Downloads\vaulta-final\$f", $content, [System.Text.Encoding]::UTF8)
        Write-Host "Updated $f"
    }
}
