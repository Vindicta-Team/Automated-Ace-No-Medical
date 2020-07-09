import os

os.system("./tools/hemtt.exe armake build --force -i include AANM 'AANM' -w unquoted-string -w redefinition-wo-undef -w excessive-concatenation")
os.system("./tools/DSCreateKey.exe 'aanm'")
os.system("./tools/DSSignFile.exe 'aanm.biprivatekey' aanm.pbo")
