//%attributes = {}

var $0; $execute : Boolean
var $1; $voSTATUS : Object

var $UUID : Text
var $JSON : Text
var $IN; $OUT; $ERROR : Text

var $RESULT : Text
ARRAY LONGINT:C221($alPosFound; 0)
ARRAY LONGINT:C221($alLenFound; 0)

var $charset : Text
var $PATHJSON_4D; $PATHJSON : Text
var $VBSCRIPT_Caller; $VBSPATH_Caller_4D; $VBSPATH_Caller : Text
var $VBSCRIPT_Relaunch; $VBSPATH_Relaunch_4D; $VBSPATH_Relaunch : Text

$voSTATUS:=$1

$charset:="UTF-8"

$UUID:=String:C10(Current date:C33; Internal date short:K1:7)+String:C10(Current time:C178; HH MM SS:K7:1)
$UUID:=Replace string:C233(Replace string:C233($UUID; "/"; ""); ":"; "")+Uppercase:C13(Generate UUID:C1066)

$PATHJSON_4D:=Temporary folder:C486+$UUID+".json"
$VBSPATH_Caller_4D:=Temporary folder:C486+$UUID+"_caller.js"
$VBSPATH_Relaunch_4D:=Temporary folder:C486+$UUID+"_relaunch.js"

$PATHJSON:=Convert path system to POSIX:C1106($PATHJSON_4D)
$VBSPATH_Caller:=Convert path system to POSIX:C1106($VBSPATH_Caller_4D)
$VBSPATH_Relaunch:=Convert path system to POSIX:C1106($VBSPATH_Relaunch_4D)

$JSON:=JSON Stringify:C1217($voSTATUS)
TEXT TO DOCUMENT:C1237($PATHJSON_4D; $JSON; $charset)

$VBSCRIPT_Caller:=PCON_OSX_JS_Caller
$VBSCRIPT_Relaunch:=PCON_OSX_JS_ReLaunch
TEXT TO DOCUMENT:C1237($VBSPATH_Caller_4D; $VBSCRIPT_Caller; $charset)
TEXT TO DOCUMENT:C1237($VBSPATH_Relaunch_4D; $VBSCRIPT_Relaunch; $charset)

$command:="osascript -l JavaScript \""+$VBSPATH_Caller+"\" \""+$VBSPATH_Relaunch+"\" \""+$PATHJSON+"\""
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
LAUNCH EXTERNAL PROCESS:C811($command; $IN; $OUT; $ERROR)

//"osascript" はコマンドライン実行時に必ずワーニングを出すので対策。
If ($ERROR#"")
	$OUT:=$ERROR
End if 

//"console.log" 出力時の最後の改行を除去
While (($OUT=("@"+Char:C90(Carriage return:K15:38))) | ($OUT=("@"+Char:C90(Line feed:K15:40))))
	$OUT:=Substring:C12($OUT; 1; Length:C16($OUT)-1)
End while 

$RESULT:=""
If (Match regex:C1019("(success|failed)$"; Lowercase:C14($OUT); 1; $alPosFound; $alLenFound))
	$RESULT:=Substring:C12(Lowercase:C14($OUT); $alPosFound{1}; $alLenFound{1})
Else 
	$RESULT:="failed"
End if 

$execute:=(Lowercase:C14($RESULT)="success")

If (Not:C34($execute))
	DELETE DOCUMENT:C159($PATHJSON)
	DELETE DOCUMENT:C159($VBSPATH_Caller)
	DELETE DOCUMENT:C159($VBSPATH_Relaunch)
End if 

$0:=$execute

QUIT 4D:C291

