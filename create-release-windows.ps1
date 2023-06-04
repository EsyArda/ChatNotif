New-Item -Type Directory tmp > $null
New-Item -Type Directory .\tmp\Esy > $null
New-Item -Type Directory .\tmp\Esy\ChatNotif > $null
New-Item -Type Directory .\tmp\Esy\ChatNotif\res > $null

# .plugin files
Copy-Item .\ChatNotif.plugin .\tmp\Esy\
Copy-Item .\ChatNotif.plugincompendium .\tmp\Esy\

# .lua files
Copy-Item .\ChatNotif\*.lua .\tmp\Esy\ChatNotif\

# Resources
Copy-Item .\ChatNotif\res\*.tga .\tmp\Esy\ChatNotif\res\

# License and README
Copy-Item .\LICENSE.md .\tmp\Esy\ChatNotif
Write-Output "See https://github.com/EsyArda/ChatNotif/blob/main/README.md for more info." > .\tmp\Esy\ChatNotif\README.txt

# ZIP name is Esy-ChatNotif-<latest tag>.zip
$latestTag = git describe --tags --abbrev=0
Compress-Archive -LiteralPath .\tmp\Esy\ -DestinationPath Esy-ChatNotif-$latestTag.zip

Remove-Item -Recurse .\tmp\