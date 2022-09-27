# import winreg

# def foo(hive, flag):
#     aReg = winreg.ConnectRegistry(None, hive)
#     aKey = winreg.OpenKey(aReg, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
#                           0, winreg.KEY_READ | flag)

#     count_subkey = winreg.QueryInfoKey(aKey)[0]

#     software_list = []

#     for i in range(count_subkey):
#         software = {}
#         try:
#             asubkey_name = winreg.EnumKey(aKey, i)
#             asubkey = winreg.OpenKey(aKey, asubkey_name)
#             software['name'] = winreg.QueryValueEx(asubkey, "DisplayName")[0]

#             try:
#                 software['version'] = winreg.QueryValueEx(asubkey, "DisplayVersion")[0]
#             except EnvironmentError:
#                 software['version'] = 'undefined'
#             try:
#                 software['publisher'] = winreg.QueryValueEx(asubkey, "Publisher")[0]
#             except EnvironmentError:
#                 software['publisher'] = 'undefined'
#             software_list.append(software)
#         except EnvironmentError:
#             continue

#     return software_list

# software_list = foo(winreg.HKEY_LOCAL_MACHINE, winreg.KEY_WOW64_32KEY) + foo(winreg.HKEY_LOCAL_MACHINE, winreg.KEY_WOW64_64KEY) + foo(winreg.HKEY_CURRENT_USER, 0)

# for soft in software_list:
#     if soft['name'] == 'osu!':
#        print(soft)

import glob, shutil
import winapps
import os

def main():
    # osuのSongsフォルダへのパスを取得
    for item in winapps.search_installed('osu'):
        osu_path_uninstall = item.uninstall_string
        osu_path_list = osu_path_uninstall.split(' ')
        osu_path = osu_path_list[0]
        osu_basepath = os.path.dirname(osu_path)
        osu_path_fin = osu_basepath + '\\Songs'

    # ダウンロードフォルダのパスを取得
    download_path = os.path.join(os.path.join(os.environ['USERPROFILE']), 'Downloads')

    osu_files = []
    osu_files = glob.glob(download_path + '\\*.osz')
    print(osu_files)
    if len(osu_files) == 0: return 1
    for osu_file in osu_files:
        try:
            shutil.move(osu_file, osu_path_fin)
        except:
            return 2
    
    return 0

if __name__ == '__main__':
    main()