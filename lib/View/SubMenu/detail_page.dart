import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pmhfoodrecipe/Provider/save_provider.dart';
import 'package:pmhfoodrecipe/View/SubMenu/personal_page.dart';
import 'package:pmhfoodrecipe/Widget/like_button.dart';
import 'package:share_plus/share_plus.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot<Object?> foods;
  final String id;
  final List<Map<String, dynamic>> likeList;
  const DetailPage({super.key,
    required this.foods,
    required this.id,
    required this.likeList
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final user = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  @override
  void initState() {
    super.initState();
    isLiked = widget.likeList.any((likes) => likes['id'] == user.uid);
  }
  void toggleLike(){
    setState(() {
      isLiked = !isLiked;
    });
    if (isLiked){
      FirebaseFirestore.instance.collection("food_recipe").doc(widget.id).update({
        "likes": FieldValue.arrayUnion([{
          "id": user.uid,
          "avatar": user.photoURL,
          "username": user.displayName
        }]),
      });
    }else{
      FirebaseFirestore.instance.collection("food_recipe").doc(widget.id).update({
        "likes": FieldValue.arrayRemove([{
          "id": user.uid,
          "avatar": user.photoURL,
          "username": user.displayName
        }])
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final provider = SaveProvider.of(context);
    var timestamp = widget.foods['created'] as Timestamp;
    var date = timestamp.toDate();
    var formatDate = DateFormat("dd/MM/yyyy").format(date);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Hero(
                  tag: widget.foods['imageURL'],
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.foods['imageURL'])
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.green.shade400,
                          shape: BoxShape.circle
                        ),
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 20,
                            color: Colors.white,
                          )
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            shape: BoxShape.circle
                        ),
                        alignment: Alignment.center,
                        child: IconButton(
                            onPressed: (){
                              showReport(context,
                                widget.foods['title'],
                                widget.foods['username']
                              );
                            },
                            icon: Icon(
                              Icons.warning_sharp,
                              size: 20,
                              color: Colors.white,
                            )
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).size.width,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.foods['title'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Thể loai: ${widget.foods['tag']}",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Đã lên sóng: ${formatDate}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: (){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                        PersonalPage(id: widget.foods['id']))
                      );
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(widget.foods['avatar'],
                            fit: BoxFit.cover,
                            height: 30,
                            width: 30,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(widget.foods['username'],
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Mô tả:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.foods['description'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.person_2,
                        size: 20,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.foods['serves'],
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black
                          ),
                        ),
                      SizedBox(width: 50),
                      Icon(
                        Icons.timer_rounded,
                        size: 20,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.foods['duration'],
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Nguyên liệu:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.foods['ingredients'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Cách chế biến:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.foods['steps'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike
                  ),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: (){
                      showLikesList(context);
                    },
                    child: Text(widget.likeList.length.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                      ),
                    ),
                  ),
                  SizedBox(width: 140),
                  GestureDetector(
                    onTap: (){
                      Share.share("PMHFoodRecipe/${widget.foods["title"]}");
                    },
                    child: Icon(
                      Icons.share_rounded,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (){
                      provider.toggleSave(widget.foods);
                    },
                    child: provider.isExist(widget.foods) ? Icon(
                      Icons.bookmark,
                      size: 20,
                      color: Colors.yellow.shade700,
                    ) : Icon(
                      Icons.bookmark_border_outlined,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 160),
                  GestureDetector(
                    onTap: (){
                      showCommentWidget(context);
                    },
                    child: Icon(
                      Icons.comment_sharp,
                      size: 20,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<List<Map<String, dynamic>>> _fetchLikeList() async{
    DocumentSnapshot likeSnapshot = await FirebaseFirestore.instance
        .collection("food_recipe")
        .doc(widget.id)
        .get();
    List<Map<String, dynamic>> likes = List<Map<String, dynamic>>.from(likeSnapshot['likes']);
    return likes;
  }
  Future showLikesList(BuildContext context){
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.75),
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30))
      ),
      builder: (context) => Container(
        height: 500,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.green.shade400,
                    shape: BoxShape.circle
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchLikeList(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      children: [
                        Icon(Icons.error,
                          size: 50,
                          color: Colors.black,
                        ),
                        SizedBox(height: 10),
                        Text("Có lỗi xảy ra: ${snapshot.error}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w800
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                var likesDoc = snapshot.data ?? [];
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: likesDoc.length,
                  itemBuilder: (context, index) {
                    var likes = likesDoc[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                PersonalPage(id: widget.foods['id'])
                            )
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(likes['avatar'],
                              fit: BoxFit.cover,
                              height: 40,
                              width: 40,
                            ),
                          ),
                          title: Text(likes['username'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w900
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        )
      ),
    );
  }
  Future showCommentWidget(BuildContext context){
    TextEditingController commentController = TextEditingController();
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.75),
      isDismissible: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30))
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      shape: BoxShape.circle
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Bình luận",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: commentController,
              minLines: 2,
              maxLines: 2,
              decoration: InputDecoration(
                  hintText: "Viết bình luận",
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                  )
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                    foregroundColor: Colors.white
                  ),
                  onPressed: () async{
                    if (commentController.text.isEmpty){
                      Fluttertoast.showToast(
                        msg: "Vui lòng ghi bình luận của bạn",
                        backgroundColor: Colors.red.shade500,
                        textColor: Colors.white,
                        fontSize: 16,
                        toastLength: Toast.LENGTH_SHORT
                      );
                    }else{
                      await FirebaseFirestore.instance.collection("food_recipe")
                          .doc(widget.id).collection("comment").add({
                        "id": user.uid,
                        "avatar": user.photoURL,
                        "username": user.displayName,
                        "comment": commentController.text,
                        "createdAt": DateTime.now()
                      });
                    }
                  },
                  child: Icon(
                    Icons.send,
                    size: 20,
                  )
              ),
            ),
            SizedBox(height: 20),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("food_recipe")
                  .doc(widget.id)
                  .collection("comment")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      "Chưa có bình luận nào",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w800
                      ),
                    ),
                  );
                }
                else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot commentData = snapshot.data!.docs[index];
                      var timestamp = commentData['createdAt'] as Timestamp;
                      var date = timestamp.toDate();
                      var formatDate = DateFormat("dd/MM/yyyy").format(date);
                      return Container(
                        padding: EdgeInsets.all(8),
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white
                        ),
                        child: ListTile(
                          leading: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>
                                      PersonalPage(id: widget.foods['id'])
                                  )
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(commentData["avatar"],
                                fit: BoxFit.cover,
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                          title: Text(commentData["username"],
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          subtitle: Text(commentData["comment"],
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          trailing: Text("${formatDate}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  Future showReport(BuildContext context, String title, String name) async{
    TextEditingController reportController = TextEditingController();
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      isDismissible: false,
      barrierColor: Colors.black.withOpacity(0.75),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30))
      ),
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.green.shade400,
                        shape: BoxShape.circle
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Bạn đang báo cáo món ${name} của ${title}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w900
                ),
              ),
              SizedBox(height: 10),
              Text("Ghi rõ những lí do bạn báo cáo cho chúng tôi về món ăn này:",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w800
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: reportController,
                minLines: 5,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                  ),
                  hintText: "Lý do",
                  hintStyle: TextStyle(color: Colors.black)
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.75,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                    foregroundColor: Colors.white
                  ),
                  onPressed: () async{
                    var report = reportController.text;
                    if (report.isEmpty){
                      Fluttertoast.showToast(
                        msg: "Vui lòng ghi đầy đủ thông tin",
                        backgroundColor: Colors.red.shade500,
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_SHORT,
                        fontSize: 16
                      );
                    }else{
                      await FirebaseFirestore.instance
                          .collection("food_recipe").doc(widget.id)
                          .collection("report").add({
                        "id": user.uid,
                        "avatar": user.photoURL,
                        "username": user.displayName,
                        "content": report,
                        "createdAt": DateTime.now()
                      });
                      Fluttertoast.showToast(
                        msg: "Cảm ơn bạn",
                        backgroundColor: Colors.green.shade400,
                        toastLength: Toast.LENGTH_SHORT,
                        textColor: Colors.white,
                        fontSize: 16
                      );
                    }
                  },
                  child: Text("Báo cáo",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}