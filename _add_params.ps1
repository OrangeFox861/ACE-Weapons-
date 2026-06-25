$basePath = "D:\steam\steamapps\common\GarrysMod\garrysmod\addons\ACE Weapons+\lua\weapons"

$weapons = @(
    "ak47mod", "ak74u", "an94", "auga1", "famasmod",
    "fnfal", "g3", "g36c", "g36e", "k2",
    "l85", "m16a3", "m416", "scarh", "scarl", "sg550"
)

$culture = [System.Globalization.CultureInfo]::InvariantCulture

foreach ($name in $weapons) {
    $testFile = Join-Path $basePath "weapon_ace_${name}test\shared.lua"
    
    Write-Host "Processing $name..."
    
    $content = Get-Content -Path $testFile -Raw
    
    # Extract RecoilSideBias value
    $m = [regex]::Match($content, 'SWEP\.RecoilSideBias\s*=\s*(-?\d+\.?\d*)')
    $sideBias = [double]::Parse($m.Groups[1].Value, $culture)
    
    Write-Host "  RecoilSideBias = $sideBias"
    
    # Insert ViewPunchAmountSide and ViewPunchAmountRoll after ViewPunchAmount line
    $pattern = '(SWEP\.ViewPunchAmount\s*=\s*\d+\.?\d*[^\n]*\n)'
    $replacement = "`${1}SWEP.ViewPunchAmountSide = $sideBias`nSWEP.ViewPunchAmountRoll = 0.5`n"
    
    $content = $content -replace $pattern, $replacement
    
    Set-Content -Path $testFile -Value $content -NoNewline
    
    Write-Host "  -> Added ViewPunchAmountSide=$sideBias, ViewPunchAmountRoll=0.5"
}

Write-Host "`nAll 16 test weapons updated!"
