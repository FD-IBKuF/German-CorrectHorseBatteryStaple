[CmdletBinding()]
param (
    [string]
    $OriginalListPath,
    [Int16]
    $MinimumWordLength = 5,
    [Int16]
    $MaximumWordLength = 14,
    [switch]
    $CutoffLongWords
)

begin {
    Function Get-File($initialDirectory, $description) {
        # See https://stackoverflow.com/a/25690250
        [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

        $foldername = New-Object System.Windows.Forms.OpenFileDialog
        # $foldername.SelectedPath = $initialDirectory

        if ($foldername.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true })) -eq "OK") {
            return $foldername.SelectedPath
        }
        else {
            exit
        }
    }

    function Test-String ($String) {
        $regex = '^([A-Za-z]{5,12})$'
        return $String -match $regex
    }
}

process {
    if (!(Test-Path $OriginalListPath -PathType Leaf)) {
        $OriginalListPath = Get-File -initialDirectory $HOME -description "Bitte Wortliste auswählen"
    }

    #FIXME: Die Regex macht aktuell noch ganz wilde Sachen...!
    # Base RegEx String: ([A-z]{4,5})\w+        ({4,5} sets the min and max length)
    # $regex = '([A-z]{' + [regex]::escape($MinimumWordLength) + ',' + [regex]::escape($MaximumWordLength) + '})\w+'
    # $regex = '[A-z]{5,14}'
    $WordList = Get-Content -Path $OriginalListPath | ForEach-Object {
        if (Test-String $_) {
            $_
        } 
    }
    $WordList[0]
}
