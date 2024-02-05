# Install the AzureAD module if not already installed
# Install-Module -Name AzureAD

# Connect to Azure AD
Connect-AzureAD

# Get all users and filter for MFA status
$users = Get-AzureADUser -All $true | Where-Object { $_.StrongAuthenticationRequirements -ne $null }

# Prepare data for export
$dataForExport = foreach ($user in $users) {
    $user | Select-Object -Property UserPrincipalName, DisplayName, @{Name="MFAStatus";Expression={if($_.StrongAuthenticationRequirements.State -ne $null){"Enabled"}else{"Disabled"}}}
}

# Export data to CSV
$dataForExport | Export-Csv -Path "c:\temp\AzureAD_MFA_Users.csv" -NoTypeInformation

# Output file location
Write-Host "Data exported to AzureAD_MFA_Users.csv"

# Disconnect from Azure AD
Disconnect-AzureAD
