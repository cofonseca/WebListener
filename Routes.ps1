$Routes = @(
    @{
        'RequestType' = 'GET'
        'RequestURL' = '/index'
        'RedirectURL' = '/index.html'
    }

    @{
        'RequestType' = 'GET'
        'RequestURL' = ''
        'RedirectURL' = '/index.html'
    }

    @{
        'RequestType' = 'GET'
        'RequestURL' = '/'
        'RedirectURL' = '/index.html'
    }

    # Example of a route that contains a custom scriptblock
    @{
        'RequestType' = 'GET'
        'RequestURL' = '/process'
        'ScriptBlock' = {
            Get-Process
        }
    }

    # Example of a more web-friendly route with scriptblock
    @{
        'RequestType' = 'GET'
        'RequestURL' = '/getservice'
        'ScriptBlock' = {
            Get-Service | ConvertTo-Html
        }
    }

    # Get-Process piped to ConvertTo-Html will generate a table with all process data, so it is better to filter it before output
    @{
        'RequestType' = 'GET'
        'RequestURL' = '/getprocess'
        'ScriptBlock' = {
            Get-Process | select Name, Id, CPU, WorkingSet, Path | ConvertTo-Html
        }
    }

    # Example of try .. catch block
    @{
        'RequestType' = 'GET'
        'RequestURL' = '/getfail'
        'ScriptBlock' = {
        try {
            Get-ChildItem c:\..\.. | ConvertTo-Html
            
            }
        catch {
            $Error[0] | ConvertTo-Html -as List
            }

        }
    }

    # ... Why not?
    @{
        'RequestType' = 'GET'
        'RequestURL' = '/reloadroutes'
        'ScriptBlock' = {
        try {
            . $Root\Routes.ps1
            ConvertTo-Html -Body 'Reload is complete.'
            }
        catch {
            $Error[0] | ConvertTo-Html -as List
            }

        }
    }
)
