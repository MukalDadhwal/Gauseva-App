import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class Post_Page extends StatefulWidget {
  final bool tag;
  final String location;
  final String severity;
  final String status;
  final DateTime dateTime;
  final int upvotes;
  final int downvotes;
  final String address;
  final List<String> urls;

  Post_Page(
    this.tag,
    this.location,
    this.severity,
    this.status,
    this.dateTime,
    this.upvotes,
    this.downvotes,
    this.address,
    this.urls,
  );

  @override
  State<Post_Page> createState() => _Post_PageState();
}

class _Post_PageState extends State<Post_Page> {
  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;

    final urlImages = widget.urls;

    return Scaffold(
      appBar: AppBar(
        title: Text("Post Information"),
        shadowColor: Colors.black,
        backgroundColor: Color(0xff57df9b),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CarouselSlider.builder(
                    itemCount: urlImages.length,
                    itemBuilder: (context, index, realIndex) {
                      final urlImage = urlImages[index];
                      return buildImage(urlImage, index);
                    },
                    options: CarouselOptions(
                        height: 25.h,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 2),
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        })),
              ),
              CarouselIndicator(
                index: currentIndex,
                count: urlImages.length,
              ),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Chip(
                  label: Text("severity: ${widget.severity}"),
                ),
                Chip(
                  label: Text("status: ${widget.status}"),
                ),
              ]),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up_outlined),
                    onPressed: () {},
                  ),
                  Text('${widget.upvotes}'),
                  IconButton(
                    icon: Icon(Icons.thumb_down_outlined),
                    onPressed: () {},
                  ),
                  Text('${widget.upvotes}'),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_rounded),
                    SizedBox(width: 20),
                    Text(
                      "Location",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "${widget.address}",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.tag),
                    SizedBox(width: 20),
                    Text(
                      "Tag",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  widget.tag ? 'Yes' : 'No',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.timer),
                    SizedBox(width: 20),
                    Text(
                      "Time",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  DateFormat('yyyy-MM-dd – kk:mm').format(widget.dateTime),
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_upward_outlined),
                  label: Text(
                    "Upload Image",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff57df9b),
                    shadowColor: Colors.black,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildImage(String urlImage, int index) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 25),
    color: Colors.grey,
    child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          urlImage,
          fit: BoxFit.cover,
          width: 500,
        )),
  );
}
