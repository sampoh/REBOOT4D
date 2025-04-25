//%attributes = {}

var $0; $comments : Text

var $CRLF : Text

//当メソッドのコメント取得
METHOD GET COMMENTS:C1189(Current method path:C1201; $comments)

//マルチスタイル除去
$comments:=ST Get plain text:C1092($comments)

//メソッドコメントの改行コードはCR → VBScriptの改行コードはCRLF
$CRLF:=Char:C90(Carriage return:K15:38)+Char:C90(Line feed:K15:40)
$comments:=Replace string:C233($comments; Char:C90(Carriage return:K15:38); $CRLF)

$0:=$comments
