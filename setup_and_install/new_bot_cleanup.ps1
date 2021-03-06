# Retrieving User Information
$GITHUBUSER = Read-Host -Prompt "What is your GitHub Username?"
Write-Output ""
Write-Output "** If you have 2 Factor Auth configured, "
Write-Output "   provide a Personal Access Token with repo and delete_repo access."
Write-Output "   Tokens can be generated at https://github.com/settings/tokens **"
$SECUREPASS = Read-Host -Prompt "What is your GitHub Password?" -AsSecureString
$GITHUBPASS = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($SECUREPASS))
Write-Output ""
$GITHUBREPO = Read-Host -Prompt "What is the name of your bot? The name of your GitHub Repo and Local Code Directory that will be deleted"
Write-Output ""

# Confirm Deletion
Write-Output "Are you sure you want to delete your GitHub Repo $GITHUBUSER/$GITHUBREPO?"
$ANSWER = Read-Host -Prompt "Type 'yes' to delete"
if ($ANSWER -ne "yes"){
	Write-Output "Exiting without deleting anything"
	exit
}

# Cleanup Process
Write-Output "Beginning the cleanup process"
Write-Output ""


# Setup GitHub Credentials
$PAIR = "${GITHUBUSER}:${GITHUBPASS}"
$BYTES = [System.Text.Encoding]::ASCII.GetBytes($PAIR)
$BASE64 = [System.Convert]::ToBase64String($BYTES)
$BASICAUTH = "Basic $BASE64"
$HEADERS = @{ Authorization = $BASICAUTH }

# Delete GitHub Repo
Write-Output "Deleting the Repo on GitHub"
Invoke-RestMethod -Method Delete -Uri "https://api.github.com/repos/$GITHUBUSER/$GITHUBREPO" -Headers $HEADERS

# Deleting Local Copy
Write-Output "Deleting the local copy"
Remove-Item -Force -Recurse ../../$GITHUBREPO

Write-Output " "
Write-Output " "
Write-Output "The GitHub repo https://github.com/$GITHUBUSER/$GITHUBREPO has been deleted."
Write-Output "The local instance has also been deleted."
Write-Output " "