/*
Title: T2Ti ERP 3.0
Description: Service utilizado para consumir os webservices referentes a CFOP
                                                                                
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
import 'package:http/http.dart' show Client;
import 'package:pegasus_pdv/src/infra/infra.dart';
import 'package:pegasus_pdv/src/model/model.dart';
import 'package:pegasus_pdv/src/service/service_base.dart';

class CfopService extends ServiceBase {
  var clienteHTTP = Client();

  Future<CfopModel> atualizar(CfopModel cfop) async {
    try {
      log(cfop.id.toString());
      log(cfop.objetoEncodeJson(cfop));

      final response = await clienteHTTP.put(
        Uri.tryParse('$endpoint/cfop/' + cfop.codigo.toString()),
        headers: ServiceBase.cabecalhoRequisicao,
        body: cfop.objetoEncodeJson(cfop),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.headers["content-type"].contains("html")) {
          tratarRetornoErro(response.body, response.headers);
          return null;
        } else {
          var cfopJson = json.decode(response.body);
          return CfopModel.fromJson(cfopJson);
        }
      } else {
        tratarRetornoErro(response.body, response.headers);
        return null;
      }
    } on Exception catch (e) {
      tratarRetornoErro(null, null, exception: e);
      return null;
    }
  }

  Future<CfopModel> inserir(CfopModel cfop) async {
    try {
      ServiceBase.cabecalhoRequisicao = Constantes.linguagemServidor == 'delphi'
          ? {
              "content-type": "application/json",
              "authentication": "Bearer " + Sessao.tokenJWT,
              "operacao": "registrar"
            }
          : {
              "content-type": "application/json",
              "authorization": "Bearer " + Sessao.tokenJWT,
              "operacao": "registrar"
            };

      final response = await clienteHTTP.post(
        Uri.tryParse('$endpoint/cfop/'),
        headers: ServiceBase.cabecalhoRequisicao,
        body: cfop.objetoEncodeJson(cfop),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.headers["content-type"].contains("html")) {
          tratarRetornoErro(response.body, response.headers);
          return null;
        } else {
          var cfopJson = json.decode(response.body);
          return CfopModel.fromJson(cfopJson);
        }
      } else {
        tratarRetornoErro(response.body, response.headers);
        return null;
      }
    } on Exception catch (e) {
      tratarRetornoErro(null, null, exception: e);
      return null;
    }
  }

  Future<CfopModel> excluir(CfopModel cfop) async {
    try {
      log(cfop.id.toString());
      log(cfop.objetoEncodeJson(cfop));

      final response = await clienteHTTP.delete(
        Uri.tryParse('$endpoint/cfop/' + cfop.codigo.toString()),
        headers: ServiceBase.cabecalhoRequisicao,
        body: cfop.objetoEncodeJson(cfop),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.headers["content-type"].contains("html")) {
          tratarRetornoErro(response.body, response.headers);
          return null;
        } else {
          var cfopJson = json.decode(response.body);
          return CfopModel.fromJson(cfopJson);
        }
      } else {
        tratarRetornoErro(response.body, response.headers);
        return null;
      }
    } on Exception catch (e) {
      tratarRetornoErro(null, null, exception: e);
      return null;
    }
  }
}
