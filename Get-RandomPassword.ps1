[CmdletBinding()]
param (
    [Parameter()]
    [Int16]
    $NumberOfPasswords = 10,
    [Parameter()]
    [string]
    $OutputPath = ".\Output.txt",
    [switch]
    $OutFile,
    [ValidateNotNullOrEmpty()]
    [Int16]
    $NumberOfWords = 4,
    [char]
    $Separator = "-",
    [switch]
    $AddNumber,
    [switch]
    $Force
)

if ($NumberOfWords -lt 4 -and -not $Force) {
    Write-Error "Number of words can't be below 4. Setting Number to minimum." -Category InvalidData
    $NumberOfWords = 4
}

$NumberOfRuns = 0

do {
    $RandomWords = (Invoke-RestMethod -Uri "http://api.corpora.uni-leipzig.de/ws/words/deu_news_2012_1M/randomword/?limit=$Number").word
    # $RandomWords = (Invoke-RestMethod -Uri http://api.corpora.uni-leipzig.de/ws/words/deu_wikipedia_2010_1M/randomword/?limit=4).word

    # $RawString = $RandomWords[0] + "-" + $RandomWords[1] + "-" + $RandomWords[2] + "-" + $RandomWords[3]
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

$PasswordOutput = $PasswordOutput.TrimEnd("`n")

if ($OutFile) {
    $PasswordOutput | Out-File -FilePath $OutputPath
}
else {
    Write-Host $PasswordOutput
    Read-Host "Enter zum beenden..."
}
