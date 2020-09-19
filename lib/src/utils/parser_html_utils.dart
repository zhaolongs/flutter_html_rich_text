import 'package:flutter/material.dart';
import 'package:flutter_html_rich_text/src/richtext/CustomImageSpan.dart';
import '../styles/size_attribute.dart';
import '../styles/tag_rule.dart';
import 'utils.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
/// 创建人： Created by zhaolong
/// 创建时间：Created by  on 2020/9/19.
///
/// 可关注公众号：我的大前端生涯   获取最新技术分享
/// 可关注网易云课堂：https://study.163.com/instructor/1021406098.htm
/// 可关注博客：https://blog.csdn.net/zl18603543572
///
/// 免费教程  https://www.toutiao.com/c/user/token/MS4wLjABAAAAYMrKikomuQJ4d-cPaeBqtAK2cQY697Pv9xIyyDhtwIM/
///
const List<String> inlineTagList = [
  'em',
  'img',
  'span',
  'strong',
  'source',
];

const List<String> blockTagList = [
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'p',
  'div',
  'video',
];

// 注意: 关键节点
const List<String> truncateTagList = [
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'p',
  'div',
  'video',
];

List<Widget> parse(String originHtmlString) {
  // 空格替换 去除所有 br 标签用 \n 代替，
  originHtmlString = originHtmlString.replaceAll('<br/>', '\n');
  originHtmlString = originHtmlString.replaceAll('<br>', '\n');
  originHtmlString = originHtmlString.replaceAll('<br />', '\n');

  ///html 依赖库解析
  dom.Document document = parser.parse(originHtmlString);

  // 注意: 先序遍历找到所有关键节点的个数
  int keyNodeCount = 0;

  ///递归遍历
  parseNodesTree(document.body, callBack: (dom.Node childNode) {
    if (childNode is dom.Element &&
        truncateTagList.indexOf(childNode.localName) != -1) {
      print('TEST: 第 ${keyNodeCount + 1} 个关键节点：');
      printNodeName(childNode);
      keyNodeCount++;
      // 注意: 对于占据整行的图片也作为关键节点处理
    } else if (childNode is dom.Element &&
        childNode.localName == 'img' &&
        checkImageNeedNewLine(childNode)) {
      print('TEST: 第 ${keyNodeCount + 1} 个关键节点：');
      printNodeName(childNode);
      keyNodeCount++;
    }
  });

  print('TEST: 共 $keyNodeCount 个关键节点');

  List<dom.Node> splitNodeList = new List<dom.Node>();

  // 注意: 关键路径作为边界（无边界不剪枝）
  // DEBUG: 使用 continue 会崩溃，原因未知
  for (int index = -1; index < keyNodeCount; ++index) {
    print('TEST: 迭代下标 index = $index');

    // 注意: szO 深拷贝 Osz
    dom.Node cloneNode = document.body.clone(true);

    // 注意: 先序遍历找到所有关键节点（由于是引用传值，所以需要重新获取一遍 hashCode）
    List<dom.Node> keyNodeList = new List<dom.Node>();
    int nodeIndex = 0;
    parseNodesTree(cloneNode, callBack: (dom.Node childNode) {
      if (childNode is dom.Element &&
          truncateTagList.indexOf(childNode.localName) != -1) {
        print('TEST: truncate tag nodeIndex = ${nodeIndex++}');
        keyNodeList.add(childNode);
        // 注意: 对于占据整行的图片也作为关键节点处理
      } else if (childNode is dom.Element &&
          childNode.localName == 'img' &&
          checkImageNeedNewLine(childNode)) {
        print('TEST: one line image nodeIndex = ${nodeIndex++}');
        keyNodeList.add(childNode);
      }
    });

    // 注意: 获得关键路径
    List<List<dom.Node>> _keyNodeRouteList = new List<List<dom.Node>>();
    for (var keyNode in keyNodeList) {
      var list = new List<dom.Node>();
      var node = keyNode;
      while (node != null && (node as dom.Element).localName != 'body') {
        list.add(node);
        node = node.parent;
      }
      _keyNodeRouteList.add(list);
    }

    List<dom.Node> keyNodeRouteLeft =
        index == -1 ? null : _keyNodeRouteList[index];
    List<dom.Node> keyNodeRouteRight = (index + 1) < _keyNodeRouteList.length
        ? _keyNodeRouteList[index + 1]
        : null;

    // 注意: 延伸边界至含有关键节点的叶子节点（先序遍历）
    if (keyNodeRouteLeft != null) {
      dom.Node node = keyNodeRouteLeft.first;
      while (node.hasChildNodes()) {
        bool found = false;
        for (var keyNode in node.nodes) {
          if (keyNode is dom.Element &&
              truncateTagList.contains(keyNode.localName)) {
            node = keyNode;
            found = true;
            keyNodeRouteLeft.insert(0, node);
            break;
          }
        }
        if (!found) {
          break;
        }
      }
    }
    if (keyNodeRouteRight != null) {
      dom.Node node = keyNodeRouteRight.first;
      while (node.hasChildNodes()) {
        bool found = false;
        for (var keyNode in node.nodes) {
          if (keyNode is dom.Element &&
              truncateTagList.contains(keyNode.localName)) {
            node = keyNode;
            found = true;
            keyNodeRouteRight.insert(0, node);
            break;
          }
        }
        if (!found) {
          break;
        }
      }
    }

    // 注意: 检查一条边界是否包含另一条边界
    // 注意: 边界包含边界：指的是，某一边界的关键节点的子节点包含另一边界
    // 注意: 在关键路径的列表中的体现就是不同长度的列表的交集为某一边界
    // 注意: 如果左边界包含右，则延伸左边界至其先序遍历的叶子节点，这里不考虑右包含左（先序遍历）
    bool isContain = true;
    // 注意: 检查边界重合
    // 注意: 边界重合：指的是，两条边界的关键节点完全重合
    // 注意: 在关键路径的列表中的体现就是列表完全相同
    // 注意: 若边界重合，则不处理
    bool isCoincide = true;
    if (keyNodeRouteLeft != null &&
        keyNodeRouteLeft.isNotEmpty &&
        keyNodeRouteRight != null &&
        keyNodeRouteRight.isNotEmpty) {
      if (keyNodeRouteLeft.length < keyNodeRouteRight.length) {
        isCoincide = false;
        for (var node in keyNodeRouteLeft) {
          if (!keyNodeRouteRight.contains(node)) {
            isContain = false;
            break;
          }
        }
        if (isContain) {
          dom.Node node = keyNodeRouteLeft.first;
          while (node.hasChildNodes()) {
            node = node.nodes.first;
            keyNodeRouteLeft.insert(0, node);
          }
        }
      } else if (keyNodeRouteLeft.length > keyNodeRouteRight.length) {
        isCoincide = false;
        for (var node in keyNodeRouteRight) {
          if (!keyNodeRouteLeft.contains(node)) {
            isContain = false;
            break;
          }
        }
        if (isContain) {
          dom.Node node = keyNodeRouteRight.first;
          while (node.hasChildNodes()) {
            node = node.nodes.first;
            keyNodeRouteRight.insert(0, node);
          }
        }
      } else {
        for (dom.Node leftNode in keyNodeRouteLeft) {
          if (!keyNodeRouteRight.contains(leftNode)) {
            isCoincide = false;
            break;
          }
        }
      }
    } else {
      isContain = false;
      isCoincide = false;
    }

    print('TEST: 左关键路径（左边界）：');
    keyNodeRouteLeft?.forEach((keyNode) => printNodeName(keyNode));

    print('TEST: 右关键路径（右边界）：');
    keyNodeRouteRight?.forEach((keyNode) => printNodeName(keyNode));

    if (!isCoincide) {
      // 注意: 裁剪关键节点
      print('TEST: 裁剪关键节点');
      removeNodeInBreadthFirstTraversalNTree(
          cloneNode, 0, keyNodeRouteLeft, keyNodeRouteRight);

      // 注意: 保存节点
      print('TEST: 保存节点：');
      parseNodesTree(cloneNode);
      // 注意: 不保存空节点（剪枝结果只剩下根节点）
      if (!(cloneNode.hasChildNodes()) &&
          cloneNode is dom.Element &&
          cloneNode.localName == 'body') {
        // print('TEST: 剩余根节点，不保存节点');
      } else {
        splitNodeList.add(cloneNode);
      }
    } else {
      print('TEST: 边界重合，不裁剪');
    }

    if (!isCoincide) {
      // 注意: 保存边界
      print('TEST: 如果边界内没有关键路径，则保存边界：');
      if (keyNodeRouteRight != null) {
        bool hasKeyRouteNode = false;
        parseNodesTree(keyNodeRouteRight.first, callBack: (dom.Node childNode) {
          if (childNode.parent.localName != 'body') {
            if ((childNode is dom.Element &&
                    truncateTagList.indexOf(childNode.localName) != -1) ||
                (childNode is dom.Element &&
                    childNode.localName == 'img' &&
                    checkImageNeedNewLine(childNode))) {
              print('TEST: 含有关键节点');
              printNodeName(childNode);
              hasKeyRouteNode = true;
            }
          } else {
            print('TEST: 父节点为 body');
          }
        });
        if (!hasKeyRouteNode) {
          print('TEST: 保存边界');
          printNodeName(keyNodeRouteRight.first);
          splitNodeList.add(keyNodeRouteRight.first);
        } else {
          print('TEST: 边界内含有关键路径');
        }
      } else {
        print('TEST: 右边界为空');
      }
    } else {
      print('TEST: 不保存边界');
    }
  }

  print('TEST: 关键路径解析完毕');

  int splitNodeIndex = 0;
  for (dom.Node splitNode in splitNodeList) {
    print('TEST: splitNodeIndex = ${splitNodeIndex++}');
    parseNodesTree(splitNode);
  }

  List<Widget> widgetList = parseNode2Flutter(splitNodeList);

  print('TEST: widgetList = ${widgetList.toString()}');

  return widgetList;
}

// 注意: 自上而下合并树并转换成 Flutter 控件

// 注意: 富文本控件在父控件中的对齐方式
Alignment richTextAlignment;
// 注意: 富文本控件的基线数值，默认字号大小
double baseLineValue;

///node 节点 转 Flutter 组件
List<Widget> parseNode2Flutter(List<dom.Node> nodeList) {
  List<Widget> widgetList = new List<Widget>();

  for (dom.Node node in nodeList) {
    // print('TEST: 转换节点：');
    // checkNodeType(node);
    richTextAlignment = Alignment.centerLeft;
    baseLineValue = 14.0;
    // 注意: 向下合并
    if (node is dom.Element && node.localName == 'video') {
      // print('TEST: video 节点');
      nodeToViedeo(node, widgetList);
    } else if (node is dom.Element && node.localName == 'img') {
      print('TEST: img 节点');
      nodeToImage(node, widgetList);
    } else {
      List<TextSpan> textSpanList = new List<TextSpan>();

      _parseNode2TextSpanTest(node, textSpanList);
      for (var i = 0; i < textSpanList.length; ++i) {
        TextSpan span = textSpanList[i];

        print("测试 获取颜色 ${span.style.color}");
        Color backGroundColor = span.style.backgroundColor;

        TextStyle spanStyle = new TextStyle(
          color: span.style.color,
          fontSize: span.style.fontSize,
          fontWeight: span.style.fontWeight,
          fontStyle: span.style.fontStyle,
          letterSpacing: span.style.letterSpacing,
          wordSpacing: span.style.wordSpacing,
          height: span.style.height,
          background: null,
          decoration: span.style.decoration,
          fontFamily: span.style.fontFamily,
        );

        widgetList.add(
          Container(
            height: 22,
            color: backGroundColor,
            child: Text(
              span.text,
              style: spanStyle,
            ),
          ),
        );
      }
//      widgetList.add(new Container(
//        alignment: richTextAlignment,
//        child: new Baseline(
//          baseline: baseLineValue, // 注意: 当前富文本段中的最大高度,
//          baselineType: TextBaseline.alphabetic,
//          child: new CustomRichText(
//            textSpanList,
//          ),
//        ),
//      ));
    }
  }

  return widgetList;
}

void nodeToImage(dom.Element node, List<Widget> widgetList) {
  if (node.attributes.containsKey('src') && node.attributes['src'] != null) {
    widgetList.add(new Container(
      width: DeviceAttribute.screenWidth,
      child: new Center(
        child: new Image.network(
          node.attributes['src'],
        ),
      ),
    ));
  }
}

void nodeToViedeo(dom.Element node, List<Widget> widgetList) {
  String sourceUrl = '';
  for (dom.Node videoNode in node.nodes) {
    if (videoNode is dom.Element && videoNode.localName == 'source') {
      if (videoNode.attributes.containsKey('src') &&
          videoNode.attributes['src'] != null) {
        sourceUrl = videoNode.attributes['src'];
        break;
      }
    }
  }
  widgetList.add(new Container(
    width: DeviceAttribute.screenWidth,
    child: new Center(
      child: new Image.network(
        sourceUrl,
      ),
    ),
  ));
}

void _parseNode2TextSpanTest(dom.Node node, List<TextSpan> textSpanList,
    {Map<String, String> styleMap}) {
  Map<String, String> effectiveStyle = new Map<String, String>();
  // 注意: 继承父级
  if (styleMap != null && styleMap.isNotEmpty) {
    styleMap.forEach(
        (String key, String value) => effectiveStyle[key] = styleMap[key]);
  }
  // 注意: 合并并覆盖父级
  if (node.attributes.containsKey('style')) {
    Map<String, String> inlineStyle =
        parseInlineStyle(node.attributes['style']);
    inlineStyle.forEach(
        (String key, String value) => effectiveStyle[key] = inlineStyle[key]);
  }

  // 注意: 获取对齐方式
  if (effectiveStyle.containsKey('text-align')) {
    richTextAlignment = AlignmentMap[effectiveStyle['text-align']];
  }

  // 注意: 获取基线最大值
  if (effectiveStyle.containsKey('font-size')) {
    if (SizeAttribute(effectiveStyle['font-size']).fontStyleValue >
        baseLineValue) {
      baseLineValue = SizeAttribute(effectiveStyle['font-size']).fontStyleValue;
    }
  }

  // 注意: 标签
  if (node is dom.Element) {
    switch (node.localName) {
      case 'a':
        effectiveStyle['text-decoration'] = 'underline';
        break;
      case 'b':
        effectiveStyle['font-weight'] = 'bold';
        break;
      case 'em':
        effectiveStyle['font-style'] = 'italic';
        break;
      case 'h1':
        effectiveStyle['font-weight'] = 'bold';
        effectiveStyle['font-size'] = '28px';
        break;
      case 'h2':
        effectiveStyle['font-weight'] = 'bold';
        effectiveStyle['font-size'] = '21px';
        break;
      case 'h3':
        effectiveStyle['font-weight'] = 'bold';
        effectiveStyle['font-size'] = '16px';
        break;
      case 'h4':
        effectiveStyle['font-weight'] = 'bold';
        effectiveStyle['font-size'] = '14px';
        break;
      case 'h5':
        effectiveStyle['font-weight'] = 'bold';
        effectiveStyle['font-size'] = '12px';
        break;
      case 'h6':
        effectiveStyle['font-weight'] = 'bold';
        effectiveStyle['font-size'] = '10px';
        break;
      case 'img':
        Map<String, double> imageSize = getImageSize(
          new SizeAttribute(node.attributes['width'] ?? '100%').imgValue,
          new SizeAttribute(node.attributes['height'] ?? '100%').imgValue,
        );
        bool newLine = imageSize['width'] >= DeviceAttribute.screenWidth;
        if (baseLineValue < imageSize['height'] && !newLine) {
          baseLineValue = imageSize['height'];
        }
        if (newLine) {
          textSpanList.add(new TextSpan(text: '\n'));
        }
        textSpanList.add(new CustomImageSpan(
          NetworkImage(node.attributes['src']),
          imageWidth: imageSize['width'] - (newLine ? 30.0 : 0.0),
          imageHeight: imageSize['height'],
          fontSize: newLine ? null : baseLineValue,
        ));
        if (newLine) {
          textSpanList.add(new TextSpan(text: '\n'));
        }
        return;
      case 'p':
        break;
      case 'span':
        break;
      case 'strong':
        effectiveStyle['font-weight'] = 'bold';
        break;
      default:
        break;
    }

    _parseNodeListTest(node.nodes, textSpanList, styleMap: effectiveStyle);
  } else if (node is dom.Text) {
    if (node.text.trim() == '' && node.text.indexOf(' ') == -1) {
      return;
    }
    if (node.text.trim() == '' && node.text.indexOf(' ') != -1) {
      node.text = ' ';
    }

    String finalText = trimStringHtml(node.text);

    print("test--" + finalText.toString() + "   ${effectiveStyle.toString()}");
    textSpanList.add(new TextSpan(
      text: finalText,
      style: convertTextStyle(effectiveStyle),
//    style: TextStyle(backgroundColor: Colors.red)
    ));
  }
}

void _parseNodeListTest(List<dom.Node> nodeList, List<TextSpan> textSpanList,
    {Map<String, String> styleMap, Alignment alignment}) {
  nodeList.forEach((dom.Node node) =>
      _parseNode2TextSpanTest(node, textSpanList, styleMap: styleMap));
}

TextSpan _parseNode2TextSpan(dom.Node node, {Map<String, String> styleMap}) {
  Map<String, String> effectiveStyle = new Map<String, String>();
  // 注意: 继承父级
  if (styleMap != null && styleMap.isNotEmpty) {
    styleMap.forEach(
        (String key, String value) => effectiveStyle[key] = styleMap[key]);
  }
  // 注意: 合并并覆盖父级
  if (node.attributes.containsKey('style')) {
    Map<String, String> inlineStyle =
        parseInlineStyle(node.attributes['style']);
    inlineStyle.forEach(
        (String key, String value) => effectiveStyle[key] = inlineStyle[key]);
  }

  // 注意: 标签
  if (node is dom.Element) {
    // 注意: 先检查是否支持该标签，避免 switc case 的消耗
    if (!supportedElements.contains(node.localName)) {
      return TextSpan();
    }

    switch (node.localName) {
      case 'a':
        effectiveStyle['text-decoration'] = 'underline';
        break;
      case 'b':
        effectiveStyle['font-weight'] = 'bold';
        break;
      case 'img':
        return new CustomImageSpan(
          NetworkImage(node.attributes['src']),
          imageWidth:
              new SizeAttribute(node.attributes['width'] ?? '100%').imgValue,
          imageHeight:
              new SizeAttribute(node.attributes['height'] ?? '100%').imgValue,
        );
      case 'p':
        break;
      case 'span':
        break;
      case 'strong':
        effectiveStyle['font-weight'] = 'bold';
        break;
      default:
        break;
    }

    print(effectiveStyle);

    return new TextSpan(
      children: _parseNodeList(node.nodes, styleMap: effectiveStyle),
      style: convertTextStyle(effectiveStyle),
    );
    // return _parseNode2TextSpan(node, styleMap: effectiveStyle);
  } else if (node is dom.Text) {
    if (node.text.trim() == '' && node.text.indexOf(' ') == -1) {
      return new TextSpan();
    }
    if (node.text.trim() == '' && node.text.indexOf(' ') != -1) {
      node.text = ' ';
    }

    String finalText = trimStringHtml(node.text);

    return new TextSpan(
      text: finalText,
      style: convertTextStyle(effectiveStyle),
    );
  }

  return new TextSpan();
}

List<TextSpan> _parseNodeList(List<dom.Node> nodeList,
    {Map<String, String> styleMap}) {
  return nodeList
      .map((node) => _parseNode2TextSpan(node, styleMap: styleMap))
      .toList();
}

String trimStringHtml(String stringToTrim) {
  stringToTrim = stringToTrim.replaceAll('\n', '');
  while (stringToTrim.indexOf('  ') != -1) {
    stringToTrim = stringToTrim.replaceAll('  ', ' ');
  }
  return stringToTrim;
}

// 遍历回调
typedef NodeTreeCallBack(dom.Node node);

void printNodeName(dom.Node node) {
  print('TEST: checkNodeType');
  if (node is dom.Element) {
    print('TEST: element = ${node.localName}');
  } else if (node is dom.Text) {
    print('TEST: text = ${node.text}');
  } else {
    print('TEST: node = ${node.runtimeType}');
  }
}

// 注意: 检查图片是否需要占据一行
bool checkImageNeedNewLine(dom.Node node) {
  if (node.attributes.containsKey('width') == false) {
    return true;
  } else if (node.attributes.containsKey('width')) {
    String width = node.attributes['width'];
    SizeAttribute attributeWidth = new SizeAttribute(width ?? '100%');
    if (attributeWidth.imgValue != null &&
        attributeWidth.imgValue >= DeviceAttribute.screenWidth) {
      return true;
    }
  }
  return false;
}

// 注意: 检查关键路径中的节点的所有子节点是否是子支的第一个/最后一个节点
bool checkKeyRouteNodes(
    dom.Node keyRouteNode, List<dom.Node> keyRouteNodeList, bool isFirst) {
  // print('TEST: checkKeyRouteNodes');
  // checkNodeType(keyRouteNode);
  // 注意: 当被检查的节点是关键节点时，检查完毕
  // 注意: 关键节点：因为关键路径可能是因为在路径重合时延伸出来的，所以关键节点还得是预设的截断点
  // 注意: 关键节点：占据整行的图片也视为关键节点
  if ((keyRouteNode == keyRouteNodeList.first &&
          keyRouteNode is dom.Element &&
          truncateTagList.contains(keyRouteNode.localName)) ||
      (keyRouteNode is dom.Element &&
          keyRouteNode.localName == 'img' &&
          checkImageNeedNewLine(keyRouteNode))) {
    return true;
  }
  // 注意: 当被检查的节点不是第一个/最后一个节点
  if (keyRouteNode is dom.Text ||
      keyRouteNodeList.indexOf(
              isFirst ? keyRouteNode.nodes.first : keyRouteNode.nodes.last) ==
          -1) {
    return false;
  }
  return checkKeyRouteNodes(
      isFirst ? keyRouteNode.nodes.first : keyRouteNode.nodes.last,
      keyRouteNodeList,
      isFirst);
}

///递归遍历
void parseNodesTree(dom.Node node,
    {NodeTreeCallBack callBack = printNodeName}) {
  ///遍历 Node 节点
  for (var i = 0; i < node.nodes.length; ++i) {
    dom.Node item = node.nodes[i];
    callBack(item);
    parseNodesTree(item, callBack: callBack);
  }
}

// 注意: mid-order
// 注意: 111 img 222 source video 333 source video 444 span 555 source video 666 span p
void midorderTraversalNTree(dom.Node node,
    {NodeTreeCallBack f = printNodeName}) {
  for (dom.Node childNode in node.nodes) {
    midorderTraversalNTree(childNode, f: f);
    f(childNode);
  }
}

// 注意: breadth-first traversal
// 注意: p span 555 span 111 img 222 video 333 444 source source video 666 source
void breadthFirstTraversalNTree(dom.Node node,
    {NodeTreeCallBack f = printNodeName}) {
  for (dom.Node childNode in node.nodes) {
    f(childNode);
  }
  for (dom.Node childNode in node.nodes) {
    breadthFirstTraversalNTree(childNode, f: f);
  }
}

// 注意: 基于广度优先遍历的 N 叉树关键路径剪枝算法（引用传递方式）
void removeNodeInBreadthFirstTraversalNTree(dom.Node node, int deepLevel,
    List<dom.Node> keyNodeRouteLeft, List<dom.Node> keyNodeRouteRight) {
  print('TEST: 裁剪节点：');
  printNodeName(node);

  // 注意: 跳过叶子节点和关键节点（用关键路径的第一个节点当作关键节点）
  if ((!node.hasChildNodes()) ||
      (keyNodeRouteLeft != null &&
          keyNodeRouteLeft.isNotEmpty &&
          keyNodeRouteLeft.first == node) ||
      (keyNodeRouteRight != null &&
          keyNodeRouteRight.isNotEmpty &&
          keyNodeRouteRight.first == node)) {
    return;
  }

  // 注意: 获取左边界
  int leftBoundary = 0;
  if (keyNodeRouteLeft != null &&
      deepLevel < keyNodeRouteLeft.length &&
      node.nodes.indexOf(
              keyNodeRouteLeft[keyNodeRouteLeft.length - deepLevel - 1]) !=
          -1) {
    leftBoundary = node.nodes
        .indexOf(keyNodeRouteLeft[keyNodeRouteLeft.length - deepLevel - 1]);
    // 注意: 如果关键路径节点的最后一个子节点也是关键路径节点或者关键路径节点就是关键节点，则左边界+1
    if (checkKeyRouteNodes(
        keyNodeRouteLeft[keyNodeRouteLeft.length - deepLevel - 1],
        keyNodeRouteLeft,
        false)) {
      leftBoundary++;
    }
  }
  print('TEST: 左边界：$leftBoundary');

  // 注意: 获取右边界
  int rightBoundary = node.nodes.length;
  if (keyNodeRouteRight != null &&
      deepLevel < keyNodeRouteRight.length &&
      node.nodes.indexOf(
              keyNodeRouteRight[keyNodeRouteRight.length - deepLevel - 1]) !=
          -1) {
    rightBoundary = node.nodes
        .indexOf(keyNodeRouteRight[keyNodeRouteRight.length - deepLevel - 1]);
    // 注意: 如果关键路径节点的第一个子节点也是关键路径节点或者关键路径节点就是关键节点，则右边界-1
    if (checkKeyRouteNodes(
        keyNodeRouteRight[keyNodeRouteRight.length - deepLevel - 1],
        keyNodeRouteRight,
        true)) {
      rightBoundary--;
    }
  }
  print('TEST: 右边界：$rightBoundary');

  List<dom.Node> removeNodeList = new List<dom.Node>();

  // 注意: 获取左支裁剪节点（开区间）
  for (int leftIndex = 0; leftIndex < leftBoundary; ++leftIndex) {
    removeNodeList.add(node.nodes[leftIndex]);
  }

  // 注意: 获取右支裁剪节点（开区间）
  for (int rightIndex = rightBoundary + 1;
      rightIndex < node.nodes.length;
      ++rightIndex) {
    removeNodeList.add(node.nodes[rightIndex]);
  }

  // 注意: 剪枝
  for (var removeNode in removeNodeList) {
    removeNode.remove();
  }

  // 注意: 深度+1
  deepLevel++;

  for (dom.Node childNode in node.nodes) {
    removeNodeInBreadthFirstTraversalNTree(
        childNode, deepLevel, keyNodeRouteLeft, keyNodeRouteRight);
  }
}
