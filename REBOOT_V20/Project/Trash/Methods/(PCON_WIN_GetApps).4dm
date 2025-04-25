//%attributes = {"invisible":true}

C_TEXT:C284($command)
C_TEXT:C284($in; $out; $err)
C_BLOB:C604($vbOut)

//$command:="PowerShell.exe -Command Get-StartApps"
$command:="PowerShell Get-AppxPackage -Name *4D*"
//$command:="PowerShell /?"
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
LAUNCH EXTERNAL PROCESS:C811($command; $in; $vbOut; $err)

$out:=Convert to text:C1012($vbOut; "Windows-31J")

TRACE:C157
