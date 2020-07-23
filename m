Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3E622ADD2
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 13:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgGWLfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 07:35:41 -0400
Received: from sonic307-56.consmr.mail.ne1.yahoo.com ([66.163.190.31]:34261
        "EHLO sonic307-56.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725846AbgGWLfl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 07:35:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1595504140; bh=dGwizWYnZGK91DDxdP+Qz2TpW7F6J5jDYhhs+LKiHMg=; h=Date:From:Reply-To:Subject:References:From:Subject; b=bI3AfobETvIO6FVT8UonmXgvR7+pIyEUfP+wmbwA6qnoUVVXXHxMtBvIPrRtIAFYsNPCa/bAYKXPmfO5s2mwi9NTMcCWTH7Sz/zD5/z7kIhSmRhw1x7mjaSvpS6jSMvvLGnOzoMdHtvG734ucyqQ/63YNVZkDQvXhPBR06wYeZ7ggECkKKRM+nOwJPLvR6iP17H1ggJEHyFW0Y4HtJjyoWzAytJUBopIhpwhSpZ9G8tnr3DL3+39lxfwhANl3p2vhVun5yjwBBfm5RAVi7OKTXaPmHUNEfFXJeHzkhc0vwVRBXukPv8uUWhfluuHELDPVGI+l7NUtLpFO0PAJkEkuA==
X-YMail-OSG: ORolTugVM1kLbpgeRxpwro.eSLPG8VaebLvV_Po_E5aXX4GFwMw8J.Ga03UiqEV
 eWpCZ0nZVNPf1QPvCvEe.MpZMOlbAyfGsJwDsX8HRCvuwrzPwvQrnwpsE8Xp45SkE2i9GtzjIIC1
 PDig5YJIuBzLJDn61q6rajGhB_8.Lh_KfHvmqff3_5W4ua09d11dM49IP2MhQty0pxOX5CvxajK7
 V.LyezlFkAskXDhhi7BLvD2qIteSg.lKzfAHxHCsFnr8dEU2MFS28XB9iovRxE0RDJtOMcBmRujT
 ASLjbcUxQ4GmSf7ZrWEI8bTb14lWo_EAAIi6zlLokyTeXXDfOcmV8hKGAkJiBR_T48khLvisNgTN
 dEYK.xug8yEqUF_l1I88pPbE11celk2YsiPcws1wz2EGbmX648K8tp4r2cPZz33HzFnH4sf3rJO.
 KZrAd07eR6CGlQ1BWC8MneUUi9r6a32EL2qWTCcj4vlj.KBvJIb1sXUhCb1Z.xgVPxHYgU9elguh
 UtHrKyL1grqeU4WeSu.k.p5rby8ciqa94PQNhwf5j2z1uq4m1zxWxg_l4t2TDcOXkD3nNJKcmjk4
 O2RRWgJYfe3QeB5Z5ChyQ9d06lnVQR4JR81E.XV.JABeWItkSU.AYqhqu.dbs10HpRZiAoOcT6R1
 XEy8k_he7ZA8TxocwRgep3ESFEL21o2mepiU7vf8iQcVZaONHLNyxG8Rk7T2qjEoc5bJCQNvsHq8
 vFcvvIRr1PHwxfNKglhD4GorLCYIIZ9e5In70lwZZC0WQFHdWb0IxwHbML1ixutnJYHERcfMSxjk
 mhnzYchddi2bfRU2ENRQt097L3KXyheciLh27J9gnrrvzp_kxe.NvbV3jvZ.b8qcRcQo4GikdfWZ
 J.55ArJMuEI2ZW0ACnZ6f7ZO9vtJuMzZnsi8pkjNs2hhYdzFs3KfsxFCWqiTM6L9zpBl34zAGwft
 hTaTRJbv9kNh4HRorua88o744JtFOjGH0Q.P5yG5tX1Czwdews5F.Pch6ow_T1wZB8YtptElB55U
 9YXRA_V5TEh5UA.f6Rw9PlRxB1G_iP21aSeqT.0wGr35DAPoWh10fQIOC9bBwCB_TIDyiL1GCu4.
 B27ICiIRwXYJUluJ3jFkSqBARMrRjw1x0XPzTIkRFUkCxuty_nNp7v2aHY1J9RBybIJpaRBV8T_F
 Q9lMEf._94mjDidNg1OXSwCQERmNjlSGv8Crl1WFQ97PtZVwyybUfhHSZ9XtEfeXF.bT2bO3xjna
 jAtBQQyYFVh__KCX3NeXniSh4xP.8LG.kMD23AQ1TsOj3NpMLWFoEsk6KIfD0r3apTVvvsNxql6t
 Cqg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Thu, 23 Jul 2020 11:35:40 +0000
Date:   Thu, 23 Jul 2020 11:35:35 +0000 (UTC)
From:   "Mr.Ahmed Muzashah" <ahmedmuzashah@gmail.com>
Reply-To: mrahmedmuzashah@gmail.com
Message-ID: <1735501629.5976359.1595504135452@mail.yahoo.com>
Subject: =?UTF-8?Q?Sch=C3=B6nen_Tag,?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1735501629.5976359.1595504135452.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sch=C3=B6nen Tag,

Bitte entschuldigen Sie, dass Sie einen =C3=9Cberraschungsbrief geschrieben=
 haben. Ich bin Herr Ahmed Muzashah, Account Manager bei einer Investmentba=
nk hier in Burkina Faso. Ich habe ein sehr wichtiges Gesch=C3=A4ft, das ich=
 mit Ihnen besprechen m=C3=B6chte. In meinem Konto ist ein Kontoentwurf er=
=C3=B6ffnet Ich habe die M=C3=B6glichkeit, den verbleibenden Fonds (15,8 Mi=
llionen US-Dollar) von f=C3=BCnfzehn Millionen achthunderttausend US-Dollar=
 eines meiner Bankkunden zu =C3=BCbertragen, der beim Zusammenbruch der Wel=
t gestorben ist Handelszentrum in den Vereinigten Staaten am 11. September =
2001.

Ich m=C3=B6chte diese Mittel investieren und Sie unserer Bank f=C3=BCr dies=
en Deal vorstellen. Alles, was ich ben=C3=B6tige, ist Ihre ehrliche Zusamme=
narbeit und ich garantiere Ihnen, dass dies unter einer legitimen Vereinbar=
ung durchgef=C3=BChrt wird, die uns vor Gesetzesverst=C3=B6=C3=9Fen sch=C3=
=BCtzt Ich bin damit einverstanden, dass 40% dieses Geldes f=C3=BCr Sie als=
 meinen ausl=C3=A4ndischen Partner, 50% f=C3=BCr mich und 10% f=C3=BCr die =
Schaffung der Grundlage f=C3=BCr die weniger Privilegien in Ihrem Land best=
immt sind. Wenn Sie wirklich an meinem Vorschlag interessiert sind, werden =
weitere Einzelheiten der =C3=9Cbertragung ber=C3=BCcksichtigt Sie werden an=
 Sie weitergeleitet, sobald ich Ihre Bereitschaftsmail f=C3=BCr eine erfolg=
reiche =C3=9Cberweisung erhalte.

Dein,
Mr.Ahmed Muzashah,
