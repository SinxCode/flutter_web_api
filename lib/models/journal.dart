import 'package:uuid/uuid.dart';

class Journal {
  String id;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  Journal({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  // função que pega um map e transforma em um Journal
  Journal.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        content = map["content"],
        createdAt = DateTime.parse(map["createdAt"]),
        updatedAt = DateTime.parse(map["updatedAt"]);

//Construtor que gera um journal vazio
  Journal.empty()
      : id = const Uuid().v1(),
        content = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  //Função que transforma o model num map
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "content": content,
      "createdAt": createdAt.toString(),
      "updatedAt": updatedAt.toString()
    };
  }

  @override
  String toString() {
    return "$content \ncreated_at: $createdAt\nupdated_at:$updatedAt";
  }
}
