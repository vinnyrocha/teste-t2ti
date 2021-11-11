/*
Title: T2Ti ERP 3.0                                                                
Description: PersistePage relacionada à tabela [CFOP] 
                                                                                
The MIT License                                                                 
                                                                                
Copyright: Copyright (C) 2021 T2Ti.COM                                          
                                                                                
Permission is hereby granted, free of charge, to any person                     
obtaining a copy of this software and associated documentation                  
files (the "Software"), to deal in the Software without                         
restriction, including without limitation the rights to use,                    
copy, modify, merge, publish, distribute, sublicense, and/or sell               
copies of the Software, and to permit persons to whom the                       
Software is furnished to do so, subject to the following                        
conditions:                                                                     
                                                                                
The above copyright notice and this permission notice shall be                  
included in all copies or substantial portions of the Software.                 
                                                                                
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,                 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES                 
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                        
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT                     
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,                    
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING                    
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR                   
OTHER DEALINGS IN THE SOFTWARE.                                                 
                                                                                
       The author may be contacted at:                                          
           t2ti.com@gmail.com                                                   
                                                                                
@author Albert Eije (alberteije@gmail.com)                    
@version 1.0.0
*******************************************************************************/

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';

import 'package:pegasus_pdv/src/database/database.dart';

import 'package:pegasus_pdv/src/infra/infra.dart';
import 'package:pegasus_pdv/src/infra/atalhos_desktop_web.dart';
import 'package:pegasus_pdv/src/service/cadastros/cfop_service.dart';

import 'package:pegasus_pdv/src/view/shared/view_util_lib.dart';
import 'package:pegasus_pdv/src/view/shared/caixas_de_dialogo.dart';
import 'package:pegasus_pdv/src/view/shared/botoes.dart';
import 'package:pegasus_pdv/src/view/shared/widgets_input.dart';

import 'package:pegasus_pdv/src/model/cadastros/cfop_model.dart';

class CfopPersistePage extends StatefulWidget {
  final Cfop cfop;
  final String title;
  final String operacao;

  const CfopPersistePage({Key key, this.cfop, this.title, this.operacao})
      : super(key: key);

  @override
  _CfopPersistePageState createState() => _CfopPersistePageState();
}

class _CfopPersistePageState extends State<CfopPersistePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  bool _formFoiAlterado = false;

  String jsonTxt = "";

  Map<LogicalKeySet, Intent> _shortcutMap;
  Map<Type, Action<Intent>> _actionMap;
  final _foco = FocusNode();

  Cfop cfop;

  final _idController = TextEditingController();
  final _codigoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _aplicacaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bootstrapGridParameters(
      gutterSize: Constantes.flutterBootstrapGutterSize,
    );

    _shortcutMap = getAtalhosPersistePage();

    _actionMap = <Type, Action<Intent>>{
      AtalhoTelaIntent: CallbackAction<AtalhoTelaIntent>(
        onInvoke: _tratarAcoesAtalhos,
      ),
    };
    cfop = widget.cfop;
    _foco.requestFocus();
  }

  void _tratarAcoesAtalhos(AtalhoTelaIntent intent) {
    switch (intent.type) {
      case AtalhoTelaType.excluir:
        _excluir();
        break;
      case AtalhoTelaType.salvar:
        _salvar();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _idController.text = widget.cfop?.id.toString() ?? '';
    _codigoController.text = widget.cfop?.codigo?.toString() ?? '';
    _descricaoController.text = widget.cfop?.descricao ?? '';
    _aplicacaoController.text = widget.cfop?.aplicacao ?? '';

    return FocusableActionDetector(
      actions: _actionMap,
      shortcuts: _shortcutMap,
      child: Focus(
        autofocus: true,
        child: Scaffold(
          drawerDragStartBehavior: DragStartBehavior.down,
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(widget.title),
            actions: widget.operacao == "I"
                ? getBotoesAppBarPersistePage(
                    context: context,
                    salvar: _salvar,
                  )
                : getBotoesAppBarPersistePageComExclusao(
                    context: context, salvar: _salvar, excluir: _excluir),
          ),
          body: SafeArea(
            top: false,
            bottom: false,
            child: Form(
              key: _formKey,
              autovalidateMode: _autoValidate,
              onWillPop: _avisarUsuarioFormAlterado,
              child: Scrollbar(
                child: SingleChildScrollView(
                  dragStartBehavior: DragStartBehavior.down,
                  child: BootstrapContainer(
                    fluid: true,
                    decoration: BoxDecoration(color: Colors.white),
                    padding: Biblioteca.isTelaPequena(context) == true
                        ? ViewUtilLib.paddingBootstrapContainerTelaPequena
                        : ViewUtilLib.paddingBootstrapContainerTelaGrande,
                    children: <Widget>[
                      Divider(
                        color: Colors.white,
                      ),
                      Divider(
                        color: Colors.white,
                      ),

                      //CFOP
                      // BootstrapRow(
                      //   height: 60,
                      //   children: <BootstrapCol>[
                      //     BootstrapCol(
                      //       sizes: 'col-12',
                      //       child: TextFormField(
                      //         maxLength: 100,
                      //         maxLines: 1,
                      //         readOnly: true,
                      //         controller: _idController,
                      //         decoration: getInputDecoration(
                      //             'ID interno', 'ID *', false),
                      //         onSaved: (String value) {},
                      //         onChanged: (text) {
                      //           cfop = cfop.copyWith(id: int.tryParse(text));
                      //           _formFoiAlterado = true;
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Divider(
                      //   color: Colors.white,
                      // ),

                      BootstrapRow(
                        height: 60,
                        children: <BootstrapCol>[
                          BootstrapCol(
                            sizes: 'col-12',
                            child: TextFormField(
                              validator: ValidaCampoFormulario
                                  .validarObrigatorioNumerico,
                              focusNode: _foco,
                              maxLength: 100,
                              maxLines: 1,
                              controller: _codigoController,
                              decoration: getInputDecoration(
                                  'Informe o código do CFOP',
                                  'Codigo *',
                                  false),
                              onSaved: (String value) {},
                              onChanged: (text) {
                                cfop =
                                    cfop.copyWith(codigo: int.tryParse(text));
                                _formFoiAlterado = true;
                              },
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                      ),

                      BootstrapRow(
                        height: 60,
                        children: <BootstrapCol>[
                          BootstrapCol(
                            sizes: 'col-12',
                            child: TextFormField(
                              validator: ValidaCampoFormulario
                                  .validarObrigatorioAlfanumerico,
                              maxLength: 100,
                              maxLines: 1,
                              controller: _descricaoController,
                              decoration: getInputDecoration(
                                  'Informe a Descrição do CFOP',
                                  'Descrição *',
                                  false),
                              onSaved: (String value) {},
                              onChanged: (text) {
                                cfop = cfop.copyWith(descricao: text);
                                _formFoiAlterado = true;
                              },
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      BootstrapRow(
                        height: 60,
                        children: <BootstrapCol>[
                          BootstrapCol(
                            sizes: 'col-12',
                            child: TextFormField(
                              maxLength: 1000,
                              maxLines: 3,
                              controller: _aplicacaoController,
                              decoration: getInputDecoration(
                                  'Aplicação', 'Aplicação', false),
                              onSaved: (String value) {},
                              onChanged: (text) {
                                cfop = cfop.copyWith(aplicacao: text);
                                _formFoiAlterado = true;
                              },
                            ),
                          ),
                        ],
                      ),

                      BootstrapRow(
                        height: 60,
                        children: <BootstrapCol>[
                          BootstrapCol(
                            sizes: 'col-12',
                            child: Text(
                              '* indica que o campo é obrigatório',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // meu codigo para salvar no mysql retaguarda_sh
  Future<void> _salvarServidor() async {
    // if (Sessao.configuracaoPdv.modulo != 'G') {

    //if (widget.operacao == 'A') {
    //  jsonTxt =
    //      '{"id": 543, "codigo": 9999, "descricao": "teste flutter", "aplicacao": "teste flutter 2"}';
    //} else {
    //  jsonTxt =
    //      '{"codigo": 9999, "descricao": "teste flutter inserindo", "aplicacao": "teste flutter 2"}';
    // }

    var _idcfop = _idController.text; //widget.cfop.id.toString();
    var _codigocfop = _codigoController.text; //widget.cfop.codigo.toString();
    var _desccfop =
        _descricaoController.text; //widget.cfop.descricao.toString();
    var _apliccfop =
        _aplicacaoController.text; //widget.cfop.aplicacao.toString();

    if (widget.operacao == 'A') {
      jsonTxt = '{"id": ' +
          _idcfop +
          ', "codigo": ' +
          _codigocfop +
          ', "descricao": ' +
          '"' +
          _desccfop +
          '"' +
          ', "aplicacao": ' +
          '"' +
          _apliccfop +
          '"' +
          '}';
    } else {
      jsonTxt = '{"codigo": ' +
          _codigocfop +
          ', "descricao": ' +
          '"' +
          _desccfop +
          '"' +
          ', "aplicacao": ' +
          '"' +
          _apliccfop +
          '"' +
          '}';
    }

    CfopModel _cfop = CfopModel.fromJson(jsonDecode(jsonTxt));

    //log("Obtendo ID do cfop" + _idcfop);
    //log("Obtendo codigo do cfop" + _codigocfop);
    //log("Obtendo descricao do cfop" + _desccfop);
    //log("Obtendo aplicacao do cfop" + _apliccfop);

    CfopService servico = CfopService();
    gerarDialogBoxEspera(context);
    if (widget.operacao == 'A') {
      _cfop = await servico.atualizar(_cfop);
    } else {
      _cfop = await servico.inserir(_cfop);
    }
    Sessao.fecharDialogBoxEspera(context);
    if (_cfop != null) {
      showInSnackBar(
          'CFOP salvo com sucesso no Servidor (Retaguarda_SH).', context,
          corFundo: Colors.red);
    } else {
      showInSnackBar(
          'Ocorreu um problema ao tentar salvar os dados do CFOP no Servidor (Retaguarda_SH).',
          context,
          corFundo: Colors.red);
    }
  }

  Future<void> _salvar() async {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = AutovalidateMode.always;
      showInSnackBar(Constantes.mensagemCorrijaErrosFormSalvar, context);
    } else {
      gerarDialogBoxConfirmacao(context, Constantes.perguntaSalvarAlteracoes,
          () async {
        form.save();
        if (widget.operacao == 'A') {
          await Sessao.db.cfopDao.alterar(cfop);
        } else {
          await Sessao.db.cfopDao.inserir(cfop);
        }
        // salva no servidor
        _salvarServidor();

        Navigator.of(context).pop();
      });
    }
  }

  Future<bool> _avisarUsuarioFormAlterado() async {
    final FormState form = _formKey.currentState;
    if (form == null || !_formFoiAlterado) return true;

    return await gerarDialogBoxFormAlterado(context);
  }

  // meu codigo para salvar no mysql retaguarda_sh
  Future<void> _excluirServidor() async {
    // if (Sessao.configuracaoPdv.modulo != 'G') {

    //if (widget.operacao == 'A') {
    //  jsonTxt =
    //      '{"id": 543, "codigo": 9999, "descricao": "teste flutter", "aplicacao": "teste flutter 2"}';
    //} else {
    //  jsonTxt =
    //      '{"codigo": 9999, "descricao": "teste flutter inserindo", "aplicacao": "teste flutter 2"}';
    // }

    var _idcfop = _idController.text; //widget.cfop.id.toString();
    var _codigocfop = _codigoController.text; //widget.cfop.codigo.toString();
    var _desccfop =
        _descricaoController.text; //widget.cfop.descricao.toString();
    var _apliccfop =
        _aplicacaoController.text; //widget.cfop.aplicacao.toString();

    jsonTxt = '{"id": ' +
        _idcfop +
        ', "codigo": ' +
        _codigocfop +
        ', "descricao": ' +
        '"' +
        _desccfop +
        '"' +
        ', "aplicacao": ' +
        '"' +
        _apliccfop +
        '"' +
        '}';

    // criando objeto json para passar para a funcao de excluir (servico.excluir)
    CfopModel _cfop = CfopModel.fromJson(jsonDecode(jsonTxt));

    //log("Obtendo ID do cfop" + _idcfop);
    //log("Obtendo codigo do cfop" + _codigocfop);
    //log("Obtendo descricao do cfop" + _desccfop);
    //log("Obtendo aplicacao do cfop" + _apliccfop);

    CfopService servico = CfopService();
    gerarDialogBoxEspera(context);

    _cfop = await servico.excluir(_cfop);

    Sessao.fecharDialogBoxEspera(context);
    if (_cfop != null) {
      showInSnackBar(
          'CFOP excluído com sucesso no Servidor (Retaguarda_SH).', context,
          corFundo: Colors.red);
    } else {
      showInSnackBar(
          'Ocorreu um problema ao tentar excluir os dados do CFOP no Servidor (Retaguarda_SH).',
          context,
          corFundo: Colors.red);
    }
  }

  void _excluir() {
    gerarDialogBoxExclusao(context, () async {
      // exclui no servidor
      _excluirServidor();

      await Sessao.db.cfopDao.excluir(cfop);

      Navigator.of(context).pop();
    });
  }
}
