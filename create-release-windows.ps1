New-Item -Type Directory tmp > $null
New-Item -Type Directory .\tmp\Esy > $null
Copy-Item .\ChatNotif.plugin .\tmp\Esy\
Copy-Item .\ChatNotif.plugincompendium .\tmp\Esy\
New-Item -Type Directory .\tmp\Esy\ChatNotif > $null
Copy-Item .\ChatNotif\*.lua .\tmp\Esy\ChatNotif\
New-Item -Type Directory .\tmp\Esy\ChatNotif\res > $null
Copy-Item .\ChatNotif\res\ring.tga .\tmp\Esy\ChatNotif\res\
Write-Output "See https://github.com/LilianHiault/ChatNotif/blob/main/README.md for more info." > .\tmp\Esy\ChatNotif\README.txt
Copy-Item .\LICENSE.md .\tmp\Esy\ChatNotif
Compress-Archive -LiteralPath .\tmp\Esy\ -DestinationPath Esy-ChatNotif-X.Y.Z.zip
Remove-Item -Recurse .\tmp\