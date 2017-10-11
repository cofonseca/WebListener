function Start-WebListener {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, HelpMessage="HTTP or HTTPS?")][ValidateSet("http","https")][String]$Protocol,
        [Parameter(Mandatory=$false)][String][Alias('Hostname')]$IPAddress,
        [Parameter(Mandatory=$false)][Int]$Port
    )

    BEGIN {
        # Load the Router
        . .\Private\Router.ps1

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
            while($ContextRequest.IsCompleted -ne $True -and $ContextRequest.IsCanceled -ne $True -and $ContextRequest.IsFaulted -ne $True -and $Exit -ne $True) {
                [System.Threading.Thread]::Sleep(30)
                
                # Process Ctrl+C
                if($Host.UI.RawUI.KeyAvailable -and (3 -eq [int]$Host.UI.RawUI.ReadKey("AllowCtrlC,IncludeKeyUp,NoEcho").Character)) {
                    Write-Output "Stopping Listener..."
                    $Listener.Abort()
                    Break
                }
            }
            
            # Request Handler
            $Context = $ContextRequest.Result
            $Request = $Context.Request
            $RequestType = $Request.HttpMethod
            $RequestURL = $Request.RawUrl

            if ($Context) {
                # Response Handler
                $Response = $Context.Response
                $Response.Headers.Add("Content-Type","text/html")

                # Let Router handle the logic
                Router $RequestType $RequestURL
            }
            
        }
        
        # Close the listener
        $Listener.Close()
    }
}
