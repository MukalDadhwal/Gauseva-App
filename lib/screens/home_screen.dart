import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../controllers/authController.dart';
import '../models/post_model.dart';
import '../widgets/post_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthController _auth;
  late List<Post> posts;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _auth = Get.find<AuthController>();
    posts = _auth.userPosts;
  }

  List<Widget> _posts = [
    Container(
      child: Text('Post 1'),
      alignment: Alignment.center,
      color: Colors.red,
      height: 20.h,
      width: 40.w,
    ),
    Container(
      child: Text('Post 2'),
      alignment: Alignment.center,
      color: Colors.amber,
      height: 20.h,
      width: 40.w,
    ),
    Container(
      child: Text('Post 3'),
      alignment: Alignment.center,
      color: Colors.red,
      height: 20.h,
      width: 40.w,
    ),
    Container(
      child: Text('Post 4'),
      alignment: Alignment.center,
      color: Colors.amber,
      height: 20.h,
      width: 40.w,
    ),
    Container(
      child: Text('Post 5'),
      alignment: Alignment.center,
      color: Colors.red,
      height: 20.h,
      width: 40.w,
    ),
    Container(
      child: Text('Post 6'),
      alignment: Alignment.center,
      color: Colors.amber,
      height: 20.h,
      width: 40.w,
    ),
    Container(
      child: Text('Post 7'),
      alignment: Alignment.center,
      color: Colors.red,
      height: 20.h,
      width: 40.w,
    ),
  ];

  Widget _buildTitle(
      BuildContext context, playlist, double height, bool shrinked) {
    final width = MediaQuery.of(context).size.width;
    // on device size greater than 700
    if (width > 700) {
      return shrinked
          ? Text(
              'Gauseva App',
              style: TextStyle(
                fontFamily: 'Raleway',
              ),
            )
          : Container(
              child: IconButton(
                icon: Icon(
                  Icons.play_circle_fill_sharp,
                  size: 30,
                ),
                onPressed: () {},
                tooltip: 'Play',
              ),
            );
    }
    // device size less than or equal to 700
    return Text(
      'Gauseva App',
      style: TextStyle(fontFamily: 'Raleway'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100.h,
          height: 30.h,
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hey,',
                style: GoogleFonts.montserrat(
                  fontSize: 30.sp,
                ),
              ),
              Text(
                "${_auth.userData['username']}",
                style: GoogleFonts.raleway(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Check the hotspots near you",
                style: GoogleFonts.raleway(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50.h,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return PostWidget(
                      "${posts[index].city}, ${posts[index].division}",
                      posts[index].severity,
                      posts[index].upvote,
                      posts[index].downvote,
                      posts[index].severity,
                      posts[index].imageUrl,
                      posts[index].postState,
                      posts[index].hasTag,
                      posts[index].address,
                      posts[index].timeCreated,
                    );
                  },
                  itemCount: posts.length,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
