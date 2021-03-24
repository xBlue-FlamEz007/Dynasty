import 'package:dynasty/common_widgets/no_property_text.dart';
import 'package:dynasty/modals/property.dart';
import 'package:dynasty/services/auth.dart';
import 'package:dynasty/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProperties extends StatefulWidget {
  @override
  _MyPropertiesState createState() => _MyPropertiesState();
}

class _MyPropertiesState extends State<MyProperties> {

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    String uid = auth.currentUserID();

    return StreamBuilder<Object>(
        stream: DatabaseService(uid: uid).myProperties,
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
    );
  }
}
