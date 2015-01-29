## Domain configuration
$UPNDomain = "@example.edu"
$OUPath = "OU=Students,OU=Domain Users,DC=example,DC=edu"

param(
    [Parameter(Mandatory = $true)]
    $Path
)

Set-StrictMode -Off

## Load the CSV
$users = @(Import-Csv $Path)
if($users.Count -eq 0)
{
    Write "Empty CSV"
	return
}

## Go through each user from the CSV
foreach($user in $users)
{
    ## Pull out the name, and create that user
    $username = $user.Username
    $password = $user.Password
    $grade = $user.Grade
    $firstName = $user.FirstName
    $lastName = $user.LastName
    $ID = $user.ID
    $grade = $user.Grade
    $classroom = $user.Classroom

    if ($username -eq "" -or $password -eq "") {
        Write "Skipping $firstName $lastName"
        Write ""
        continue
    }

    $potentialUser = Get-ADUser -LDAPFilter "(sAMAccountName=$username)"

    if ($potentialUser -eq $Null) {
        # User Does Not Exist
        $securePassword = ConvertTo-SecureString -String $password -AsPlainText �Force

        Write "Putting $firstName $lastName"

        $newUser = New-ADUser `
            -Name "$firstName $lastName" `
            -SamAccountName "$username" `
            -UserPrincipalName "$username$UPNDomain" `
            -GivenName "$firstName" `
            -Surname "$lastName" `
            -DisplayName "$firstName $lastName" `
            -Title "$grade" `
            -Department "$classroom" `
            -Path $OUPath `
            -AccountPassword $securePassword

        Write "---- Adding to Students group"
        Add-ADGroupMember -Members "$username" -Identity Students

        Write "---- Enabling account"
        Enable-ADAccount -Identity "$username"
    } else {
	    $potentialUser.givenName = $firstName
	    $potentialUser.sn = $lastName
	    $potentialUser.title = $grade
	    $potentialUser.department = $classroom


	    Write "Updating $firstName $lastName"

        ## Finalize the information in Active Directory
        Set-ADUser -instance $potentialUser
    }
    Write " "
}
