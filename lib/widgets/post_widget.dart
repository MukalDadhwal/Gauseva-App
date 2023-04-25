import 'package:flutter/material.dart';
import 'package:gauseva_app/enums.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import '../screens/post.dart';

class PostWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final int upvotes;
  final int downvotes;
  final String severity;
  final List<String> postImageUrl;
  final CurrentPostState state;
  final bool hasTag;
  final String address;
  final DateTime time;

  PostWidget(
    this.title,
    this.subtitle,
    this.upvotes,
    this.downvotes,
    this.severity,
    this.postImageUrl,
    this.state,
    this.hasTag,
    this.address,
    this.time,
  );

  String getCurrentStatus(CurrentPostState state) {
    switch (state) {
      case CurrentPostState.adopted:
        return 'adopted';
      case CurrentPostState.inprogress:
        return 'inprogress';
      case CurrentPostState.pending:
        return 'pending';
      default:
        return 'pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(
        Post_Page(hasTag, address, severity, getCurrentStatus(state), time,
            upvotes, downvotes, address, postImageUrl),
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        color: Colors.white,
        child: ListTile(
          tileColor: Colors.white,
          contentPadding: const EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.network(
              postImageUrl[0],
              width: 20.w,
              height: 30.h,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            "Cows found near$title",
            style: GoogleFonts.raleway(fontSize: 12.sp),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'severity: $severity',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey,
                ),
              ),
              Text(
                'status: ${getCurrentStatus(state)}',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.grey,
                ),
              )
            ],
          ),
          // trailing: FittedBox(
          //   // width: 5,
          //   child: Row(
          //     children: [
          //       IconButton(
          //         onPressed: () {},
          //         icon: Icon(Icons.thumb_up_sharp),
          //       ),
          //       Text('$upvotes'),
          //       IconButton(
          //         onPressed: () {},
          //         icon: Icon(Icons.thumb_down_rounded),
          //       ),
          //       Text('$downvotes'),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}
