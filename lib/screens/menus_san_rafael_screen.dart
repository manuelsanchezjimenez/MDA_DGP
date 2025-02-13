import 'dart:ui';
import 'package:app_dgp/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../components/arrow_button.dart';
import '../components/menus_san_rafael_button.dart';
import '../models/ActivityImageDbModel.dart';
import '../models/comanda_menu_model.dart';
import '../models/menu_model.dart';
import '../mongodb.dart';


class MenuComedorScreen extends StatefulWidget{
  final menu_comanda;
  final dataImage;
  MenuComedorScreen({required this.menu_comanda, required this.dataImage});
  @override
  _MenuComedor createState() => _MenuComedor();
}

class _MenuComedor extends State<MenuComedorScreen> {
  late List<String> splitted;
  late List<Menu> menu_model = [];

  late int cont;
  final int limit_list= 4;
  late int limit = limit_list;
  late int length;
  //bool _flag = true;

  void initState(){
    super.initState();
    splitted = ComandaMenuDbModel.fromJson(widget.menu_comanda[0]).descripcion.split('\n');

    for(int i=0; i<splitted.length; i++){
      Menu menu = Menu(tipo: splitted[i], cantidad: 0);
      menu_model.add(menu);
    }
    setState(() {
      cont = 0;
      length = menu_model.length;
    });
  }

  AppBar buildAppBar(){
    return AppBar(
      backgroundColor: kPrimaryColor,
      elevation: 0,
      leading: Transform.scale(
          scale: 2.5,
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )
      ),
      title: Text(
        "Tarea Comedor",
        style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: kPrimaryWhite,
            fontFamily: 'Escolar'
        ),
      ),
      centerTitle: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    Size size =  MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: kPrimaryWhite,
        appBar: buildAppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top:10),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  //color: Colors.pink,
                    width: size.width*0.95,
                    height: size.height*0.8,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ArrowButton(
                              heroTag: "btn_back",
                              icon: Icons.arrow_back,
                              onPressed: () async{
                                int length = menu_model.length;
                                if(length > limit_list) {
                                  setState(() {
                                    cont -= 4;
                                    length += 4;
                                    if(cont == -4){
                                      cont = 0;
                                    }
                                  });
                                  if(length > limit_list){
                                    setState(() {
                                      limit=limit_list;
                                    });
                                  }
                                }
                              },
                              tooltip: "Anterior"
                          ),
                          Container(
                            //color: Colors.lightGreen,
                            width: size.width*0.73,
                            child: ListView.builder(
                              itemCount: limit,
                              itemBuilder: (context, index) {
                                //final pd = widget.cart.productsCart[index];
                                return buildMenuTile(menu_model[index+cont], cont+index+1);
                              },
                            ),
                          ),
                          ArrowButton(
                              heroTag: "btn_forward",
                              icon: Icons.arrow_forward,
                              onPressed: () async{
                                print(widget.dataImage[0].toString());
                                if(cont == 0){
                                  length = menu_model.length;
                                }
                                if(length > limit_list) {
                                  setState(() {
                                    cont += 4;
                                    length-= 4;
                                  });
                                  if(cont == menu_model.length){
                                    cont = menu_model.length-limit_list;
                                  }
                                  if(length < limit_list){
                                    print(length);
                                    setState(() {
                                      limit=length;
                                    });
                                  }
                                }
                              },
                              tooltip: "Siguiente"
                          )
                        ],
                      ),
                    )
                ),
              ),
            ),
            Container(
               child: Padding(
                 padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                 child:  Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Container(
                       width: size.width*0.2,
                       height: size.height*0.08,
                       child: ElevatedButton(
                         onPressed: ComandaMenuDbModel.fromJson(widget.menu_comanda[0]).completado ? null : ()=> _showDialog(context),//{
                           /*if(!(ComandaMenuDbModel.fromJson(widget.menu_comanda[0]).completado)){
                             _showDialog(context);
                           }*/

                         child: Text("Enviar",
                           style: TextStyle(fontFamily: 'Escolar', fontSize: 30, fontWeight: FontWeight.bold),
                         ),
                         style: ElevatedButton.styleFrom(
                           backgroundColor: !ComandaMenuDbModel.fromJson(widget.menu_comanda[0]).completado ? Colors.green : Colors.grey,
                         ),
                       ),
                     ),
                     Transform.scale(
                       scale: 1.6,
                       child: SpeedDial(
                         animatedIcon: AnimatedIcons.menu_close,
                         backgroundColor: kPrimaryColor,
                         icon: Icons.share,
                         children: [
                           SpeedDialChild(
                         child:Image.asset("assets/ok.png"),
                             backgroundColor: kPrimaryLightColor,
                             //labelShadow: BoxShadow(color: kPrimaryColor, blurRadius: 20) ,
                             label: '¡Hecho!',
                             labelStyle: TextStyle(fontFamily: 'Escolar', fontSize: 20, fontWeight: FontWeight.bold),
                             onTap: (){
                                String msg = '¡Hecho!';
                                MongoDatabase.updateUserComment(ComandaMenuDbModel.fromJson(widget.menu_comanda[0]).id,msg);
                             }
                           ),
                           SpeedDialChild(
                             child:Image.asset("assets/necesito_ayuda.png"),
                             backgroundColor: kPrimaryLightColor,
                             label: '¡Necesito ayuda!',
                             labelStyle: TextStyle(fontFamily: 'Escolar', fontSize: 20, fontWeight: FontWeight.bold),
                               onTap: (){
                                 String msg = '¡Necesito ayuda!';
                                 MongoDatabase.updateUserComment(ComandaMenuDbModel.fromJson(widget.menu_comanda[0]).id,msg);
                               }
                           ),
                           SpeedDialChild(
                             child:Image.asset("assets/no_se.png"),
                             backgroundColor: kPrimaryLightColor,
                             label: 'No sé hacerlo',
                             labelStyle: TextStyle(fontFamily: 'Escolar', fontSize: 20, fontWeight: FontWeight.bold),
                               onTap: (){
                                 String msg = 'No sé hacerlo';
                                 MongoDatabase.updateUserComment(ComandaMenuDbModel.fromJson(widget.menu_comanda[0]).id,msg);
                               }
                           )
                         ],
                       ),
                     ),
                   ],
                 ),
               )
            )
          ],
        )
    );
  }

  Widget buildMenuTile(Menu menu_item, int cont) {
    Size size =  MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: kPrimaryColor,
                width: 3
              ),
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
        //color: kPrimaryLightColor,
        height: size.height*0.185,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                  child: ActivityImageDbModel.fromJson(widget.dataImage[0]).imagen == ' ' ?
                  new Center(child: new Text("No hay imágenes", style: TextStyle(fontSize: 20)),) :
                  Image.asset('assets/menu/'+ActivityImageDbModel.fromJson(widget.dataImage[cont]).imagen),
                )
              ),
              Container(
                //color:Colors.redAccent,
                width: size.width*0.38,
                child: Center(
                  child: Text(menu_item.tipo,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Escolar'
                    ),
                  ),
                ),
              ),
              Expanded(
                child:Align(
                  alignment: Alignment.centerRight,
                  child:Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width*0.01),
                    child:Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MenusButton(
                            key: Key("decreaseItems"),
                            icon : Icons.remove,
                            onTap:(){
                              setState(() {
                                menu_item.reduceCantidad();
                              });
                            }//=>setState(()=>pd.decreaseItems()),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child:Container(
                            width: size.width*0.05,
                            height: size.height*0.1,
                            decoration: BoxDecoration(
                              color: kPrimaryWhite,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: kPrimaryColor,
                                width: 3
                              ),
                            ),
                            child: Center(
                              child: Text(
                                menu_item.cantidad.toString(),
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Escolar'
                                ),
                              ),
                            )
                          )
                        ),
                        MenusButton(
                          key: Key("increaseItems"),
                          icon : Icons.add,
                          onTap: (){
                            setState(() {
                              menu_item.aumentaCantidad();
                            });
                          },
                          //onTap:()=>setState(()=>pd.increaseItems()),
                        ),
                      ],
                    ),
                  )
                )
              )
            ],
          ),
        )
      )
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enviar tarea',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  //color: kPrimaryWhite,
                  fontFamily: 'Escolar'
              ),
            ),
            content: Text('¿Estás seguro de enviar la tarea?',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  //color: kPrimaryWhite,
                  fontFamily: 'Escolar'
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'NO',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      fontFamily: 'Escolar'
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {});
                  if(!(ComandaMenuDbModel.fromJson(widget.menu_comanda[0]).completado)){
                    MongoDatabase.updateActivityState(ComandaMenuDbModel.fromJson(widget.menu_comanda[0]).id);
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  'SI',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Escolar'
                  ),
                ),
              )
            ],
          );
        });
  }
}