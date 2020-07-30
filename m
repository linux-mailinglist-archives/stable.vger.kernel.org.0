Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF2C23300C
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 12:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgG3KIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 06:08:37 -0400
Received: from sonic309-20.consmr.mail.ne1.yahoo.com ([66.163.184.146]:44138
        "EHLO sonic309-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728916AbgG3KIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 06:08:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1596103710; bh=dGwizWYnZGK91DDxdP+Qz2TpW7F6J5jDYhhs+LKiHMg=; h=Date:From:Reply-To:Subject:References:From:Subject; b=VwpDFCZ64KoA/iay0Ru3OMfBdgWWrxv97vNW40SwIykV5yFpnTMxE6TL5ttNEaawcaCDD6ER48kRgXT/TWU/ZaqZCOLUobn1xl9tvcXuRDCbDDX8Ec+xIVeWj0vbK3xxh4+uGGykvx0o9tuI6GzxFiAMzfGtCanI9d5qeoYoh1sskHn6iDNYMQ2pG8MV1JCzVv4ISFTEMHdUY/IKEGJOHD2hFUSzLa/OvqskDAcxId5w4AxFOUK32B3vDY9/6rxCDpNsUgn9egs6CdOXb7Rd5WmcJDtxIsHNUgVIzQe6ttEsvDtPTYDKEWBgzxzgFqIuNXTUezovVyEAUC4o45/lbA==
X-YMail-OSG: 4Q1KbqQVM1nA0ivpA2xbqc9aNkDRBkAqfg3taGQ3.nSmslm58r.fOTRXoRZCswm
 TFSO85LzJ7F6C0P9yioX7EYXkI8WG.LAVQKrXNEruAb.DylQTCqbKRA57pQA97RrqwY39XS8G8jX
 w26pT_GG8YABh8.CVSilLV4yV4dWYe30ugUxfzEJNhxYmLh1NnKwNfQGXrcMun9rsDWAu_D7n0bG
 yrwK9jDbz65dzEfPN90v8Z830RZjMHYZfj_zxNF4i_m3SgUld9sf.NXPCubcNGhbN0MTzI1JTnUA
 WZhpMtMtOhHD8K1H8aFHbTs1.RfJasp5Wbvoi56Um2ExWljTsrPXQcLm4M9_c_jeYCp4zz5M4jdP
 X7uJab4v2t13IO.4MMFjeTsukWy1sS._3Nynp.7kmlte2TIwkIwrYgYtYknES.jBbQ8d3LhaDU0I
 ZF0Orz9BunyDnTGlArXORyQLTw.7SJQU53DSWzv4wNTc1KS05Ybjmul_CabvzWUaHjhWIqZ0dBJ2
 67z391PD5__UGzIb_J_rwzWbTYkdUumeZrX050dekpH6_ZJ3BWS5H1URj33pY38KKF6ydIj7TR47
 51bXKUWCSua6cMEr0Iyc5oCDKITsDo.6iSpovQ24KrPyi2puKBacuvY6x2LKhI6XIhInf93060Cy
 8ezcaGmWAFQ.lPyal2aLoejUQQ6DbSlUWMZx9JmYKjhRTkPII1rADfMJI9Y_TxBttPTn5mjb48te
 znvk9WTHeGiJ1kX0ZtCKquG9GcHQmkwmA8XcPNcrVzZGDCLwYtf.W6h.kQ8q.1QLLc.7UztwpJDH
 T9i6esnpGoR.Paaa5YpKGsJyk7ms_ef0tMpEDPlV78YX.KT1qP1aE7nNy.0jU258SboYa9wEzcuh
 kwfs.EjxdXZnjGZn31rpqebvd095FmfqYrfbkLKCkxc292P8lhi0Z50KgTnSIfpqgXxOpIjFxoH_
 Tb_RKojP.tGQwm7Gr0z1QTVE7HJ3CnjvOdXp3HuA_jwgSEUx7skvFdKv50hySiHKsrGsMTXUhyYm
 HXodi3.Sg3YereHTPykopphRb_4XXBPK4.QMwWISpF_zdSCKlGL6EfX4hG3TRVUSbU4bI4aYvw8C
 qihwMlZgbpVG0GQ6g2q7RgFD9CbAUGck4GhM8EVLwxPcwFmuBY7k.Xuo_2AGWcU7o4eR7EBUPpFD
 KhPWhsbQaYoMSgdvZe.e3DHrp6e9tHBcTWsobZmGJMcqMfZU8laMZK8adTws4TGHnEe3T5hxomoE
 ua3vRyzU0j9ksL1PQwTd0jgqeLPd78nH9Gr.kcJmFWq2t3rE-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Thu, 30 Jul 2020 10:08:30 +0000
Date:   Thu, 30 Jul 2020 10:08:25 +0000 (UTC)
From:   "Mr.Ahmed Muzashah" <ahmedmuzashah@gmail.com>
Reply-To: mrahmedmuzashah@gmail.com
Message-ID: <1853197067.9420883.1596103705265@mail.yahoo.com>
Subject: =?UTF-8?Q?Sch=C3=B6nen_Tag,?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1853197067.9420883.1596103705265.ref@mail.yahoo.com>
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
