//%attributes = {}

var $0; $execute : Boolean
var $1; $voSTATUS : Object

var $UUID : Text
var $JSON; $PATHJSON; $OUT : Text
var $vbIN; $vbOUT : Blob

var $charset : Text
var $WSHCRIPT_Caller; $WSHPATH_Caller : Text
var $WSHCRIPT_Relaunch; $WSHPATH_Relaunch : Text

var $JAVASCRIPT_MODE : Boolean

$JAVASCRIPT_MODE:=PCON_WIN_JS_Mode

$voSTATUS:=$1

$charset:="Windows-31J"

$UUID:=String:C10(Current date:C33; Internal date short:K1:7)+String:C10(Current time:C178; HH MM SS:K7:1)
$UUID:=Replace string:C233(Replace string:C233($UUID; "/"; ""); ":"; "")+Uppercase:C13(Generate UUID:C1066)

$PATHJSON:=Temporary folder:C486+$UUID+"_json.txt"

If ($JAVASCRIPT_MODE)
	$WSHPATH_Caller:=Temporary folder:C486+$UUID+"_caller.js"
	$WSHPATH_Relaunch:=Temporary folder:C486+$UUID+"_relaunch.js"
Else 
	//VBScriptモード ( 旧仕様 )
	$WSHPATH_Caller:=Temporary folder:C486+$UUID+"_caller.vbs"
	$WSHPATH_Relaunch:=Temporary folder:C486+$UUID+"_relaunch.vbs"
End if 

$JSON:=JSON Stringify:C1217($voSTATUS)
If (Not:C34($JAVASCRIPT_MODE))
	//VBScriptモード ( 旧仕様 )
	$JSON:=Replace string:C233($JSON; "\""; "<quot>")
End if 

CONVERT FROM TEXT:C1011($JSON; $charset; $vbIN)
BLOB TO DOCUMENT:C526($PATHJSON; $vbIN)

If ($JAVASCRIPT_MODE)
	$WSHCRIPT_Caller:=PCON_WIN_JS_Caller
	$WSHCRIPT_Relaunch:=PCON_WIN_JS_ReLaunch
Else 
	//VBScriptモード ( 旧仕様 )
	$WSHCRIPT_Caller:=PCON_WIN_VBS_Caller
	$WSHCRIPT_Relaunch:=PCON_WIN_VBS_ReLaunch
End if 

TEXT TO DOCUMENT:C1237($WSHPATH_Caller; $WSHCRIPT_Caller; $charset)
TEXT TO DOCUMENT:C1237($WSHPATH_Relaunch; $WSHCRIPT_Relaunch; $charset)

$command:="cscript /nologo \""+$WSHPATH_Caller+"\" \""+$WSHPATH_Relaunch+"\" \""+$PATHJSON+"\""
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
LAUNCH EXTERNAL PROCESS:C811($command; $vbIN; $vbOUT)

$OUT:=Convert to text:C1012($vbOUT; $charset)
$OUT:=Replace string:C233(Replace string:C233($OUT; Char:C90(Carriage return:K15:38); ""); Char:C90(Line feed:K15:40); "")

$execute:=(Lowercase:C14($OUT)="success")

If (Not:C34($execute))
	DELETE DOCUMENT:C159($PATHJSON)
	DELETE DOCUMENT:C159($WSHPATH_Caller)
	DELETE DOCUMENT:C159($WSHPATH_Relaunch)
End if 

$0:=$execute

QUIT 4D:C291
