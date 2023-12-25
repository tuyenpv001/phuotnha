import 'package:flutter/material.dart';

class SearchMap extends StatefulWidget {
  const SearchMap({super.key});

  @override
  State<SearchMap> createState() => _SearchMapState();
}

class _SearchMapState extends State<SearchMap> {
  final TextEditingController pickUpTextEditingController = TextEditingController();
  final TextEditingController destinationTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return 
      Column(
        children: [
          Container(
   
            decoration: const BoxDecoration(
              color: Colors.black12,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7)
                )
              ]
            ),
            child: Padding(
              padding:const  EdgeInsets.all(0.8),
              child: Column(
                children: [
                  // Pickup address
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius:  BorderRadius.circular(5),

                    ),
                    child: Padding(padding: const EdgeInsets.all(3),
                    child: TextField(
                      controller: pickUpTextEditingController,
                      decoration: const InputDecoration(
                        hintText: "Pick up address",
                        fillColor: Colors.white12,
                        filled: true,
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          left: 11,top: 9,bottom: 9
                        )
                      ),
                    ),
                    
                    ),

                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  // destination address
                  Container(
                    decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: TextField(
                    controller: destinationTextEditingController,
                    decoration: const InputDecoration(
                        hintText: "Destination address",
                        fillColor: Colors.white12,
                        filled: true,
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 11, top: 9, bottom: 9)),
                  ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      );

  }
}