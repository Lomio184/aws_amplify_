import 'dart:async';

import 'package:awspro/analytics_service.dart';
import 'package:awspro/analytics_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'analytics_events.dart';
import 'analytics_service.dart';

class GalleryPage extends StatelessWidget {
  GalleryPage({ Key? key,  
    required this.shouldLogOut,  
    required this.shouldShowCamera, 
    required this.imageUrlsController,
  }) : super(key: key) { 
    AnalyticsService.log(ViewGalleryEvent());
  }

  final VoidCallback shouldLogOut;
  final VoidCallback shouldShowCamera;
  final StreamController<List<String> > imageUrlsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        title : Text('Gallery'),
        actions : [
          Padding(
            padding : const EdgeInsets.all(8),
            child : GestureDetector(
              child : Icon(Icons.logout),
              onTap : shouldLogOut
            )
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        child : Icon(Icons.camera_alt),
        onPressed: shouldShowCamera,
      ),
      body : Container(child : _galleryGrid())
    );
  }

  _galleryGrid() => StreamBuilder(
    stream : imageUrlsController.stream,
    builder : (context, AsyncSnapshot<List< String>> snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data!.length != 0) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: snapshot.data![index],
                fit : BoxFit.cover,
                placeholder: (context, url) => Container(
                  alignment : Alignment.center,
                  child : CircularProgressIndicator()
                ),
              );
            },
          );
        } else {
          return Center(child : Text('No Images to display'));
        }
      } else {
        return Center(child : CircularProgressIndicator());
      }
    }
  );
}