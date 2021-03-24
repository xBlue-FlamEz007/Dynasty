import 'package:dynasty/common_widgets/loading.dart';
import 'package:dynasty/common_widgets/no_property_text.dart';
import 'package:dynasty/common_widgets/platform_alert_dialog.dart';
import 'package:dynasty/modals/property.dart';
import 'package:dynasty/modals/user.dart';
import 'package:dynasty/services/auth.dart';
import 'package:dynasty/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum PropertyDealType { both, sell, rent }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ScrollController _scrollController = ScrollController();
  PropertyDealType _propertyDealType = PropertyDealType.both;
  List <PropertyData> temp = [
    PropertyData(pid: '1', propertyPic: 'assets/images/property_icon.png', propertyType: 'Office',
    description: 'Nice', address: 'Scranton', dealType: 'sell', price: '10000', uid: '1814011'),
    PropertyData(pid: '2', propertyPic: 'assets/images/property_icon.png', propertyType: 'Apartment',
        description: 'asfsafsd', address: 'Kharghar', dealType: 'rent', price: '2340', uid: '1814033'),
    PropertyData(pid: '3', propertyPic: 'assets/images/property_icon.png', propertyType: 'Apartment',
        description: 'Nice', address: 'Scranton', dealType: 'sell', price: '10000', uid: '1814015'),
    PropertyData(pid: '4', propertyPic: 'assets/images/property_icon.png', propertyType: 'Warehouse',
        description: 'asasaswewe', address: 'Scranton', dealType: 'rent', price: '100', uid: '1814012'),
    PropertyData(pid: '4', propertyPic: 'assets/images/property_icon.png', propertyType: 'Warehouse',
        description: 'asasaswewe', address: 'Scranton', dealType: 'rent', price: '100', uid: '1814012'),
    PropertyData(pid: '4', propertyPic: 'assets/images/property_icon.png', propertyType: 'Warehouse',
        description: 'asasaswewe', address: 'Scranton', dealType: 'rent', price: '100', uid: '1814012'),
    PropertyData(pid: '4', propertyPic: 'assets/images/property_icon.png', propertyType: 'Warehouse',
        description: 'asasaswewe', address: 'Scranton', dealType: 'rent', price: '100', uid: '1814012')
  ];

  GestureDetector _propertyTypeDetector(String typeName, FontWeight weight, double size,
      PropertyDealType dealType) {
    return GestureDetector(
      child: Text(
        typeName,
        style: TextStyle(
          fontWeight: weight,
          fontSize: size,
        ),
      ),
      onTap: () {
        setState(() {
          _propertyDealType = dealType;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthBase>(context, listen: false);
    String uid = auth.currentUserID();

    return StreamBuilder<Object>(
      stream: DatabaseService(uid: uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          String firstName = userData.firstName;
          var profilePic = userData.profilePic ==  'default' ?
          AssetImage('assets/images/default_profilepic.png') : NetworkImage(userData.profilePic);
          var bothWeight, sellWeight, rentWeight, bothSize, sellSize, rentSize;
          Stream propertyStream;
          if (_propertyDealType == PropertyDealType.both) {
            bothWeight = FontWeight.bold;
            sellWeight = FontWeight.normal;
            rentWeight = FontWeight.normal;
            bothSize = 20.0;
            sellSize = 15.0;
            rentSize = 15.0;
            propertyStream = DatabaseService(uid: uid).allProperties;
          } else if (_propertyDealType == PropertyDealType.sell) {
            bothWeight = FontWeight.normal;
            sellWeight = FontWeight.bold;
            rentWeight = FontWeight.normal;
            bothSize = 15.0;
            sellSize = 20.0;
            rentSize = 15.0;
            propertyStream = DatabaseService(uid: uid).sellProperties;
          } else {
            bothWeight = FontWeight.normal;
            sellWeight = FontWeight.normal;
            rentWeight = FontWeight.bold;
            bothSize = 15.0;
            sellSize = 15.0;
            rentSize = 20.0;
            propertyStream = DatabaseService(uid: uid).rentProperties;
          }

          return Scaffold(
            backgroundColor: Colors.grey[200],
            body: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Stack(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: profilePic
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(70.0, 25.0, 0.0, 0.0),
                        child: Text(
                          firstName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20.0, 75.0, 0.0, 0.0),
                    child: Row(
                      children: <Widget>[
                        _propertyTypeDetector('Both', bothWeight, bothSize, PropertyDealType.both),
                        SizedBox(width: 10.0,),
                        _propertyTypeDetector('Sell', sellWeight, sellSize, PropertyDealType.sell),
                        SizedBox(width: 10.0,),
                        _propertyTypeDetector('Rent', rentWeight, rentSize, PropertyDealType.rent),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 110.0),
                    child: Scrollbar(
                      isAlwaysShown: true,
                      controller: _scrollController,
                      child: StreamBuilder<Object>(
                        stream: propertyStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<PropertyData> propertyList = snapshot.data;

                            return ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: propertyList.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Center(
                                    child: Container(
                                      width: 380,
                                      color: Colors.white,
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                            height: 100.0,
                                            child: propertyList[index].propertyPic == 'default' ?
                                            Image.asset('assets/images/property_icon.png') :
                                            Image.network(propertyList[index].propertyPic)
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(100.0, 10.0, 10.0, 10.0),
                                            child: Text(
                                              propertyList[index].propertyType,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(330.0, 0.0, 10.0, 10.0),
                                            child: IconButton(
                                              iconSize: 20.0,
                                              icon: Icon(
                                                Icons.favorite_border,
                                              ),
                                              onPressed: () {},
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(100.0, 30.0, 10.0, 10.0),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.location_on,
                                                  size: 10.0,
                                                ),
                                                Text(
                                                  propertyList[index].location
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              padding: EdgeInsets.fromLTRB(105.0, 70.0, 10.0, 10.0),
                                              child: Text(
                                                propertyList[index].dealType
                                              )
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(315.0, 70.0, 10.0, 10.0),
                                            child: Text(
                                              '\$' + propertyList[index].price
                                            ),
                                          ),
                                        ]
                                      ),
                                    ),
                                  )
                                );
                              },
                            );
                          } else {
                            return NoPropertyText();
                          }
                        }
                      ),
                    )
                  ),
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

