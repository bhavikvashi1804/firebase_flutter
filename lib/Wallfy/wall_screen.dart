
import 'package:firebase_wallpaper/Wallfy/fullscreen_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';



const String testDevice = '';

class WallScreen extends StatefulWidget {
  @override
  _WallScreenState createState() => new _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {


  List<DocumentSnapshot> wallpaperList;
  final CollectionReference collectionReference=Firestore.instance.collection('wallpaper');

  StreamSubscription<QuerySnapshot> subscription;



  @override
  void initState() {

    subscription=collectionReference.snapshots().listen((dataSnapshot){
      setState(() {
        wallpaperList=dataSnapshot.documents;
      });
    });

    super.initState();
  }


  @override
  void dispose() {
    subscription?.cancel();
    //subscription if not null then dispose it
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wallpaper App"),),
      body: wallpaperList!=null?
      StaggeredGridView.countBuilder(
          padding: EdgeInsets.all(8.0),
          crossAxisCount: 4,
          itemCount: wallpaperList.length,
          itemBuilder: (context,i){
            String imagePath=wallpaperList[i].data['url'];

            return Material(

              elevation: 8.0,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              child: InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context)=>FullScreenImagePage(imagePath),
                    ),
                  );
                },
                child: Hero(
                  tag: imagePath,
                  child: FadeInImage(
                    image: NetworkImage(imagePath),
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/default.jpg'),
                  ),
                ),

              ),

            );
          },
          staggeredTileBuilder: (index)=>StaggeredTile.count(2,index.isEven?2:3),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ) :Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}