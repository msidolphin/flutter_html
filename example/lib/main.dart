import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new MyHomePage(title: 'flutter_html Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

const titleData = """
  <div style="font-size:17px;color:#333;margin-bottom:2px;">申请加入班组</div>
  <div style="font-size:14px;color:#606060;margin-bottom:2px;">王大陆的班组</div>
""";

const contentData = """
  <div>
    <span style="font-size:14px;color:#333">申请人：</span>
    <span style="font-size:14px;color:#333;font-weight:500;">张三</span>
  </div>
  <div>
    <span style="font-size:14px;color:#333">联系电话：</span>
    <span style="font-size:14px;color:#333">15363393934</span>
  </div>
""";

const actionData = """
  <flex id="1" actions="">123123213</flex>
  <div style="text-align:right;">
    <a data-id="1" style='color:red;padding: 0px 10px;margin: 0px 10px 0px 0px;' href="/page">不同意</a>
    <span> </span>
    <span> </span>
    <span> </span>
    <a style='color:#ffb700;padding: 0px 10px;' href="/page">同意</a>
  </div>
""";

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('flutter_html Example'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey,
          child: Column(
            children: [
              HtmlWidget('''
                <div style="background:green;color:red;border-bottom:10px;font-size:20px">
                  <span style="border-top: 1px solid red">112131231211</span>
                </div>
                <row>
                  <div style="font-size:13px">1</div>
                  <div>2</div>
                  <div>3</div>
                </row>
                <message>
                  <message-title title="" subtitle="">
                    <message-action color="">同意</message-action>
                    <message-action color="">不同意</message-action>
                  </message-title>
                  <message-body>
                    <message-row>1</message-row>
                    <message-row>1</message-row>
                  </message-body>
                </message>
              ''', customWidgetBuilder: (element) {
                element.localName;
                if (element.localName.toLowerCase() == 'message') {


                  print(element.innerHtml);
                  return FlutterLogo();
                }


                return null;
              },),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Html(
                              data: titleData,
                            ),
                          ),
                          Container(
                            width: 120,
                            alignment: Alignment.centerRight,
                            child: Html(
                              data: actionData,
                              customRender: {
                                "flex": (RenderContext context, Widget child, attributes, _) {
                                  // print(child);
                                  // print(attributes);
                                  return FlutterLogo(
                                    style: (attributes['horizontal'] != null)
                                        ? FlutterLogoStyle.horizontal
                                        : FlutterLogoStyle.markOnly,
                                    textColor: context.style.color,
                                    size: context.style.fontSize.size * 5,
                                  );
                                },
                              },
                              onLinkTap: (e, attrs) {
                                print(attrs);
                              },
                              style: {
                                "html": Style(
                                  backgroundColor: Colors.grey
                                ),
                                "a": Style(
                                  textDecoration: TextDecoration.none,
                                )
                              },
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.5,
                            color: Colors.grey
                          )
                        )
                      ),
                    ),
                    Container(
                      child: Html(
                        data: contentData,
                      ),
                    )
                  ],
                ),
                color: Colors.white,
              ),
              SizedBox(height: 12,),
              Container(
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Html(
                              data: titleData,
                            ),
                          ),
                          Container(
                            width: 120,
                            alignment: Alignment.centerRight,
                            child: Html(
                              data: actionData,
                              onLinkTap: (e, atts) {
                                print(e);
                              },
                              style: {
                                "html": Style(
                                    backgroundColor: Colors.grey
                                ),
                                "a": Style(
                                  textDecoration: TextDecoration.none,
                                )
                              },
                            ),
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 0.5,
                                  color: Colors.grey
                              )
                          )
                      ),
                    ),
                    Container(
                      child: Html(
                        data: contentData,
                      ),
                    )
                  ],
                ),
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
