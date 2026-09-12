
$files = @("index.html", "app.html", "docs.html", "audit.html")

foreach ($f in $files) {
    if (Test-Path $f) {
        $text = Get-Content $f -Raw

        # Common Color replacements for Solana
        $text = $text.Replace("--void:    #000000;", "--void:    #0a0a0f;")
        $text = $text.Replace("--void: #000000;", "--void: #0a0a0f;")
        $text = $text.Replace("--deep:    #080808;", "--deep:    #0f0f1a;")
        $text = $text.Replace("--deep: #080808;", "--deep: #0f0f1a;")
        $text = $text.Replace("--surface: #111111;", "--surface: rgba(15,15,26,0.8);")
        $text = $text.Replace("--bg: #000;", "--bg: #0a0a0f;")
        $text = $text.Replace("--surface: #0a0a0a;", "--surface: #0f0f1a;")

        $text = $text.Replace("--lime:    #39d98a;", "--lime:    #14F195;")
        $text = $text.Replace("--lime: #39d98a;", "--lime: #14F195;")
        $text = $text.Replace("--red:     #888888;", "--red:     #9945FF;")
        $text = $text.Replace("--red: #d4595c;", "--red: #9945FF;")
        $text = $text.Replace("--amber:   #ffb300;", "--amber:   #9945FF;")
        $text = $text.Replace("--green: #00ff88;", "--green: #14F195;")

        # Add solana colors variables
        $text = $text.Replace("--gold:    #ffffff;", "--sol-purple: #9945FF; --sol-green: #14F195; --sol-grad: linear-gradient(90deg, var(--sol-purple), var(--sol-green));`n  --gold:    #ffffff;")
        $text = $text.Replace("--gold: #ffffff;", "--sol-purple: #9945FF; --sol-green: #14F195; --sol-grad: linear-gradient(90deg, #9945FF, #14F195); --gold: #ffffff;")

        # Logo update
        $text = $text.Replace("<div class=""nav-brand"">VAULTA<span", "<div class=""nav-brand"">VAULTA <span style=""color:#14F195"">?</span><span")
        $text = $text.Replace("<a href=""/"" class=""nav-brand"">VAULTA`n    <div", "<a href=""/"" class=""nav-brand"">VAULTA <span style=""color:#14F195"">?</span>`n    <div")

        # Headings text gradient modifications
        $text = $text.Replace("class=""hero-title t-display""", "class=""hero-title t-display"" style=""background: var(--sol-grad); -webkit-background-clip: text; -webkit-text-fill-color: transparent;""")
        $text = $text.Replace("class=""doc-h1""", "class=""doc-h1"" style=""background: var(--sol-grad); -webkit-background-clip: text; -webkit-text-fill-color: transparent; display: inline-block;""")
        $text = $text.Replace("class=""cta-title reveal""", "class=""cta-title reveal"" style=""background: var(--sol-grad); -webkit-background-clip: text; -webkit-text-fill-color: transparent;""")

        # Buttons (only updating the CSS rules in <style> by replacing the background)
        $text = $text.Replace("background: var(--gold); color: var(--void);", "background: var(--sol-grad); color: var(--void);")
        $text = $text.Replace("border-color: rgba(255,255,255,0.3); }`n.btn-primary-lg {", "border-color: rgba(255,255,255,0.3); }`n.btn-primary-lg {")
        # glow effect
        $text = $text.Replace("transform: translateY(-2px) scale(1.03); filter: brightness(1.1); }", "transform: translateY(-2px) scale(1.03); filter: brightness(1.1); box-shadow: 0 0 20px #9945FF; }")
        
        # Aurora background in index.html specifically
        if ($f -eq "index.html") {
            $text = $text.Replace("background:`n    radial-gradient(ellipse 80% 60% at 50% -10%,  rgba(255,255,255,0.04) 0%, transparent 55%),`n    radial-gradient(ellipse 40% 40% at 85% 70%, rgba(255,255,255,0.03) 0%, transparent 50%),`n    radial-gradient(ellipse 30% 30% at 15% 80%, rgba(57,217,138,0.03) 0%, transparent 50%);", "background:`n    radial-gradient(ellipse 80% 60% at 50% -10%, rgba(153,69,255,0.1) 0%, transparent 55%),`n    radial-gradient(ellipse 40% 40% at 85% 70%, rgba(20,241,149,0.08) 0%, transparent 50%),`n    radial-gradient(ellipse 30% 30% at 15% 80%, rgba(153,69,255,0.08) 0%, transparent 50%);`n  animation: auroraShift 10s ease-in-out infinite alternate;`n}`n@keyframes auroraShift {`n  0% { transform: scale(1); opacity: 0.8; }`n  100% { transform: scale(1.05); opacity: 1; }")
        }

        # Ticker alternating dots
        $text = $text.Replace(".t-dot::before { content: '?'; font-size: 7px; color: var(--gold-lo); position: absolute; left: 50%; top: 50%; transform: translate(-50%, -50%); }", ".t-dot::before { content: '?'; font-size: 7px; color: var(--sol-purple); position: absolute; left: 50%; top: 50%; transform: translate(-50%, -50%); }`n.t-dot:nth-child(even)::before { color: var(--sol-green); }")

        Set-Content $f -Value $text
    }
}

