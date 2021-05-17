import 'package:dynasty/app/my_properties.dart';
import 'package:dynasty/app/property_page.dart';
import 'package:dynasty/common_widgets/loading.dart';
import 'package:dynasty/common_widgets/no_property_text.dart';
import 'package:dynasty/modals/property.dart';
import 'package:dynasty/modals/user.dart';
import 'package:dynasty/services/auth.dart';
import 'package:dynasty/services/database.dart';
import 'package:favorite_button/favorite_button.dart';
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
          List <String>favourites = userData.favourites;
          void addFavourite(String pid) {
            favourites.add(pid);
            DatabaseService(uid: uid).updateFavourites(favourites);
          }
          void removeFavourite(String pid) {
            favourites.remove(pid);
            DatabaseService(uid: uid).updateFavourites(favourites);
          }
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
                      Container(
                        padding: EdgeInsets.fromLTRB(350.0, 13.0, 0.0, 0.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.account_balance_sharp,
                            color: Colors.green[900],
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => MyProperties()
                              )
                            );
                          },
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
                                          GestureDetector(
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                              height: 100.0,
                                              child: propertyList[index].propertyPic == 'default' ?
                                              Image.asset('assets/images/property_icon.png') :
                                              Image.network(propertyList[index].propertyPic)
                                            ),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute<void>(
                                                  builder: (context) => PropertyPage(
                                                    propertyPic: propertyList[index].propertyPic,
                                                    propertyType: propertyList[index].propertyType,
                                                    description: propertyList[index].description,
                                                    location: propertyList[index].location,
                                                    address: propertyList[index].address,
                                                    dealType: propertyList[index].dealType,
                                                    price: propertyList[index].price,
                                                    date: propertyList[index].date,
                                                    uid: propertyList[index].uid,
                                                  ),
                                                )
                                              );
                                            },
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
                                           padding: EdgeInsets.fromLTRB(350.0, 10.0, 0.0, 0.0),
                                           child: FavoriteButton(
                                             iconSize: 30.0,
                                             valueChanged: (_isFavorite) {
                                               print('Is Favorite $_isFavorite)');
                                             },
                                           )
                                         ),
                                         /* Container(
                                            padding: EdgeInsets.fromLTRB(340.0, 0.0, 10.0, 10.0),
                                            child: IconButton(
                                              iconSize: 20.0,
                                              icon: Icon(
                                                Icons.favorite_border,
                                              ),
                                              onPressed: () {
                                                /*if (favourites.contains(propertyList[index].pid)) {
                                                  removeFavourite(propertyList[index].pid);
                                                } else {
                                                  addFavourite(propertyList[index].pid);
                                                }*/
                                              },
                                            ),
                                          ),*/
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
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                      propertyList[index].dealType
                                                  )
                                                ),
                                                Container(
                                                  child: Text(
                                                    '\$' + propertyList[index].price
                                                  ),
                                                ),
                                              ],
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

