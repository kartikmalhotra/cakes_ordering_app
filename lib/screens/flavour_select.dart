import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:foodeasecakes/models/cakes_model.dart';

class FlavourDropDown extends StatefulWidget {
  final List<String> flavourList;
  final Function(String) selectedFlavour;

  const FlavourDropDown({
    Key? key,
    required this.flavourList,
    required this.selectedFlavour,
  }) : super(key: key);

  @override
  State<FlavourDropDown> createState() => FlavourDropDownState();
}

class FlavourDropDownState extends State<FlavourDropDown> {
  List<String> flavourList = <String>[];
  String? _selectedFlavour;

  @override
  void initState() {
    flavourList = widget.flavourList;
    if (flavourList.isNotEmpty) {
      _selectedFlavour = flavourList.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
        border: Border.all(width: 0.2),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButton<String>(
        value: _selectedFlavour,
        icon: const Icon(Icons.arrow_downward_outlined),
        elevation: 16,
        underline: Container(),
        borderRadius: BorderRadius.circular(20.0),
        style: const TextStyle(color: Colors.deepPurple),
        onChanged: (String? value) {
          setState(() {
            _selectedFlavour = value!;
            widget.selectedFlavour(_selectedFlavour!);
          });
        },
        items: flavourList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value.toString(),
                style: Theme.of(context).textTheme.bodyText1),
          );
        }).toList(),
      ),
    );
  }
}
