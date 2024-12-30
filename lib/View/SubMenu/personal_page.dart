import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pmhfoodrecipe/Provider/history_provider.dart';
import 'package:pmhfoodrecipe/View/SubMenu/detail_page.dart';
class PersonalPage extends StatefulWidget {
  final String id;
  const PersonalPage({super.key, required this.id});

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final foodCollection = FirebaseFirestore.instance.collection("food_recipe");
  final userCollection = FirebaseFirestore.instance.collection("user");
  Query get detailuserfoodData => foodCollection.where("id", isEqualTo: widget.id);
  Query get infomationUser => userCollection.where("uid", isEqualTo: widget.id);
  @override
  Widget build(BuildContext context) {
    final historyprovider = HistoryProvider.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot<Object?>>(
              stream: infomationUser.snapshots(),
              builder: (context, snapshot){
                if (!snapshot.hasData){
                  return Center(child: CircularProgressIndicator());
                }
                else{
                  var doc = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: doc.length,
                    itemBuilder: (context, index){
                      DocumentSnapshot userdata = doc[index];
                      return Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(userdata['avatar'],
                                  fit: BoxFit.cover,
                                  height: 75,
                                  width: 75,
                                ),
                              ),
                              SizedBox(width: 20),
                              Column(
                                children: [
                                  Text(userdata['username'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(userdata['email'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 33),
                          Center(
                            child: Text(userdata['description'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          )
                        ],
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
              child: StreamBuilder<QuerySnapshot<Object?>>(
                stream: detailuserfoodData.snapshots(),
                builder: (context, snapshot){
                  if (!snapshot.hasData){
                    return Center(
                      child: Text("Không có dữ liệu",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    );
                  }
                  else{
                    var doc = snapshot.data!.docs;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: doc.length,
                      itemBuilder: (context, index){
                        DocumentSnapshot foods = doc[index];
                        return GestureDetector(
                          onTap: (){
                            historyprovider.toggleView(foods);
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => DetailPage(
                                foods: foods,
                                id: foods.id,
                                likeList: List<Map<String, dynamic>>.from(foods['likes'] ?? []),
                              ))
                            );
                          },
                          child: Card(
                            color: Colors.white.withOpacity(0.25),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Container(
                              margin: EdgeInsets.all(12),
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
                                        child: Image.network(foods['imageURL'], fit: BoxFit.cover,),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(foods['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text("Thể loại: ${foods['tag']}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
