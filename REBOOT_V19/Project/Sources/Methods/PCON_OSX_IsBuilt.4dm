//%attributes = {}

var $0; $isBuildApp : Boolean

var $1; $isCompiled : Boolean
var $2; $structure : Text
var $3; $application : Text

var $TEMP : Text

$isCompiled:=$1
$structure:=$2
$application:=$3

If ($isCompiled)
	If ($structure=$application)
		//おそらくV16まではこちらで動作
		$isBuildApp:=True:C214
	Else 
		//V17でうまく動作しなかったため対策
		If ($structure=($application+"/@"))
			//"$application" の下層の "Contents/MacOS" 内に "$structure" があればビルドと判定
			$TEMP:=Substring:C12($structure; Length:C16($application)+1)
			$isBuildApp:=Match regex:C1019("^/Contents/MacOS/.*?$"; $TEMP; 1)
		End if 
	End if 
Else 
	$isBuildApp:=False:C215
End if 

$0:=$isBuildApp
