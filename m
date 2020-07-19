Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50024224ECE
	for <lists+stable@lfdr.de>; Sun, 19 Jul 2020 05:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgGSDAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jul 2020 23:00:30 -0400
Received: from sonic301-30.consmr.mail.ne1.yahoo.com ([66.163.184.199]:41826
        "EHLO sonic301-30.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726390AbgGSDA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jul 2020 23:00:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1595127628; bh=Zh8f6bORM80VqMgICWCij9HH7uxxBhlOlIApnEIDMwE=; h=Date:From:Reply-To:Subject:References:From:Subject; b=tWtCoI0RA+q7qaYKo+48dy22O+EoeU36Y3iNFm2OyST/vsQctMyeKbbZgKrsSVcFP21K8DgKGA7XbSBHHfgkDQBN5vAvLatqn5gSNwHvd9twd/20JSzHnL5rVAiguk19FeFIwZxPvbgIiaucGnCGGFV/CPP3FzvDA1NwblVjZJjPc6l7tX5N1tVBTdUsI1214+Rk/Y+kjoiMEEh4RgtIjiYNEP7N6CpiqrwfDJkWMNjB7kRhgCgCsuIignU4TXsXPvHWA1AoBTZu7cXHckJDUCN3tFFzHZSiAfDDTn9+7vAgIHMLsNN+YyMNnNyKaMtRK0WgtOtSz+dr32yN3N5EPA==
X-YMail-OSG: 2ldGm44VM1liC2Uiwp0OIztjrvnEhUOJRwOd8M8cB.fXF41XzW8PXd0J98cl0F3
 BUhAVLeQPgTqlZlA2G1.F3pk8Xb4VFafhuLlCzcIXOj26B2OwGNx2dc9KAqbpGRwZlz7EMr5AeB3
 Ie7JjPYhfM6Qkk6hh52YWquA2FOwupLmTcUkHZ.12cAtJCYr3wRnDSdCTw6eiwHBxQmrL2CSdYWs
 xePvnSVPLcuSaBjEy86U018jc6BUlNE3VZb1s__VhkorYacZ39UR068l8if4GOUgy9wMcofw6TD4
 GlfSFNDRpv236pvhIEF2BUxSTqD35s5rcYgeprl_1EqTRxBcnSBOkziwbXnogVT8mR_193t4PxIH
 CvAJby5D_MZu0395PLH2EqlmxiVhaJG8xA_u0b99BHCeWm0qN2jKTXEYqOHHObiI_o4ivRtIHGMx
 2OcTp8A4QG6tL1Rmo37TDL0eOM7MGXt99DmCiM_gg7KORDbZnl2tTuxCMrjfP2BZY3325SgtcIf9
 QXtdoFkfjMs1R48DOcRBxbb7aMr.qgzR_ajHFDvHoCWo20MxP0e7tncxu7PLz4uUtD7mmJVZTsVk
 gM5cKpNcxUyvL80FS1uZCePEb8HKd.ldiha1tVnVY3.BeqFNlFTBe8ZoENrL2VI3eiI8M0sv3Lut
 QnmIbp9DIfigPpuWzzHG3ZvjYSy.eQM5m2NBWMwnlCeU2rYJzQSBjkFFzSxU7IWCB61YM2vzqGnV
 8C1GC1mfsmrCUNrJIS_rP_3TJPHBdEEQ8VIAzhvkUbN2Ub6L6E20zzZ874NWyjIOjGzXDBPrHrkG
 VSj.kaM.AcWCqO3_uaE_IhdATpK4Nqkywa.h8.97GVbz4faYuwu1uaXeVYQDK2CwgPzT75_lokk6
 UakvUPcVALgV2hTONBv13y_tmX0aeu8iEo39jBLekOxiEsuWQFHCe29WCFqszldRd8WQqRByCNQO
 FvnEdAmEDsiydNczCQUGpnFlbjm4m93ab2VPD_RQ1srBXLnnXhf.IsMe54vTfZvDs18kNK0J5Akp
 8Bl87oh3jOJ9NtFiC_78pC0qj0N5NaQXG4jRFME3wWCamdUqwwRX1fEQfgGGqgfGpixnzqgcYqOA
 feTrc2xNzXETrmCI9bcSRPhq8ycoOyLcSFUGh0Nb7Vo.sLp5CBQ1crI.jclxXL2mrQReLNEB.gTk
 fypu5QV2If3S7vSF8P9G0LBv2.up8esyWoNak1.PrLM3BFyktZBKPfB1bZO5bmGvhLQU3i6aiaTL
 jsI2oYVJz5MvLRHhu1RdDxSdAFNZrFA.58Q8h5Hh.QnIGG5ZM6kFx0KvvK3kTxZFVuQISoQP_ePN
 RJy_GGLoFrEZA63_yE2w1AONPorgnqA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Sun, 19 Jul 2020 03:00:28 +0000
Date:   Sun, 19 Jul 2020 03:00:24 +0000 (UTC)
From:   Sandrina Omaru <sandrinaomaru2019@outlook.fr>
Reply-To: sandrinaomaru2019@gmail.com
Message-ID: <831460570.3787391.1595127624431@mail.yahoo.com>
Subject: =?UTF-8?Q?Ahoj_drah=C3=A1?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <831460570.3787391.1595127624431.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101 Firefox/78.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ahoj drah=C3=A1

Viem, =C5=BEe mi po=C5=A1lete e-mail, aby som v=C3=A1s prekvapil, preto=C5=
=BEe v=C3=A1s pozn=C3=A1m. Pros=C3=ADm, je mi ve=C4=BEmi =C4=BE=C3=BAto, ak=
 m=C3=A1m z=C3=A1sah do ochrany osobn=C3=BDch =C3=BAdajov. Je mi pote=C5=A1=
en=C3=ADm kontaktova=C5=A5 v=C3=A1s s podnikate=C4=BEsk=C3=BDm z=C3=A1merom=
, ktor=C3=BD je odhodlan=C3=BD zalo=C5=BEi=C5=A5 vo va=C5=A1ej krajine.

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
