import 'package:flutter/material.dart';
import 'package:wishes_social_media_app/Constants/app-assets.dart';
class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Search"),
          centerTitle: true,
          leading: InkWell(onTap: (){
            Navigator.pop(context);
          },
              child: Image.asset(
            "Images/Vector (1).png",
            color: const Color(0xff3BA7FF),
          )),
        ),
        body:
         SingleChildScrollView(
           child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Search here",
                    fillColor: Color(0xffF6F6F6),
                    filled: true,
                    suffixIcon: Icon(Icons.search),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffF6F6F6))
                    ),
           
                 focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Color(0xffF6F6F6))
                      )
                  ),
           
           
           
                ),
              ),
              SizedBox(height: 10,),

              Text("Suggested",textAlign:TextAlign.start,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
           SizedBox(height: 10,),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(AppAssets.searchimage1),
           
                ),
                title: Text("Anika Dokidis"),
                subtitle: Text("22 followers"),
                trailing: TextButton(onPressed: (){}, child: Text("follow")),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(AppAssets.searchimage2),
           
                ),
                title: Text("Anika Dokidis"),
                subtitle: Text("22 followers"),
                trailing: TextButton(onPressed: (){}, child: Text("follow")),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(AppAssets.searchimage3),
           
                ),
                title: Text("Anika Dokidis"),
                subtitle: Text("22 followers"),
                trailing: TextButton(onPressed: (){}, child: Text("follow")),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Text(
                    "j",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Color(0xff08CA79),
           
                ),
                title: Text("Jed Enp."),
                subtitle: Text("22 followers"),
                trailing: TextButton(onPressed: (){}, child: Text("follow")),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Text(
                    "M",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue,
           
                ),
                title: Text("Milans."),
                subtitle: Text("22 followers"),
                trailing: TextButton(onPressed: (){}, child: Text("follow")),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Text(
                    "A",
                    style: TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Color(0xffD4D4D4
                  ),
           
                ),
                title: Text("Axasix"),
                subtitle: Text("22 followers"),
                trailing: TextButton(onPressed: (){}, child: Text("follow")),
              ),
           
            ],
                   ),
         ),
      ),
    );
  }
}

