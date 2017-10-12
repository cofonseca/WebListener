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
    @{
        'RequestType' = 'GET'
        'RequestURL' = '/getservice'
        'ScriptBlock' = {
            Get-Service
        }
    }
    @{
        'RequestType' = 'GET'
        'RequestURL' = '/getprocess'
        'ScriptBlock' = {
            Get-Process
        }
    }
)