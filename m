Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A4254E6EB
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 18:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbiFPQXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 12:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbiFPQXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 12:23:38 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38752ED54
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 09:23:36 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id h65so2010722oia.11
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 09:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=n7fvufN8T8cNUDt4b3uBUtYOZ0gShsn4TR9J8Mah/QQ=;
        b=hZp0iBm2MteiguYrUNyH/H8+iupSTQm/44Pbpwzae8k3N2H9nwtxOv9r0dQZvhgwSO
         7DmVC6WgUMXfTNfMmopO4eTSytG6ZNeP3uqbekZ82R6/qNzry1DryG56KaGj5X7mivTq
         Zcl5q9jIVdWYTLSU6lVeOxYUhCS0d641QwQ+uzPlb/em8Z0iy56L8iOViT24czmsq1qq
         a3CnMzavWMjNUae/udamkfuW60ZW81It3E+Rs7Iuba/jd1CUazeuFJXfSFdkmL1IreWx
         1Ix3XHBIYkWfBkYvazWJVDAFvmLrPkbScFrn7ShDKD6NLe/46L6/XUwMdNAAcmbGw670
         E8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=n7fvufN8T8cNUDt4b3uBUtYOZ0gShsn4TR9J8Mah/QQ=;
        b=mdZPay1lQdu0zfIA2M2FJdpu23g7Uu4rTsQn/tLiYkNcRQXuh9XaqWCS9Frgavuyn8
         CPhmxXi4sPSYwtbZOMzJoVI21uY9dtOUChDF3+xe2cMN352fjWtJLtUz2CC4/PB5Fh3S
         TWwIYHdOQkdW/vgdiexOS3RfVkUSFUX3P02fTVQ1rqvyehzjDprFSDKA/grpRdImQzU8
         zSWS4SSg7jYyFHq2bQcajSjBCa+euXikseNK0QFjcy5m0MWe/TF9MihySlbRUQR61coV
         6YtPGWOUtabuUDNFjyIFQPPBOg8UqEvViLYVtw8W7GyStb/nw/AN476S+syB2KW1oRt7
         5R7g==
X-Gm-Message-State: AOAM533PMsN19JR+HjCH6npcCtnvs95TW0CmJHUuDrnffRlrBLGVvWkg
        /zctToPXFqrk3293e5HdTembx+OOztsN1FERP9k=
X-Google-Smtp-Source: ABdhPJyZMIKvYkk31H0zwv1QEA6GlirRXHNUjevF2UxsDnurG8b/Vs6ONXMZ5ty8Pi6m2QHRgEEP9hhOjj4v+3zXWQg=
X-Received: by 2002:a05:6808:1189:b0:32b:7fb5:f443 with SMTP id
 j9-20020a056808118900b0032b7fb5f443mr8340278oil.269.1655396615681; Thu, 16
 Jun 2022 09:23:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:9b4c:b0:a5:8b59:81aa with HTTP; Thu, 16 Jun 2022
 09:23:33 -0700 (PDT)
From:   nnani nawafo <nnadinawafo11@gmail.com>
Date:   Thu, 16 Jun 2022 16:23:33 +0000
Message-ID: <CAPhDfr02y7L0OP04=kN=xxG7T_s_aexTS19VZ40ws79Wk0FYEQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Gratulujem!

Organiz=C3=A1cia Spojen=C3=BDch n=C3=A1rodov dospela k z=C3=A1veru, =C5=BEe=
 schv=C3=A1li vyplatenie
kompenza=C4=8Dn=C3=A9ho fondu vo v=C3=BD=C5=A1ke =C5=A1iestich mili=C3=B3no=
v americk=C3=BDch dol=C3=A1rov (6
000 000,00 USD) =C5=A1=C5=A5astn=C3=BDm pr=C3=ADjemcom na celom svete prost=
redn=C3=ADctvom
pomoci novozvolen=C3=A9ho prezidenta v d=C3=B4sledku ochorenia COVID-19
(koronav=C3=ADrus), ktor=C3=BD sp=C3=B4sobil ekonomick=C3=BD kolaps v roku =
r=C3=B4znych
krajin=C3=A1ch a glob=C3=A1lne ohrozenie to=C4=BEk=C3=BDch =C5=BEivotov.

 Organiz=C3=A1cia Spojen=C3=BDch n=C3=A1rodov poverila =C5=A1vaj=C4=8Diarsk=
u svetov=C3=BA banku, aby
v spolupr=C3=A1ci s bankou IBE v Spojenom kr=C3=A1=C4=BEovstve uvo=C4=BEnil=
a platby z
kompenza=C4=8Dn=C3=A9ho fondu.

Platba bude vystaven=C3=A1 na bankomatov=C3=BA v=C3=ADzov=C3=BA kartu a odo=
slan=C3=A1 =C5=A1=C5=A5astn=C3=A9mu
pr=C3=ADjemcovi, ktor=C3=BD o =C5=88u po=C5=BEiada prostredn=C3=ADctvom ban=
ky IBE v Spojenom
kr=C3=A1=C4=BEovstve prostredn=C3=ADctvom diplomatickej kuri=C3=A9rskej spo=
lo=C4=8Dnosti v
bl=C3=ADzkosti prij=C3=ADmaj=C3=BAcej krajiny.

Toto s=C3=BA inform=C3=A1cie, ktor=C3=A9 vedenie Spojen=C3=A9ho kr=C3=A1=C4=
=BEovstva vy=C5=BEaduje na
doru=C4=8Denie platby z kompenza=C4=8Dn=C3=A9ho fondu do prij=C3=ADmacej kr=
ajiny.

1. Va=C5=A1e meno:
2. Adresa bydliska:
3. Mesto:
4. Krajina:
5. Povolanie:
6. Sex:
7. Rodinn=C3=BD stav:
8.Vek:
9. Pas / ob=C4=8Diansky preukaz / prepojenie na vodi=C4=8Dov
10. Telef=C3=B3nne =C4=8D=C3=ADslo:
Kontaktujte n=C3=A1=C5=A1ho e-mailov=C3=A9ho z=C3=A1stupcu:
n=C3=A1zov solomo brandy

EMIL ADDRESS (solomonbrandyfiveone@gmail.com) pre va=C5=A1u platbu bez ome=
=C5=A1kania,

S Pozdravom
Pani Mary J Robertsonov=C3=A1.
