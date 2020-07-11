import os
import json
import hashlib
import shutil
import glob
import constants
import datetime
from git import Repo

####### Functions
def readDatasFromFile(filePath):
    return json.loads(open(filePath, 'rb').read())

def writeDatasIntoFile(filePath, datas):
    with open(filePath, 'w') as f:
        json.dump(datas, f)

def getMd5Checksum(filePath):
    return hashlib.md5(open(filePath,'rb').read()).hexdigest()

def updatemod(datas, aceZipChecksum):
    # git clone
    # // https://[USERNAME]:[TOKEN]@[GIT_ENTERPRISE_DOMAIN]/[ORGANIZATION]/[REPO].git

    cloned_repo = Repo.clone_from('https:// ' + constants.GITHUB_USERNAME + ':' + constants.GITHUB_TOKEN + '@github.com/Vindicta-Team/Automated-Ace-No-Medical', '/tmp/repo')

    if os.path.isdir('/tmp/repo/AANM'):
        shutil.rmtree('/tmp/repo/AANM')
    
    shutil.copytree(aceModPath, '/tmp/repo/AANM', False, None, shutil.copy2, False, True)

    # clean up some files
    medicalFileList = glob.glob('/tmp/repo/AANM/addons/ace_medical*')
    for medicalFilePath in medicalFileList:
        os.remove(medicalFilePath)
    
    # copy mod files
    shutil.copyfile('/app/aanm-files/mod.cpp', '/tmp/repo/AANM/mod.cpp')
    shutil.copyfile('/app/aanm-files/meta.cpp', '/tmp/repo/AANM/meta.cpp')

    # comit files
    cloned_repo.index.add(['*'])
    cloned_repo.index.commit("update-" + datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S"))
    cloned_repo.remotes.origin.push()

    # if update done update 
    datas['ace'] = aceZipChecksum
    writeDatasIntoFile(constants.JSON_FILE_DB, datas)
    print('AANM update done')


####### Init logic

# clean up and update mod
if os.path.isfile('/tmp/ace.zip'):
    os.remove('/tmp/ace.zip')

if os.path.isdir('/tmp/repo'):
    shutil.rmtree('/tmp/repo')

aceModPath = '/tmp/mods/steamapps/workshop/content/'+constants.ARMA_APPID+'/'+constants.ACE_APPID
if not os.path.exists(aceModPath):
    os.makedirs(aceModPath)

# get last ace version
os.system("cd /home/steam/steamcmd && ./steamcmd.sh +login " + constants.STEAM_USERNAME + " '" + constants.STEAM_PASSWORD + "' +force_install_dir " + constants.INSTALL_DIR + " +workshop_download_item " + constants.ARMA_APPID + " " + constants.ACE_APPID + " validate +quit")

# Zip and checksum it
shutil.make_archive('/tmp/ace', 'zip', aceModPath)
aceZipChecksum = getMd5Checksum('/tmp/ace.zip')

if os.path.exists(constants.JSON_FILE_DB):
    # retrieve data
    datas = readDatasFromFile(constants.JSON_FILE_DB)
    # update if needed
    if datas['ace'] != aceZipChecksum:
        updatemod(datas, aceZipChecksum)
else:
    datas = json.loads('{"ace":"123"}')
    updatemod(datas, aceZipChecksum)

print('AANM check finished')
