import 'dart:convert';
import 'dart:io';
import 'Pessoa.dart';

class PessoaJuridica extends Pessoa {
  // atributos
  String razaoSocial;
  String nomeFantasia;
  
  // métodos:
  // construtor
  PessoaJuridica({required this.razaoSocial,
                  required this.nomeFantasia,
                  required super.codigo,
                  required super.endereco
                  }):super(nome:razaoSocial) {
                    while (!validarCodigo()) {
                      print('Insira um CNPJ válido: ');
                      codigo = stdin.readLineSync(encoding: utf8)!; 
                    }
                  }

  // validar codigo
  @override
  bool validarCodigo() {
    int? teste = int.tryParse(codigo);
    if (teste == null) { // checar se possui apenas números
      print("CNPJ inválido.");
      return false;      
    } else {
      if (teste < 10000000000000 || teste > 99999999999999) { // checar se possui 14 dígitos
        print("CNPJ inválido.");
        return false;
      } else {
        return true;
      }
    }
  }

  // retornar codigo
  @override
  String get codigoFormatado {
    if (validarCodigo()) {
      String codigoFormatado = '';
      for (int i=0; i < codigo.length; i++) {
        codigoFormatado += codigo[i];
        if (i == 1 || i == 4) {
          codigoFormatado += '.';
        } else if (i == 7) {
          codigoFormatado += '/';
        } else if (i == 11) {
          codigoFormatado += '-';
        }
      }
      return codigoFormatado;
    } else {
      return("CNPJ inválido.");
    }
  }

  // exibir dados
  @override
  void mostrarDados() {    
    String comp = '';
    if (endereco.complemento != '') {comp = ', ';}  
    print("CNPJ: $codigoFormatado");
    print("Razão social: $razaoSocial");
    print("Nome fantasia: $nomeFantasia");
    print("Endereço: Logradouro ${endereco.logradouro}, nº ${endereco.numero}$comp${endereco.complemento}, bairro ${endereco.bairro}, estado ${endereco.estado}, CEP ${endereco.cepFormatado}.");
    print("\n");
}

}