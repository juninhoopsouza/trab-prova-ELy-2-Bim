import 'package:flutter/material.dart';
import 'package:preferencias/pessoa.dart';
import 'package:preferencias/database_helper.dart';
import 'package:preferencias/pessoa_screen.dart';

class ListViewPessoa extends StatefulWidget {
  @override
  _ListViewPessoaState createState() => new _ListViewPessoaState();
}

class _ListViewPessoaState extends State<ListViewPessoa> {
//atributo de vetor dos itens
  List<Pessoa> items = new List();
//conexão com banco de dados
  DatabaseHelper db = new DatabaseHelper();
  @override
  void initState() {
    super.initState();
    db.getPessoas().then((pessoas) {
      setState(() {
        pessoas.forEach((pessoa) {
          items.add(Pessoa.fromMap(pessoa));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSA ListView Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('ListView Demo'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(height: 5.0),
                    ListTile(
                      title: Text(
                        '${items[position].nome}',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      subtitle: Row(children: [
                        Text('${items[position].telefone}',
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontStyle: FontStyle.italic,
                            )),
                        IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => _deletePessoa(
                                context, items[position], position)),
                      ]),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 15.0,
                        child: Text(
                          '${items[position].id}',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () => _navigateToPessoa(context, items[position]),
                    ),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _createNewPessoa(context),
        ),
      ),
    );
  }

  void _deletePessoa(BuildContext context, Pessoa pessoa, int position) async {
    db.deletePessoa(pessoa.id).then((pessoas) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToPessoa(BuildContext context, Pessoa pessoa) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PessoaScreen(pessoa)),
    );
    if (result == 'update') {
      db.getPessoas().then((pessoas) {
        setState(() {
          items.clear();
          pessoas.forEach((pessoa) {
            items.add(Pessoa.fromMap(pessoa));
          });
        });
      });
    }
  }

  void _createNewPessoa(BuildContext context) async {
//aguarda o retorno da página de cadastro
    String result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PessoaScreen(Pessoa('', '', '', ''))),
    );
//se o retorno for salvar, recarrega a lista
    if (result == 'save') {
      db.getPessoas().then((pessoas) {
        setState(() {
          items.clear();
          pessoas.forEach((pessoa) {
            items.add(Pessoa.fromMap(pessoa));
          });
        });
      });
    }
  }
}
