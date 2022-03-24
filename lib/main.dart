import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/services.dart';
import 'package:flare_flutter/flare_actor.dart';

void main()=>runApp(TabsApp());

class TabsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Splash()
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() { 
    super.initState();
    Future.delayed(Duration(seconds:4),(){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=>Tabs())
         );
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlareActor("flare/encryptanimation.flr",alignment: Alignment.center,fit: BoxFit.contain,animation:"Untitled"),
      backgroundColor: Colors.black,
    );
  }
}



class Tabs extends StatefulWidget {
  const Tabs({Key key}): super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
    String encryptedtext = "";
  String text="";
  String secret="";
  String decrypttext="";
  String secret1="";
  String textt="";
  String decryptedtext ="decrypted text";
  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
Padding(
          padding: const EdgeInsets.all(25),
          child: ListView(
              children: [
                SizedBox(height:60),
                TextField(
                    onChanged: (val) {
                      text = val;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter the text to encrypt",
                    )),
                TextField(
                    onChanged: (sl) {
                      secret = sl;
                    },
                    decoration:
                        InputDecoration(hintText: "Enter the key to encrypt")),
                SizedBox(height: 20),
                RaisedButton(
                  onPressed: () {
                    if (secret != null && secret.isNotEmpty) {
                      String secretadd= "saifjckjfklasjdhfljaskldjhflaksj";
                      final key = encrypt.Key.fromUtf8(secret+secretadd.substring(0,32-secret.length));
                      final iv = encrypt.IV.fromLength(16);
                      debugPrint("entered");
                      var enc = encrypt.Encrypter(encrypt.AES(key));
                      final encrypted = enc.encrypt(text, iv: iv);
                      debugPrint(encrypted.toString());
                      setState(() {
                        encryptedtext = encrypted.base64;
                      });
                    }
                  },
                  child: Text("Encrypt text",
                      style: TextStyle(color: Colors.white)),
                  color: Colors.blue,
                ),
                Text(encryptedtext),
                SizedBox(height: 30),
                Builder(builder: (context) {
                  return InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: encryptedtext));
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Text copied successfully")));
                      },
                      child: Text("COPY THIS",
                          style: TextStyle(color: Colors.blue)));
                }),
                SizedBox(height: 30)
              ]),
        ),
      Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(
              children: [
                SizedBox(height:60),
                TextField(
                  onChanged: (val){
                    decrypttext=val;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter the text",
                  ),
                ),
                TextField(
                  onChanged: (val){
                    secret1=val;
                  },
                  decoration:
                      InputDecoration(hintText: "Enter the key to decrypt"),
                ),
                SizedBox(height: 20),
                RaisedButton(
                  onPressed: () {
                     if (secret1.isNotEmpty) {
                      String secretadd= "sailasdjfklasjdhfljaskldjhflaksj";
                      final key = encrypt.Key.fromUtf8(secret1+secretadd.substring(0,32-secret1.length));
                      final iv = encrypt.IV.fromLength(16);
                      debugPrint("entered");
                      var enc = encrypt.Encrypter(encrypt.AES(key));
                     var d= enc.decrypt(encrypt.Encrypted.fromBase64(decrypttext),iv: iv );
                     debugPrint(d);
                     setState(() {
                       textt=d;
                     });
                  }
                  },
                  child: Text(
                    "Decrypt text",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                ),
                Text(textt)
              ]),
        )
    ];
    final _kTabs= <Tab> [
      Tab(icon: Icon(Icons.security),text:'ENCRYPT'),
      Tab(icon: Icon(Icons.settings_backup_restore),text:'DECRYPT')
    ];
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("SECURE DATA",style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          bottom: TabBar(tabs: _kTabs),
        ),
        body: TabBarView(
          children: _kTabPages,
        ),
      ),
    );
  }
}
