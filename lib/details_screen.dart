import 'package:contact_app/contact_model.dart';
import 'package:contact_app/db_helper.dart';
import 'package:contact_app/home_screen.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {

  ContactModel? contactModel;
  DetailsScreen({this.contactModel});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController contactImageUrlController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  DbHelper? helper;

  @override
  void initState() {
    super.initState();
    helper = DbHelper();
  }

  @override
  Widget build(BuildContext context) {
    contactNameController.text = '${widget.contactModel!.contactName}';
    contactNumberController.text = '${widget.contactModel!.contactNumber}';
    contactImageUrlController.text = '${widget.contactModel!.contactImageUrl}';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.blueAccent,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Contact Details',
          style: TextStyle(
            color: Colors.blueAccent,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(
          bottom: 15,
          top: 10,
          start: 15,
          end: 15,
        ),
        child: Container(
          width: double.infinity,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                if(widget.contactModel!.contactImageUrl != '')
                  CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  radius: 90,
                  backgroundImage: NetworkImage(
                    '${widget.contactModel!.contactImageUrl}',
                  ),
                ),
                if(widget.contactModel!.contactImageUrl == '')
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    radius: 90,
                    child: Icon(
                      Icons.person_rounded,
                      size: 136,
                    ),
                  ),
                SizedBox(
                  height: 15,
                ),
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
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                              'Save'
                          ),
                          content: Text(
                              'Are you sure , you wanna save this contact'
                          ),
                          contentTextStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 17,
                          ),
                          actions:
                          [
                            TextButton(
                              onPressed: ()
                              {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Close',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: ()
                              {
                                ContactModel contactModel = ContactModel({
                                  'id':widget.contactModel!.id,
                                  'contactName':contactNameController.text,
                                  'contactNumber':contactNumberController.text,
                                  'contactImageUrl':contactImageUrlController.text,
                                });
                                helper!.updateIntoDatabase(contactModel);
                                Navigator.of(context)
                                    .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      'Save',
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
                Container(
                  width: double.infinity,
                  child: MaterialButton(
                    onPressed: ()
                    {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                              'Delete'
                          ),
                          content: Text(
                              'Are you sure , you wanna delete this contactv'
                          ),
                          contentTextStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 17,
                          ),
                          actions:
                          [
                            TextButton(
                              onPressed: ()
                              {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Close',
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: ()
                              {
                                helper!.deleteFromDatabase(widget.contactModel!.id!);
                                Navigator.of(context)
                                    .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15,),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

