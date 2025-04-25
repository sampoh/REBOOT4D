//%attributes = {}

var $0; $voSTATUS : Object

var $isCompiled; $isBuilt; $DETECTED : Boolean

var $command; $in; $out : Text
var $application_4D; $structure_4D : Text
var $application; $structure : Text
var $vbOut : Blob

var $i; $sizeI; $pos : Integer
ARRAY LONGINT:C221($alPID; 0)
ARRAY TEXT:C222($atCommandLine; 0)

var $TEMP : Text
var $CommandLine : Text
var $PID : Integer

var $bootCommand : Text

$structure_4D:=Structure file:C489(*)
$application_4D:=Application file:C491
$structure:=Convert path system to POSIX:C1106($structure_4D)
$application:=Convert path system to POSIX:C1106($application_4D)

//"非コンパイル" , "コンパイル済み非ビルド" , "ビルド済み" の3パターンを判別
$isCompiled:=Is compiled mode:C492(*)
//$isBuilt:=($structure=$application)
//↓V17用対策
$isBuilt:=PCON_OSX_IsBuilt($isCompiled; $structure; $application)

If ($isBuilt)
	$structure_4D:=""
	$structure:=""
End if 

//$command:="ps axo pid,command"
//↓文字コード指定 - 2019/10/30 Y.Takahara
$command:="bash -c \"export LANG=ja_JP.UTF-8;ps axo pid,command\""
SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
LAUNCH EXTERNAL PROCESS:C811($command; $in; $vbOut)
$out:=Convert to text:C1012($vbOut; "UTF-8")

PCON_OSX_Analyze($out; ->$atCommandLine; ->$alPID)

$pos:=Find in array:C230($atCommandLine; $application)
$DETECTED:=($pos>0)
If ((Not:C34($DETECTED)) & ($application="@.app"))
	$sizeI:=Size of array:C274($atCommandLine)
	For ($i; 1; $sizeI)
		$TEMP:=$atCommandLine{$i}
		If ($TEMP=($application+"/@"))
			$DETECTED:=True:C214
			$pos:=$i
			$i:=$sizeI+1
		End if 
	End for 
End if 

If ($DETECTED)
	$CommandLine:=$atCommandLine{$pos}
	$PID:=$alPID{$pos}
	If ($isBuilt)
		$bootCommand:="open \""+$application+"\""
	Else 
		$bootCommand:="open \""+$application+"\" \""+$structure+"\""
	End if 
Else 
	$CommandLine:=""
	$PID:=0
End if 

//アプリケーション特定情報
OB SET:C1220($voSTATUS; \
"detected"; $DETECTED; \
"isCompiled"; $isCompiled; \
"isBuilt"; $isBuilt; \
"application"; $application)

//"ps" コマンドと連携して特定した情報
OB SET:C1220($voSTATUS; \
"CommandLine"; $CommandLine; \
"ProcessID"; $PID)

//起動コマンド
OB SET:C1220($voSTATUS; "bootCommand"; $bootCommand)

$0:=$voSTATUS
