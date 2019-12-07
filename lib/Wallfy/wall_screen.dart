
import 'package:firebase_wallpaper/Wallfy/fullscreen_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


import 'package:firebase_admob/firebase_admob.dart';



import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';




const String testDevice = '';

class WallScreen extends StatefulWidget {
  final FirebaseAnalytics FA;
  final FirebaseAnalyticsObserver FAO;

  WallScreen(this.FA,this.FAO);

  @override
  _WallScreenState createState() => new _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {


  List<DocumentSnapshot> wallpaperList;
  final CollectionReference collectionReference=Firestore.instance.collection('wallpaper');

  StreamSubscription<QuerySnapshot> subscription;


  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
    //testDevices: testDevice!=null?<String>[testDevice]:null,
    //testDevices: <String>['4619A49BC0CD6021B131BEFF3764AEBB'],
    keywords: <String>['wallpapers', 'walls', 'amoled'],
    birthday: new DateTime.now(),
    childDirected: true,
    gender: MobileAdGender.unknown,
  );


  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;



  BannerAd createBannerAd() {
    return new BannerAd(
        adUnitId: 'ca-app-pub-6041775164300762/3469856391',
        size: AdSize.banner,
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Banner event : $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return new InterstitialAd(
        adUnitId: 'ca-app-pub-6041775164300762/2976183757',
        targetingInfo: targetInfo,
        listener: (MobileAdEvent event) {
          print("Interstitial event : $event");
        });
  }





  Future<Null> _currentScreen() async {
    await widget.FA.setCurrentScreen(
        screenName: 'Wall Screen', screenClassOverride: 'WallScreen');
  }

  Future<Null> _sendAnalytics() async {
    await widget.FA
        .logEvent(name: 'full_screen_tapped', parameters: <String, dynamic>{});
  }





  @override
  void initState() {
    
    
    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-6041775164300762~9957057905');
    _bannerAd=createBannerAd()..load()..show(
      anchorType: AnchorType.bottom,
      //it is used to set location of Ad
    );





    subscription=collectionReference.snapshots().listen((dataSnapshot){
      setState(() {
        wallpaperList=dataSnapshot.documents;
      });
    });

    //AdRequest.Builder.addTestDevice("4619A49BC0CD6021B131BEFF3764AEBB");


    //_currentScreen();

    super.initState();
  }


  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
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
                  _sendAnalytics();
                  createInterstitialAd()..load()..show();
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