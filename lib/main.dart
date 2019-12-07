import 'package:firebase_wallpaper/CRUD/crud.dart';

import 'package:firebase_wallpaper/User_Auth/user_auth.dart';
import 'package:firebase_wallpaper/Wallfy/wall_screen.dart';
import 'package:flutter/material.dart';


import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  static FirebaseAnalytics analytics=FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer=FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      home: MyHomePage( 'Flutter & Flutter',analytics,observer),
    );
  }
}

class MyHomePage extends StatefulWidget {

  final String title;

  final FirebaseAnalytics FA;
  final FirebaseAnalyticsObserver FAO;

  MyHomePage(this.title,this.FA,this.FAO);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text('User Auth'),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context)=>UserAuth(),
                    )
                  );
                },
              ),
              RaisedButton(
                child: Text('CRUD'),
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context)=>CrudSample(),
                      )
                  );
                },
              ),
              RaisedButton(
                child: Text('Wallpaper App'),
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context)=>WallScreen(widget.FA,widget.FAO),
                      )
                  );
                },
              ),



            ],
          ),
        ),
      )
    );
  }
}
