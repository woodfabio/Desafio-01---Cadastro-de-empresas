import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'PessoaJuridica.dart';
import 'Pessoa.dart';

class Empresa extends PessoaJuridica {
  // atributos
  String id;
  String telefone;
  String horaCadastro;
  //Pessoa socio;

  // métodos:
  // construtor
  Empresa({this.id = '',
           required this.telefone,
           this.horaCadastro = '',
           //required this.socio,
           required super.razaoSocial,
           required super.nomeFantasia,
           required super.codigo,
           required super.endereco}) {
            horaCadastro = DateTime.now().toString();
            var uuid = Uuid();
            id = uuid.v4();
            while (!validarCodigo()) {
                      print('Insira um CNPJ válido: ');
                      codigo = stdin.readLineSync(encoding: utf8)!; 
                    }
           }

  // mostrar dados
  @override
  void mostrarDados() {
    String comp = '';
    if (endereco.complemento != '') {comp = ', ';}
    print("ID: $id");
    print("CNPJ: $codigoFormatado Data Cadastro: $horaCadastro");
    print("Telefone: $telefone");
    print("Razão social: $razaoSocial");
    print("Nome fantasia: $nomeFantasia");;
    print("Endereço: Logradouro ${endereco.logradouro}, nº ${endereco.numero}$comp${endereco.complemento}, bairro ${endereco.bairro}, estado ${endereco.estado}, CEP ${endereco.cepFormatado}.");
  } 

}