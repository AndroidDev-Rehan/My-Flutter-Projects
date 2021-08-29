import 'package:favourite_quotes/quote.dart';
import 'package:favourite_quotes/quote_item.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';


late final database;
late final QuotesList quotesList;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'quotes_database.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE quotes(id TEXT PRIMARY KEY, text TEXT, author TEXT)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,

  );

  quotesList = await QuotesList.create(database);

  runApp(MyApp());

}



class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final myController1 = TextEditingController();
  final myController2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController1.dispose();
    myController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuotesList>(
      create: (context) => quotesList,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text(
              "My Favourite Quotes"
            ),
          ),
          body:
           Consumer(
               builder: (context,QuotesList data,child) {
             return
              Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      children: [
                        TextFormField(
                            controller: myController1,
                            decoration: InputDecoration(
                              hintText: "Enter the new Quote here.",
                              labelText: "Quote"
                          ),
                            // onChanged: (value){
                            //   quoteText = value.toString();
                            // }
                        ),
                        TextFormField(
                            controller: myController2,
                          decoration: InputDecoration(
                              hintText: "Enter the Author name here.",
                              labelText: "Author"
                          ),
                          // onChanged: (value){
                          //   authorText = value.toString();
                          // },
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                            onPressed: () async{
                              if(((myController1.text.toString())!="") && ((myController2.text.toString())!="")){
                                Quote quote = Quote(text: myController1.text.toString(), author: myController2.text.toString(), id: Uuid().v4());
//                              await insertQ(quote);
//                                Provider.of<QuotesList>(context,listen: false).insertQuote(quote);
                                quotesList.insertQuote(quote);
                                myController1.text = "";
                                myController2.text = "";
                              }
                            },
                            child: Text(
                                "Enter Quote"
                            )
                        ),
                      ]
                  ),
                ),
                quotesList.getList.isNotEmpty ?
                Expanded(child: MyQuotes())
                   :
                Expanded(
                  child: Center(
                    child: Text(
                      "NO QUOTES ADDED YET :)"
                    )
                  ),
                ),
              ],
             );
               }
          ),
        ),
      ),
    );
  }
}

class MyQuotes extends StatefulWidget {
  const MyQuotes({Key? key}) : super(key: key);

  @override
  _MyQuotesState createState() => _MyQuotesState();
}

class _MyQuotesState extends State<MyQuotes> {
  @override
  Widget build(BuildContext context) {
           return ListView.builder(
            itemCount: quotesList.getList.length,
            itemBuilder: (context,index) {
              return QuoteItem(quote: quotesList.getList[index]);
            }
        );
  }
}






