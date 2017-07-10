function New-WebListener {
    [CmdletBinding()]param(
        [String]$Protocol,
        [String][Alias('Hostname')]$IPAddress,
        [Int]$Port
    )

    BEGIN {

        $URL = "$Protocol"+"://$IPAddress"+":$Port/"
        $Root = Split-Path -Parent $PSCommandPath
    }

    PROCESS {

        # Add routes (Get, Post, etc)
        # Route should include a path
        # The page at the path should be served

        # Spin up a new HTTP Listener
        $Listener = New-Object System.Net.HttpListener
        $Listener.Prefixes.Add($URL)
        $Listener.Start()
        Write-Output "Starting Listener at $URL..."

        while ($Listener.IsListening) {

            # Request Handler
            $Context = $Listener.GetContext()
            $Request = $Context.Request
            $RequestURL = $Request.Url.OriginalString
            Write-Output $RequestURL

            # Response Handler
            $Response = $Context.Response
            $Response.Headers.Add("Content-Type","text/html")
            $Response.StatusCode = 200 #only if it's successful

            #get the end of the url as the page/path and inject it into the page variable

            $PageURL = ([System.Uri]$RequestURL).LocalPath
            $PageContent = Get-Content ("$Root\views$PageURL")
            $ResponseBuffer = [System.Text.Encoding]::UTF8.GetBytes($PageContent)
            $Response.ContentLength64 = $ResponseBuffer.Length
            $Response.OutputStream.Write($ResponseBuffer,0,$ResponseBuffer.Length)
            $Response.Close()

        }

    }

}