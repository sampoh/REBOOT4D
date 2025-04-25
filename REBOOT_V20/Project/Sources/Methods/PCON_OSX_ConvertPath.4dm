//%attributes = {}

var $1 : Pointer
ARRAY TEXT:C222($atPATH; 0)

var $execute : Boolean
var $i; $sizeI : Integer

$execute:=(Count parameters:C259>=1)

If ($execute)
	$execute:=Not:C34(Is nil pointer:C315($1))
End if 

If ($execute)
	$execute:=((Type:C295($1->)=Text array:K8:16) | (Type:C295($1->)=String array:K8:15))
End if 

If ($execute)
	
	COPY ARRAY:C226($1->; $atPATH)
	
	$sizeI:=Size of array:C274($atPATH)
	For ($i; 1; $sizeI)
		$atPATH{$i}:=Convert path system to POSIX:C1106($atPATH{$i})
	End for 
	
	COPY ARRAY:C226($atPATH; $1->)
	
End if 
