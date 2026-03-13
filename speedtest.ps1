# =============================================
# SPEED TEST - RTIC HUB FCA
# =============================================

$ESC = [char]27
$CYAN    = "$ESC[96m"
$GREEN   = "$ESC[92m"
$YELLOW  = "$ESC[93m"
$RED     = "$ESC[91m"
$WHITE   = "$ESC[97m"
$GRAY    = "$ESC[90m"
$ORANGE  = "$ESC[38;5;208m"
$MINT    = "$ESC[38;2;80;255;180m"
$BOLD    = "$ESC[1m"
$RST     = "$ESC[0m"
$LBLUE   = "$ESC[38;2;100;200;255m"

$host.UI.RawUI.WindowTitle = 'Speed Test - RTIC HUB'
Clear-Host

function Draw-Header {
    Write-Host ""
    Write-Host "  $ORANGE$BOLD════════════════════════════════════════════════════════════$RST"
    Write-Host "  $WHITE$BOLD  SPEED TEST$RST  $LBLUE- Velocidad de Conexion$RST"
    Write-Host "  $GRAY  Bajada  /  Subida  /  Latencia$RST"
    Write-Host "  $ORANGE$BOLD════════════════════════════════════════════════════════════$RST"
    Write-Host ""
}

function Draw-Section ($titulo, $color) {
    Write-Host "  $color════════════════════════════════════════════════════════════$RST"
    Write-Host "  $color$BOLD  $titulo$RST"
    Write-Host "  $color════════════════════════════════════════════════════════════$RST"
}

function Show-Spinner ($msg, $ms) {
    $frames = @(
        "  [=         ]",
        "  [ =        ]",
        "  [  =       ]",
        "  [   =      ]",
        "  [    =     ]",
        "  [     =    ]",
        "  [      =   ]",
        "  [       =  ]",
        "  [        = ]",
        "  [         =]",
        "  [        = ]",
        "  [       =  ]",
        "  [      =   ]",
        "  [     =    ]",
        "  [    =     ]",
        "  [   =      ]",
        "  [  =       ]",
        "  [ =        ]"
    )
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $i = 0
    while ($sw.ElapsedMilliseconds -lt $ms) {
        $frame = $frames[$i % $frames.Length]
        Write-Host "`r  $CYAN$frame$RST  $GRAY$msg$RST   " -NoNewline
        Start-Sleep -Milliseconds 60
        $i++
    }
    Write-Host "`r                                                            " -NoNewline
    Write-Host "`r" -NoNewline
}

function Show-ProgressBar ($pct, $color) {
    $total = 40
    $filled = [math]::Round($pct / 100 * $total)
    $empty = $total - $filled
    $bar = ("$color" + [string]::new([char]0x2588, $filled) + "$GRAY" + [string]::new([char]0x2591, $empty) + "$RST")
    Write-Host "  [ $bar ] $WHITE$pct%$RST" -NoNewline
}

# ─── HEADER ───
Draw-Header

# ─────────────────────────────────────────────
# [1/3] LATENCIA
# ─────────────────────────────────────────────
Draw-Section "[1/3]  LATENCIA" $CYAN
Write-Host ""

$srv = $null
$servidores = @('8.8.8.8','1.1.1.1','9.9.9.9')
foreach ($s in $servidores) {
    ping -n 1 -w 1000 $s 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) { $srv = $s; break }
}

if (-not $srv) {
    Write-Host "  $YELLOW  ! Ping bloqueado o sin respuesta - continuando...$RST"
} else {
    Write-Host "  $GRAY  Servidor seleccionado : $WHITE$srv$RST"
    Write-Host ""
    $ok = 0
    $tiempos = @()
    for ($i = 1; $i -le 4; $i++) {
        $sw_ping = [System.Diagnostics.Stopwatch]::StartNew()
        ping -n 1 -w 2000 $srv 2>$null | Out-Null
        $sw_ping.Stop()
        if ($LASTEXITCODE -eq 0) {
            $ok++
            $ms_val = $sw_ping.ElapsedMilliseconds
            $tiempos += $ms_val
            Write-Host "  $GREEN  Ping $i  >>  OK  $GRAY($ms_val ms)$RST"
        } else {
            Write-Host "  $YELLOW  Ping $i  >>  sin respuesta$RST"
        }
    }
    Write-Host ""
    if ($tiempos.Count -gt 0) {
        $avg = [math]::Round(($tiempos | Measure-Object -Average).Average, 0)
        Write-Host "  $CYAN  Latencia promedio : $WHITE$BOLD$avg ms$RST   $GRAY(paquetes OK: $ok/4)$RST"
    }
}

Write-Host ""

# ─────────────────────────────────────────────
# [2/3] BAJADA
# ─────────────────────────────────────────────
Draw-Section "[2/3]  BAJADA  (Download)" $GREEN
Write-Host ""
Write-Host "  $GRAY  Descargando 50 MB desde Cloudflare...$RST"
Write-Host ""

$DL = 0
try {
    $wc = New-Object System.Net.WebClient
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    Show-Spinner "Midiendo bajada..." 300
    $data = $wc.DownloadData('https://speed.cloudflare.com/__down?bytes=52428800')
    $sw.Stop()
    $DL = [math]::Round(($data.Length * 8) / ($sw.Elapsed.TotalMilliseconds * 1000), 1)
    $data = $null
    Write-Host "  $GREEN$BOLD  Resultado  >>  $DL Mbps$RST"
    Write-Host ""
    $pct = [math]::Min([math]::Round($DL / 300 * 100), 100)
    Show-ProgressBar $pct $GREEN
    Write-Host ""
} catch {
    Write-Host "  $RED  ERROR en descarga: $_$RST"
}

Write-Host ""

# ─────────────────────────────────────────────
# [3/3] SUBIDA
# ─────────────────────────────────────────────
Draw-Section "[3/3]  SUBIDA  (Upload)" $YELLOW
Write-Host ""
Write-Host "  $GRAY  Enviando 10 MB a Cloudflare...$RST"
Write-Host ""

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
    Show-Spinner "Midiendo subida..." 300
    $stream = $req.GetRequestStream()
    $stream.Write($uploadBytes, 0, $uploadBytes.Length)
    $stream.Close()
    $resp = $req.GetResponse()
    $sw2.Stop()
    $resp.Close()
    $UL = [math]::Round(($uploadBytes.Length * 8) / ($sw2.Elapsed.TotalMilliseconds * 1000), 1)
    Write-Host "  $YELLOW$BOLD  Resultado  >>  $UL Mbps$RST"
    Write-Host ""
    $pct2 = [math]::Min([math]::Round($UL / 100 * 100), 100)
    Show-ProgressBar $pct2 $YELLOW
    Write-Host ""
} catch {
    Write-Host "  $RED  ERROR subida: $_$RST"
}

Write-Host ""

# ─────────────────────────────────────────────
# RESUMEN FINAL
# ─────────────────────────────────────────────
Write-Host "  $ORANGE$BOLD════════════════════════════════════════════════════════════$RST"
Write-Host "  $WHITE$BOLD  RESUMEN FINAL$RST"
Write-Host "  $ORANGE$BOLD════════════════════════════════════════════════════════════$RST"
Write-Host ""
Write-Host "  $LBLUE  Bajada   :  $WHITE$BOLD$DL Mbps$RST"
Write-Host "  $LBLUE  Subida   :  $WHITE$BOLD$UL Mbps$RST"
Write-Host ""

$d = [double]$DL
if     ($d -ge 300) { Write-Host "  $GREEN$BOLD  Calidad  :  EXCELENTE   (Fibra alta velocidad)$RST" }
elseif ($d -ge 100) { Write-Host "  $GREEN$BOLD  Calidad  :  MUY BUENA   (4K / gaming)$RST" }
elseif ($d -ge 50)  { Write-Host "  $YELLOW$BOLD  Calidad  :  BUENA       (Streaming HD)$RST" }
elseif ($d -ge 25)  { Write-Host "  $YELLOW$BOLD  Calidad  :  REGULAR     (Uso general)$RST" }
elseif ($d -ge 1)   { Write-Host "  $RED$BOLD  Calidad  :  LENTA$RST" }
else                { Write-Host "  $GRAY  Calidad  :  Sin datos$RST" }

Write-Host ""
Write-Host "  $ORANGE$BOLD════════════════════════════════════════════════════════════$RST"
Write-Host ""
Write-Host "  $GRAY  Prueba completada. Presiona Enter para volver...$RST"
Read-Host