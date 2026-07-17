param(
  [int]$Port = 4321
)

$Root = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$Prefix = "http://localhost:$Port/"
$Address = [System.Net.IPAddress]::Parse("127.0.0.1")
$Server = [System.Net.Sockets.TcpListener]::new($Address, $Port)

$MimeTypes = @{
  ".html" = "text/html; charset=utf-8"
  ".css" = "text/css; charset=utf-8"
  ".js" = "application/javascript; charset=utf-8"
  ".json" = "application/json; charset=utf-8"
  ".png" = "image/png"
  ".jpg" = "image/jpeg"
  ".jpeg" = "image/jpeg"
  ".svg" = "image/svg+xml"
  ".webp" = "image/webp"
  ".ico" = "image/x-icon"
  ".pdf" = "application/pdf"
}

function Get-SafePath {
  param([string]$UrlPath)

  $CleanPath = $UrlPath.Split("?")[0].TrimStart("/")
  $DecodedPath = [System.Uri]::UnescapeDataString($CleanPath)
  if ([string]::IsNullOrWhiteSpace($DecodedPath)) {
    $DecodedPath = "index.html"
  }

  $Candidate = Join-Path $Root $DecodedPath
  $FullPath = [System.IO.Path]::GetFullPath($Candidate)

  if (-not $FullPath.StartsWith($Root, [System.StringComparison]::OrdinalIgnoreCase)) {
    return $null
  }

  if (Test-Path $FullPath -PathType Container) {
    return Join-Path $FullPath "index.html"
  }

  return $FullPath
}

function Write-Response {
  param(
    [System.Net.Sockets.NetworkStream]$Stream,
    [int]$StatusCode,
    [string]$StatusText,
    [string]$ContentType,
    [byte[]]$Body
  )

  $Header = "HTTP/1.1 $StatusCode $StatusText`r`nContent-Type: $ContentType`r`nContent-Length: $($Body.Length)`r`nConnection: close`r`n`r`n"
  $HeaderBytes = [System.Text.Encoding]::ASCII.GetBytes($Header)
  try {
    $Stream.Write($HeaderBytes, 0, $HeaderBytes.Length)
    if ($Body.Length -gt 0) {
      $Stream.Write($Body, 0, $Body.Length)
    }
  }
  catch [System.IO.IOException] {
    # Browsers sometimes close preview requests early; keep the server alive.
  }
}

try {
  $Server.Start()
  Write-Host "Serving $Root at $Prefix"
  Write-Host "Press Ctrl+C to stop."

  while ($true) {
    $Client = $Server.AcceptTcpClient()
    try {
      $Stream = $Client.GetStream()
      $Reader = [System.IO.StreamReader]::new($Stream, [System.Text.Encoding]::ASCII, $false, 1024, $true)
      $RequestLine = $Reader.ReadLine()

      if ([string]::IsNullOrWhiteSpace($RequestLine)) {
        $Body = [System.Text.Encoding]::UTF8.GetBytes("400 Bad Request")
        Write-Response $Stream 400 "Bad Request" "text/plain; charset=utf-8" $Body
        continue
      }

      $Parts = $RequestLine.Split(" ")
      $Method = $Parts[0]
      $UrlPath = $Parts[1]

      while (-not [string]::IsNullOrWhiteSpace($Reader.ReadLine())) {
      }

      if ($Method -ne "GET" -and $Method -ne "HEAD") {
        $Body = [System.Text.Encoding]::UTF8.GetBytes("405 Method Not Allowed")
        Write-Response $Stream 405 "Method Not Allowed" "text/plain; charset=utf-8" $Body
        continue
      }

      $FilePath = Get-SafePath $UrlPath
      if ($null -eq $FilePath -or -not (Test-Path $FilePath -PathType Leaf)) {
        $Body = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
        Write-Response $Stream 404 "Not Found" "text/plain; charset=utf-8" $Body
        continue
      }

      $Extension = [System.IO.Path]::GetExtension($FilePath).ToLowerInvariant()
      $ContentType = $MimeTypes[$Extension]
      if ([string]::IsNullOrWhiteSpace($ContentType)) {
        $ContentType = "application/octet-stream"
      }

      $Bytes = [System.IO.File]::ReadAllBytes($FilePath)
      if ($Method -eq "HEAD") {
        $Bytes = [byte[]]::new(0)
      }

      Write-Response $Stream 200 "OK" $ContentType $Bytes
    }
    catch {
      try {
        if ($null -ne $Stream) {
          $Body = [System.Text.Encoding]::UTF8.GetBytes("500 Internal Server Error")
          Write-Response $Stream 500 "Internal Server Error" "text/plain; charset=utf-8" $Body
        }
      }
      catch {
      }
    }
    finally {
      $Client.Close()
    }
  }
}
finally {
  $Server.Stop()
}
