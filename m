Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E95532B31
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 15:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237332AbiEXNXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 09:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235573AbiEXNW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 09:22:59 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5D1994F6
        for <stable@vger.kernel.org>; Tue, 24 May 2022 06:22:55 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id v66so21369264oib.3
        for <stable@vger.kernel.org>; Tue, 24 May 2022 06:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=XeiufcpwSIY/Zpt8BFry97S7pt6Ekixag30xT58L2+Q=;
        b=dOx4+UtQO/4OdOdhCu5ecWkuEwzZHI7wsvpk/VHpK8XzEICiRoTjSuMKBa6rnFBfK5
         djUn+M6WFbg1GrQnpe1o4vpt8jn/I+hEs8UXy660ggevaMAppuHNdTorSV3O7kdJ628r
         IbQTv1WT5LUrCkGu0u9ZGUZrvsKOqJ0rV3fpzOK4uFOrbRhP3+kcCD+w5uBJeiKEnd26
         fPK6T6KgEEfTfXUb45o18TcTzl3jJTuae+Xz6oAvCLQD+OTGCskLIGot52v8s0dXYzJg
         N+eWJTjpSSNyGgwFhBhP7+ZwOI8Y9oGheih0EDwXcUUQ3VKutmTB3g+vEf8o6UjHKZwW
         4YJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=XeiufcpwSIY/Zpt8BFry97S7pt6Ekixag30xT58L2+Q=;
        b=y5FItIydYEct2dzK2MP3y0dWTrCoc1cFV9SRG96Wgbi1krOzH3SRdOSHoB2vRFM3p+
         WBi3BwsWP0u6XxMX+/YSdRROA59oniKPkcEjjCPCJ6Ck363iDsRn8BRp9wcHzUe1FOwk
         RpSefoy2on8nGKZoq0kKrAOoVzgMLBJmjT/uklAss8dz//oksXgmjichM5XQJ7EsGq1m
         EKIJALM44MjwLbeE4A7vbHohmfcjxULB8u/iIN9YSKE9w6CDGBd74zNKPWyoRDQ9MTjx
         S+F9QKuiu9NtwYvka3XFBf+H/c6KLGPHjBf8n90Ud3dmkeNMXoUokXF6uti1YgvZZKYu
         kO+Q==
X-Gm-Message-State: AOAM533OFAf2C2dlzM9bzyhX7dNsIHQowIMT46UjGdXdUaWXPQF4YltN
        ypKQAWc2BgLHsnA2RUtv3atf7aNeidDqXRowaY4=
X-Google-Smtp-Source: ABdhPJyfE3D2oTmcS5ulnnoqwnJv9wjykCzWTKkqrfgmApxm49ttOdH0/apGEbsEqKYwIZ5EVjEHuu7gG4kF8YUoAWs=
X-Received: by 2002:a54:469a:0:b0:322:9e32:e71a with SMTP id
 k26-20020a54469a000000b003229e32e71amr2212881oic.282.1653398574550; Tue, 24
 May 2022 06:22:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:9225:b0:9b:4d7b:9eb4 with HTTP; Tue, 24 May 2022
 06:22:53 -0700 (PDT)
Reply-To: ahb2017tg@gmail.com
From:   andrea mamon <cba1978tg@gmail.com>
Date:   Tue, 24 May 2022 15:22:53 +0200
Message-ID: <CAJoV5MRh+0oHK1kBauMUiRqFLVTezhXgtpZK2dFT8FR=Cxrs7w@mail.gmail.com>
Subject: Hola
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=7.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:243 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5155]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [cba1978tg[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.7 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.9 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Querido amigo ,

Mucho tiempo, espero que todo est=C3=A9 bien junto con su familia, si es
as=C3=AD, gloria a Dios Todopoderoso. Bueno, lamento escuchar esta noticia
y entender que la culpa no es m=C3=ADa. Me complace informarles sobre mi
=C3=A9xito en la transferencia de esos fondos bajo la cooperaci=C3=B3n de u=
n
nuevo socio de EE. UU. Actualmente estoy en EE. UU. para recibir
tratamiento mientras tanto, no olvid=C3=A9 sus esfuerzos pasados ??e
intentos de obtener los fondos a pesar de que nos fall=C3=B3 de alguna
manera. Ahora comun=C3=ADquese con mi pastor mientras estaba en Togo. Dej=
=C3=A9
$ 500,000.00 para usted.
como su propia parte para compensar sus esfuerzos de entrada durante
la transacci=C3=B3n sin importar que falle debido a su falta de
comprensi=C3=B3n.
Nombre: Pastora Mar=C3=ADa Antonio
Direcci=C3=B3n: 55 avenida slyvanus olympio
Correo electr=C3=B3nico: chika_abarla2008@yahoo.com
P=C3=ADdale que le env=C3=ADe la cantidad total de $ 500,000.00 d=C3=B3lare=
s
estadounidenses que dej=C3=A9 como compensaci=C3=B3n por todos los esfuerzo=
s e
intentos anteriores para ayudarme en este asunto. Apreci=C3=A9 mucho sus
esfuerzos en ese momento. As=C3=AD que si=C3=A9ntase libre y p=C3=B3ngase e=
n contacto
con ellos e ind=C3=ADqueles c=C3=B3mo desea recibir su parte.
Por favor, av=C3=ADsame de inmediato si recibes tu parte para que podamos
compartir la alegr=C3=ADa juntos despu=C3=A9s de todos los sufrimientos en =
ese
momento, est=C3=A1 bien.

En este momento, estoy muy ocupado con mi tratamiento y mi salud. As=C3=AD
que no dude en ponerse en contacto con mi pastor hoy de inmediato para
reclamar.
tu fondo Gracias de nuevo y que Dios los bendiga.

Saludos,
se=C3=B1ora andrea mam=C3=B3n
