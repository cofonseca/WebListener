function Router {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true,Position=0)][String]$RequestType,
        [Parameter(Mandatory=$true,Position=1)][String]$RequestURL
    )

    . $Root\Routes.ps1
    $Route = ($Routes | Where-Object {$_.RequestType -eq $RequestType -and $_.RequestURL -eq $RequestURL})

    # GET
    if ($RequestType -eq 'GET') {

        if (Test-Path -PathType Leaf -Path "$Root\views$RequestURL") {

            if ($($Route.RequestURL) -notmatch 'favicon') {
                Write-Verbose "Page found: $RequestURL"
                $Response.StatusCode = 200
            }

            $PageContent = Get-Content ("$Root\views$RequestURL")

        } elseif ($Route.RedirectURL) {

            Write-Verbose "Page found: $($Route.RedirectURL)"
            $Response.StatusCode = 200
            $PageContent = Get-Content ("$Root\views$($Route.RedirectURL)")

        } else {

            Write-Verbose "Page not found: 404: $RequestURL"
            $Response.StatusCode = 404
            $PageContent = Get-Content ("$Root\views\errorpages\404.html")

        }

        $ResponseBuffer = [System.Text.Encoding]::UTF8.GetBytes($PageContent)
        $Response.ContentLength64 = $ResponseBuffer.Length
        $Response.OutputStream.Write($ResponseBuffer,0,$ResponseBuffer.Length)
        $Response.Close()

        if ($Route.ScriptBlock) {
            & ([ScriptBlock]::Create($Route.ScriptBlock))
        }

    }

    # POST
    if ($RequestType -eq 'POST') {
        Write-Output $Context.Request
    }

    # PUT
    if ($RequestType -eq 'PUT') {

    }

    # DELETE
    if ($RequestType -eq 'DELETE') {

    }

}