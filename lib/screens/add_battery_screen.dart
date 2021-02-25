import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_battery/helpers/database_helpers.dart';
import 'package:sqflite_battery/models/BatteryModels.dart';

class AddBatteryScreen extends StatefulWidget {
  final Function updateBatteryList;
  final Battery battery;
  AddBatteryScreen({this.battery, this.updateBatteryList});

  @override
  _AddBatteryScreenState createState() => _AddBatteryScreenState();
}

class _AddBatteryScreenState extends State<AddBatteryScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _batteryType = '';
  DateTime _purchaseData = DateTime.now();
  String _numberOfCharge = '';
  String _storageLocation = '';
  DateTime _date = DateTime.now();
  String _chargeStatus;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _purchaseDateContorller = TextEditingController();
  final DateFormat _dateFormatter = DateFormat('MMM dd,yyyy');
  final List<String> _chargeStatuss = ['Empty', 'Full'];

  @override
  void initState() {
    super.initState();
    if (widget.battery != null) {
      _name = widget.battery.name;
      _date = widget.battery.date;
      _batteryType = widget.battery.batteryType;
      _storageLocation = widget.battery.storageLocation;
      _purchaseData = widget.battery.purchaseData;
      _numberOfCharge = widget.battery.numberOfCharge;
      _chargeStatus = widget.battery.chargeStatus;
    }
    _dateController.text = _dateFormatter.format(_date);
    _purchaseDateContorller.text = _dateFormatter.format(_purchaseData);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _purchaseDateContorller.dispose();
    super.dispose();
  }

  _handleDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
    );

    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      _dateController.text = _dateFormatter.format(_date);
    }
  }

  _handleDatePickerForPurchaseDate() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _purchaseData,
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
    );
    if (date != null && date != _date) {
      setState(() {
        _purchaseData = date;
      });
      _purchaseDateContorller.text = _dateFormatter.format(_purchaseData);
    }
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      //Insert and update the Task to user Database
      Battery battery = Battery(
        name: _name,
        date: _date,
        batteryType: _batteryType,
        storageLocation: _storageLocation,
        chargeStatus: _chargeStatus,
        numberOfCharge: _numberOfCharge,
        purchaseData: _purchaseData,
      );

      if (widget.battery == null) {
        DatabaseHelper.instance.insertBattery(battery);
      } else {
        battery.id = widget.battery.id;
        DatabaseHelper.instance.updateBattery(battery);
      }
      widget.updateBatteryList();
      Navigator.pop(context);
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteBattery(widget.battery.id);
    widget.updateBatteryList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  widget.battery == null ? "Add Battery" : "Update Battery",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelStyle: TextStyle(fontSize: 18),
                            labelText: 'Battery Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (input) => input.trim().isEmpty
                              ? "Enter a Battery Name"
                              : null,
                          onSaved: (input) => _name = input,
                          initialValue: _name,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelStyle: TextStyle(fontSize: 18),
                            labelText: 'Battery Type',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (input) => input.trim().isEmpty
                              ? "Enter a Battery Type"
                              : null,
                          onSaved: (input) => _batteryType = input,
                          initialValue: _batteryType,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: _purchaseDateContorller,
                          style: TextStyle(fontSize: 18.0),
                          onTap: _handleDatePickerForPurchaseDate,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelStyle: TextStyle(fontSize: 18),
                            labelText: "Purchase Date",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelStyle: TextStyle(fontSize: 18),
                            labelText: 'Number of Charges',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (input) => input.trim().isEmpty
                              ? "Enter a Number of Charges"
                              : null,
                          onSaved: (input) => _numberOfCharge = input,
                          initialValue: _numberOfCharge,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: DropdownButtonFormField(
                          isDense: true,
                          icon: Icon(Icons.arrow_drop_down_circle),
                          iconSize: 22,
                          iconEnabledColor: Theme.of(context).primaryColor,
                          items: _chargeStatuss.map((String _chargeStatus) {
                            return DropdownMenuItem(
                              value: _chargeStatus,
                              child: Text(
                                _chargeStatus,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            );
                          }).toList(),
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelStyle: TextStyle(fontSize: 18),
                            labelText: 'Charge Status',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (input) => _chargeStatus == null
                              ? "Select Charge Status"
                              : null,
                          onChanged: (value) {
                            setState(() {
                              _chargeStatus = value;
                            });
                          },
                          value: _chargeStatus,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: _dateController,
                          style: TextStyle(fontSize: 18.0),
                          onTap: _handleDatePicker,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelStyle: TextStyle(fontSize: 18),
                            labelText: "Last Charge Date",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusColor: Colors.red,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18.0),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelStyle: TextStyle(fontSize: 18),
                            labelText: 'Storage Location',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (input) => input.trim().isEmpty
                              ? "Enter a Storage Location"
                              : null,
                          onSaved: (input) => _storageLocation = input,
                          initialValue: _storageLocation,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20.0),
                        height: 60.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: FlatButton(
                          child: Text(
                            widget.battery == null ? "Add" : "Update",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          onPressed: _submit,
                        ),
                      ),
                      widget.battery != null
                          ? Container(
                              margin: EdgeInsets.symmetric(vertical: 20.0),
                              height: 60.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: FlatButton(
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                                onPressed: _delete,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
