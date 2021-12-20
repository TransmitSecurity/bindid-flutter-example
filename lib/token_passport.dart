import 'package:flutter/material.dart';

class TokenPassport extends StatelessWidget {

  final Map<dynamic, dynamic> tokenItems;

  const TokenPassport({Key? key, required this.tokenItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your token data'),
      ),
      body:
      ListView.builder(
        itemBuilder: (context, position) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                        const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
                        child: Text(
                          tokenItems.keys.elementAt(position),
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
                        child: Text(
                        tokenItems.values.elementAt(position).toString(),
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                  ),
                ],
              ),
              const Divider(
                height: 2.0,
                color: Colors.grey,
              )
            ],
          );
        },
        itemCount: tokenItems.length,
      ),
    );
  }
}