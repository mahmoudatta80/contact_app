import 'package:contact_app/contact_model.dart';
import 'package:contact_app/db_helper.dart';
import 'package:contact_app/details_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isPhotoShown = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController contactImageUrlController = TextEditingController();
  bool isBottomBarShown = false;
  DbHelper? helper;

  @override
  void initState() {
    super.initState();
    helper = DbHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'My Contact',
          style: TextStyle(
            color: Colors.blueAccent,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(
          bottom: 15,
          top: 0,
          start: 10,
          end: 10,
        ),
        child: FutureBuilder(
          future: helper!.readFromDatabase(),
          builder: (context,AsyncSnapshot? snapshot) {
            if(!snapshot!.hasData) {
              return Center(
                child: Icon(
                  Icons.menu_outlined,
                  size: 60,
                  color: Colors.blueAccent,
                ),
              );
            }else {
              if(snapshot.data.length ==0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu_outlined,
                        size: 60,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'The Contact List Is empty',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black26,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return GridView.builder(
                    itemCount: snapshot.data.length,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
                    itemBuilder: (context, index) {
                      ContactModel contactModel = ContactModel.fromMap(snapshot.data[index]);
                      // if(contactModel.contactImageUrl == '') {
                      //   setState(() {
                      //     isPhotoShown = false;
                      //   });
                      // }else {
                      //   setState(() {
                      //     isPhotoShown = true;
                      //   });
                      // }
                      return InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(contactModel: contactModel),
                            ),);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if(contactModel.contactImageUrl != '')
                              CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                radius: 45,
                                backgroundImage: NetworkImage(
                                  '${contactModel.contactImageUrl}',
                                ),
                              ),
                            if(contactModel.contactImageUrl == '')
                              CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                radius: 45,
                                child: Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 68,
                                ),
                              ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                              '${contactModel.contactName}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              '+20${contactModel.contactNumber}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    }
                );
              }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(
          isBottomBarShown?Icons.edit:Icons.add,
          size: 48,
        ),
        onPressed: ()
        {
          if(isBottomBarShown) {
            if(formKey.currentState!.validate()) {
              ContactModel contactModel = ContactModel({
                'contactName':contactNameController.text,
                'contactNumber':contactNumberController.text,
                'contactImageUrl':contactImageUrlController.text,
              });
              helper!.insertToDatabase(contactModel);
              Navigator.of(context).pop();
              isBottomBarShown = false;
            }else {
              return null;
            }
          }else {
            contactNameController.text = '';
            contactNumberController.text = '';
            contactImageUrlController.text = '';
            scaffoldKey.currentState!.showBottomSheet(
                  (context) => Container(
                padding: EdgeInsets.all(22,),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: contactNameController,
                        decoration: InputDecoration(
                          label: Text(
                            'Contact Name',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if(value!.isEmpty) {
                            return 'It must not be empty' ;
                          }else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: contactNumberController,
                        decoration: InputDecoration(
                          label: Text(
                            'Contact Number (+20)',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if(value!.isEmpty) {
                            return 'It must not be empty' ;
                          }else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        controller: contactImageUrlController,
                        decoration: InputDecoration(
                          label: Text(
                            'Contact Image Url (Optional)',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: double.infinity,
                        child: MaterialButton(
                          onPressed: ()
                          {
                            if(formKey.currentState!.validate()) {
                              ContactModel contactModel = ContactModel({
                                'contactName':contactNameController.text,
                                'contactNumber':contactNumberController.text,
                                'contactImageUrl':contactImageUrlController.text,
                              });
                              helper!.insertToDatabase(contactModel);
                              Navigator.of(context).pop();
                            }else {
                              return null;
                            }
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15,),
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).closed.then((value) {
              setState(() {
                isBottomBarShown = false;
              });
            });
            setState(() {
              isBottomBarShown = true;
            });
          }
        },
      ),
    );
  }
}