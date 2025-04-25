//%attributes = {}

var $1; $STD : Text
var $2 : Pointer
ARRAY TEXT:C222($atCommandLine; 0)
var $3 : Pointer
ARRAY LONGINT:C221($alPID; 0)

var $loop : Boolean
var $pos : Integer
var $line : Text
ARRAY TEXT:C222($atLine; 0)

var $i; $sizeI : Integer
var $pattern : Text

ARRAY LONGINT:C221($alPosFound; 0)
ARRAY LONGINT:C221($alLenFound; 0)

$STD:=$1

$STD:=Replace string:C233($STD; Char:C90(Carriage return:K15:38)+Char:C90(Line feed:K15:40); Char:C90(Carriage return:K15:38))
$STD:=Replace string:C233($STD; Char:C90(Line feed:K15:40); Char:C90(Carriage return:K15:38))

$loop:=True:C214
While ($loop)
	$pos:=Position:C15(Char:C90(Carriage return:K15:38); $STD)
	$loop:=($pos>0)
	If ($loop)
		$line:=Substring:C12($STD; 1; $pos-1)
		$STD:=Substring:C12($STD; $pos+1)
	Else 
		$line:=$STD
	End if 
	If ($line#"")
		While ($line=" @")
			$line:=Substring:C12($line; 2)
		End while 
		While ($line="@ ")
			$line:=Substring:C12($line; 1; Length:C16($line)-1)
		End while 
		APPEND TO ARRAY:C911($atLine; $line)
	End if 
End while 

$pattern:="^([0-9]+) (.*?)$"
$sizeI:=Size of array:C274($atLine)
For ($i; 1; $sizeI)
	$line:=$atLine{$i}
	If (Match regex:C1019($pattern; $line; 1; $alPosFound; $alLenFound))
		APPEND TO ARRAY:C911($alPID; Num:C11(Substring:C12($line; $alPosFound{1}; $alLenFound{1})))
		APPEND TO ARRAY:C911($atCommandLine; Substring:C12($line; $alPosFound{2}; $alLenFound{2}))
	End if 
End for 

COPY ARRAY:C226($atCommandLine; $2->)
COPY ARRAY:C226($alPID; $3->)
