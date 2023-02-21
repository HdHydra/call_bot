import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  late List<dynamic> urls;
  late int index;
  DetailScreen(this.urls, this.index);
  DetailScreenState createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(widget.urls[widget.index]),
          ),
        ),
        onTap: () {
          setState(() {
            if (widget.index < widget.urls.length - 1) {
              print('${widget.index} ${widget.urls.length}');
              widget.index = widget.index + 1;
            }
          });
          // Navigator.pop(context);
        },
      ),
    );
  }
}
