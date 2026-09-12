$index = Get-Content "index.html" -Encoding UTF8 -Raw
$modal = [regex]::Match($index, "(?s)<div class=`"modal-overlay`" id=`"walletModal`" onclick=`"closeWalletOnBg\(event\)`">.*?</div>\s*</div>\s*</div>").Value

$files = @("docs.html", "audit.html", "404.html")

foreach ($f in $files) {
    $content = Get-Content $f -Encoding UTF8 -Raw
    # Remove everything from <div class="modal-overlay" id="walletModal" down to <script>
    $content = $content -replace "(?s)<div class=`"modal-overlay`" id=`"walletModal`" onclick=`"closeWalletOnBg\(event\)`">.*?<script>", ($modal + "`n`n<script>")
    [IO.File]::WriteAllText("D:\Downloads\vaulta-final\$f", $content, [System.Text.Encoding]::UTF8)
    Write-Host "Fixed $f"
}
