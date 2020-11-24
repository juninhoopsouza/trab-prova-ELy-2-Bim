class Pessoa {
  int _id;
  String _nome;
  String _cidade;
  String _email;
  String _telefone;
  //construtor da classe
  Pessoa(this._nome, this._telefone, this._cidade, this._email);
  //converte dados de vetor para objeto
  Pessoa.map(dynamic obj) {
    this._id = obj['id'];
    this._nome = obj['nome'];
    this._cidade = obj['cidade'];
    this._email = obj['email'];
    this._telefone = obj['telefone'];
  }
  // encapsulamento
  int get id => _id;
  String get nome => _nome;
  String get email => _email;
  String get cidade => _cidade;
  String get telefone => _telefone;
  //converte o objeto em um map
  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['nome'] = _nome;
    map['telefone'] = _telefone;
    map['cidade'] = _cidade;
    map['email'] = _email;
    return map;
  }

  //converte map em um objeto
  Pessoa.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._nome = map['nome'];
    this._telefone = map['telefone'];
    this._email = map['email'];
    this._cidade = map['cidade'];
  }
}
