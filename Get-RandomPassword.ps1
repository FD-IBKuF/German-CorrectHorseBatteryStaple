[CmdletBinding()]
param (
    [Int16]
    $NumberOfPasswords = 10,
    [string]
    [ValidateNotNullOrEmpty()]
    $OutputDirectory = ".\",
    [string]
    [ValidateNotNullOrEmpty()]
    $OutputFilename = "Passwörter Output.txt",
    [ValidateNotNullOrEmpty()]
    [Int16]
    $NumberOfWords = 4,
    [char]
    $Separator = "-",
    [switch]
    $AddNumber,
    [switch]
    $Force,
    [switch]
    $UseWikipedia,
    [switch]
    $ReturnList
)

if (-not (Test-Path $OutputDirectory -PathType Container)) {
    $OutputDirectory = ".\"
}

$OutputPath = $OutputDirectory + $OutputFilename

if ($NumberOfWords -lt 4 -and -not $Force) {
    Write-Error "Number of words can't be below 4. Setting Number to minimum." -Category InvalidData
    $NumberOfWords = 4
}

$NumberOfRuns = 0

do {
    try {
        if ($UseWikipedia) {
            $RandomWords = (Invoke-RestMethod -Uri "http://api.corpora.uni-leipzig.de/ws/words/deu_wikipedia_2010_1M/randomword/?limit=$NumberOfWords").word
        }
        else {
            $RandomWords = (Invoke-RestMethod -Uri "http://api.corpora.uni-leipzig.de/ws/words/deu_news_2012_1M/randomword/?limit=$NumberOfWords").word
        }
    }
    catch {
        Throw $_
    }

    $RawString = ""
    foreach ($Word in $RandomWords) {
        $RawString += "$Word$Separator"
    }

    if ($AddNumber -and -not ($RawString -match "[0-9]")) {
        $RawString += Get-Random -Minimum 0 -Maximum 9
    }

    $FilteredString = $RawString.TrimEnd("$Separator") -replace " ", "_" -replace "\.", ""
    $FilteredString += "`n"
    $PasswordOutput += $FilteredString
    $NumberOfRuns++
} while ($NumberOfRuns -lt $NumberOfPasswords)

if ($ReturnList) {
    return $PasswordOutput
}
else {
    $PasswordOutput | Out-File -FilePath $OutputPath
    Write-Verbose $PasswordOutput
}
