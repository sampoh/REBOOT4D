//%attributes = {}

var $voSTATUS : Object

var $isCompiled; $isBuilt; $DETECTED : Boolean

var $command; $in; $out : Text
var $application; $structure : Text

var $i; $sizeI : Integer
var $TEMP : Text
ARRAY TEXT:C222($atCommandLine; 0)
ARRAY TEXT:C222($atName; 0)
ARRAY LONGINT:C221($alPID; 0)

var $CommandLine : Text
var $PID : Integer

var $loop : Boolean
var $exeName : Text
var $pos : Integer

var $bootCommand : Text
var $appInfo : Object

$structure:=Structure file:C489(*)
$application:=Application file:C491

//"非コンパイル" , "コンパイル済み非ビルド" , "ビルド済み" の3パターンを判別
$isCompiled:=Is compiled mode:C492(*)
$isBuilt:=($structure=$application)

If ($isBuilt)
	$structure:=""
End if 

//検索する実行ファイル名
$exeName:=$application
$loop:=($exeName#"")
While ($loop)
	$pos:=Position:C15("\\"; $exeName)
	If ($pos>0)
		$exeName:=Substring:C12($exeName; $pos+1)
		$loop:=($exeName#"")
	Else 
		$loop:=False:C215
	End if 
End while 

If ($exeName#"")
	
	//$command:="wmic process where \"Name LIKE '"+$exeName+"'\" get ProcessID,Name,ExecutablePath /format:list"
	//↓PowerShell版に修正 ( wmic は Windows 11 22H2 以降で動かないことがある ) - 2025/04/24 Y.Takahara
	$command:="powershell.exe -Command \"Get-CimInstance Win32_Process | Where-Object { $_.Name -like '"+$exeName+"' } | ForEach-Object { \\\"Name=$($_.Name)\\\"; \\\"ProcessId=$($_.ProcessId)\\\"; \\\"ExecutablePath=$($_.ExecutablePath)\\\"; \\\"\\\" }\""
	
	SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
	LAUNCH EXTERNAL PROCESS:C811($command; $in; $out)
	
	PCON_WIN_Analyze($out; ->$atCommandLine; ->$atName; ->$alPID)
	
End if 

$appInfo:=Get application info:C1599  //Windows上のプロセスIDを正確に特定可能となった - 2025/04/26

//$pos:=Find in array($atCommandLine; $application)
$pos:=Find in array:C230($alPID; $appInfo.pid)

$DETECTED:=($pos>0)
If (Not:C34($DETECTED))
	$sizeI:=Size of array:C274($atCommandLine)
	For ($i; 1; $sizeI)
		$TEMP:=$atCommandLine{$i}
		$TEMP:=Replace string:C233($TEMP; "\""; "")
		If ($TEMP=($application+" @"))
			$DETECTED:=True:C214
			$pos:=$i
			$i:=$sizeI+1
		End if 
	End for 
End if 

If ($DETECTED)
	$CommandLine:=$atCommandLine{$pos}
	$exeName:=$atName{$pos}
	$PID:=$alPID{$pos}
	If ($isBuilt)
		//$bootCommand:="START \" \" \""+$application+"\" /B"
		//↓"START" コマンドでは起動できなかったため直接起動に修正
		$bootCommand:="\""+$application+"\""
	Else 
		//$bootCommand:="START \" \" \""+$application+"\" \""+$structure+"\" /B"
		//↓"START" コマンドでは起動できなかったため直接起動に修正
		$bootCommand:="\""+$application+"\" \""+$structure+"\""
	End if 
Else 
	$CommandLine:=""
	$exeName:=""
	$PID:=0
End if 

//アプリケーション特定状況
OB SET:C1220($voSTATUS; \
"detected"; $DETECTED; \
"isCompiled"; $isCompiled; \
"isBuilt"; $isBuilt)

//"wmic" コマンドで取得したもの ( 外部スクリプトでアプリケーションの終了待機に使用 )
OB SET:C1220($voSTATUS; \
"CommandLine"; $CommandLine; \
"Name"; $exeName; \
"ProcessID"; $PID)

//起動コマンド
OB SET:C1220($voSTATUS; "bootCommand"; $bootCommand)

$0:=$voSTATUS

