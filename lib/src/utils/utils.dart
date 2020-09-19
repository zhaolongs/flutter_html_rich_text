import 'package:flutter/material.dart';
import '../styles/size_attribute.dart';
/// 创建人： Created by zhaolong
/// 创建时间：Created by  on 2020/9/19.
///
/// 可关注公众号：我的大前端生涯   获取最新技术分享
/// 可关注网易云课堂：https://study.163.com/instructor/1021406098.htm
/// 可关注博客：https://blog.csdn.net/zl18603543572
///
/// 免费教程  https://www.toutiao.com/c/user/token/MS4wLjABAAAAYMrKikomuQJ4d-cPaeBqtAK2cQY697Pv9xIyyDhtwIM/
///
const Map<String, String> HtmlSpecialCharacterMap = {
  '&nbsp;': ' ',
  '&amp;' : '&', 
  '&lt;'  : '<',
  '&gt;'  : '>',
  '&quot;': '"',
  '&qpos;': '\'',
};

BoxFit size2BoxFit(double heightFactor, double widthFactor) {
  if (heightFactor == 1.0 && widthFactor == 1.0) {
    return BoxFit.fill;
  } else if (heightFactor == 1.0) {
    return BoxFit.fitHeight;
  } else if (widthFactor == 1.0) {
    return BoxFit.fitWidth;
  } else {
    return BoxFit.none;
  }
}

const Map<String, Color> CssNameColorMap = {
  'aliceblue'           : Color(0xffF0F8FF),
  'antiquewhite'        : Color(0xffFAEBD7),
  'aqua'                : Color(0xff00FFFF),
  'aquamarine'          : Color(0xff7FFFD4),
  'azure'               : Color(0xffF0FFFF),
  'beige'               : Color(0xffF5F5DC),
  'bisque'              : Color(0xffFFE4C4),
  'black'               : Color(0xff000000),
  'blanchedalmond'      : Color(0xffFFEBCD),
  'blue'                : Color(0xff0000FF),
  'blueviolet'          : Color(0xff8A2BE2),
  'brown'               : Color(0xffA52A2A),
  'burlywood'           : Color(0xffDEB887),
  'cadetblue'           : Color(0xff5F9EA0),
  'chartreuse'          : Color(0xff7FFF00),
  'chocolate'           : Color(0xffD2691E),
  'coral'               : Color(0xffFF7F50),
  'cornflowerblue'      : Color(0xff6495ED),
  'cornsilk'            : Color(0xffFFF8DC),
  'crimson'             : Color(0xffDC143C),
  'cyan'                : Color(0xff00FFFF),
  'darkblue'            : Color(0xff00008B),
  'darkcyan'            : Color(0xff008B8B),
  'darkgoldenrod'       : Color(0xffB8860B),
  'darkgray'            : Color(0xffA9A9A9),
  'darkgreen'           : Color(0xff006400),
  'darkkhaki'           : Color(0xffBDB76B),
  'darkmagenta'         : Color(0xff8B008B),
  'darkolivegreen'      : Color(0xff556B2F),
  'darkorange'          : Color(0xffFF8C00),
  'darkorchid'          : Color(0xff9932CC),
  'darkred'             : Color(0xff8B0000),
  'darksalmon'          : Color(0xffE9967A),
  'darkseagreen'        : Color(0xff8FBC8F),
  'darkslateblue'       : Color(0xff483D8B),
  'darkslategray'       : Color(0xff2F4F4F),
  'darkturquoise'       : Color(0xff00CED1),
  'darkviolet'          : Color(0xff9400D3),
  'deeppink'            : Color(0xffFF1493),
  'deepskyblue'         : Color(0xff00BFFF),
  'dimgray'             : Color(0xff696969),
  'dodgerblue'          : Color(0xff1E90FF),
  'firebrick'           : Color(0xffB22222),
  'floralwhite'         : Color(0xffFFFAF0),
  'forestgreen'         : Color(0xff228B22),
  'fuchsia'             : Color(0xffFF00FF),
  'gainsboro'           : Color(0xffDCDCDC),
  'ghostwhite'          : Color(0xffF8F8FF),
  'gold'                : Color(0xffFFD700),
  'goldenrod'           : Color(0xffDAA520),
  'gray'                : Color(0xff808080),
  'green'               : Color(0xff008000),
  'greenyellow'         : Color(0xffADFF2F),
  'honeydew'            : Color(0xffF0FFF0),
  'hotpink'             : Color(0xffFF69B4),
  'indianred'           : Color(0xffCD5C5C),
  'indigo'              : Color(0xff4B0082),
  'ivory'               : Color(0xffFFFFF0),
  'khaki'               : Color(0xffF0E68C),
  'lavender'            : Color(0xffE6E6FA),
  'lavenderblush'       : Color(0xffFFF0F5),
  'lawngreen'           : Color(0xff7CFC00),
  'lemonchiffon'        : Color(0xffFFFACD),
  'lightblue'           : Color(0xffADD8E6),
  'lightcoral'          : Color(0xffF08080),
  'lightcyan'           : Color(0xffE0FFFF),
  'lightgoldenrodyellow': Color(0xffFAFAD2),
  'lightgray'           : Color(0xffD3D3D3),
  'lightgreen'          : Color(0xff90EE90),
  'lightpink'           : Color(0xffFFB6C1),
  'lightsalmon'         : Color(0xffFFA07A),
  'lightseagreen'       : Color(0xff20B2AA),
  'lightskyblue'        : Color(0xff87CEFA),
  'lightslategray'      : Color(0xff778899),
  'lightsteelblue'      : Color(0xffB0C4DE),
  'lightyellow'         : Color(0xffFFFFE0),
  'lime'                : Color(0xff00FF00),
  'limegreen'           : Color(0xff32CD32),
  'linen'               : Color(0xffFAF0E6),
  'magenta'             : Color(0xffFF00FF),
  'maroon'              : Color(0xff800000),
  'mediumaquamarine'    : Color(0xff66CDAA),
  'mediumblue'          : Color(0xff0000CD),
  'mediumorchid'        : Color(0xffBA55D3),
  'mediumpurple'        : Color(0xff9370DB),
  'mediumseagreen'      : Color(0xff3CB371),
  'mediumslateblue'     : Color(0xff7B68EE),
  'mediumspringgreen'   : Color(0xff00FA9A),
  'mediumturquoise'     : Color(0xff48D1CC),
  'mediumvioletred'     : Color(0xffC71585),
  'midnightblue'        : Color(0xff191970),
  'mintcream'           : Color(0xffF5FFFA),
  'mistyrose'           : Color(0xffFFE4E1),
  'moccasin'            : Color(0xffFFE4B5),
  'navajowhite'         : Color(0xffFFDEAD),
  'navy'                : Color(0xff000080),
  'oldlace'             : Color(0xffFDF5E6),
  'olive'               : Color(0xff808000),
  'olivedrab'           : Color(0xff6B8E23),
  'orange'              : Color(0xffFFA500),
  'orangered'           : Color(0xffFF4500),
  'orchid'              : Color(0xffDA70D6),
  'palegoldenrod'       : Color(0xffEEE8AA),
  'palegreen'           : Color(0xff98FB98),
  'paleturquoise'       : Color(0xffAFEEEE),
  'palevioletred'       : Color(0xffDB7093),
  'papayawhip'          : Color(0xffFFEFD5),
  'peachpuff'           : Color(0xffFFDAB9),
  'peru'                : Color(0xffCD853F),
  'pink'                : Color(0xffFFC0CB),
  'plum'                : Color(0xffDDA0DD),
  'powderblue'          : Color(0xffB0E0E6),
  'purple'              : Color(0xff800080),
  'red'                 : Color(0xffFF0000),
  'rosybrown'           : Color(0xffBC8F8F),
  'royalblue'           : Color(0xff4169E1),
  'saddlebrown'         : Color(0xff8B4513),
  'salmon'              : Color(0xffFA8072),
  'sandybrown'          : Color(0xffF4A460),
  'seagreen'            : Color(0xff2E8B57),
  'seashell'            : Color(0xffFFF5EE),
  'sienna'              : Color(0xffA0522D),
  'silver'              : Color(0xffC0C0C0),
  'skyblue'             : Color(0xff87CEEB),
  'slateblue'           : Color(0xff6A5ACD),
  'slategray'           : Color(0xff708090),
  'snow'                : Color(0xffFFFAFA),
  'springgreen'         : Color(0xff00FF7F),
  'steelblue'           : Color(0xff4682B4),
  'tan'                 : Color(0xffD2B48C),
  'teal'                : Color(0xff008080),
  'thistle'             : Color(0xffD8BFD8),
  'tomato'              : Color(0xffFF6347),
  'turquoise'           : Color(0xff40E0D0),
  'violet'              : Color(0xffEE82EE),
  'wheat'               : Color(0xffF5DEB3),
  'white'               : Color(0xffFFFFFF),
  'whitesmoke'          : Color(0xffF5F5F5),
  'yellow'              : Color(0xffFFFF00),
  'yellowgreen'         : Color(0xff9ACD32),
};

const Map<String, FontWeight> FontWeightMap = {
  'normal' : FontWeight.normal,
  'bold'   : FontWeight.bold,
  'bolder' : FontWeight.bold,
  // TODO: 待确认
  'lighter': FontWeight.w100,
  '100'    : FontWeight.w100,
  '200'    : FontWeight.w200,
  '300'    : FontWeight.w300,
  '400'    : FontWeight.w400,
  '500'    : FontWeight.w500,
  '600'    : FontWeight.w600,
  '700'    : FontWeight.w700,
  '800'    : FontWeight.w800,
  '900'    : FontWeight.w900,
};

// 注意: 处理 p 标签的 text-align 时改变其 container 的 alignment，但是无法处理 justify
const Map<String, Alignment> AlignmentMap = {
  'left'  : Alignment.centerLeft, 
  'right' : Alignment.centerRight,
  'center': Alignment.center,
};

const Map<String, TextAlign> TextAlignMap = {
  'left'   : TextAlign.left,
  'center' : TextAlign.center,
  'right'  : TextAlign.right,
  'justify': TextAlign.justify,
};

const Map<String, TextDirection> TextDirectionMap = {
  'ltr': TextDirection.ltr,
  'rtl': TextDirection.rtl,
};

const Map<String, TextDecoration> TextDecorationMap = {
  'none'        : TextDecoration.none,
  'underline'   : TextDecoration.underline,
  'overline'    : TextDecoration.overline,
  'line-through': TextDecoration.lineThrough,
  // 注意: 暂不支持
  'blink'       : TextDecoration.none,
};

Color string2Color(String colorString) {
  // 注意: 16进制
  if (colorString.contains('#')) {
    return new Color(int.tryParse(colorString.replaceAll('#', '0xff')));
  // 注意: 在 rgb 前检查是否是 rgba 形式的，可以免去使用正则表达式匹配
  } else if (colorString.contains('rgba')) {
    List<String> rgbaStringList = colorString.substring(colorString.indexOf('(') + 1, colorString.indexOf(')')).split(',');
    return Color.fromRGBO(int.tryParse(rgbaStringList[0]), int.tryParse(rgbaStringList[1]), int.tryParse(rgbaStringList[2]), double.tryParse(rgbaStringList[3]));
  } else if (colorString.contains('rgb')) {
    List<String> rgbaStringList = colorString.substring(colorString.indexOf('(') + 1, colorString.indexOf(')')).split(',');
    return Color.fromRGBO(int.tryParse(rgbaStringList[0]), int.tryParse(rgbaStringList[1]), int.tryParse(rgbaStringList[2]), 1.0);
  } else if (CssNameColorMap.containsKey(colorString.toLowerCase())) {
    return CssNameColorMap[colorString.toLowerCase()];
  } else {
    return Colors.black;
  }
}

// 注意: 解析 HTML 内联样式，最后一个值必须以';'结尾
Map<String, String> parseInlineStyle(String styleString) {
  List<String> keyValueStringList = styleString.split(';');
  Map<String, String> styleMap = new Map<String, String>();
  for (String keyValueString in keyValueStringList) {
    if (keyValueString.isEmpty) {
      continue;
    }
    List<String> keyValueList = keyValueString.split(':');
    styleMap[keyValueList.first.trim()] = keyValueList.last.trim();
  }
  return styleMap;
}

TextStyle convertTextStyle(Map<String, String> styleMap) {
  Map<String, String> effectiveStyleMap = new Map<String, String>();

  // 注意: Map 是无序集合，使用 forEach 方法依次迭代每一个属性以保证 font 中的属性与其他 font 中同名的属性可以被依次替换
  // 注意: 例：<p style="font:italic bold 16px/30px Georgia,serif; font-size: 12px;">，font-size 会替换 font 中的 font-size
  // 注意: 例：<p style="font-style: italic; font:normal bold 16px/25px Georgia,serif; font-size: 12px;">
  // 注意: font 中的 font-style 会替换 font-style，font-size 会替换 font 中的 font-size
  styleMap.forEach((String key, String value) {
    // 注意: 使用 font 中的样式替换
    if (key == 'font') {
      List<String> fontStyleList = styleMap['font'].split(' ');
      if (fontStyleList != null && fontStyleList.isNotEmpty) {
        // 注意: font-style
        if (fontStyleList.indexOf('italic') != -1 || fontStyleList.indexOf('oblique') != -1) {
          effectiveStyleMap['font-style'] = 'italic';
        }

        // 注意: font-variant 暂不支持

        // 注意: font-weight
        fontStyleList.forEach((String fontStyle) {
          if (FontWeightMap.keys.contains(fontStyle)) {
            effectiveStyleMap['font-weight'] = fontStyle;
          }
        });
        
        // 注意: font-size/line-height
        if (fontStyleList[fontStyleList.length-2].indexOf('/') != -1) {
          List<String> sizeHeightList = fontStyleList[fontStyleList.length-2].split('/');
          effectiveStyleMap['font-size'] = sizeHeightList.first;
          effectiveStyleMap['line-height'] = sizeHeightList.last;
        } else {
          effectiveStyleMap['font-size'] = fontStyleList[fontStyleList.length-2];
        }
        // 注意: font-family
        effectiveStyleMap['font-family'] = fontStyleList.last;
      }
    } else {
      effectiveStyleMap[key] = value;
    }
  });
  
  return (effectiveStyleMap == null || effectiveStyleMap.isEmpty) ? new TextStyle() : new TextStyle(
    color         : effectiveStyleMap.containsKey('color')            ? string2Color(effectiveStyleMap['color'])                                           : Colors.black,
    fontSize      : effectiveStyleMap.containsKey('font-size')        ? SizeAttribute(effectiveStyleMap['font-size']).fontStyleValue                       : defaultFontSize,
    fontWeight    : effectiveStyleMap.containsKey('font-weight')      ? FontWeightMap[effectiveStyleMap['font-weight'].toLowerCase()]                      : FontWeight.normal,
    fontStyle     : effectiveStyleMap.containsKey('font-style')       ? FontStyle.italic                                                                   : FontStyle.normal,
    letterSpacing : effectiveStyleMap.containsKey('letter-spacing')   ? SizeAttribute(effectiveStyleMap['letter-spacing']).fontStyleValue                  : null,
    wordSpacing   : effectiveStyleMap.containsKey('word-spacing')     ? SizeAttribute(effectiveStyleMap['word-spacing']).fontStyleValue                    : null,
    height        : effectiveStyleMap.containsKey('line-height')      ? SizeAttribute(effectiveStyleMap['line-height']).fontStyleValue                     : null,
    backgroundColor    : effectiveStyleMap.containsKey('background-color') ? (() => string2Color(effectiveStyleMap['background-color']))() : null,
    decoration    : effectiveStyleMap.containsKey('text-decoration')  ? TextDecorationMap[effectiveStyleMap['text-decoration'].toLowerCase()]              : TextDecoration.none,
    fontFamily    : effectiveStyleMap.containsKey('font-family')      ? effectiveStyleMap['font-family']                                                   : null,
  );
}

Map<String, double> getImageSize(double width, double height) {
  Map<String, double> imageSize = new Map<String, double>();
  imageSize['width'] = width ?? DeviceAttribute.screenWidth;
  imageSize['height'] = height ?? DeviceAttribute.screenWidth;
  double scale = 1.0;
  if (imageSize['width'] > DeviceAttribute.screenWidth) {
    scale = DeviceAttribute.screenWidth / imageSize['width'];
    imageSize['width'] = DeviceAttribute.screenWidth;
    imageSize['height'] = scale * height;
  }
  return imageSize;
}