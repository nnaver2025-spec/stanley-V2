$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$statusUrl = "http://127.0.0.1:8080/api/status?t=$([DateTimeOffset]::UtcNow.ToUnixTimeSeconds())"
$outLog = Join-Path $scriptDir "server.log"
$errLog = Join-Path $scriptDir "server.err.log"

try {
    Invoke-RestMethod -Uri $statusUrl -TimeoutSec 2 | Out-Null
    exit 0
} catch {
    # Server is not responding yet; start it below.
}

function Resolve-PythonCommand {
    $python = Get-Command python.exe -ErrorAction SilentlyContinue
    if ($python) {
        return @{ File = $python.Source; Args = @("server.py") }
    }

    $pyLauncher = Get-Command py.exe -ErrorAction SilentlyContinue
    if ($pyLauncher) {
        return @{ File = $pyLauncher.Source; Args = @("-3", "server.py") }
    }

    return $null
}

$pythonCommand = Resolve-PythonCommand
if (-not $pythonCommand) {
    "Python was not found on PATH at $(Get-Date -Format s)." | Out-File -FilePath $errLog -Append -Encoding utf8
    exit 1
}

$env:STANLEY_NO_BROWSER = "1"
Start-Process `
    -FilePath $pythonCommand.File `
    -ArgumentList $pythonCommand.Args `
    -WorkingDirectory $scriptDir `
    -WindowStyle Hidden `
    -RedirectStandardOutput $outLog `
    -RedirectStandardError $errLog
