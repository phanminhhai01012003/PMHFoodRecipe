import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pmhfoodrecipe/View/SubMenu/rate_us.dart';
import 'package:pmhfoodrecipe/Widget/list_tile_widget.dart';
class RateScreen extends StatefulWidget {
  const RateScreen({super.key});

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final ratingCollection = FirebaseFirestore.instance.collection("rating");
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Đánh giá ứng dụng",
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.green.shade400,
          foregroundColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(text: "Tất cả", icon: Icon(Icons.all_inclusive)),
              Tab(text: "Của tôi", icon: Icon(Icons.person))
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: TabBarView(
            children: [
              GetAllRate(context),
              GetCurrentUserRate(context)
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green.shade400,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => RateUs(rateData: null))
            );
          },
        ),
      ),
    );
  }
  Widget GetAllRate(BuildContext context){
    return StreamBuilder(
      stream: ratingCollection.snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData){
          return Center(
            child: Column(
              children: [
                Icon(Icons.error_outline_rounded,
                  size: 50,
                  color: Colors.black,
                ),
                SizedBox(height: 20),
                Text("Lỗi khi tải",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
                )
              ],
            ),
          );
        }
        else if (snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        else{
          var doc = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: doc.length,
            itemBuilder: (context, index){
              DocumentSnapshot rates = doc[index];
              var timestamp = rates['createdAt'] as Timestamp;
              var date = timestamp.toDate();
              var formatDate = DateFormat("dd/MM/yyyy").format(date);
              return Container(
                padding: EdgeInsets.all(8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(rates['avatar'],
                            fit: BoxFit.cover,
                            width: 30,
                            height: 30,
                          ),
                        ),
                        SizedBox(width: 15),
                        Text(rates['username'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(Icons.star,
                          size: 20,
                          color: Colors.yellow,
                        ),
                        SizedBox(width: 10),
                        Text(rates['rate'],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        SizedBox(width: 20),
                        Text("${formatDate}",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(rates['content'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
  Widget GetCurrentUserRate(BuildContext context){
    return StreamBuilder(
      stream: ratingCollection
          .where("id", isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot){
        if (!snapshot.hasData){
          return Center(
            child: Column(
              children: [
                Icon(Icons.error_outline_rounded,
                  size: 50,
                  color: Colors.black,
                ),
                SizedBox(height: 20),
                Text("Lỗi khi tải",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
                )
              ],
            ),
          );
        }
        else if (snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        else{
          var doc = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: doc.length,
            itemBuilder: (context, index){
              DocumentSnapshot rate = doc[index];
              var timestamp = rate['createdAt'] as Timestamp;
              var date = timestamp.toDate();
              var formatDate = DateFormat("dd/MM/yyyy").format(date);
              return GestureDetector(
                onLongPress: (){
                  showCurrentUserBottomSheet(context, rate);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(rate['avatar'],
                              fit: BoxFit.cover,
                              width: 30,
                              height: 30,
                            ),
                          ),
                          SizedBox(width: 15),
                          Text(rate['username'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w800
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Icon(Icons.star,
                            size: 20,
                            color: Colors.yellow,
                          ),
                          SizedBox(width: 10),
                          Text(rate['rating'],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(width: 20),
                          Text("${formatDate}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(rate['content'],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
  Future showCurrentUserBottomSheet(BuildContext context, DocumentSnapshot rate) async{
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.75),
      isDismissible: false,
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
            SizedBox(height: 50),
            ListTileWidget(
              title: "Chỉnh sửa",
              icon: Icons.edit,
              onPress: (){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RateUs(rateData: rate))
                );
              },
            ),
            SizedBox(height: 10),
            ListTileWidget(
              title: "Xóa",
              icon: Icons.delete,
              onPress: (){
                showDeleteDialog(context, rate);
              },
            )
          ],
        ),
      )
    );
  }
  void showDeleteDialog(BuildContext context, DocumentSnapshot rate){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            title: Text("Xóa món ăn",
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            content: Text("Bạn muốn xóa đánh giá này?"),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                ),
                onPressed: () async{
                  await FirebaseFirestore.instance.runTransaction((Transaction transaction) async{
                    transaction.delete(rate.reference);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Container(
                        padding: EdgeInsets.all(16),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(12)
                        ),
                        child: Text("Đã xóa",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text("Yes"),
              ),
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("No",
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          );
        }
    );
  }
}