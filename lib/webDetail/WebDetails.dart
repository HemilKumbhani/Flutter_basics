import 'package:flutter/material.dart';
import 'package:Talkies/utils/Strings.dart';

class webDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "WebDetails",
      theme: ThemeData(primarySwatch: Colors.red),
      home: webDetailView(),
    );
  }
}

class webDetailView extends StatefulWidget {
  @override
  _webDetailsState createState() => _webDetailsState();
}

class _webDetailsState extends State<webDetailView> {
  String _title = "WebView Example";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: startDrawer(),
      body: Center(child: Text(_title)),
    );
  }

  Widget startDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                FlutterLogo(
                  size: 48.0,
                ),
                Text(
                  "Web Example",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  "your@emailid.com",
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                )
              ],
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            decoration: BoxDecoration(color: Colors.orangeAccent),
          ),
          createDrawerListTiles(Icons.photo_camera, "Import"),
          createDrawerListTiles(Icons.photo, "Gallery"),
          createDrawerListTiles(Icons.slideshow, "Slideshow"),
          createDrawerListTiles(Icons.build, "Tools"),
          Divider(),
          createDrawerListTiles(Icons.share, "Share"),
          createDrawerListTiles(Icons.send, "Send"),
        ],
      ),
    );
  }

  Widget createDrawerListTiles(IconData icon, String title) {
    return ListTile(
      leading: Icon(
        icon,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _title = title;
          Navigator.pop(context);
        });
      },
    );
  }
}
