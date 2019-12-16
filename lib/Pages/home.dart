
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_setup/model/board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';





void main() => runApp(Home());


class Home extends StatelessWidget {

 
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Board> boardMessages =List();
   Board board;
   final FirebaseDatabase database=FirebaseDatabase.instance;
   final GlobalKey<FormState> formKey=GlobalKey<FormState>();
   DatabaseReference databaseReference;

   @override
   void initState(){
     super.initState();

     board=Board("", "");
     databaseReference=database.reference().child("community_board");
     databaseReference.onChildAdded.listen(_onEntryAdded);
        }
     
     
     
     
       
       @override
       Widget build(BuildContext context) {
         
         return Scaffold(
           appBar: AppBar(
             title: new Text("Board"),
            
           
           ),
           body: Column(
             children: <Widget>[
               Flexible(
                 flex: 0,
                 child: Form(
                   key: formKey,
                   child: Flex(
                     direction: Axis.vertical,
                     children: <Widget>[
                       ListTile(
                         leading: Icon(Icons.subject),
                         title: TextFormField(
                           initialValue: "",
                           onSaved: (val)=> board.subject=val,
                           validator: (val)=> val==""? val:null,
                         ),

                       ),
                       ListTile(
                           leading: Icon(Icons.message),
                           title: TextFormField(
                             initialValue: "",
                             onSaved: (val)=> board.body=val,
                             validator: (val)=>val==""? val:null,
                           ),
                       ),
                       //send orPost buttons
                    FlatButton(

                      child: Text('Post'),
                      color: Colors.greenAccent,
                       onPressed: () {
                         handleSubmit();
                         
                         
                                               },
                                               
                                                 
                                                                     ),
                                                 
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                Flexible(
                                                                  child: FirebaseAnimatedList(
                                                                    query: databaseReference,
                                                                    itemBuilder: (_,DataSnapshot snapshot,
                                                                    Animation<double> animation, int index){

                                                                      return new Card(
                                                                        child: ListTile(
                                                                          leading: CircleAvatar(
                                                                            backgroundColor: Colors.red,
                                                                          ),
                                                                          title: Text(boardMessages[index].subject),
                                                                          subtitle: Text(boardMessages[index].body),
                                                                        ),
                                                                      );

                                                                    },
                                                                  )
                                                                )
                                                 
                                                 
                                                              ],
                                                            ),
                                                             
                                                          );
                                                        }
                                                      
                                                        void _onEntryAdded(Event event) {
                                                          setState(() {
                                                            boardMessages.add(Board.fromSnapshot(event.snapshot));
                                                          });
                                                   }
                         
                           void handleSubmit() {

                             final FormState form=formKey.currentState;
                             if(form.validate()){
                               form.save();
                               form.reset();
                               //save the to the database
                               databaseReference.push().set(board.toJson());
                             }
                           }
                        
                          
}
