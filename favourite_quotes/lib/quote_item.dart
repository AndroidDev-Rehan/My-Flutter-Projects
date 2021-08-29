import 'package:favourite_quotes/quote.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuoteItem extends StatelessWidget {

  final Quote quote;
  const QuoteItem({required this.quote});

  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(quote.text),
        subtitle: Text(quote.author),
        trailing: IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () {
            Provider.of<QuotesList>(context,listen: false).deleteQuote(quote);
          },
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}


