function New-WebListener {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, HelpMessage="HTTP or HTTPS?")][ValidateSet("http","https")][String]$Protocol,
        [Parameter(Mandatory=$false)][String][Alias('Hostname')]$IPAddress,
        [Parameter(Mandatory=$false)][Int]$Port
    )

    BEGIN {
        if (!($Protocol)) {
            $Protocol = 'http'
        }
        if (!($IPAddress)) {
            $IPAddress = '127.0.0.1'
        }
        if (!($Port)) {
            $Port = 8080
        }
        $URL = "$Protocol"+"://$IPAddress"+":$Port/"
        $Root = Split-Path -Parent $PSCommandPath
        
    }

    PROCESS {

        # Add routes (GET, POST, PUT, DELETE)

        # Spin up a new HTTP Listener
        $Listener = New-Object System.Net.HttpListener
        $Listener.Prefixes.Add($URL)
        $Listener.Start()
        Write-Output "Starting Listener at $URL..."
        $Exit = $False

        while ($Listener.IsListening) {
            
            # Use async request to avoid blocking the current thread
            $ContextRequest = $Listener.GetContextAsync()
            
            # Check every 30ms if a request has been received
            while($ContextRequest.IsCompleted -ne $True -and $ContextRequest.IsCanceled -ne $True -and $ContextRequest.IsFaulted -ne $True -and $exit -ne $True) {
                [System.Threading.Thread]::Sleep(30)
                
                # Process Ctrl+C
                if($Host.UI.RawUI.KeyAvailable -and (3 -eq  [int]$Host.UI.RawUI.ReadKey("AllowCtrlC,IncludeKeyUp,NoEcho").Character)) {
                    Write-Output "Stopping Listener..."
                    $Listener.Stop()
                    break
                }
            }
            
            # Request Handler
            $Context = $ContextRequest.Result
            $Request = $Context.Request
            $RequestURL = $Request.RawUrl

            # Default to Index
            if ($RequestURL -eq '' -or $RequestURL -eq '/') {
                $RequestURL = '/index.html'
            }

            # Response Handler
            $Response = $Context.Response
            $Response.Headers.Add("Content-Type","text/html")
            $Response.StatusCode = 200 #only if it's successful

            $PageURL = ([System.Uri]$RequestURL).LocalPath
            if (Test-Path "$Root\views$RequestURL") {
                Write-Output "Page found: $RequestURL"
                $PageContent = Get-Content ("$Root\views$RequestURL")
            } else {
                Write-Output "Page not found: 404: $RequestURL"
                $PageContent = Get-Content ("$Root\views\errorpages\404.html")
            }
            $ResponseBuffer = [System.Text.Encoding]::UTF8.GetBytes($PageContent)
            $Response.ContentLength64 = $ResponseBuffer.Length
            $Response.OutputStream.Write($ResponseBuffer,0,$ResponseBuffer.Length)
            $Response.Close()

        }
        
        # Close the listener
        $Listener.Close()
    }
}
