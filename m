Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1E5214884
	for <lists+stable@lfdr.de>; Sat,  4 Jul 2020 22:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgGDUBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jul 2020 16:01:12 -0400
Received: from sonic305-21.consmr.mail.ir2.yahoo.com ([77.238.177.83]:34644
        "EHLO sonic305-21.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726153AbgGDUBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jul 2020 16:01:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1593892870; bh=ZWeDLwf4cGlLDzTwCuOen1zTINlp5j+f2ywobrqBR9o=; h=Date:From:Reply-To:Subject:References:From:Subject; b=WQlEU/R0+cJZsp8SW4Altdsz0vmNInoHBoiemNrV7AObViW7PjN7EGqyhpF3UddBXRlUCfnGtfXVwhAQlgk5nWnBtGd6nR3zoHFXJMblJVkFBeEcYoLg9FwYqK1sUlZ4k1RJknUmROwBa24WKk5yEZh+foCoAtKEFIq+RBh1zExpuFQJzqmL37AmthmDBKrCOofr6yduCFnk/g55GIkrAz8H1JIawns0AMzWj/zeGV3iQNTA0fZT/HS+GZjA/KxQLf15Z2FK4AOCStCjOAZwigbSDrngxmpXKp4TNNl3ngeeF51nEpPiQyzEdAZWxPnurY+JXeoJIa6NxoY+SFJKIw==
X-YMail-OSG: WsrsM9QVM1kCf9u635Sa8Tn6KMtOMcfvIMgvFME.J_dlc27rrI.vbXHqpjMcDD0
 1yJ3yQ6fwbPjMJ5P5SaFxPasNXhfLJ7f7v67UhK38R66fAQ0rUzqdG7ws0LkpqXnyBZU_LYeBdhA
 JLVPFJf0qhI5MMaoA6GkVxE5oI.0P9MWNRGSdY17_QfaNH5HE1wWxT9wJQBAHchkIcgv2ii28_BX
 CcsvBrDT2TtIpsMG8eJdOlgiN95szg79wJoPiCKK9ZIu21wySVq6Fqx45.WsN89r9..Wf6ehPU6.
 dulWc7zSxDqdoRnE1AqhfPRTzjd7lKBAavGwfhRVZ_1mPp3VxqZhnMi_KBmAc3..Xt1or8HiGRq5
 az2ZIOut69CBdVeZHBT0dbNCPCJkTEzTjXxheV4tcm8Mc.CbXGYGaMzB7rnG4hfe5CWKW0LNjhIp
 SieTX32RRyw_R1oHOgZzQvK8YU1pTcQudcBEv8iXk.BwkzMEjXAFRcGjNVhTKcxbapH6RtwDb7Cd
 Hdwb.fHctnuQePuF_OgN7twgQR1OFb12MI237xgPyozSG11uJKtwTrBpJkxMBAehRePSj_JbFf3C
 dWYi1803vMV95VYYLouA1u12FZQR4yKzCX3XMAeAH5m7.iqQjervlMR91pF2Dx0BPzIm2z5NjeAE
 rxKAw6SPyC_kR2SbH.zfwgWPSzAwemC2v0le8xoPVEcPbkSoQ_8ULBsTqYqp_8l01H2vzZr30hjq
 WdQ94JiNoIdjZpdxF6.CwWz4dvF.mQZ6QvxmfaYxaaQ.SYHrt4tY3MndmJTTKWS.xaoheDZJbRM0
 EbRvlW5zkyti5D.IjUp762QpQbaIyLG2B5JhUd87FXPBCeE1cIQpqC9FnB_TcNI3SrQfqElAISvq
 qXRQ0PZm.Xg3q39ILevqr.3FUGRd5Blj_6tvfRnEZ2UhSHCoYjnHP6tmPxQj5.OjnpAQ6SZT4kr2
 foS_.viaghzuwFYtsiM3K0Np8ooCALU.4VwnK1A1S2kPuAQ.1dQDPLkXhTxFVQBNMSFNvih4TEWD
 vb4kMBwgY9unQIYjqWxDmgtBhjYmCkUcOT8CU.ceoZJKwgLni4DawjVvWsqnOY2ssYNMA3s6F68u
 SAA608K4SyR3GyGUfO1lmOJD_BnGf0Aufi4MbEadj3XePyiI9ImVtyIHslE2Stm2ZRTeqHbm.qBi
 V5ELHVZv7uqtnXfkUKeN6x2d1Wrz8lD2stIxbcb5yUcMvgpHnRMUvHtb8XXFpEMk3WBU3Hzw6Buv
 y9tA4OfTbzDPLSmPk8cxewNeTah.0nk1L3M1tKqOzKTonNrEdXCYs83hT4D4EswxheHFq01ZYsMm
 CaVXv
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ir2.yahoo.com with HTTP; Sat, 4 Jul 2020 20:01:10 +0000
Date:   Sat, 4 Jul 2020 20:01:10 +0000 (UTC)
From:   Theresa Han <serena@lantermo.it>
Reply-To: theresahan21@hotmail.com
Message-ID: <641178172.4499921.1593892870359@mail.yahoo.com>
Subject: =?UTF-8?Q?Ich_gr=C3=BC=C3=9Fe_dich_im_Namen_des_Herrn?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <641178172.4499921.1593892870359.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16197 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101 Firefox/78.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ich gr=C3=BC=C3=9Fe dich im Namen des Herrn

Ich kann mir nicht vorstellen wie du dich f=C3=BChlen wirst Sie einen pl=C3=
=B6tzlichen Brief aus einem abgelegenen Land in der fernen Elfenbeink=C3=BC=
ste erhalten werden und wahrscheinlich von jemandem, mit dem Sie nicht gut =
verwandt sind. Ich appelliere an Sie, etwas Geduld zu =C3=BCben und meinen =
Brief zu lesen Umgang mit Ihnen in dieser wichtigen Transaktion
=20
Ich bin Frau Theresa Han, 65 Jahre alt, in der Elfenbeink=C3=BCste, an Kreb=
sleiden leidend. Ich war mit Herrn Johnson Han verheiratet, der bei der Reg=
ierung von Elfenbeink=C3=BCste als Auftragnehmer t=C3=A4tig war, bevor er n=
ach einigen Tagen im Krankenhaus starb
=20
Mein verstorbener Ehemann hat die Summe von US$2,5 Millionen (zwei Millione=
n f=C3=BCnfhunderttausend USD) bei einer Bank in der Elfenbeink=C3=BCste hi=
nterlegt. Ich habe an Krebs gelitten. K=C3=BCrzlich sagte mir mein Arzt, da=
ss ich aufgrund der Krebserkrankungen, an denen ich leide, nur noch begrenz=
te Lebenstage habe. Ich m=C3=B6chte wissen, ob ich Ihnen vertrauen kann, di=
ese Mittel f=C3=BCr Wohlt=C3=A4tigkeit / Waisenhaus zu verwenden, und 20 Pr=
ozent werden f=C3=BCr Sie als Entsch=C3=A4digung sein
=20
Ich habe diese Entscheidung getroffen, weil ich kein Kind habe, das dieses =
Geld erben w=C3=BCrde, und mein Ehemann Verwandte sind b=C3=BCrgerliche und=
 sehr wohlhabende Personen und ich m=C3=B6chte nicht, dass mein Ehemann har=
t verdientes Geld missbraucht wird
=20
Bitte nehmen Sie Kontakt mit mir auf, damit ich Ihnen weitere Einzelheiten =
mitteilen kann und jede Verz=C3=B6gerung Ihrer Antwort mir Raum geben wird,=
 eine weitere gute Person f=C3=BCr diesen Zweck zu gewinnen
=20
Warten auf Ihre dringende Antwort Mit Gott sind alle Dinge m=C3=B6glich
=20
Deine Schwester in Christus
=20
Frau Theresa Han
