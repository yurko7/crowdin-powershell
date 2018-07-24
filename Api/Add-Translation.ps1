function Add-Translation
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Alias('identifier')]
        [string]$ProjectId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Alias('key')]
        [string]$ProjectKey,

        [Parameter(Mandatory)]
        [string]$FileName,

        [Parameter(Mandatory)]
        [System.IO.FileInfo]$File,

        [Parameter(Mandatory)]
        [string]$Language,

        [Parameter()]
        [Alias('import_duplicates')]
        [switch]$ImportDuplicates,

        [Parameter()]
        [Alias('import_eq_suggestions')]
        [switch]$ImportEqualSuggestions,

        [Parameter()]
        [Alias('auto_approve_imported ')]
        [switch]$AutoApproveImported,

        [Parameter()]
        [string]$Format,

        [Parameter()]
        [string]$Branch
    )

    $ProjectId = [Uri]::EscapeDataString($ProjectId)
    $body = [pscustomobject]@{
        'key' = $ProjectKey
        "files[$FileName]" = $File
    }
    $body = $PSCmdlet | ConvertFrom-PSCmdlet -TargetObject $body -ExcludeParameter ProjectId,ProjectKey,FileName,File
    Invoke-ApiRequest -Url "project/$ProjectId/upload-translation?json" -Body $body
}