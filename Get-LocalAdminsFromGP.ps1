#Retrieve All GPOs
$GetGpos = Get-GPO -All
#Loop all GPOs and create objects from specific attributes
$GpoLocalAdmins = foreach ($g in $GetGpos) {
    [xml]$Gpo = Get-GPOReport -ReportType Xml -Guid $g.Id
    [PSCustomObject]@{
        "Name" = $Gpo.GPO.Name
        "Comp-Prefs" = $Gpo.GPO.Computer.ExtensionData.Extension.LocalUsersAndGroups.Group.Properties.Members.member.name
        "Comp-Restricted" = $Gpo.GPO.Computer.ExtensionData.Extension.restrictedgroups.member.name."#text"
        "Comp-UserRights" = $Gpo.GPO.Computer.ExtensionData.Extension.UserRightsAssignment.Member.Name."#text"
        "User-Prefs" = $Gpo.GPO.User.ExtensionData.Extension.LocalUsersAndGroups.Group.Properties.Members.Member.name
    }
}
#Output info
$GpoLocalAdmins | Sort-Object Name | Format-Table -AutoSize -Wrap
