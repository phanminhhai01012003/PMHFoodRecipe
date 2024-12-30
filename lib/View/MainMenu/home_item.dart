import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pmhfoodrecipe/Provider/history_provider.dart';
import 'package:pmhfoodrecipe/View/MainMenu/notification_item.dart';
import 'package:pmhfoodrecipe/View/SubMenu/detail_page.dart';
import 'package:pmhfoodrecipe/View/SubMenu/search_item.dart';
class HomeItem extends StatefulWidget {
  const HomeItem({super.key});

  @override
  State<HomeItem> createState() => _HomeItemState();
}

class _HomeItemState extends State<HomeItem> {
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
        backgroundColor: Colors.green.shade400,
        title: Text("PMH Food Recipe",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
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
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                readOnly: true,
                onTap: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchItem())
                  );
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,
                    size: 20,
                    color: Colors.grey,
                  ),
                  hintText: "Tìm kiếm",
                  hintStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.black)
                  )
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Hôm nay có gì mới?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 10),
            Text("Hãy cùng nhau khám phá những món ăn mà bạn yêu thích "
                "và học cách chế biến chúng",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("food_recipe")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
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
                  else {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot foods = snapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: (){
                            historyprovider.toggleView(foods);
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DetailPage(
                                          foods: foods,
                                          id: foods.id,
                                          likeList: List<Map<String, dynamic>>.from(foods['likes'] ?? []),
                                        ))
                            );
                          },
                          child: Card(
                            color: Colors.white.withOpacity(0.25),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              height: 200,
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: foods['imageURL'],
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: SizedBox(
                                        height: 120,
                                        width: double.infinity,
                                        child: Image.network(foods['imageURL'], fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(foods['title'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text("Thể loại: ${foods['tag']}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
