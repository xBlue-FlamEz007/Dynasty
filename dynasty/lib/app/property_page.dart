import 'package:dynasty/common_widgets/form_submit_button.dart';
import 'package:dynasty/common_widgets/loading.dart';
import 'package:dynasty/common_widgets/platform_alert_dialog.dart';
import 'package:dynasty/modals/user.dart';
import 'package:dynasty/services/database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyPage extends StatefulWidget {
  PropertyPage({this.propertyPic, this.propertyType, this.description, this.location,
    this.address, this.dealType, this.price, this.date, this.uid});
  final String propertyPic;
  final String propertyType;
  final String description;
  final String location;
  final String address;
  final String dealType;
  final String price;
  final String date;
  final String uid;

  @override
  _PropertyPageState createState() => _PropertyPageState();
}

class _PropertyPageState extends State<PropertyPage> {

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      PlatformAlertDialog(
        title: 'Contact Failed',
        content: 'Could not contact seller',
        defaultActionText: 'OK',
      ).show(context);
      print('Command could not launch $command');
    }
  }

  Widget _bottomSheet(String email, String phoneNumber) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'How do you want to contact?',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(
                  Icons.email_sharp,
                  color: Colors.green[800],
                ),
                onPressed: () {
                  customLaunch('mailto:' + email + '?subject=Dynasty&body=Interest%20in%20property');
                },
                label: Text('Email'),
              ),
              FlatButton.icon(
                icon: Icon(
                  Icons.phone,
                  color: Colors.green[800],
                ),
                onPressed: () {
                  customLaunch('tel:' + phoneNumber);
                },
                label: Text('Phone'),
              ),
              FlatButton.icon(
                icon: Icon(
                  Icons.sms,
                  color: Colors.green[800],
                ),
                onPressed: () {
                  customLaunch('sms:' + phoneNumber);
                },
                label: Text('SMS'),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String propertyPic = widget.propertyPic;
    String propertyType = widget.propertyType;
    String description = widget.description;
    String location = widget.location;
    String address = widget.address;
    String dealType = widget.dealType;
    String price = widget.price;
    String date = widget.date;
    String sellerUid = widget.uid;

    return StreamBuilder<Object>(
      stream: DatabaseService(uid: sellerUid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData sellerData = snapshot.data;
          String sellerName = sellerData.firstName + " " + sellerData.lastName;
          String sellerEmail = sellerData.email;
          String sellerPhoneNumber = sellerData.phoneNumber;
          var sellerProfilePic = sellerData.profilePic ==  'default' ?
          AssetImage('assets/images/default_profilepic.png') :
          NetworkImage(sellerData.profilePic);

          return Scaffold(
            appBar: AppBar(
              title: Text('Property'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0),
                      height: 220.0,
                      child: propertyPic == 'default' ?
                      Image.asset('assets/images/property_icon.png') :
                      Image.network(propertyPic)
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: Text(
                      propertyType,
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: Text(
                      '\$' + price,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: Stack(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: 15.0,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                          child: Text(
                            address,
                            style: TextStyle(
                                fontSize: 15.0
                            ),
                          ),
                        ),
                      ],
                    )
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Deal Type',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: Text(
                      dealType,
                      style: TextStyle(
                        fontSize: 15.0
                      ),
                    )
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(height: 5.0,),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 15.0
                      ),
                    )
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(13.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Sold by',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 17.0,
                                  height: 17.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: sellerProfilePic
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.0,),
                                Text(
                                  sellerName,
                                  style: TextStyle(
                                    fontSize: 15.0
                                  ),
                                )
                              ],
                            )
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                            child: Text(
                              'Date Posted',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Container(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                            child: Text(
                              date,
                              style: TextStyle(
                                fontSize: 15.0
                              ),
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0,),
                  FormSubmitButton(
                    text: 'Contact Seller',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => _bottomSheet(sellerEmail, sellerPhoneNumber))
                      );
                    },
                  ),
                  SizedBox(height: 10.0,),
                ],
              ),
            ),
          );
        } else {
          return Loading();
        }
      }
    );
  }
}
