$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Format-RequestBody" {
    Context "Properly expands object members" {
        $data = [PSCustomObject]@{
            StringParam = 'some string'
            IntParam = 7
            SwitchParam = [System.Management.Automation.SwitchParameter]$true
            BoolParam = $true
            DateTimeParam = Get-Date -Year 1987 -Month 6 -Day 19 -Hour 21 -Minute 36 -Second 0
            ArrayParam = 'a','b',@{c = @($false)},'d',@('e')
            HashtableParam = [ordered]@{A = 'a1'; B = 'b2'; C = 'c3'; D = @([ordered]@{E = 'ee'; F = 'ff'}, @(17, [ordered]@{X = 'xx'; Y = 'yy'; Z = (3)}))}
        }

        $requestBody = Format-RequestBody -InputObject $data
        $dump = $requestBody | Out-String -Stream | Where-Object { -not [String]::IsNullOrEmpty($_) }
        $expected = @(
            'stringparam                : some string'
            'intparam                   : 7'
            'switchparam                : 1'
            'boolparam                  : 1'
            'datetimeparam              : 1987-06-19T21:36:00'
            'arrayparam[0]              : a'
            'arrayparam[1]              : b'
            'arrayparam[2][c][0]        : 0'
            'arrayparam[3]              : d'
            'arrayparam[4][0]           : e'
            'hashtableparam[A]          : a1'
            'hashtableparam[B]          : b2'
            'hashtableparam[C]          : c3'
            'hashtableparam[D][0][E]    : ee'
            'hashtableparam[D][0][F]    : ff'
            'hashtableparam[D][1][0]    : 17'
            'hashtableparam[D][1][1][X] : xx'
            'hashtableparam[D][1][1][Y] : yy'
            'hashtableparam[D][1][1][Z] : 3')
        for ($i = 0; $i -lt $dump.Length; $i++)
        {
            It "$($expected[$i])" {
                $dump[$i] | Should -BeExactly $expected[$i]
            }
        }
    }
}