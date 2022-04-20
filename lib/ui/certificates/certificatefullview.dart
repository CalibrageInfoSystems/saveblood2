import 'package:flutter/material.dart';
// import 'package:flutter_advanced_networkimage/provider.dart';
// import 'package:flutter_advanced_networkimage/transition.dart';
// import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_logindemo/localization/app_translations.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ImageFullscreen extends StatelessWidget {
  final String imageURL;
  ImageFullscreen(this.imageURL);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppTranslations.of(context).text("key_Donor_Certificates"),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Colors.orange[200], Colors.pinkAccent])),
          ),
        ),
        body: Container(
          child: PinchZoom(
            image: Image.network(imageURL),
            zoomedBackgroundColor: Colors.black.withOpacity(0.5),
            resetDuration: const Duration(milliseconds: 100),
            maxScale: 2.5,
          ),
          // child:
//        ZoomableWidget(
//   minScale: 0.3,
//   maxScale: 2.0,
//   // default factor is 1.0, use 0.0 to disable boundary
//   panLimit: 0.8,
//   child: Container(
//     child: TransitionToImage(
//       image: AdvancedNetworkImage(imageURL, timeoutDuration: Duration(minutes: 1)),
//       // This is the default placeholder widget at loading status,
//       // you can write your own widget with CustomPainter.
//       placeholder: CircularProgressIndicator(),
//       // This is default duration
//       duration: Duration(milliseconds: 300),
//     ),
//   ),
// ),
        ));
  }
}
