import 'Endereco.dart';

abstract class Pessoa {
  // atributos
  String nome;
  String codigo;
  Endereco endereco;

  // métodos:
  // construtor
  Pessoa({required this.nome,
          required this.codigo,
          required this.endereco
          });
  
  // validar codigo
  bool validarCodigo() {
    int? teste = int.tryParse(codigo);
    if (teste == null) { // checar se possui apenas números
      return false;
    } else {
      if (teste < 1000000000 || teste > 99999999999) { // checar se possui 11 dígitos
        return false;
      } else {
        return true;
      }
    }
  }

  // retornar codigo formatado
  String get codigoFormatado {
    if (validarCodigo()) {
      String codigoFormatado = '';
      for (int i=0; i < codigo.length; i++) {
        codigoFormatado += codigo[i];
        if (i == 2 || i == 5) {
          codigoFormatado += '.';
        } else if (i == 8) {
          codigoFormatado += '-';
        }
      }
      return codigoFormatado;
    } else {
      return("Código inválido.");
    }
  }

  // exibir dados
  void mostrarDados() {
    String comp = '';
    if (endereco.complemento != '') {comp = ', ';}
    print("CPF: $codigo");
    print("Nome Completo: $nome");
    print("Endereço: Logradouro ${endereco.logradouro}, nº ${endereco.numero}$comp${endereco.complemento}, bairro ${endereco.bairro}, estado ${endereco.estado}, CEP ${endereco.cepFormatado}.");
  }

  // getter para qualquer atributo
  String getAtributo(String atrib) {
    return atrib;
  }

}