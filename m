Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F9F2788FF
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 15:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgIYNEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 09:04:41 -0400
Received: from sonic308-1.consmr.mail.bf2.yahoo.com ([74.6.130.40]:39074 "EHLO
        sonic308-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728353AbgIYNEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 09:04:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1601039079; bh=dGwizWYnZGK91DDxdP+Qz2TpW7F6J5jDYhhs+LKiHMg=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Nbymp84HIrcWFqkkS+5HM1VK/RzZwgS+NyzPtRBuGAm652Bd8jv4FRy3BaTUrGoD7R0UZjVDMFVTWqlcwFtwoCZrOMofJ81HjpXupJ2QjCF4nUVqTwYhmIsce8oy/E7Vg4FAqIfJfma59v1cFOX5nMKWipYQoc5b6o95yadhbeI+4z0jULnvhzisScBY1C40csgX4J5dP548+nX5tnBdmfN3Pp20URpWpXZd/l4jVhzTnWN4Eosf5plzEE+426z2onX5jIwLIcxYO1oR5Yini5ioGEs2ZYsfTr/NcUcTfuSEh2xZQp+YoI1Rm+EQ08UvJ3Vh08x/Ex2ur+gyvRw0aQ==
X-YMail-OSG: 0aGa_p4VM1lun2FyocHZ8ls4TCmtJiWT_sHAGBNIuWYpt5VpVasZ1r.0AM7Ffq9
 lzxwCBuMOJeNaTKA4relPIHdC6m4QoFzco6dNKcBCqz0OimMLkSCP61F94_Pk8qn5DWRalcGb9mI
 QsIPMPu26RzoCKQQe7AmF1qKash.2ZLF2paXvLbLOQO1WBYsjg3OVb.QQqcDjQN6vPl4UaJma5Jr
 47dg.c88VbQ98jnJwkAxX5YfdyZcBZ7ji4wmATzCtuX1JTZDHElWFM.3xyXDaQdhfj1PRaVKqbAD
 zJs8hQTYKfPGinlWuoJTEZXd7fVIi8_JdlIFt04BBZrKjSmi2M22gQ.Zia21yrtoGvi8_SpO.K78
 iVPqzrAhRwJUKM6vHSFiKcxNjAVxTA8JOnBhsn2PqD1DyVMkXvZ.NFgHLdxXfv6DnhrPresv8NQg
 EkzD2Ri.xwiKr4wz5WwD6zEvfrVs07QOzZeyUBM97gzG20o2PVLAdyDuLbWp2o9MFaEdlbvgRw8Z
 bsOrOvjUOvRpvKfBCoqFcaSV53uj.5iSWo2zqIJtCk8F_.5c5jchPO1wtiFBl_1Lhd95UHNrFDwk
 TZSiflyPGkE4q_8hySGWhwN8jQwsQIGPjbpqAiNXo9sO.nHXq1o9.2PxFJsk6SG.hA6nFDLJGHKZ
 2390Qt3bd6ZcPqMFgM8cUj1FBIs8T62rRa5epacjEG_QvVCX4mNg1HZz3S_cybDWSRxPRdWHiWXF
 YAhKTMB16ZZQFpxI2Fkzis5u_TrsQT3CFQfASrig6rWLTFrvvHt7QZOHr24EiGiynONo6v84KM9a
 ECzh3mY4Tog1CYmkmYrlnb92BixOpzDiaCHWpmtYTXtAJhKIRDj8O4ie39kX2Wb8ApfHRUT.rtAq
 6ogV28o0z5_kLNBrLki24u4RSrPw78zC9G0gYz.vODuJ_7XLCrHtSIf.4S7n2pU9CgcMHxI5HXwc
 706jsYLXCqGlQlWXGt3hBizrnqXqtuBfh05bvqMItRhvinbq2OFdBhHQvKtKx9YalSnZLdnUGauT
 Nvio5iDffNwgDttKRPUaffVT64yJ.l1UR0VU_r5pGLsR9CzI.jBc6UvX_3kPQFD.stKHuyXrIDSi
 huT.pP1FerTkEEQEhKa_VOQXnNIlZ3Cs.eEJYeGpmKMsosOelt6dwV12TkZ7iYrpwVpk0ClmmYfD
 YTuxyS6C00WkZNFhfVpyy.7jkF60Xx9FkWBZ4WATR.r6N0mfbZobG3M8MGOnOTmLeTwvtcSvKWU9
 7AQ6UrGDurhYmxShLP.hnfYXzZIA75hfzFhqtwQaSWB7QWxlCjPfqatxVC4P7Zmg_kWl1B1Itghj
 oVyQqV2YcYsqSuuaqU8y0WgyzngPHc_I73EcEYetgi7WaaZU24O3AoYaq1Fjv.759ChTIaaOTtc_
 jv_YvpBqqc.Twg9FFW8Ds0x.ja8YXNsWvyOLRE_GCWSRheA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.bf2.yahoo.com with HTTP; Fri, 25 Sep 2020 13:04:39 +0000
Date:   Fri, 25 Sep 2020 13:04:39 +0000 (UTC)
From:   "Mr.Ahmed Muzashah" <ahmedmuzashah@gmail.com>
Reply-To: mrahmedmuzashah@gmail.com
Message-ID: <1766281751.649388.1601039079165@mail.yahoo.com>
Subject: =?UTF-8?Q?Sch=C3=B6nen_Tag,?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1766281751.649388.1601039079165.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16674 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
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
