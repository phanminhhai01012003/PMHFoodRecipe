import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pmhfoodrecipe/Provider/history_provider.dart';
import 'package:pmhfoodrecipe/View/MainMenu/notification_item.dart';
import 'package:pmhfoodrecipe/View/SubMenu/add_edit_item.dart';
import 'package:pmhfoodrecipe/View/SubMenu/detail_page.dart';
class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final currentuser = FirebaseAuth.instance.currentUser!;
  Query get currentFood => FirebaseFirestore.instance
      .collection("food_recipe")
      .where("id", isEqualTo: currentuser.uid);
  @override
  Widget build(BuildContext context) {
    final historyprovider = HistoryProvider.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Image.asset("assets/images/FoodDesign.png",
          height: 40,
          fit: BoxFit.cover,
        ),
        title: Text("Viết món ăn cho riêng bạn",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade400,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationItem())
              );
            },
            icon: Icon(Icons.notifications,
              size: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text("Bạn đã có công thức nấu ăn cho bản thân rồi đúng không?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800
                ),
              ),
              SizedBox(height: 20),
              Text("Còn chần chừ gì nữa. Hãy tạo ra món ăn ngon cho bạn và cả gia đình!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.5,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade400,
                    foregroundColor: Colors.white
                  ),
                  onPressed: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddEditItem(food: null))
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.add, size: 20),
                      SizedBox(width: 15),
                      Text("Viết món mới",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 35),
              Text("Món ăn của bạn",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot<Object?>>(
                stream: currentFood.snapshots(),
                builder: (context, snapshot){
                  if (!snapshot.hasData){
                    return Center(
                      child: Text(
                        "Bạn chưa có món ăn nào trong sổ tay của bạn",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    );
                  }else{
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index){
                        DocumentSnapshot foods = snapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: (){
                            historyprovider.toggleView(foods);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => DetailPage(
                                    foods: foods,
                                    id: foods.id,
                                    likeList: List<Map<String, dynamic>>.from(foods['likes'] ?? []))
                                )
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.all(8),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.black.withOpacity(0.25)
                              ),
                              child: Slidable(
                                key: ValueKey(foods.id),
                                endActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context){
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => AddEditItem(food: foods))
                                        );
                                      },
                                      backgroundColor: Colors.amber,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                    ),
                                    SlidableAction(
                                      onPressed: (context) async{
                                        showDeleteDialog(context, foods);
                                      },
                                      backgroundColor: Colors.red.shade700,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                    )
                                  ],
                                ),
                                child: ListTile(
                                  leading: Hero(
                                    tag: foods['imageURL'],
                                    child: Container(
                                      width: 100,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Image.network(foods['imageURL'], fit: BoxFit.cover),
                                    ),
                                  ),
                                  title: Text(foods['title'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800
                                    ),
                                  ),
                                  subtitle: Text("Thể loại: ${foods['tag']}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
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
      ),
    );
  }
  void showDeleteDialog(BuildContext context, DocumentSnapshot foods){
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
            content: Text("Bạn có chắc chắn muốn xóa món ăn này không?\nBạn sẽ không thể khôi phục lại thành quả của mình sau khi xóa"),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                ),
                onPressed: () async{
                  await FirebaseFirestore.instance.runTransaction((Transaction transaction) async{
                    transaction.delete(foods.reference);
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