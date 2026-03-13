$host.UI.RawUI.WindowTitle = 'Speed Test - RTIC HUB'
try {
    $size = $host.UI.RawUI.WindowSize
    $size.Width = 90
    $size.Height = 42
    $host.UI.RawUI.WindowSize = $size
    $buf = $host.UI.RawUI.BufferSize
    $buf.Width = 90
    $host.UI.RawUI.BufferSize = $buf
} catch {}

Clear-Host

$ESC    = [char]27
$CYAN   = "$ESC[96m"
$GREEN  = "$ESC[92m"
$YELLOW = "$ESC[93m"
$RED    = "$ESC[91m"
$WHITE  = "$ESC[97m"
$GRAY   = "$ESC[90m"
$ORANGE = "$ESC[38;5;208m"
$BOLD   = "$ESC[1m"
$RST    = "$ESC[0m"
$LBLUE  = "$ESC[38;2;100;200;255m"
$SEP    = "  ============================================================"

function Draw-Header {
    Write-Host ""
    Write-Host "$ORANGE$BOLD$SEP$RST"
    Write-Host "  $WHITE$BOLD  SPEED TEST$RST  $LBLUE- Velocidad de Conexion$RST"
    Write-Host "$ORANGE$BOLD$SEP$RST"
    Write-Host ""
}

function Draw-Section ($titulo, $color) {
    Write-Host "$color$SEP$RST"
    Write-Host "  $color$BOLD  $titulo$RST"
    Write-Host "$color$SEP$RST"
    Write-Host ""
}

function Show-FakeProgress ($color, $ms) {
    $slots  = 30
    $steps  = $slots * 2
    $delay  = [math]::Round($ms / $steps)
    $filled = 0

    # frames de la bolita que rebota dentro de la barra vacia al inicio
    for ($p = 0; $p -le $steps; $p++) {
        $pct    = [math]::Round($p / $steps * 100)
        $filled = [math]::Round($p / $steps * $slots)
        $empty  = $slots - $filled

        # segmento lleno con bloque solido + punta brillante
        if ($filled -gt 0) {
            $barFull  = ($color + ("=" * ($filled - 1)) + ">" + $RST)
        } else {
            $barFull  = ""
        }
        $barEmpty = ($GRAY + ("-" * $empty) + $RST)

        $pctStr = "$pct%".PadLeft(4)
        Write-Host "`r  $WHITE[$RST$barFull$barEmpty$WHITE]$RST $CYAN$BOLD$pctStr$RST  " -NoNewline
        Start-Sleep -Milliseconds $delay
    }
    Write-Host ""
}

function Show-Calculating ($ms) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $frames = @(
        "  Calculando         ",
        "  Calculando .       ",
        "  Calculando . .     ",
        "  Calculando . . .   ",
        "  Calculando . . . . "
    )
    $i = 0
    while ($sw.ElapsedMilliseconds -lt $ms) {
        Write-Host "`r$CYAN$($frames[$i % $frames.Length])$RST" -NoNewline
        Start-Sleep -Milliseconds 180
        $i++
    }
    Write-Host "`r                          " -NoNewline
    Write-Host "`r" -NoNewline
}

Draw-Header

# ─────────────────────────
# [1/3] LATENCIA
# ─────────────────────────
Draw-Section "[1/3]  LATENCIA" $CYAN

$srv = $null
foreach ($s in @('8.8.8.8','1.1.1.1','9.9.9.9')) {
    ping -n 1 -w 1000 $s 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) { $srv = $s; break }
}

if (-not $srv) {
    Write-Host "  $YELLOW  ! Ping bloqueado o sin respuesta - continuando...$RST"
} else {
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
            Write-Host "  $YELLOW  Ping $i  >>  timeout$RST"
        }
    }
    Write-Host ""
    if ($tiempos.Count -gt 0) {
        $avg = [math]::Round(($tiempos | Measure-Object -Average).Average, 0)
        Write-Host "  $CYAN  Latencia promedio : $WHITE$BOLD$avg ms$RST   $GRAY(OK: $ok/4)$RST"
    }
}
Write-Host ""

# ─────────────────────────
# [2/3] BAJADA
# ─────────────────────────
Draw-Section "[2/3]  BAJADA  (Download)" $GREEN

$DL = 0
try {
    $wc   = New-Object System.Net.WebClient
    $sw   = [System.Diagnostics.Stopwatch]::StartNew()
    $data = $wc.DownloadData('https://speed.cloudflare.com/__down?bytes=52428800')
    $sw.Stop()
    $DL   = [math]::Round(($data.Length * 8) / ($sw.Elapsed.TotalMilliseconds * 1000), 1)
    $data = $null
    Show-FakeProgress $GREEN 2000
    Show-Calculating 800
    Write-Host "  $GREEN$BOLD  Resultado  >>  $DL Mbps$RST"
} catch {
    Write-Host "  $RED  ERROR: $_$RST"
}
Write-Host ""

# ─────────────────────────
# [3/3] SUBIDA
# ─────────────────────────
Draw-Section "[3/3]  SUBIDA  (Upload)" $YELLOW

$UL = 0
try {
    $uploadBytes = New-Object byte[] 10485760
    $req = [System.Net.HttpWebRequest]::Create('https://speed.cloudflare.com/__up')
    $req.Method = 'POST'
    $req.ContentType = 'application/octet-stream'
    $req.ContentLength = $uploadBytes.Length
    $req.AllowWriteStreamBuffering = $false
    $req.SendChunked = $false
    $req.Timeout = 60000
    $sw2    = [System.Diagnostics.Stopwatch]::StartNew()
    $stream = $req.GetRequestStream()
    $stream.Write($uploadBytes, 0, $uploadBytes.Length)
    $stream.Close()
    $resp = $req.GetResponse()
    $sw2.Stop()
    $resp.Close()
    $UL = [math]::Round(($uploadBytes.Length * 8) / ($sw2.Elapsed.TotalMilliseconds * 1000), 1)
    Show-FakeProgress $YELLOW 2000
    Show-Calculating 800
    Write-Host "  $YELLOW$BOLD  Resultado  >>  $UL Mbps$RST"
} catch {
    Write-Host "  $RED  ERROR: $_$RST"
}
Write-Host ""

# ─────────────────────────
# RESUMEN
# ─────────────────────────
Write-Host "$ORANGE$BOLD$SEP$RST"
Write-Host "  $WHITE$BOLD  RESUMEN FINAL$RST"
Write-Host "$ORANGE$BOLD$SEP$RST"
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
Write-Host "$ORANGE$BOLD$SEP$RST"
Write-Host ""
Write-Host "  $GRAY  Prueba completada. Presiona Enter para volver...$RST"

$null = $host.UI.ReadLine()