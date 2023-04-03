import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final List<dynamic> images;
  final Function(List<dynamic>) onFilter;

  const SearchBar({Key? key, required this.images, required this.onFilter})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String _filterText = '';

  List<dynamic> get filteredNames {
    return widget.images.where((name) {
      return name['name'].toLowerCase().contains(_filterText.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
            ),
            onTap: () {},
            onChanged: (text) {
              setState(() {
                _filterText = text;
                widget.onFilter(filteredNames);
              });
            },
          ),
        ));
  }
}
