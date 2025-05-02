# REBOOT4D
4Dのリブート用コンポーネントです。4D v16/v17/v18/v19/v20に対応しています。  
Windows/macOS両方に対応しています。  
※1 Windows 8以降に対応しています。Windows 7では動作しません。  
※2 実行ファイルが完全に同じパスのアプリが複数同時起動していても正常に動作します。  
  
---
例えば以下
```
ARRAY TEXT($atDEL;0)  
ARRAY TEXT($atFROM;0)  
ARRAY TEXT($atTO;0)  
  
APPEND TO ARRAY($atDEL;"C:\\temp.txt")  
APPEND TO ARRAY($atFROM;"C:\\new\\sample.txt")  
APPEND TO ARRAY($atTO;"C:\\sample.txt")  
  
REBOOT (->$atDEL;->$atFROM;->$atTO)
```
のように使用することで再起動に合わせて  
"C:\temp.txt" にあるファイルを削除し  
"C:\new\sample.txt" にあるファイルを  
"C:\sample.txt" に移動します。  
  
引数は任意なので再起動のみの使用も可能です。  
詳しい使用方法は "REBOOT" メソッドのコメントを参照ください。
