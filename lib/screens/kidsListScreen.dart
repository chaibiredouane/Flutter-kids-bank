import 'package:first/models/kidModel.dart';
import 'package:first/screens/sideDrawer.dart';
import 'package:first/services/database.dart';
import 'package:first/services/kidService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KidsListScreeen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Kid>>.value(
      initialData: [],
      value: KidService().kids,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chaibi Family"),
        ),
        drawer: SideDrawer(),
        body: KidsList(),
      ),
    );
  }
}

class KidsList extends StatefulWidget {
  const KidsList({Key? key}) : super(key: key);

  @override
  _KidsListState createState() => _KidsListState();
}

class _KidsListState extends State<KidsList> {
  @override
  Widget build(BuildContext context) {
    final kids = Provider.of<List<Kid>>(context);
    return ListView.builder(
        itemCount: kids.length,
        itemBuilder: (context, index) {
          return KidsItemWidget(kids[index]);
        });
  }
}

class KidsItemWidget extends StatelessWidget {
  const KidsItemWidget(this.kid) : super();
  final Kid kid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/details', arguments: kid);
      },
      child: Card(
        margin: EdgeInsets.all(8),
        elevation: 10,
        child: Row(
          children: [
            Hero(
              tag: "imageKid" + kid.uid.toString(),
              child: CircleAvatar(
                backgroundImage: AssetImage(kid.imageUrl!),
                radius: 50,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      kid.firstName! + ' ' + kid.lastName!,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Text(
                    'Solde : ' + kid.solde.toString(),
                    style: TextStyle(color: Colors.grey[500]),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
