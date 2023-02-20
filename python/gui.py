# TODO: Nuitka

import dearpygui.dearpygui as dpg
import main

# 初期化
dpg.create_context()

def move(sender, app_data, user_data):
    result = main.main()

    if result == 0:
        dpg.set_value(user_data, 'Move successfully')
    elif result == 1:
        dpg.set_value(user_data, 'No beatmaps')
    elif result == 2:
        dpg.set_value(user_data, 'Something wrong')

# メインウィンドウ設定
with dpg.window(label='main_window', tag='main_window'):
    dpg.add_button(label='Move beatmaps' ,callback=move, user_data='result_text')
    dpg.add_separator()
    dpg.add_text(tag='result_text')

# 後処理
dpg.create_viewport(title="move beatmaps", width=250, height=100)
dpg.setup_dearpygui()
dpg.show_viewport()
dpg.set_primary_window('main_window', True)
dpg.start_dearpygui()
dpg.destroy_context()

