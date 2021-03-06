function Invoke-Pretranslation
{
    [CmdletBinding(DefaultParameterSetName = 'AccountKey')]
    param (
        [Parameter(Mandatory)]
        [string]$ProjectId,

        [Parameter(Mandatory, ParameterSetName = 'ProjectKey')]
        [Alias('key')]
        [string]$ProjectKey,

        [Parameter(Mandatory, ParameterSetName = 'AccountKey')]
        [Alias('login')]
        [string]$LoginName,

        [Parameter(Mandatory, ParameterSetName = 'AccountKey')]
        [Alias('account-key')]
        [string]$AccountKey,

        [Parameter(Mandatory)]
        [Alias('languages')]
        [string[]]$Language,

        [Parameter(Mandatory)]
        [Alias('files')]
        [string[]]$File,

        [Parameter()]
        [ValidateSet('tm', 'mt')]
        [string]$Method,

        [Parameter()]
        [string]$Engine,

        [Parameter()]
        [Alias('approve_translated')]
        [switch]$ApproveTranslated,

        [Parameter()]
        [ValidateRange(0, 2)]
        [Alias('auto_approve_option')]
        [int]$AutoApproveOption,

        [Parameter()]
        [Alias('import_duplicates')]
        [switch]$ImportDuplicates,

        [Parameter()]
        [Alias('apply_untranslated_strings_only')]
        [switch]$UntranslatedStringsOnly,

        [Parameter()]
        [Alias('perfect_match')]
        [switch]$PerfectMatch
    )

    $ProjectId = [Uri]::EscapeDataString($ProjectId)
    $body = $PSCmdlet | ConvertFrom-PSCmdlet -ExcludeParameter ProjectId
    Invoke-ApiRequest -Url "project/$ProjectId/pre-translate?json" -Body $body
}