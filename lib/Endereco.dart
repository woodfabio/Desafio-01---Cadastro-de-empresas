import 'dart:convert';
import 'dart:io';

class Endereco {
  String logradouro;
  String numero;
  String? complemento;
  String bairro;
  String estado;
  String cep;

  // methods
  // constructor
  Endereco({required this.logradouro,
            required this.numero,
            required this.complemento,
            required this.bairro,
            required this.estado,
            required this.cep}) {
              while (!validarCep()) {
              print('Insira um CEP válido: ');
              cep = stdin.readLineSync(encoding: utf8)!;
              if (complemento == ' ') {
                complemento = '';
              }
              }
            }

  // validar CEP
  bool validarCep() {
    int? teste = int.tryParse(cep);
    if (teste == null) { // checar se possui apenas números
      return false;
    } else {
      if (teste <  10000000 || teste > 99999999) { // checar se possui 8 dígitos
        return false;
      } else {
        return true;
      }
    }
  }

  // getters
  String get cepFormatado {
    if (validarCep()) {
        String cepFormatado = '';
        for (int i=0; i < cep.length; i++) {
          cepFormatado += cep[i];
          if (i == 4) {
            cepFormatado += '-';
          }
        }
        return cepFormatado;
    } else {
      return("CPF inválido.");
    }
  }


}