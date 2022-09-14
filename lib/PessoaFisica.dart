import 'dart:convert';
import 'dart:io';
import 'Pessoa.dart';

class PessoaFisica extends Pessoa {

  // métodos:
  // construtor
  PessoaFisica({required super.nome,
                required super.codigo,
                required super.endereco
                }) {
                  while (!validarCodigo()) {
                      print('Insira um CPF válido: ');
                      codigo = stdin.readLineSync(encoding: utf8)!; 
                    }
                }  

}