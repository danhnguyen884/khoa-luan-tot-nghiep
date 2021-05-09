import 'package:chat_app/views/callscreens/video_room.dart';
import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
       children: [
         Container(
           child: VideoRoom(
             groupId: "test",
           ),
           decoration: ShapeDecoration(
             color: Colors.white,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.only(),
             ),
             shadows: [new BoxShadow(blurRadius:5.0)],
           ),
         ),
       ],
    );
  }
}
