import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Quote{
  final String text;
  final String author;
  final String id;

  Quote({required this.text, required this.author, required this.id});

  factory Quote.fromMap(Map<String, dynamic> map){

    return Quote(
        text: map['text'],
        author: map['author'],
        id: map['id'],
    );
  }

  Map<String,dynamic> toMap(){
  return {
    'id' : id,
    'text' : text,
    'author': author,
    };
  }

}

class QuotesList extends ChangeNotifier{

  final Future<Database> database;
   List<Quote> _items = [
    Quote(
      text: "MY First T",
      author: "Author",
      id: "7777"
    )
  ];


  QuotesList._create({required this.database});

  static Future<QuotesList> create(Future<Database> database) async {
    var quotesList = QuotesList._create(database: database);
    await quotesList.plzGetQuotes();
    return quotesList;
  }

  List<Quote> get getList {
    return _items;
  }

  plzGetQuotes() async{
    _items = await getQuotes();
  }

  insertQuote(Quote quote) async {
    final db = await database;
    await db.insert(
      'quotes',
      quote.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _items.add(quote);
    notifyListeners();
  }

  deleteQuote(Quote quote) async{

    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'quotes',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [quote.id],
    );

    _items.remove(quote);
    notifyListeners();
  }



  Future<List<Quote>> getQuotes() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The quotes.
    final List<Map<String, dynamic>> maps = await db.query('quotes');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Quote(
        id: maps[i]['id']!,
        text: maps[i]['text']!,
        author: maps[i]['author']!,
      );
    });
  }

}