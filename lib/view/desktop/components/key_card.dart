import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class KeyCard extends StatelessWidget {
  TextEditingController textController;
  bool active;
  IconData iconData;
  KeyCard({super.key,
    required this.textController,
    required this.active,
    required this.iconData
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1)
      ),
      child: Expanded(
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0
                      ),
                    ),
                    child: Center(
                      child: active ?
                      Icon( iconData, size: 80,) :
                      Icon( iconData, size: 80, color: Colors.black12,),
                      // Text("Gerar chave"),
                    ),
                  ), // ChaveIcon
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text("Chave")),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(onPressed: (){}, child: Text("Download")),
                              ElevatedButton(onPressed: (){}, child: Text("Upload"))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TextFormField(
                readOnly: true,
                maxLines: 6,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Texto criptografado",
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8
                  )
                ),
                controller: textController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
