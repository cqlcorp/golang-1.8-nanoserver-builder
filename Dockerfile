FROM golang:1.8-nanoserver

MAINTAINER Chad Gilbert <chad.gilbert@cqlcorp.com>

ENV GIT_VERSION=2.14.1 \
    GIT_SHA256=65c12e4959b8874187b68ec37e532fe7fc526e10f6f0f29e699fa1d2449e7d92

RUN $ErrorActionPreference = 'Stop'; \
    $ProgressPreference = 'SilentlyContinue' ;\
    Invoke-WebRequest -UseBasicParsing $('https://github.com/git-for-windows/git/releases/download/v' + $Env:GIT_VERSION + '.windows.1/MinGit-' + $Env:GIT_VERSION + '-64-bit.zip') -OutFile git.zip; \
    if ((Get-FileHash git.zip -Algorithm sha256).Hash -ne $env:GIT_SHA256) {exit 1} ; \
    Expand-Archive git.zip -DestinationPath C:\git; \
    Remove-Item git.zip; \
    Write-Host 'Updating PATH ...'; \
    $env:PATH = 'C:\\git\\cmd;C:\\git\\mingw64\\bin;C:\\git\\usr\\bin;' + $env:PATH; \
    Set-ItemProperty -Path 'HKLM:\\SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Environment\\' -Name Path -Value $env:PATH

WORKDIR $GOPATH
