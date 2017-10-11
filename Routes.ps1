$Routes = @(
    @{
        'RequestType' = 'GET'
        'RequestURL' = '/index'
        'ServePage' = '/index.html'
    }

    @{
        'RequestType' = 'GET'
        'RequestURL' = ''
        'ServePage' = '/index.html'
    }

    @{
        'RequestType' = 'GET'
        'RequestURL' = '/'
        'ServePage' = '/index.html'
    }

    # Example of a route that contains a custom scriptblock
    @{
        'RequestType' = 'GET'
        'RequestURL' = '/process'
        'ScriptBlock' = {
            Get-Process
        }
    }
)