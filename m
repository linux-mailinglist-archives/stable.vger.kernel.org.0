Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BA62831B5
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 10:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgJEIPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 04:15:44 -0400
Received: from sonic315-15.consmr.mail.bf2.yahoo.com ([74.6.134.125]:41725
        "EHLO sonic315-15.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725880AbgJEIPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 04:15:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601885742; bh=yxMXRQ0o6aY7GOCEnBwfeyIzWV8x6CpqarbmLiBHsds=; h=Date:From:Reply-To:Subject:References:From:Subject; b=PVyWtF3WjSzhOCAZjxHzdSKXqRKCD94m3qf0a7K5s3hF0xPhC6ttUcZYN6GhLI+RrBg5mvCoyEfQReis9AJ/CD931qpPtnIPXUo+HpBPqHo3bB0GaEmquqvrqNh6fQy0Iu03i2yEdfH30qM7vb0fyKe82PvsATt7gTzbGwZLjkrtFpRqifNiOO5SYQE3JH4WyNBjf4eJwE2nI0TN74PYN21BoRWteRI+2SVruIMAK1T+Zxjs7vXSp5SkwC/UIOUHfeT7ufxPuflK6Vz/2/Pr893RJNu8xQRMhhswKqmk7GekIuwgCeZCgAMB7XaPj0IEUl1T41UoyHXPCkLjoRGeNg==
X-YMail-OSG: Zy72Q0oVM1mE_9jt1zzDow4kNtyZf9pcc9dUCKBee3ZZZYrWV._jKYoCiCPVbIt
 Jyrs_mbdNrx0NbybDlE5Y6S1fBvm9EdNku5sNzS91lh2he.uKw32toCo.K258TMrs4_FE67lJrNp
 ZcKaONZJ4SSW8j_4YyJi3r45RyH9B6D4jCiWUWWBoElNwn0iscZJx5oOoeHneHD_TX.6_BYABVYa
 woJ7VJaz7YAmgcxfHqz1PQ3MMZ.al.UT2YOLbFYtfALU9hxRZgwIED.vNFnuBjk6CzspBfPCfUad
 O4vOQIuqqJoY212bX7c9lrgoFK5VwblPsmljrETbH6GkvQBJe80lxkaeyNmPgY4GSgLLfBwgWLGW
 dc0ZXxYxk9rGID_WJPyyug_fmVwKMmu7O0GyjzxDGIh4TM086wO.CIZoHwTWiG92GR32Ytn9iQvd
 RxkA.MJIy1xPtPZMY0D9GuCIU729pYRT8Qpdx62qTwH3wx78cjZvIqkeo_JDmqTKPSz9NIxjDcFO
 6.QkZ2SvWiwgwqyJKgiUhfHX.mu_rdO88kmYnlBXIuFv7RyNUEmp9NerMegZbwe3Fh4m2ZYGRYld
 xgHSUMRGBhMiRJtqVrJvdGD3wFAoVVtz609.F3hhF_05HcccIygDKUnXDhlIqAPdLYscPImDxueE
 enzjjn2vCytXB6YAUMRsUQdk88xHVF77XBUzBJJ.olBy2EeIYnMnFRKjYqHTHbfhxXu2Mk2gDJur
 NtqM5r.JTy1YuUOur3WoNY3IXChr5UTgHtE9FHZLUmmjYM6VYD8boD2g2ioUxXbW4DmuTZDcL874
 gc12mTByQwER2o6spepknxJeHYT9VZfW5t0Vj7VuNcX_xoLLaEFRgjdlnlUljrAgcVXeSvLfINrd
 MDOJxPx_XykWoI_Cdt45vcQk3tRmi1fF6Qw4gsSYG3DG_9LbdnoxERKR8.cpf7I4cROMPUcWK2_V
 SYhsrZ_x1lbdhTwoGfIrfiO.X8J1aBT.Cl17eoM8QwiwEhtYhrxS_KYt5go7tHLX2j8y_iRa0pBU
 gmwDfkQ.2yGBz2Vy3.yTKHHJVxyLv3hy6.WF2ol1xhJ5oKLzBXy8PI8MMwLnhy1cpXDNTQfwlrCx
 h1jv4qCcXJAUlbD_MjvgnAsc2OQr.vhMnZhFmkjVbeRcTkUewrzG0n_27OatS6ELTVtwz3PJ5Jfp
 FFQRj_mSRv8Wv3gcqcUeIHskuuch8FujTKLnKFyJKgzyv3V.luycPSYJv4jOGZME7AXPqH.tHYFm
 E7u8voD5ZEDIQk6.R5xsk1ydeq47J9cSHV.ZPQPWFSOhvQXP4jpm0WDwHmBTZ6V9uKH_uL4fV5W9
 mMx8z8jpj.sUL5gAIzHz_4TqYD2vr0kjuZjm8PU4n4if6Cmq1NZv0RD.oqcdJV1S2NUPOzgUTpzW
 TfH_P4kSgzWc58XJopwuGbFilL7IG6tMTbeaW.pkK6PM-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Mon, 5 Oct 2020 08:15:42 +0000
Date:   Mon, 5 Oct 2020 08:15:39 +0000 (UTC)
From:   Mrs Theresa Wallas <theresawallas1980@gmail.com>
Reply-To: m.wallas@yahoo.com
Message-ID: <52175749.1786383.1601885739658@mail.yahoo.com>
Subject: =?UTF-8?Q?Doa=C3=A7=C3=A3o_pela_obra_de_Deus.?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <52175749.1786383.1601885739658.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16718 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:81.0) Gecko/20100101 Firefox/81.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mais querido em cristo,

Sa=C3=BAdo-vos em nome de nosso Senhor Jesus Cristo, nosso Senhor, temos qu=
e adorar com todo o cora=C3=A7=C3=A3o nosso Senhor Jesus Cristo, porque dec=
idimos permanecer sob a cobertura de Sua un=C3=A7=C3=A3o, Obedi=C3=AAncia a=
o Seu prop=C3=B3sito e viver uma vida que O honre. nos manter=C3=A1 sob Sua=
 m=C3=A3o de b=C3=AAn=C3=A7=C3=A3o.

Sou a senhora Theresa Wallas, do Kuwait. Sou casado com o Sr. Johnson Walla=
s, que trabalhou na embaixada do Kuwait na Costa do Marfim por nove anos an=
tes de sua morte no ano de 2005. Fomos casados por onze anos sem um filho. =
Ele morreu ap=C3=B3s uma breve doen=C3=A7a que durou apenas quatro dias. An=
tes de sua morte, n=C3=B3s dois nascemos crist=C3=A3os de novo.

Desde sua morte, decidi n=C3=A3o me casar novamente ou ter um filho fora do=
 meu lar matrimonial, contra o qual a B=C3=ADblia =C3=A9 contra. Quando meu=
 falecido marido estava vivo, ele depositou a quantia de US $ 3,5 milh=C3=
=B5es em um banco aqui em Abidjan, Costa do Marfim. Atualmente, esse dinhei=
ro ainda est=C3=A1 no banco.

Recentemente, meu m=C3=A9dico me disse que eu n=C3=A3o duraria pelos pr=C3=
=B3ximos oito meses devido a um problema de c=C3=A2ncer. O que mais me pert=
urba =C3=A9 a doen=C3=A7a do derrame. Tendo conhecido minha condi=C3=A7=C3=
=A3o, decidi doar esse fundo a uma organiza=C3=A7=C3=A3o de caridade que ut=
ilizaria esse dinheiro da maneira que vou instruir aqui.

Quero uma organiza=C3=A7=C3=A3o que usar=C3=A1 esse fundo para orfanatos, e=
scola, igreja e vi=C3=BAvas, propagando a palavra de Deus e envidando esfor=
=C3=A7os para que a casa de Deus seja mantida. A B=C3=ADblia nos fez entend=
er que "Bem-aventurada =C3=A9 a m=C3=A3o que d=C3=A1". Tomei essa decis=C3=
=A3o porque n=C3=A3o tenho nenhum filho que herdar=C3=A1 esse dinheiro e os=
 parentes de meu marido n=C3=A3o s=C3=A3o crist=C3=A3os e n=C3=A3o quero qu=
e os esfor=C3=A7os de meu marido sejam usados pelos incr=C3=A9dulos.

N=C3=A3o quero uma situa=C3=A7=C3=A3o em que esse dinheiro seja usado de ma=
neira =C3=ADmpia. =C3=89 por isso que estou tomando essa decis=C3=A3o. N=C3=
=A3o tenho medo da morte, portanto sei para onde estou indo. Eu sei que vou=
 estar no seio do Senhor. =C3=8Axodo 14 VS 14 diz que "o senhor lutar=C3=A1=
 contra meu caso e eu manterei minha paz".

Eu n=C3=A3o preciso de nenhuma comunica=C3=A7=C3=A3o telef=C3=B4nica a esse=
 respeito por causa da minha sa=C3=BAde, portanto, a presen=C3=A7a dos pare=
ntes de meu marido sempre perto de mim. N=C3=A3o quero que eles saibam sobr=
e esse desenvolvimento. Com Deus tudo =C3=A9 possivel. Assim que receber su=
a resposta, darei a voc=C3=AA o contato do Banco aqui na Abidjan de Costa d=
o Marfim.

Tamb=C3=A9m emitirei uma carta de autoridade que comprova voc=C3=AA o atual=
 benefici=C3=A1rio deste fundo. Quero que voc=C3=AA e a igreja orem sempre =
por mim, porque o senhor =C3=A9 meu pastor. Minha felicidade =C3=A9 que viv=
i a vida de um crist=C3=A3o digno. Quem quer que queira servir ao Senhor de=
ve servi-lo em esp=C3=ADrito e verdade. Por favor seja sempre piedoso ao lo=
ngo da sua vida. Entre em contato comigo neste email: (m.wallas@yahoo.com),=
 qualquer atraso em sua resposta me dar=C3=A1 espa=C3=A7o para procurar out=
ra igreja / organiza=C3=A7=C3=A3o ou indiv=C3=ADduo com esse mesmo objetivo=
. Por favor, assegure-me de que agir=C3=A1 de acordo com o que afirmei aqui=
. Na esperan=C3=A7a de receber sua resposta.

Permane=C3=A7a aben=C3=A7oado no Senhor.

Seu em Cristo,

Senhora Teresa Wallas.

