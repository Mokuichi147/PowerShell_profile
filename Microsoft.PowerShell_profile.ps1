$MyVenvFolder = Join-Path $HOME '.virtualenvs'
$DefaultPyVersion = '3.10'

if (-Not(Test-Path -Path $MyVenvFolder -PathType Container)) {
    New-Item -Path $MyVenvFolder -ItemType directory | Out-Null
    echo ('created venvs folder: ' + $MyVenvFolder)
}


<#
.SYNOPSIS
    Prepare a python virtual environment in the current folder
#>
function set-venv {
    param (
        [string] $VenvName,
        [string] $PyVersion = $DefaultPyVersion
    )

    $VenvFolder = Join-Path $MyVenvFolder $VenvName

    if (-Not(Test-Path -Path $VenvFolder -PathType Container)) {
        echo 'Generating...'
        py -$PyVersion -m 'venv' $VenvFolder
        $ActivateFile = Join-Path $MyVenvFolder $VenvName 'Scripts' 'Activate.ps1'
        $Content = Get-Content -Encoding utf8 $ActivateFile
        $Content = $Content.Replace('deactivate', 'quit')
        Set-Content -Path $ActivateFile -Value $Content -Encoding utf8
    }

    if (Test-Path -Path .venv -PathType Leaf) {
        Set-Content -Path .venv -Value $VenvName -Encoding utf8
        echo ('Changed: ' + $VenvName)
    } else {
        New-Item -Path .venv -ItemType file | Out-Null
        Set-Content -Path .venv -Value $VenvName -Encoding utf8
        echo ('Created: ' + $VenvName)
    }
}


function get-venv {
    return Get-Content -Encoding utf8 .venv
}


function venv {
    if (Test-Path -Path .venv -PathType Leaf) {
        $VenvName = get-venv
        $ActivateFile = Join-Path $MyVenvFolder $VenvName 'Scripts' 'Activate.ps1'
        Invoke-Expression $ActivateFile
    } else {
        echo 'Please execute the following command `"set-venv <venv-name>`"'
    }
}