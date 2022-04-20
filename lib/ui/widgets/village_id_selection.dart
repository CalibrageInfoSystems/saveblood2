import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_logindemo/ui/models/states_model.dart';
import 'package:http/http.dart';

import '../api_config.dart';

 
class VillageSelectionDropdown extends StatefulWidget {





  @override
  _VillageSelectionDropdownState createState() =>
      _VillageSelectionDropdownState();
}

class _VillageSelectionDropdownState extends State<VillageSelectionDropdown> {

 AddressItemModel stateselected;
 AddressItemModel distsselected;
 AddressItemModel mandalselected;
AddressItemModel villagelistselected;

  _VillageSelectionDropdownState();


  List<AddressItemModel> _stateslist;
  List<AddressItemModel> _distslist = new List<AddressItemModel>();
  List<AddressItemModel> _mandalslist = new List<AddressItemModel>();//
  List<AddressItemModel> _villagelist = new List<AddressItemModel>();
  @override
  void initState() {
    super.initState();
    stateselected = null;
    distsselected = null;
    mandalselected = null;
    villagelistselected = null;
    getstates();
  }

  @override
  Widget build(BuildContext context) {
    return addressForm();
  }

 Widget addressForm()
 {
   return Column(
      children: <Widget>[
        statesDropdown(), 
        distsDropdown(),
        mandalsDropdown(),
        villagesDropdown()
      ]
    );
 }
  
  Widget statesDropdown() {
    return Material(
      borderRadius: BorderRadius.circular(25.0),
      elevation: 12,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: Column(children: <Widget>[
          DropdownButton<AddressItemModel>(
            hint: Text('select states '),
            isExpanded: true,
            value: stateselected,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 12,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (AddressItemModel newValue) {
              setState(() {
                mandalselected = null;
                distsselected = null;
                villagelistselected =null;
                stateselected = newValue;
                
                getDistsbystateid(newValue.id);
              });
            },
            items: _stateslist.map((AddressItemModel user) {
              return new DropdownMenuItem<AddressItemModel>(
                value: user,
                child: new Text(
                  user.name,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }
  Widget distsDropdown() {
    return Material(
      borderRadius: BorderRadius.circular(25.0),
      elevation: 12,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child:Column(children: <Widget>[
          DropdownButton<AddressItemModel>(
            hint: Text('select dist'),
            isExpanded: true,
            value: distsselected,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 12,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (AddressItemModel newValue) {
              setState(() {
                mandalselected = null;
                villagelistselected =null;
                getMandalsbyDistid(newValue.id);
                if(newValue == null)
                {

                }else
                {
                   distsselected = newValue;
                    
                }
               
                //distsselected = newValue;
                // getDistsbystateid(newValue.id);
              });
            },
            items: _distslist.map((AddressItemModel user) {
              return new DropdownMenuItem<AddressItemModel>(
                value: user,
                child: new Text(
                  user.name,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }
  Widget mandalsDropdown() {
    return Material(
      borderRadius: BorderRadius.circular(25.0),
      elevation: 12,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: Column(children: <Widget>[
          DropdownButton<AddressItemModel>(
            hint: Text('Select Madal '),
            isExpanded: true,
            value: mandalselected,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 12,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (AddressItemModel newValue) {
              villagelistselected =null;
              setState(() {
                if(newValue == null)
                {

                }else
                {
                   mandalselected = newValue;
                }
                getvillaagebyMandalid(newValue.id);
                //distsselected = newValue;
                // getDistsbystateid(newValue.id);
              });
            },
            items:_mandalslist.map((AddressItemModel user) {
              return new DropdownMenuItem<AddressItemModel>(
                value: user,
                child: new Text(
                  user.name,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }
  Widget villagesDropdown() {
    return Material(
      borderRadius: BorderRadius.circular(25.0),
      elevation: 12,
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 0.80),
        ),
        child: Column(children: <Widget>[
          DropdownButton<AddressItemModel>(
            hint: Text('Select Village '),
            isExpanded: true,
            value: villagelistselected,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 12,
            style: TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (AddressItemModel newValue) {
              setState(() {
                if(newValue == null)
                {

                }else
                {
                   villagelistselected = newValue;
                }
                //distsselected = newValue;
                // getDistsbystateid(newValue.id);
              });
            },
            items:_villagelist.map((AddressItemModel user) {
              return new DropdownMenuItem<AddressItemModel>(
                value: user,
                child: new Text(
                  user.name,
                  style: new TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ]),
      ),
    );
  }

  Future<void> getstates() async {
    List<AddressItemModel> statelist = new List<AddressItemModel>();
    Response res = await get(baseUrl + getStatesByCountryComponentUrl);

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      for (int i = 0; i < items.length; i++) {
        print(items[i]['name']);
        statelist.add(
            new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
      }
      setState(() {
        _stateslist = statelist;
      });
    } else {
      return null;
    }
  }
  Future<void> getDistsbystateid(int stateid) async {
    List<AddressItemModel> distslist = new List<AddressItemModel>();
    Response res = await get(
        baseUrl + getDistrictsByStateComponentUrl + stateid.toString());

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      for (int i = 0; i < items.length; i++) {
        print(items[i]['name']);
        distslist.add(
            new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
      }
      setState(() {
        _distslist = distslist;
      });
    } else {
      return null;
    }
  }
  Future<void> getMandalsbyDistid(int distid) async {
    List<AddressItemModel> mandalslist = new List<AddressItemModel>();

    var url = baseUrl + getMandalsByDistrictComponentUrl + '/' + distid.toString();
    print('API :'+url);
    Response res = await get(url );

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      for (int i = 0; i < items.length; i++) {
        print(items[i]['name']);
        mandalslist.add(
            new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
      }
      setState(() {
        if(mandalslist !=null)
        {
        _mandalslist = mandalslist;
        }
       
      });
    } else {
      return null;
    }
  }
  Future<void> getvillaagebyMandalid(int mandalis) async {
    List<AddressItemModel> villagelist = new List<AddressItemModel>();

    var url = baseUrl + getVillagesByMandalComponentUrl + '/' + mandalis.toString();
    print('API :'+url);
    Response res = await get(url );

    int statusCode = res.statusCode;
    String responseBody = res.body;

    if (statusCode == 200) {
      Map<String, dynamic> parsedMAP = json.decode(responseBody);

      var items = parsedMAP['listResult'] as List;
      for (int i = 0; i < items.length; i++) {
        print(items[i]['name']);
        villagelist.add(
            new AddressItemModel(id: items[i]['id'], name: items[i]['name']));
      }
      setState(() {
        if(villagelist !=null)
        {
        _villagelist = villagelist;

        }
       
      });
    } else {
      return null;
    }
  }
}
