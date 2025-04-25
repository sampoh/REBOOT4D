//%attributes = {}
//Power Shell 対応版

var $1; $STR; $CRLF : Text
var $2; $3; $4 : Pointer

ARRAY TEXT:C222($atCommandLine; 0)
ARRAY TEXT:C222($atName; 0)
ARRAY LONGINT:C221($alPID; 0)

var $one : Text
var $SPLIT : Collection

ARRAY LONGINT:C221($alPosFound; 0)
ARRAY LONGINT:C221($alLenFound; 0)

var $command; $name; $PID_STR : Text
var $PID : Integer

$STD:=$1

$CRLF:=Char:C90(Carriage return:K15:38)+Char:C90(Line feed:K15:40)+Char:C90(Carriage return:K15:38)+Char:C90(Line feed:K15:40)

$SPLIT:=Split string:C1554($STD; $CRLF)

For each ($one; $SPLIT)
	
	$command:=""
	$name:=""
	$PID_STR:=""
	
	If (Match regex:C1019("ExecutablePath=(.*?)$"; $one; 1; $alPosFound; $alLenFound))
		$command:=Substring:C12($one; $alPosFound{1}; $alLenFound{1})
	End if 
	
	If (Match regex:C1019("Name=(.*?)([\r\n]+)"; $one; 1; $alPosFound; $alLenFound))
		$name:=Substring:C12($one; $alPosFound{1}; $alLenFound{1})
	End if 
	
	If (Match regex:C1019("ProcessId=([0-9]+)"; $one; 1; $alPosFound; $alLenFound))
		$PID_STR:=Substring:C12($one; $alPosFound{1}; $alLenFound{1})
		$PID:=Num:C11($PID_STR)
	End if 
	
	While ($command="@ ")
		$command:=Substring:C12($command; 1; Length:C16($command)-1)
	End while 
	
	If ($command="\"@\"")
		$command:=Substring:C12($command; 2; Length:C16($command)-2)
	End if 
	
	If (($command#"") & ($name#"") & ($PID_STR#""))
		APPEND TO ARRAY:C911($atCommandLine; $command)
		APPEND TO ARRAY:C911($atName; $name)
		APPEND TO ARRAY:C911($alPID; $PID)
	End if 
	
End for each 

COPY ARRAY:C226($atCommandLine; $2->)
COPY ARRAY:C226($atName; $3->)
COPY ARRAY:C226($alPID; $4->)

