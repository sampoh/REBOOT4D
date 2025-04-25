//%attributes = {}

var $0; $comments : Text

var $CRLF : Text

//当メソッドのコメント取得
METHOD GET COMMENTS:C1189(Current method path:C1201; $comments)

//マルチスタイル除去
$comments:=ST Get plain text:C1092($comments)

//メソッドコメントの改行コードはCR → シェルスクリプトの改行コードはCR
//※ なのでそのまま

//$CRLF:=Char(Carriage return)+Char(Line feed)
//$comments:=Replace string($comments;Char(Carriage return);$CRLF)

$0:=$comments
