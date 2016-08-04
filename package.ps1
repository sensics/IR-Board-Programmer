
[CmdletBinding()]
Param(
    [switch]$SelfExtractor,
    [switch]$Dummy
)

# Clean up temporary hex files.
Get-ChildItem *.hex -Exclude "ir_led_driver_production.hex" -Recurse | Remove-Item

$outstem = 'IR-Board-Programmer-Bundle-20160408'
if ($SelfExtractor) {
  $outfile = "$outstem.exe"
} else {
  $outfile = "$outstem.zip"
}

$sevenzip = '7za'
$sfx='7z.sfx'
$sevenzipbase=Join-Path $env:ChocolateyInstall "lib\7zip.commandline\tools"
if (("$env:ChocolateyInstall" -ne '') -and (Test-Path $sevenzipbase)) {
  $sevenzip=Join-Path $sevenzipbase '7z.exe'
  $sfx=Join-Path $sevenzipbase '7z.sfx'
  Write-Host 'Found Chocolatey install of 7zip.commandline: -SelfExtractor more likely to work!'
} else {
  Write-Host 'For best results, run "choco install -y 7zip.commandline" first - we could not find this.'
}

$DirName=$(Get-Item .).Name

$directories = @('srecord-1.64-win32', 'stm8flash')

$files = @(Get-Item 'Program-LedHex.ps1') +
    @(Get-Item 'Program-IRFirmware.cmd') +
    @(Get-ChildItem *.hex) +
    @(Get-ChildItem *.txt)

$sources = $files + @($directories | ForEach-Object { Get-Item $_ })
$args = @('a', "$DirName\$outfile")

if ($SelfExtractor) {
  $args += "-sfx$sfx"
} else {
  $args += '-tzip'
}

Push-Location ..
  # Since we were getting "Item" objects, not path strings, we can do the last-minute directory change.
  # Need the trim start so 7z doesn't strip the leading directory.
  $args += @($sources | Resolve-Path -Relative | ForEach-Object { $_.TrimStart(".\") })
  if ($Dummy) {
    Write-Host "Arguments to $sevenzip :"
    Write-Host $args
  } else {
    Start-Process "$sevenzip" -ArgumentList $args -NoNewWindow -Wait
  }

Pop-Location
