import 'dart:convert';
import 'dart:io';
import 'package:desafio_fabio_wood/Empresa.dart';
import 'package:desafio_fabio_wood/Pessoa.dart';
import 'package:desafio_fabio_wood/Endereco.dart';
import 'package:desafio_fabio_wood/PessoaFisica.dart';
import 'package:desafio_fabio_wood/PessoaJuridica.dart';

void main(List<String> arguments) {
  final cadastroEmpresas = <Map<String, Pessoa>>[];

  String option = "";

  do {
    print(
      '''
  ================ MENU ==================

  [1] - Cadastrar nova empresa
  [2] - Buscar empresa cadastrada por CNPJ
  [3] - Buscar empresa pelo CPF/CNPJ do sócio
  [4] - Listar empresas cadastradas em ordem alfabética (razão social)
  [5] - Excluir uma empresa
  [6] - Sair
  ========================================
''',
    );
    option = stdin.readLineSync(encoding: utf8)!;

    switch (option) {
      case '1':
        Map<String, Pessoa> emp = novaEmpresa();
        // checar se o ID gerado já existe no cadastro antes de adicionar nova empresa
        int ind = -1;
        if (cadastroEmpresas.isNotEmpty) {
          ind = localIndex(empresas:cadastroEmpresas, option:'4', word:emp['empresa']!.getAtributo('id'));
        }
        if (ind == -1) {
          cadastroEmpresas.add(emp);
        } else {
          print("ID já cadastrado.");
        }
        break;
      
      case '2':
        if (cadastroEmpresas.isNotEmpty) {
          print('Digite o CNPJ da empresa: ');
          String cod = stdin.readLineSync(encoding: utf8)!;
          int indice = localIndex(empresas:cadastroEmpresas, option:'1', word:cod);
          if (indice >= 0) {
            mostrarMapa(mapa:cadastroEmpresas[indice]);
          } else {
            print("Não há empresa cadastrada com este CNPJ");
          }
        } else {
          print("Não há empresas cadastradas");
        }
        break;

      case '3':
        if (cadastroEmpresas.isNotEmpty) {
          print('Digite o CPF/CNPJ do sócio: ');
          String cod = stdin.readLineSync(encoding: utf8)!;
          int indice = localIndex(empresas:cadastroEmpresas, option:'2', word:cod);
          if (indice >= 0) {
            mostrarMapa(mapa:cadastroEmpresas[indice]);
          } else {
            print("Não há empresa cadastrada com este CNPJ");
          }
        } else{
          print("Não há empresas cadastradas");
        }
        break;
      
      case '4':
        if (cadastroEmpresas.isNotEmpty) {
          print("Estas são as empresas cadastradas em ordem alfabética de razão social:");

          final orderEmpr = <Map<String, Pessoa>>[];     // receberá a lista de empresas ordenada
          final emprNomes = <String>[]; // recebrá os nomes das empresas para ordenar
                                        // o tipo está como String? apenas para evitar erro na linha 105
          
          // separar nomes das empresas
          for (int i=0; i < cadastroEmpresas.length; i++) {
            emprNomes.add(cadastroEmpresas[i]['empresa']!.nome);
          }
          // ordenar nomes das empresas
          emprNomes.sort((a, b) => a.toUpperCase().compareTo(b.toUpperCase()));
          // ordenar empresas pelo nome
          for (int i=0; i < cadastroEmpresas.length; i++) {
            orderEmpr.add(cadastroEmpresas[localIndex(empresas:cadastroEmpresas, option:'3', word:emprNomes[i])]);
          }
          mostrarCadastro(empresas:orderEmpr);
        } else {
          print("Não há empresas cadastradas");
        }
        // Abaixo temos outra solução para o problema. Usando a função "localIndex" isto não é necessário, mas
        // mantive estes comandos apenas como curiosidade:
        /*
        for (int i=0; i < cadastroEmpresas.length; i++) {    // loop ao longo dos nomes
          for (int j=0; j < cadastroEmpresas.length; j++) {  // loop ao longo das empresas
            if (emprNomes[i]==cadastroEmpresas[j]['name']) { // encontrar empresa com o nome corrente
              orderEmpr.add(cadastroEmpresas[j]);            // adicionar a empresa em orderEmpr
            }
          }
        }
        */        
        break;

      case '5':
        if (cadastroEmpresas.isNotEmpty) {
          print("Lista de empresas cadastradas: \n");
          mostrarCadastro(empresas: cadastroEmpresas);
          print("Digite o ID da empresa a ser removida: ");
          String entryId = stdin.readLineSync(encoding: utf8)!;
          int indexRem = localIndex(empresas:cadastroEmpresas, option: '4', word:entryId);
          if (indexRem >= 0 ){
            cadastroEmpresas.removeAt(indexRem);
            print("Empresa removida do cadastro.");
          } else {
            print("Não há empresa cadastrada com este ID");
          }
        } else {
          print("Não há empresas cadastradas.");
        }
        break;

      case '6':
        print("Obrigado por usar nosso aplicativo, até mais!");
        break;
      default:
        print("Opção inválida, tente novamente.\n\n");
        break;
    }
  } while (option != "6");
}

// funções

// função para exibir o mapa empresa-sócio:
void mostrarMapa({required Map<String, Pessoa> mapa}) {
  mapa['empresa']!.mostrarDados();
  print("Sócio:");
  mapa['sócio']!.mostrarDados();
}

// função para exibir o cadastro de empresas
void mostrarCadastro({required List<Map<String, Pessoa>> empresas}) {
  if (empresas.isNotEmpty) {
    for (int i=0; i < empresas.length; i++) {
     print("Empresa ${i+1}");
     mostrarMapa(mapa:empresas[i]);
    }
  } else {
    print("Não há empresas cadastradas.");
  }
}

// função para receber e validar String
String validString(String word) {
  String entryWord;
  bool check = true;
  do {
    print("Digite o/a $word da empresa: ");
    entryWord = stdin.readLineSync(encoding:utf8)!;
    if (entryWord.isEmpty) {  // checar se o valor está vazio
      print("Valor inválido.");    
    } else {
      check = false;
    }
  } while (check);
  return entryWord;
}

// função para cadastrar nova empresa
Map<String, Pessoa> novaEmpresa() {
  // verificar se o sócio é PF ou PJ
  String check = '';
  do {
    print('''
O sócio desta empresa é uma pessoa física ou jurídica?
[1] - Pessoa física
[2] - Pessoa jurídica
''');
    check = stdin.readLineSync(encoding:utf8)!;
    if (check != '1' && check != '2') {
      print('Opção inválida, tente novamente');
    }
  } while (check != '1' && check != '2');

  // atributos do endereço do sócio da empresa:
  String socLogr = validString('logradouro do sócio');
  String socNum = validString('número do sócio');
  String socCompl = validString('complemento (se inexistente, insira "espaço") do sócio');
  String socBairro = validString('bairro do sócio');
  String socEst = validString('estado do sócio');  
  String socCEP = validString('CEP do sócio');
  
  // criar objeto endereço do sócio da empresa:
  Endereco socEnd = Endereco(logradouro: socLogr, 
                              numero: socNum, 
                              complemento: socCompl, 
                              bairro: socBairro, 
                              estado: socEst, 
                              cep: socCEP);

  // criar objeto sócio:
  Pessoa socio;
  // se sócio for PF
  if (check == '1') {
    String socNome = validString('nome do sócio'); 
    String socCPF = validString('CPF do sócio');

    socio = PessoaFisica(nome: socNome, 
                               codigo: socCPF, 
                               endereco: socEnd);
  } else {
  // se sócio for PJ
    String socRazaoSocial = validString('razão social do sócio');  
    String socNomeFantasia = validString('nome fantasia do sócio'); 
    String socCNPJ = validString('CNPJ do sócio');

    socio = PessoaJuridica(razaoSocial: socRazaoSocial, 
                           nomeFantasia: socNomeFantasia, 
                           codigo: socCNPJ, 
                           endereco: socEnd); 
  }

  // atributos do endereço da empresa:
  String empLogr = validString('logradouro');
  String empNum = validString('número');
  String empCompl = validString('complemento (se inexistente, insira "espaço")');
  String empBairro = validString('bairro');
  String empEst = validString('estado');  
  String empCEP = validString('CEP');

  // criar objeto endereço da empresa
  Endereco empEnd = Endereco(logradouro: empLogr, 
                              numero: empNum, 
                              complemento: empCompl, 
                              bairro: empBairro, 
                              estado: empEst, 
                              cep: empCEP);

  // atributos da empresa exceto endereço:
  String empRazaoSocial = validString('razão social');  
  String empNomeFantasia = validString('nome fantasia');  
  String empTel = validString('telefone');  
  String empCNPJ = validString('CNPJ');

  // criar objeto empresa
  Empresa novaEmpresa = Empresa(telefone: empTel,
                                razaoSocial: empRazaoSocial, 
                                nomeFantasia: empNomeFantasia, 
                                codigo: empCNPJ, 
                                endereco: empEnd);
  
  Map<String,Pessoa> newmap = {'empresa':novaEmpresa, 'sócio':socio};

  //print("This is your new city: ");
  //showCity(city:newmap);
  return newmap;
}

// função para identificar o ídice do mapa da empresa pelo CNPJ, CPF/CNPJ do sócio, razão social ou ID
int localIndex({required List<Map> empresas, 
               required String option,
               required String word}) {
  int meuIndice = -1;
  switch (option) {
    case '1': // buscar pelo CNPJ da empresa
      for (int i=0; i < empresas.length; i++) {
        if (empresas[i]['empresa'].codigo == word) {
          meuIndice = i;
          break;
        }
      }
      break;
    
    case '2': // buscar pelo CPF/CNPJ do sócio
      for (int i=0; i < empresas.length; i++) {
      if (empresas[i]['sócio'].codigo == word) {
        meuIndice = i;
        break;
      }
    }
      break;

    case '3': // buscar pela razão social da empresa
      for (int i=0; i < empresas.length; i++) {
        if (empresas[i]['empresa'].razaoSocial == word) {
          meuIndice = i;
          break;
        }
      }
      break;
    case '4':
      for (int i=0; i < empresas.length; i++) {
        if (empresas[i]['empresa'].id == word) {
          meuIndice = i;
          break;
        }
      }
      break;

    default:
      break;
  }
  if (meuIndice == -1) {
    print("Não há valor condizente no cadastro.");
    }
  return meuIndice;
}
