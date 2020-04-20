param([String]$command)

if ($command -eq 'start') {
    $app = Start-Process ./nginx.exe -PassThru
    Wait-Process $app.Id
} 
if ($command -eq 'reload') {
    Start-Process ./nginx -ArgumentList '-s reload'
}