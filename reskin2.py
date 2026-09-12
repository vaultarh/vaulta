import re

def update_file(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"Skipping {filepath}: {e}")
        return

    with open('d:/Downloads/vaulta-final/index.html', 'r', encoding='utf-8') as f:
        index_content = f.read()

    # Extract items from index.html
    fonts_match = re.search(r'(<link[^>]*fonts\.googleapis\.com[^>]*>)', index_content)
    fonts = fonts_match.group(1) if fonts_match else ''

    nav_match = re.search(r'(<nav>.*?</nav>)', index_content, re.DOTALL)
    nav = nav_match.group(1) if nav_match else ''
    
    # Fix nav links for subpages
    nav = nav.replace('href="#how"', 'href="/#how"')
    nav = nav.replace('href="#vaults"', 'href="/#vaults"')
    nav = nav.replace('href="#ai"', 'href="/#ai"')
    nav = nav.replace('href="#security"', 'href="/#security"')
    nav = nav.replace('href="#roadmap"', 'href="/#roadmap"')

    footer_match = re.search(r'(<footer>.*?</footer>)', index_content, re.DOTALL)
    footer = footer_match.group(1) if footer_match else ''
    footer = footer.replace('href="#vaults"', 'href="/#vaults"')
    footer = footer.replace('href="#ai"', 'href="/#ai"')
    footer = footer.replace('href="#security"', 'href="/#security"')
    footer = footer.replace('href="#roadmap"', 'href="/#roadmap"')

    modal_match = re.search(r'(<div class="modal-overlay".*?</div>\s*</div>\s*</div>)', index_content, re.DOTALL)
    modal = modal_match.group(1) if modal_match else ''

    # Extract script
    script_match = re.search(r'(<script>.*?// ── WALLET MODAL ──.*?</script>)', index_content, re.DOTALL)
    script = script_match.group(1) if script_match else ''

    # Extract global CSS (nav, footer, modal, buttons, variables)
    style_match = re.search(r'<style>(.*?)</style>', index_content, re.DOTALL)
    root_vars = ''
    full_style = ''
    if style_match:
        full_style = style_match.group(1)
        # Extract variables
        vars_match = re.search(r'(:root\s*\{.*?\})', full_style, re.DOTALL)
        root_vars = vars_match.group(1) if vars_match else ''

    # REPLACE FONTS
    content = re.sub(r'<link[^>]*fonts\.googleapis\.com[^>]*>', fonts, content)

    # REPLACE NAV
    if '<nav>' in content:
        content = re.sub(r'<nav>.*?</nav>', nav, content, flags=re.DOTALL)
    else:
        # insert after <body>
        content = re.sub(r'(<body>)', r'\1\n' + nav, content)

    # REPLACE FOOTER
    if '<footer>' in content:
        content = re.sub(r'<footer>.*?</footer>', footer, content, flags=re.DOTALL)
    else:
        content = content.replace('</body>', '\n' + footer + '\n</body>')
        
    # CSS Updates
    # Replace the old root variables with the new root variables
    if ':root {' in content:
        content = re.sub(r':root\s*\{.*?\}', root_vars, content, flags=re.DOTALL)

    # Add the CSS for nav, modal, footer if missing
    style_parts_to_inject = []
    
    # We remove the old nav and footer styles from content if possible
    content = re.sub(r'/\* NAV \*/.*?/\* (DOCS LAYOUT|APP LAYOUT) \*/', r'/* \1 */', content, flags=re.DOTALL)
    
    for section in ['/* ── NAV ── */', '/* ── FOOTER ── */', '/* ── WALLET MODAL ── */']:
        if section in full_style:
            # roughly extract until next section
            part = full_style.split(section)[1].split('/* ──')[0]
            style_parts_to_inject.append(section + part)
            
    # Inject missing styles
    for part in style_parts_to_inject:
        content = content.replace('</style>', part + '\n</style>')

    # Add modal and scripts
    if modal and 'modal-overlay' not in content:
        content = content.replace('</body>', '\n' + modal + '\n</body>')
        
    if script and 'function openWallet' not in content:
        content = content.replace('</body>', '\n' + script + '\n</body>')

    # Specific fix for body background
    content = re.sub(r'body\{background:.*?;', r'body{background:var(--bg);', content)

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
        
    print(f"Updated {filepath}")

files = ['d:/Downloads/vaulta-final/app.html', 'd:/Downloads/vaulta-final/docs.html', 'd:/Downloads/vaulta-final/audit.html', 'd:/Downloads/vaulta-final/404.html']
for f in files:
    update_file(f)
