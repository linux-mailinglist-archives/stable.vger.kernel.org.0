Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1373A220621
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 09:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgGOHYa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 03:24:30 -0400
Received: from sonic302-1.consmr.mail.bf2.yahoo.com ([74.6.135.40]:39629 "EHLO
        sonic302-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728888AbgGOHYa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 03:24:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1594797868; bh=fC+Q4STjy2Khv8uGKhjNuH9xlCHziugnjXa1nFb72cA=; h=Date:From:Reply-To:Subject:References:From:Subject; b=h3z3PeCc5gCjMVCPaT49unzxNfAgc3IwxhDl/DPN2rNrmRkokPlxrfokf6oi5dLEpZXD5SI2QaOUymNUL7iJ0eShNU/zNBO8+nRMq5E/qcxk9uWmRWlhKZ+OPid/pps1UCsD2I9oC0mCBkMUt46nsfntsTDrbfeonhOTOvrg1+mv/C5AXmMg6gQt99jKypaEbzPXEQCOyQ/S+t+CGZBrxfPHJo4lLUV3qtno0pf4jaPvcr1MsV+0xg22RxqG5rhtRbSXdPbxOMElysB1N5Fy10xZjU1kvpEPznhv7rDvhWZq+lpQ7O1EwowQt2nwIP7p69mtofmkemdiOegRYjPD/g==
X-YMail-OSG: .aBNfJwVM1nGI0un7S3MH1R._kpDtrU2hsjX4qjr9BLxcF5OZRmPAoKDpcczG1y
 qHbH5l2NCpmgwUIY21gpRRdOhj9dTfiGHixqgA8_z9b0XbieNYwOa5CMS.JWSyJ2hHgD3Yfm1yAK
 9TGW6bmWxaMjvb.kkynU7EwciM.PiaTCzm_Mi71RuCICI4ezT32Krl6GBHOSLLpRfb6s2Lu..LT3
 Gf1EucisMqo.amUoQbOcVKwqoJ.GNjpSPrpor4ES.i6VZkCR6ltgsbD7j41YlXSGfc3lGOFbsSxz
 auaYtzJ810EjKy0R0gew8T_q.dI.v8xNkfaGkiikGIaJyzXXNYpdgkmVPWnkKwnE3K8N4rBK66ju
 wI.O.xMtDV5uo3WGVdo3Qn20_eZ6w.4OUId6V8g5ADqt1N0544ZdRbTQXTj6B_ZxyTbFTGhVAdAQ
 dEDgpBo0rUjl7ClVnJGuEwaai0bY7RUDYX4ORDPzcqr09Nw6BtskNSAFq9r5vYetqpTPndG30pbt
 tbe29tGjTapFoS7alo4Z43zRTUl9ph1lfNkjKdL5zDdW4u9TjeEm7Z9n9DVjPjACt1.MKMNQdf9j
 hrqbjFVUtUy6uUVXqOMTV7aXQkQmDNabH7mYZeXcIKnln354Swy8Tv0KTURqlS6ITZF2roj1WYP2
 h0PGfNPspirqDgahFn0WAhIjBgucE754oCQqdepdBymEnOleHl6Ky1d0FD2G7FK95Klnzy3zbRn6
 jGGSDUoH_guw.dBjnMPQRPL1_h1b7whzboOXst.BaDpSs92lGB79iEXQkBmgwAxHFq.ehs.GvD6s
 eJGjluCuO42B1HUbwOJ1haKmMIo3pPhbGA8jBXqqSGOPI178Uh8V_8gpYeNUwBhE4QGCBn6MWQVe
 0835lSNhGGh2LNPWY_JwBbosHhy_gICOecRhI3YwB4m4ExTtMOyZmDYAaUjB4HQ6w_h4bfgG.nM_
 Mk1FwJwXvIRiOL472fbR2mO7MMaREApbEFFkH6CODjpSFXFjIAK1ZA3XQtJj5orWQ8W5w6DPCrxe
 3If_JkEZMxl55dv0bpb3Ahawa6N11.6Ekf3JkNG2NBjAMQnBYfSIjKCBKJnXDBFnhivOIxdGohnn
 mlD0.xHga0MWMORaFPtozH4DRYEUiWfCzz9dxk0XCYo7MT9GO8LmpvdYIO0nhD2uc.nenNDms6cY
 W7XYcEvwacJ3_w7g_Aziqbgm7HCo.q40s2ziv42mj9UDzdC24LqsDOAODvKazDtC4erhbVgniJ1B
 rGVB4nL2SJJYGr56PZ_FXClj7E19jPOeITRjucWtey9.gSicNDOPRJ4rGNYsIPtMnAa6TaG7i08b
 Y0AXqezvUC_XC4gzPmZWODcZbnYvz
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.bf2.yahoo.com with HTTP; Wed, 15 Jul 2020 07:24:28 +0000
Date:   Wed, 15 Jul 2020 07:24:25 +0000 (UTC)
From:   Sandrina Omaru <sandrinaomaru2019@outlook.fr>
Reply-To: sandrinaomaru2019@gmail.com
Message-ID: <547052805.1330971.1594797865985@mail.yahoo.com>
Subject: =?UTF-8?Q?Ahoj_drah=C3=A1?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <547052805.1330971.1594797865985.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101 Firefox/78.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ahoj drah=C3=A1

Viem, =C5=BEe mi po=C5=A1lete e-mail, aby som v=C3=A1s prekvapil, preto=C5=
=BEe v=C3=A1s pozn=C3=A1m. Pros=C3=ADm, je mi ve=C4=BEmi =C4=BE=C3=BAto, ak=
 m=C3=A1m v=C3=A1=C5=A1 z=C3=A1sah do ochrany osobn=C3=BDch =C3=BAdajov. Je=
 mi pote=C5=A1en=C3=ADm kontaktova=C5=A5 v=C3=A1s s obchodn=C3=BDm projekto=
m, ktor=C3=BD je odhodlan=C3=BD zalo=C5=BEi=C5=A5 vo va=C5=A1ej krajine.

D=C3=B4vod, pre=C4=8Do som v=C3=A1s kontaktoval, aby ste to mali z d=C3=B4v=
odu naliehavosti a n=C3=A1tlaku, =C5=BEe mus=C3=ADm n=C3=A1js=C5=A5 niekoho=
, kto by mi pomohol. M=C3=B4j neskoro otec (Omaru, b=C3=BDval=C3=BD ministe=
r hospod=C3=A1rstva a financi=C3=AD Laurent Gbagbo a zomrel 11. janu=C3=A1r=
a 2012, ale zomrel pred svojou smr=C5=A5ou bol v obrovskom mno=C5=BEstve os=
em mili=C3=B3nov =C5=A1es=C5=A5stotis=C3=ADc eur (8,6 mili=C3=B3na), ktor=
=C3=A9 tu boli vo ved=C3=BAcej banke, Ivoire. Zriedka bol ulo=C5=BEen=C3=BD=
 v Slonovine, kde =C4=8Dakal na pomoc, tak=C5=BEe ma neve=C4=8F ako bud=C3=
=BA tieto peniaze preveden=C3=A9 mimo krajinu, tak sa odtia=C4=BEto s=C5=A5=
ahujem, aby som pokra=C4=8Doval vo svojom vzdel=C3=A1van=C3=AD vo va=C5=A1e=
j krajine, zatia=C4=BE =C4=8Do vy m=C3=A1te na starosti investovanie s peni=
azmi.

Pokorne h=C4=BEad=C3=A1m Bo=C5=BEiu pomoc nasleduj=C3=BAcimi sp=C3=B4sobmi;=
 Mus=C3=ADm poskytn=C3=BA=C5=A5 bankov=C3=BD =C3=BA=C4=8Det skuto=C4=8Dnost=
i, =C5=BEe tieto peniaze bud=C3=BA preveden=C3=A9, aby sl=C3=BA=C5=BEili ak=
o str=C3=A1=C5=BEca tohto mosta pre siroty a st=C3=A1le ve=C4=BEmi mlad=C3=
=A9. Ak mi m=C3=B4=C5=BEete pom=C3=B4c=C5=A5, som r=C3=A1d, =C5=BEe v=C3=A1=
m m=C3=B4=C5=BEem pon=C3=BAknu=C5=A5 25% z celkovej sumy pe=C5=88az=C3=AD a=
 5% na v=C3=BDdavky, s ktor=C3=BDmi m=C3=B4=C5=BEete tento proces previes=
=C5=A5. O=C4=8Dak=C3=A1va sa, =C5=BEe na v=C3=A1s budem okam=C5=BEite reago=
va=C5=A5, tak=C5=BEe s vami budem hovori=C5=A5.
Kontaktujte ma tu v mojom s=C3=BAkromnom e-mailovom ID sandrinaomaru2019@gm=
ail.com
Boh =C5=BEehnaj
Needy.Love
Sandrina Omaru.

Je n=C3=A1m =C4=BE=C3=BAto, =C5=BEe som t=C3=BAto spr=C3=A1vu odoslal do pr=
ie=C4=8Dinka so spamom kv=C3=B4li chybe v sieti, preto=C5=BEe tu v mojej kr=
ajine.
