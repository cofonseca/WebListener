# WebListener
WebListener is a small, PowerShell-based web server. It was primarily designed for really basic, lightweight use, and for testing simple web apps. One advantage to this is that it's really easy to create a frontend that will allow you to run PowerShell code on the backend, such as a page to display server statistics, or a portal to deploy virtual machines.

## Getting Started
To get started, simply import the module, then run New-WebListener.

```
New-WebListener
```

Your web server is now live at *http://localhost:8080* !

Your web pages and supporting folder structure should live in the '*views*' directory.

## Routing

WebListener has a simple routing mechanism that will help you to control how requests are handled.

To add a route, open up '*Routes.ps1*', and add a new hashtable to the array. Your hashtable should look like this:

```
@{
    'RequestType' = 'GET'
    'RequestURL' = '/'
    'RedirectURL' = '/index.html'
    'ScriptBlock = {}
}
```

***RequestType*** is mandatory. This key should contain one of the following four values: GET, PUT, POST, DELETE.

***RequestURL*** is the URL that the router will respond to. For example, to create a route for /index, enter '/index'.

***RedirectURL*** is the full path to the file that will be served when a request for the RequestURL is made. If the filepath is the same as the RequestURL, this can be left blank or excluded.

***ScriptBlock*** allows you to run PowerShell code when a URL is requested. If you don't want to run anything, leave this blank, or exclude it.

In the above example, when a call is made to *http://localhost:8080/*, the user will be redirected to '*index.html*'. 