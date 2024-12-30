import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pmhfoodrecipe/Provider/history_provider.dart';
import 'package:pmhfoodrecipe/Provider/save_provider.dart';
import 'package:pmhfoodrecipe/View/MainMenu/notification_item.dart';
import 'package:pmhfoodrecipe/View/SubMenu/detail_page.dart';
class SaveFood extends StatefulWidget {
  const SaveFood({super.key});

  @override
  State<SaveFood> createState() => _SaveFoodState();
}

class _SaveFoodState extends State<SaveFood> {
  @override
  Widget build(BuildContext context) {
    final saveprovider = SaveProvider.of(context);
    final historyprovider = HistoryProvider.of(context);
    final saveItem = saveprovider.saveProducts;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        leading: Image.asset("assets/images/FoodDesign.png",
          height: 40,
          fit: BoxFit.cover,
        ),
        title: Text("Món ăn đã lưu",
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
              color: Colors.white,
              size: 20,
            ),
          )
        ],
      ),
      body: saveItem.isEmpty ? Center(
          child: Text("Không có dữ liệu",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),
          ),
        ) : ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: saveItem.length,
          itemBuilder: (context, index){
            String save = saveItem[index];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("food_recipe")
                  .doc(save).get(),
              builder: (context, snapshot){
                if (!snapshot.hasData){
                  return Center(
                    child: Column(
                      children: [
                        Icon(Icons.error_outline_rounded,
                          color: Colors.black,
                          size: 50,
                        ),
                        SizedBox(height: 20),
                        Text("Lỗi khi tải",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.black
                          ),
                        )
                      ],
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                var foods = snapshot.data!;
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: (){
                        historyprovider.toggleView(foods);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) =>
                                DetailPage(
                                  foods: foods,
                                  id: foods.id,
                                  likeList: List<Map<String, dynamic>>.from(foods['likes'] ?? []),
                                )
                            )
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black.withOpacity(0.25),
                          ),
                          child: Row(
                            children: [
                              Hero(
                                tag: foods["imageURL"],
                                child: Container(
                                  width: 100,
                                  height: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(foods["imageURL"])
                                      )
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(foods["title"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text("Thể loại: ${foods["tag"]}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 35,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            saveprovider.toggleSave(foods);
                          });
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 25,
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
    );
  }
}
