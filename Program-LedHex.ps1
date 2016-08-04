[CmdletBinding()]
Param(
    [Parameter(Position=1)]$HexFile = "ir_led_driver_production.hex"
)

# Includes stm8flash (slightly modified from https://github.com/vdudouyt/stm8flash ) instead of ST Visual Programmer as the programming software.

# Requires an STLink v2-type programming tool for the STM8.
# Pass the combined (flash and eeprom) hex file as the first or -HexFile argument. Ignore the warnings about libusb.
$Tool = "stlinkv2"

$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$STM8Flash = Join-Path $PSScriptRoot "stm8flash\stm8flash.exe"
$SRecCat = Join-Path $PSScriptRoot "srecord-1.64-win32\srec_cat.exe"

$ProgFile = Join-Path $PSScriptRoot "program-tmp.hex"
$DataFile = Join-Path $PSScriptRoot "eeprom-tmp.hex"

Write-Verbose "Extracting program segment of $HexFile to $ProgFile"
# Keep the entire program segment and the execution start address in the new hex file.
$ExtractProgArgs = @("""$HexFile""", '--intel', '--crop', '0x008000', '0x00a000', '--enable=execution_start_address', '--output', """$ProgFile""", '--intel')
Start-Process $SRecCat -ArgumentList $ExtractProgArgs -NoNewWindow -Wait

Write-Verbose "Extracting EEPROM segment of $HexFile to $DataFile"
# Keep the entire EEPROM segment in the new hex file.
$ExtractDataArgs = @("""$HexFile""", '--intel', '--crop', '0x004000', '0x004080', '--output', """$DataFile""", '--intel')
Start-Process $SRecCat -ArgumentList $ExtractDataArgs -NoNewWindow -Wait

$ProgBaseArgs = @(
    '-c',
    $Tool,
    '-p',
    'stm8s003k3')
Write-Host "Basic arguments to stm8flash: $ProgBaseArgs"


$ProgFlashArgs = $ProgBaseArgs + @('-w', """$ProgFile""")
Write-Host "Arguments to stm8flash for program: $ProgFlashArgs"
Start-Process $STM8Flash -ArgumentList $ProgFlashArgs -NoNewWindow -Wait

$ProgEepromArgs = $ProgBaseArgs + @('-w', """$DataFile""", '-s', 'eeprom')
Write-Host "Arguments to stm8flash for eeprom: $ProgEepromArgs"
Start-Process $STM8Flash -ArgumentList $ProgEepromArgs -NoNewWindow -Wait
