import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resieve/home.dart';
import 'package:resieve/flagged.dart';

class AllMessages extends StatefulWidget {
  AllMessages({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _AllMessagesState createState() => _AllMessagesState();
}

class _AllMessagesState extends State<AllMessages> {
  List<String> litems = [
    "This is the first message",
    "This is the second message",
    "This is the third message",
    "This is the fourth message"
  ];

  @override
  void initState() {
    super.initState();
  }

  void refresh(){
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('All Messages'),
        actions: <Widget>[
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                refresh();
              },
              child: Container(
                margin: EdgeInsets.only(right: 10,top:10),
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
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Resieve()));
              },
              leading: Icon(FontAwesomeIcons.filter),
              title: Text('Resieved'),
              trailing: Chip(
                label: Text(
                  '20',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.45),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => FlaggedMessages()));
              },
              leading: Icon(FontAwesomeIcons.flag),
              title: Text('Flagged'),
              trailing: Chip(
                label: Text(
                  '2',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.45),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pop();
              },
              leading: Icon(FontAwesomeIcons.inbox),
              title: Text('All Messages'),
              trailing: Chip(
                label: Text(
                  '22',
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
                    onTap: (){
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
                    onTap: () {},
                    leading: Image.asset(
                      'assets/scroll.png',
                      width: 27,
                      height: 27,
                      colorBlendMode: BlendMode.srcATop,
                    ),
                    title: Text('Harry Specter',maxLines: 1,style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(litems[index]),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
