import 'dart:io';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailImage extends StatefulWidget {
  final File imageFile;
  DetailImage({
    super.key,
    required this.imageFile,
  });

  @override
  State<DetailImage> createState() => _DetailImageState();
}

class _DetailImageState extends State<DetailImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.green,
        title: Text('Xem Chi Tiết Ảnh'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: InteractiveViewer(
          child: Image.file(
            widget.imageFile,
            fit: BoxFit.fill,
          ),
          minScale: 0.1,
          maxScale: 2.0,
        ),
      ),
    );
  }
}

class DetailImageNetWork extends StatefulWidget {
  final String link;
  DetailImageNetWork({
    super.key,
    required this.link,
  });

  @override
  State<DetailImageNetWork> createState() => _DetailImageNetWorkState();
}

class _DetailImageNetWorkState extends State<DetailImageNetWork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.green,
        title: Text('Xem Chi Tiết Ảnh'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: InteractiveViewer(
          child: Stack(
            children: [
              Center(
                child: CircularProgressIndicator(),
              ),
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: widget.link,
                fit: BoxFit.fill,
              ),
            ],
          ),
          minScale: 0.1,
          maxScale: 2.0,
        ),
      ),
    );
  }
}
