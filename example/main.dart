import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_rich_text/flutter_html_rich_text.dart';

/// 创建人： Created by zhaolong
/// 创建时间：Created by  on 2020/9/19.
///
/// 可关注公众号：我的大前端生涯   获取最新技术分享
/// 可关注网易云课堂：https://study.163.com/instructor/1021406098.htm
/// 可关注博客：https://blog.csdn.net/zl18603543572
///
///
///

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '测试富文本',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String htmlData =
      "<div class='article-title-box'> <h1 class='title-article' id='articleContentId'>Flutter跨平台开发一点一滴分析系列文章，Flutter教程，Flutter实战系列</h1></div>";

  @override
  Widget build(BuildContext context) {
    String txt =
        "<p>长途高速驱动轮<span style='background-color:#ff3333'><span style='color:#ffffff;padding:10px'> 3条立减 购胎抽奖</span></span></p><p>长途高速驱动轮<span style='background-color:#ff3333'><span style='color:#ffffff;padding:10px'> 3条立减 购胎抽奖</span></span></p>";
    return Scaffold(
      ///一个标题
      appBar: AppBar(
        title: Text('A页面'),
      ),
      body: Center(
        ///竖起排列 线性布局
        child: Column(
          ///子 Widget  居中
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HtmlRichText(
              htmlText: txt,
            ),
          ],
        ),
      ),
    );
  }
}
