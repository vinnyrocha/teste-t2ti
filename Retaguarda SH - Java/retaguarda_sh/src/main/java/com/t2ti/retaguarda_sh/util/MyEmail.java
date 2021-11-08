package com.t2ti.retaguarda_sh.util;

import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;

public class MyEmail {

    

    @SuppressWarnings("deprecation")
	public static void main(String[] args) throws Exception {

    try {	
    	SimpleEmail email = new SimpleEmail();
    	email.setHostName("smtp.gmail.com"); // o servidor SMTP para envio do e-mail
    	email.addTo("vinny_rocha19@hotmail.com", "Vinicius Rocha"); //destinatário
    	email.setFrom("atualizacoessysala@gmail.com"); // remetente
    	email.setSubject("Mensagem de Teste"); // assunto do e-mail
    	email.setMsg("Teste de Email utilizando commons-email"); //conteudo do e-mail
    	email.setAuthentication("atualizacoessysala@gmail.com",""); 
    	email.setSSL(true);
    	//email.setSmtpPort(465);
    	email.send(); //enviar   
      
    } catch (EmailException e) {  

        System.out.println(e.getMessage());  

        }   


    }

}
