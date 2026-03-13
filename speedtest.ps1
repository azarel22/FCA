$host.UI.RawUI.WindowTitle = 'Speed Test'
Clear-Host

function Show-Spinner ($msg, $ms) {
    $f = @('|','/','-','\')
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $i = 0
    while ($sw.ElapsedMilliseconds -lt $ms) {
        Write-Host ("`r   " + $f[$i % 4] + "  $msg   ") -NoNewline -ForegroundColor DarkCyan
        Start-Sleep -Milliseconds 80
        $i++
    }
    Write-Host "`r                                        " -NoNewline
    Write-Host "`r" -NoNewline
}

Write-Host ''
Write-Host '  +--------------------------------------------------+' -ForegroundColor Cyan
Write-Host '  |        SPEED TEST - Velocidad de Red            |' -ForegroundColor Cyan
Write-Host '  |     Bajada  /  Subida  /  Latencia              |' -ForegroundColor Cyan
Write-Host '  +--------------------------------------------------+' -ForegroundColor Cyan
Write-Host ''
Write-Host '  +--------------------------------------------------+' -ForegroundColor DarkCyan
Write-Host '  |  [1/3]  LATENCIA                                |' -ForegroundColor DarkCyan
Write-Host '  +--------------------------------------------------+' -ForegroundColor DarkCyan

$srv = $null
foreach ($s in @('8.8.8.8','1.1.1.1','9.9.9.9')) {
    ping -n 1 -w 1000 $s 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) { $srv = $s; break }
}
if (-not $srv) {
    Write-Host '   ! Ping bloqueado - continuando...' -ForegroundColor Yellow
} else {
    Write-Host "   Servidor : $srv" -ForegroundColor White
    Write-Host ''
    $ok = 0
    for ($i=1; $i -le 4; $i++) {
        ping -n 1 -w 2000 $srv 2>$null | Out-Null
        if ($LASTEXITCODE -eq 0) { $ok++; Write-Host "   Ping $i  >>  OK" -ForegroundColor Green }
        else { Write-Host "   Ping $i  >>  sin respuesta" -ForegroundColor Yellow }
    }
    Write-Host ''
    Write-Host "   Paquetes recibidos : $ok de 4" -ForegroundColor Cyan
}

Write-Host ''
Write-Host '  +--------------------------------------------------+' -ForegroundColor Green
Write-Host '  |  [2/3]  BAJADA  (Download)                      |' -ForegroundColor Green
Write-Host '  +--------------------------------------------------+' -ForegroundColor Green
Write-Host '   Descargando 50 MB desde Cloudflare...' -ForegroundColor DarkGray
$DL = 0
try {
    $wc = New-Object System.Net.WebClient
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    Show-Spinner 'Por favor espera...' 200
    $data = $wc.DownloadData('https://speed.cloudflare.com/__down?bytes=52428800')
    $sw.Stop()
    $DL = [math]::Round(($data.Length * 8) / ($sw.Elapsed.TotalMilliseconds * 1000), 1)
    $data = $null
    Write-Host "   Resultado >> $DL Mbps" -ForegroundColor Green
} catch {
    Write-Host "   ERROR en descarga: $_" -ForegroundColor Red
}

Write-Host ''
Write-Host '  +--------------------------------------------------+' -ForegroundColor Yellow
Write-Host '  |  [3/3]  SUBIDA  (Upload)                        |' -ForegroundColor Yellow
Write-Host '  +--------------------------------------------------+' -ForegroundColor Yellow
Write-Host '   Enviando 10 MB a Cloudflare...' -ForegroundColor DarkGray
$UL = 0
try {
    $uploadBytes = New-Object byte[] 10485760
    $url = 'https://speed.cloudflare.com/__up'
    $req = [System.Net.HttpWebRequest]::Create($url)
    $req.Method = 'POST'
    $req.ContentType = 'application/octet-stream'
    $req.ContentLength = $uploadBytes.Length
    $req.AllowWriteStreamBuffering = $false
    $req.SendChunked = $false
    $req.Timeout = 60000
    $sw2 = [System.Diagnostics.Stopwatch]::StartNew()
    Show-Spinner 'Por favor espera...' 200
    $stream = $req.GetRequestStream()
    $stream.Write($uploadBytes, 0, $uploadBytes.Length)
    $stream.Close()
    $resp = $req.GetResponse()
    $sw2.Stop()
    $resp.Close()
    $UL = [math]::Round(($uploadBytes.Length * 8) / ($sw2.Elapsed.TotalMilliseconds * 1000), 1)
    Write-Host "   Resultado >> $UL Mbps" -ForegroundColor Green
} catch {
    Write-Host "   ERROR subida: $_" -ForegroundColor Red
}

Write-Host ''
Write-Host '  +====================================================+' -ForegroundColor Cyan
Write-Host '  |  RESUMEN FINAL                                    |' -ForegroundColor Cyan
Write-Host '  +====================================================+' -ForegroundColor Cyan
Write-Host ''
Write-Host "    Bajada  : $DL Mbps" -ForegroundColor White
Write-Host "    Subida  : $UL Mbps" -ForegroundColor White
Write-Host ''
$d = [double]$DL
if     ($d -ge 300) { Write-Host '    Calidad : EXCELENTE  (Fibra alta velocidad)' -ForegroundColor Green }
elseif ($d -ge 100) { Write-Host '    Calidad : MUY BUENA  (4K / gaming)'          -ForegroundColor Green }
elseif ($d -ge 50)  { Write-Host '    Calidad : BUENA      (Streaming HD)'         -ForegroundColor Yellow }
elseif ($d -ge 25)  { Write-Host '    Calidad : REGULAR    (Uso general)'          -ForegroundColor Yellow }
elseif ($d -ge 1)   { Write-Host '    Calidad : LENTA'                             -ForegroundColor Red }
else                { Write-Host '    Calidad : Sin datos'                         -ForegroundColor DarkGray }
Write-Host ''
Write-Host '  +====================================================+' -ForegroundColor Cyan
Write-Host ''
Write-Host '    Prueba completada. Presiona Enter para volver...' -ForegroundColor DarkGray
Read-Host