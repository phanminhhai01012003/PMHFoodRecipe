import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:pmhfoodrecipe/View/Authentication/changepassword.dart';
import 'package:pmhfoodrecipe/View/Authentication/loginpage.dart';
import 'package:pmhfoodrecipe/View/MainMenu/notification_item.dart';
import 'package:pmhfoodrecipe/View/SubMenu/about_us.dart';
import 'package:pmhfoodrecipe/View/SubMenu/historypage.dart';
import 'package:pmhfoodrecipe/View/SubMenu/rate_screen.dart';
import 'package:pmhfoodrecipe/View/SubMenu/user_profile.dart';
import 'package:pmhfoodrecipe/Widget/list_tile_widget.dart';
class ProfileItem extends StatefulWidget {
  const ProfileItem({super.key});

  @override
  State<ProfileItem> createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Query get currentUserData => FirebaseFirestore.instance
      .collection("user")
      .where("uid", isEqualTo: _auth.currentUser!.uid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Image.asset("assets/images/FoodDesign.png",
          height: 40,
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.green.shade400,
        title: Text("Hồ sơ cá nhân",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationItem())
              );
            },
            icon: Icon(Icons.notifications,
              size: 20,
              color: Colors.white
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            StreamBuilder(
              stream: currentUserData.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (!snapshot.hasData){
                  return Center(child: CircularProgressIndicator());
                }
                else{
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      DocumentSnapshot user = snapshot.data!.docs[index];
                      return Center(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(user['avatar'],
                                fit: BoxFit.cover,
                                height: 150,
                                width: 150,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(user['username'],
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 18
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(user['email'],
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 14
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              height: 50,
                              width: 200,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade400,
                                  foregroundColor: Colors.white
                                ),
                                onPressed: (){
                                  Navigator.push(context, 
                                    MaterialPageRoute(builder: (context) => UserProfile(userData: user))
                                  );
                                },
                                child: Text("Chỉnh sửa thông tin",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Divider(color: Colors.black45, thickness: 3),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    ListTileWidget(
                      title: "Lịch sử xem",
                      icon: Icons.manage_history,
                      onPress: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HistoryPage())
                        );
                      },
                    ),
                    ListTileWidget(
                      title: "Giới thiệu",
                      icon: Icons.info,
                      onPress: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AboutUs())
                        );
                      },
                    ),
                    ListTileWidget(
                      title: "Đánh giá",
                      icon: Icons.star_rate,
                      onPress: (){
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RateScreen())
                        );
                      },
                    ),
                    ListTileWidget(
                      title: "Đổi mật khẩu",
                      icon: Icons.lock,
                      onPress: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ChangePassword())
                        );
                      },
                    ),
                    ListTileWidget(
                      title: "Đăng xuất",
                      icon: LineAwesomeIcons.sign_out_alt_solid,
                      onPress: (){
                        _showLogoutDialog(context);
                      },
                      endIcon: false,
                      textColor: Colors.red.shade600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
  void _showLogoutDialog (BuildContext context){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Đăng xuất",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            content: Text("Bạn có chắc chắn muốn đăng xuất không?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No")
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    await _auth.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Container(
                          padding: EdgeInsets.all(16),
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Text("Bạn đã thoát khỏi phiên đăng nhập",
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    );
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage())
                    );
                  },
                  child: Text("Yes"))
            ],
          );
        });
  }
}