import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

class Resieve extends StatefulWidget {
  Resieve({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ResieveState createState() => _ResieveState();
}

class _ResieveState extends State<Resieve> {
  String name = "All Messages";
  Color resieved = Color.fromRGBO(0, 190, 255, 0.5);
  Color flagged = Color.fromRGBO(255, 0, 0, 0.5);
  Color neutral = Color.fromRGBO(0, 00, 0, 0.05);
  Color msgColor = Color.fromRGBO(0, 00, 0, 0.05);
  int allCount = 0;
  int flagCount = 0;
  int resCount = 0;

  TextEditingController controller = TextEditingController();

  List<String> litems = [];
  List<String> tags = [];

  @override
  void initState() {
    super.initState();
    download();
  }

  void refresh() {
    allCount = 0;
    flagCount = 0;
    resCount = 0;
    litems.clear();
    download();
  }

  void download() async {
    Firestore.instance
        .collection("chat")
        .orderBy('time', descending: true)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) async {
        if (f.data['id'] == 1) {
          if (msgColor == neutral) {
            String msg = f.data['msg'];
            msg.replaceAll(new RegExp(r'[^\w\s]+'), '');
            print(msg);
            String url = 'http://0.0.0.0:5005/api/$msg';
            Response response = await get(url);
            String json = response.body;
            print(json);
            for (int i = 0; i < json.length; i++) {
              if (json[i] == '1') {
                flagCount += 1;
                break;
              }
            }
            setState(() {
              litems.add(f.data['msg']);
              allCount += 1;
            });
            resCount = allCount - flagCount;
          }
          if (msgColor == flagged) {
            allCount += 1;
            int flag = 0;
            String msg = f.data['msg'];
            msg.replaceAll(new RegExp(r'[^\w\s]+'), '');
            print(msg);
            String url = 'http://0.0.0.0:5005/api/$msg';
            Response response = await get(url);
            String json = response.body;
            print(json);
            for (int i = 0; i < json.length; i++) {
              if (json[i] == '1') {
                flag = 1;
                flagCount += 1;
                break;
              }
            }
            if (flag == 1) {
              setState(() {
                litems.add(f.data['msg']);
                tags.add(json);
              });
            }
            resCount = allCount - flagCount;
          }
          if (msgColor == resieved) {
            allCount+=1;
            int flag = 0;
            String msg = f.data['msg'];
            msg.replaceAll(new RegExp(r'[^\w\s]+'), '');
            print(msg);
            String url = 'http://0.0.0.0:5005/api/$msg';
            Response response = await get(url);
            String json = response.body;
            print(json);
            for (int i = 0; i < json.length; i++) {
              if (json[i] == '1') {
                flag = 1;
                flagCount+=1;
                break;
              }
            }
            if (flag == 0) {
              setState(() {
                litems.add(f.data['msg']);
              });
            }
            resCount = allCount - flagCount;
          }
        }
      });
    });
  }

  Future<String> filter(String msg) async {}

  void upload() async {
    setState(() {
      Firestore.instance.collection('chat').document().setData({
        'user': 'James Bond',
        'msg': controller.text,
        'time': DateTime.now().millisecondsSinceEpoch,
        'id': 2
      });
    });
    Fluttertoast.showToast(
        msg: "Message Sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.cyan,
        textColor: Colors.black,
        fontSize: 14.0);
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    title: Text('To Harry Specter',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ))),
                Container(
                  padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
                  child: TextFormField(
                    autofocus: true,
                    maxLength: 150,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 7.5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(),
                      ),
                    ),
                    validator: (val) {},
                    controller: controller,
                    keyboardType: TextInputType.text,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 25, bottom: 25),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      color: Colors.cyan,
                      onPressed: () {
                        Navigator.pop(context);
                        upload();
                        setState(() {
                          controller.text = "";
                        });
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                      )),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(name),
        actions: <Widget>[
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                refresh();
              },
              child: Container(
                margin: EdgeInsets.only(right: 10, top: 10),
                child: Image.asset('assets/refreshing.png',
                    width: 30, height: 30, alignment: Alignment.center),
              ))
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountEmail: Text('harry.specter@resieve.com'),
              accountName: Text('Harry Specter'),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://avatars0.githubusercontent.com/u/42489078?s=460&v=4"),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  name = "Resieved";
                  msgColor = resieved;
                });
                refresh();
              },
              leading: Icon(FontAwesomeIcons.filter),
              title: Text('Resieved'),
              trailing: Chip(
                label: Text(
                  resCount.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.45),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                setState(() {
                  name = "Flagged";
                  msgColor = flagged;
                });
                refresh();
                print(tags);
              },
              leading: Icon(FontAwesomeIcons.flag),
              title: Text('Flagged'),
              trailing: Chip(
                label: Text(
                  flagCount.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.45),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                //filter flagged messages here
                setState(() {
                  name = "All Messages";
                  msgColor = neutral;
                });
                refresh();
              },
              leading: Icon(FontAwesomeIcons.inbox),
              title: Text('All Messages'),
              trailing: Chip(
                label: Text(
                  allCount.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.45),
              ),
            ),
            Divider(),
            Expanded(
              child: SafeArea(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    leading: Icon(FontAwesomeIcons.backward),
                    title: Text('Back'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: litems.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return new ListTile(
                    onTap: () {
                      if (msgColor == flagged) {
                        String msge = '';
                        if (tags[index][0] == '1') {
                          msge += 'Toxic ';
                        }
                        if (tags[index][1] == '1') {
                          msge += 'Obscene ';
                        }
                        if (tags[index][2] == '1') {
                          msge += 'Insult ';
                        }
                        if (tags[index][3] == '1') {
                          msge += 'Racist ';
                        }
                        if (tags[index][4] == '1') {
                          msge += 'Sexist ';
                        }
                        Fluttertoast.showToast(
                            msg: msge,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.black,
                            fontSize: 14.0);
                      }
                    },
                    leading: Padding(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Image.asset(
                        'assets/scroll.png',
                        width: 27,
                        height: 27,
                        color: msgColor,
                        colorBlendMode: BlendMode.srcATop,
                      ),
                    ),
                    title: Text(
                      'James Bond',
                      maxLines: 1,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      litems[index],
                      maxLines: 10,
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 230, 255, 0.65),
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        child: Icon(
          Icons.add,
        ),
        mini: true,
      ),
    );
  }
}
