import 'package:flutter/material.dart';

class KeyCard extends StatelessWidget {
  TextEditingController textController;
  bool active;
  IconData iconData;
  String type;
  KeyCard({super.key,
    required this.textController,
    required this.active,
    required this.iconData,
    required this.type
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 290,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1)
      ),
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
                      Expanded(
                          child: Text("Chave $type",
                            style: TextStyle(
                                fontSize: 25,
                              fontWeight: FontWeight.w200
                            ),
                          ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: (){},
                                    icon: Icon(Icons.upload, color: Colors.white,),
                                    label: Text("Upload",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.indigoAccent,
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)
                                        )
                                    ),
                                  ),
                              ),
                              SizedBox(width: 8,),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: active ? (){} : null,
                                  icon: Icon(Icons.download, color: Colors.white,),
                                  label: Text("Download",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.indigoAccent,
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8,),
          TextFormField(
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
        ],
      ),
    );
  }
}
