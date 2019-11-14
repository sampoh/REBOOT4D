# REBOOT4D
4Dのリブート用コンポーネントです。4D v16およびv17に対応しています。  
Windows/macOS両方に対応しています。  
  
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
詳しい仕様方法は "REBOOT" メソッドのコメントを参照ください。
