//%attributes = {"shared":true}
//< アプリケーション再起動 >

//第1引数 ( 任意 ) : 削除ファイルのフルパステキスト配列へのポインタ 【 ポインタ型 】
//第2引数 ( 任意 ) : 移動元ファイルのフルパステキスト配列へのポインタ 【 ポインタ型 】
//第3引数 ( 任意 ) : 移動先ファイルのフルパステキスト配列へのポインタ 【 ポインタ型 】

//※1 【 第2引数と第3引数を設定するが、第1引数は未設定としたい 】 といった場合はNULLポインタか要素ゼロの配列へのポインタを渡せば良い
//※2 第2引数と第3引数の配列要素数は同じでないと無効
//※3 移動元ファイルが存在しない場合、移動先ファイルはそのまま
//※4 移動先に既にファイルが存在した場合は上書きします

var $1; $2; $3 : Pointer
ARRAY TEXT:C222($atRemove; 0)
ARRAY TEXT:C222($atMoveF; 0)
ARRAY TEXT:C222($atMoveT; 0)

var $voSTATUS : Object

If (Count parameters:C259>=1)
	If (Not:C34(Is nil pointer:C315($1)))
		If ((Type:C295($1->)=Text array:K8:16) | (Type:C295($1->)=String array:K8:15))
			COPY ARRAY:C226($1->; $atRemove)
		End if 
	End if 
End if 

If (Count parameters:C259>=3)
	If ((Not:C34(Is nil pointer:C315($2))) & (Not:C34(Is nil pointer:C315($3))))
		If (\
			((Type:C295($2->)=Text array:K8:16) | (Type:C295($2->)=String array:K8:15)) & \
			((Type:C295($3->)=Text array:K8:16) | (Type:C295($3->)=String array:K8:15)))
			If ((Size of array:C274($2->))=(Size of array:C274($3->)))
				COPY ARRAY:C226($2->; $atMoveF)
				COPY ARRAY:C226($3->; $atMoveT)
			End if 
		End if 
	End if 
End if 

//再起動実施
Case of 
	: (isWin)
		
		//各種情報取得
		$voSTATUS:=PCON_WIN
		
		//付随処理用のパスを格納
		OB SET ARRAY:C1227($voSTATUS; "PATH_REMOVE"; $atRemove)
		OB SET ARRAY:C1227($voSTATUS; "PATH_MOVE_F"; $atMoveF)
		OB SET ARRAY:C1227($voSTATUS; "PATH_MOVE_T"; $atMoveT)
		
		//4D再起動
		PCON_WIN_Reboot($voSTATUS)
		
	: (isMac)
		
		//各種情報取得
		$voSTATUS:=PCON_OSX
		
		PCON_OSX_ConvertPath(->$atRemove)
		PCON_OSX_ConvertPath(->$atMoveF)
		PCON_OSX_ConvertPath(->$atMoveT)
		
		//付随処理用のパスを格納
		OB SET ARRAY:C1227($voSTATUS; "PATH_REMOVE"; $atRemove)
		OB SET ARRAY:C1227($voSTATUS; "PATH_MOVE_F"; $atMoveF)
		OB SET ARRAY:C1227($voSTATUS; "PATH_MOVE_T"; $atMoveT)
		
		PCON_OSX_Reboot($voSTATUS)
		
End case 
