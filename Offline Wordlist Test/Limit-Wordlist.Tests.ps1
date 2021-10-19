BeforeAll { 
    # . $PSScriptRoot\Limit-Wordlist.ps1
    function Test-String ($String) {
        # Regex Explanations:
        # - the "^" and "$" force the regex to check if the *entire* string matches (https://stackoverflow.com/a/51408221)
        # - "[A-Za-z]" checks for only ASCI characters
        # - "{5,12}" ensures a proper length between 5 and 12 chars
        $regex = '^([A-Za-z]{5,12})$'
        return $String -match $regex
    }
}

Describe "Regex Filter Test" {
    $TestData = @(
        @{ Word = "der";        Expected = $false }
        @{ Word = "sich";       Expected = $false }
        @{ Word = "nicht";      Expected = $true }
        @{ Word = "werden";     Expected = $true }
        @{ Word = "Grund";      Expected = $true}
        @{ Word = "scheint";    Expected = $true}
        @{ Word = "Zukunft";    Expected = $true}
        @{ Word = "Juni";       Expected = $false}
        @{ Word = "daß";        Expected = $false }
        @{ Word = "können";     Expected = $false}
        @{ Word = "Jahren";     Expected = $true}
        @{ Word = "Millionen";  Expected = $true}
        @{ Word = "vor allem";  Expected = $false}
        @{ Word = "ob";         Expected = $false}
        @{ Word = "nicht nur";  Expected = $false}
        @{ Word = "hätten";     Expected = $false}
        @{ Word = "großen";     Expected = $false}
        @{ Word = "dass=daß";   Expected = $false}
        @{ Word = "Informationen";  Expected = $false}
        @{ Word = "Bundesregieru";  Expected = $false}
        @{ Word = "europäischen";   Expected = $false}
        @{ Word = "politischene";   Expected = $true}
    )

    It "Returns <Expected> (<Word>)" -TestCases $TestData {
        Test-String -String $Word | Should -Be $Expected
    }
}