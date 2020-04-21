// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "advancedPopupMenuToolTip" : MessageLookupByLibrary.simpleMessage("高级功能"),
    "bronze" : MessageLookupByLibrary.simpleMessage("铜"),
    "dynamicAnalyzeMenuButton" : MessageLookupByLibrary.simpleMessage("动态分析"),
    "gold" : MessageLookupByLibrary.simpleMessage("金"),
    "jitterRangeToolTip" : MessageLookupByLibrary.simpleMessage("修改生成奖杯时间戳的抖动时间范围"),
    "jitterUnit" : MessageLookupByLibrary.simpleMessage("单位微秒"),
    "jitterWrongFormatAlert" : MessageLookupByLibrary.simpleMessage("抖动格式错误"),
    "orderByPSN" : MessageLookupByLibrary.simpleMessage("以PSN排序"),
    "orderByTime" : MessageLookupByLibrary.simpleMessage("以时间排序"),
    "pageEditorFinishAlertBack" : MessageLookupByLibrary.simpleMessage("返回编辑器"),
    "pageEditorFinishAlertDetail" : MessageLookupByLibrary.simpleMessage("全部更改已保存。点击 完成 按钮下载新的 TRPTRANS_MOD.DAT 文件\n*.将 TRPTRANS_MOD.DAT 重命名为 TRPTRANS.DAT 文件回传至vita覆盖原始文件(回传前请确保vita的原始 TRPTRANS.DAT 文件处于解密状态)"),
    "pageEditorFinishAlertFinish" : MessageLookupByLibrary.simpleMessage("完成"),
    "pageEditorFinishAlertTitle" : MessageLookupByLibrary.simpleMessage("保存成功"),
    "pageEditorModifyFinish" : MessageLookupByLibrary.simpleMessage("完成"),
    "pageEditorModifyLock" : MessageLookupByLibrary.simpleMessage("加锁"),
    "pageEditorModifyPick" : MessageLookupByLibrary.simpleMessage("挑选"),
    "pageEditorModifyRandom" : MessageLookupByLibrary.simpleMessage("随机"),
    "pageEditorRandomPSNTimeEndDefault" : MessageLookupByLibrary.simpleMessage("未设定。使用当前系统时间"),
    "pageHomeAlert" : MessageLookupByLibrary.simpleMessage("*.在传输前请确保 TRPTRANS.DAT 文件是解密状态："),
    "pageHomeAlertDetail" : MessageLookupByLibrary.simpleMessage("1. 使用vitashell导航至 ur0:/user/xx/trophy/data/ 文件夹\n2. 对 NPWRXXXXX_00 文件夹按三角键, 然后选择 Open decrypted 选项并确认\n3. 传输文件夹内解密的 TRPTRANS.DAT \n"),
    "pageHomeAppBarTitle" : MessageLookupByLibrary.simpleMessage("Vita奖杯编辑器"),
    "pageHomeFiles" : MessageLookupByLibrary.simpleMessage("*.所需文件："),
    "pageHomeFilesDetail" : MessageLookupByLibrary.simpleMessage("ur0:/user/xx/trophy/conf/NPWRXXXXX_00/TROP.SFM\nur0:/user/xx/trophy/data/NPWRXXXXX_00/TRPTRANS.DAT\n请使用vitashell或其他文件管理工具把以上两个文件传输至你的电脑/手机等设备\n"),
    "pageHomeSelectFiles" : MessageLookupByLibrary.simpleMessage("选择文件"),
    "pageHomeUsage" : MessageLookupByLibrary.simpleMessage("用途："),
    "pageHomeUsageDetail" : MessageLookupByLibrary.simpleMessage("本工具可用来微调奖杯解锁，不能用来迅速解锁全部奖杯\n代码可能存在Bug所以请谨慎使用。使用前请务必备份原始 TRPTRANS.DAT 文件\n"),
    "pageLocaleCN" : MessageLookupByLibrary.simpleMessage("简体中文"),
    "pageLocaleEN" : MessageLookupByLibrary.simpleMessage("English"),
    "pageLocaleTitle" : MessageLookupByLibrary.simpleMessage("选择语言"),
    "platinum" : MessageLookupByLibrary.simpleMessage("白金"),
    "psnTimeWrongFormatAlert" : MessageLookupByLibrary.simpleMessage("时间格式错误"),
    "randomDateTimeRangeBegin" : MessageLookupByLibrary.simpleMessage("起点"),
    "randomDateTimeRangeEnd" : MessageLookupByLibrary.simpleMessage("终点"),
    "randomDateTimeRangeTimeZoneAlert" : MessageLookupByLibrary.simpleMessage("*.挑选的时间将会从你的本地时区转换为UTC时间并显示"),
    "randomDateTimeRangeToolTip" : MessageLookupByLibrary.simpleMessage("修改随机PSN时间范围(仅用于随机生成奖杯)"),
    "saveChanges" : MessageLookupByLibrary.simpleMessage("保存更改"),
    "scriptUnlockManualExample" : MessageLookupByLibrary.simpleMessage("例子:"),
    "scriptUnlockManualHavePlat" : MessageLookupByLibrary.simpleMessage("是否有白金奖杯"),
    "scriptUnlockManualHide" : MessageLookupByLibrary.simpleMessage("隐藏说明"),
    "scriptUnlockManualId" : MessageLookupByLibrary.simpleMessage("id从零开始，跟据奖杯列表默认顺序一一对应"),
    "scriptUnlockManualJitter" : MessageLookupByLibrary.simpleMessage("生成时间戳的抖动，单位微秒"),
    "scriptUnlockManualRandom" : MessageLookupByLibrary.simpleMessage("时间将随机生成"),
    "scriptUnlockManualRandomBaseEnd" : MessageLookupByLibrary.simpleMessage("如果在trophies[i].time中使用了时间随机生成，那么以下两列是必需的。对应随机时间的起始和终止范围"),
    "scriptUnlockManualShow" : MessageLookupByLibrary.simpleMessage("显示说明"),
    "scriptUnlockManualTitle" : MessageLookupByLibrary.simpleMessage("脚本使用JSON格式， 文件名可以为任意.json"),
    "scriptUnlockMenuButton" : MessageLookupByLibrary.simpleMessage("脚本解锁"),
    "scriptUnlockSelect" : MessageLookupByLibrary.simpleMessage("选择脚本"),
    "searchTrophyHint" : MessageLookupByLibrary.simpleMessage("输入奖杯名称"),
    "silver" : MessageLookupByLibrary.simpleMessage("银"),
    "staticAnalyzeMenuButton" : MessageLookupByLibrary.simpleMessage("静态分析"),
    "titleDefault" : MessageLookupByLibrary.simpleMessage("PSV奖杯编辑器"),
    "titleHead" : MessageLookupByLibrary.simpleMessage("正在编辑: "),
    "unobtained" : MessageLookupByLibrary.simpleMessage("未获得")
  };
}
