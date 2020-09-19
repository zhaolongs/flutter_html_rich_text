library richtext_html;

import 'package:flutter/material.dart';
import 'utils/parser_html_utils.dart';
import 'styles/size_attribute.dart';
/// 创建人： Created by zhaolong
/// 创建时间：Created by  on 2020/9/19.
///
/// 可关注公众号：我的大前端生涯   获取最新技术分享
/// 可关注网易云课堂：https://study.163.com/instructor/1021406098.htm
/// 可关注博客：https://blog.csdn.net/zl18603543572
///
/// 免费教程  https://www.toutiao.com/c/user/token/MS4wLjABAAAAYMrKikomuQJ4d-cPaeBqtAK2cQY697Pv9xIyyDhtwIM/
///
// 注意: 视为 HTML 的 body 部分
class HtmlRichText extends StatelessWidget {
  final String htmlText;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final TextStyle golobalTextStyle;

  HtmlRichText({
    Key key,
    // 注意: HTML 中的内容
    @required this.htmlText,
    // 注意: body 的内边距
    this.padding,
    // 注意: body 的背景色
    this.backgroundColor,
    // 注意: 所有文本在 HTML 中的外部样式
    this.golobalTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeviceAttribute.screenWidth = MediaQuery.of(context).size.width;
    DeviceAttribute.devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    return Container(
      padding: padding,
      color: backgroundColor,
      child: buildMerge(),
    );
  }

  Widget buildMerge() {
    return golobalTextStyle == null
        ? buildWrap()
        : DefaultTextStyle.merge(
            style: golobalTextStyle,
            child: buildWrap(),
          );
  }

  Wrap buildWrap() {
    return Wrap(
      alignment: WrapAlignment.start,
      children: () {
        try {
          return parse(htmlText);
        } catch (e) {
          print(e);
          return [];
        }
      }(),
    );
  }
}
