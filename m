Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926091E8FD7
	for <lists+stable@lfdr.de>; Sat, 30 May 2020 10:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgE3Imj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 May 2020 04:42:39 -0400
Received: from sonic305-35.consmr.mail.bf2.yahoo.com ([74.6.133.234]:38442
        "EHLO sonic305-35.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728404AbgE3Imj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 May 2020 04:42:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1590828156; bh=+KYzMZVpJshMSj0g6TX9eXW4HgddQ5vPPZTG6Ti/GIU=; h=Date:From:Reply-To:Subject:References:From:Subject; b=NWJq/Bj308MWoxE6FKrN2C8Plm3XjRDwmgqm2yt5lYqHSJfk4qPhEnTVCxgHeagc3VHLyf8L8bSELlDMI2AKkDO8g+i1el2VuegMm1iy8BD74boSXkYdXr7UjwVYAa1d60MUKmB6XBK+Hx/3luxZTASEi7iYnHt46V7PbrFd5at5e8QjMUTVnJeJ82MZIB14yE73vEsecvj7DQiLgthb0gruOGtSy9p2ufo1M9ynDlc7rvE6rgz68adGV+edByPEiJ9SCpylMbMrTsJbp8XyIkVvBydJvqWEjCOC7r7zVgbYNvDk8ute+hM+v6bXFuWNWvaTXb4U86b34Sb2+/6AYA==
X-YMail-OSG: cYiPKdsVM1lrGCXPNRxnwely17v8AUOMFFKCAe5KD5IVdtpvsKUIK61pvWGd4bl
 GJFnqFgJonzU2OqNwjzg450RweGvLeecf2sAjzgZ.6x8wAq1KxJH0i5VBnlC3EzNfJVsjbltZk8I
 s4qoj4ftiRsN2lfhwCM6fPZD2elFaK_0c7Vs.uFHbY5ra5mlrQo9TEeviHnqM7bue_fD6UDSAnEL
 O7y1e4EQSZmnX3.K7gjEijPhY4jkhGKFKssITiNIhIl_XnHCHCDSUEI8kE8djZDyz4v63rHD6BoF
 JMarh_uK5N9RLHlL06F.o9apD.kYLbes48tOrY3mwx6kGepLQTLFzU9E63YthcOuC56YL00rSt.u
 ceg3ZMB4hwRrE8G87VOMJ2P.LEmklvd6bXJstGD8fkBIjBvQwzBDdlucAWsygS4c8zvzD4V35KYS
 K7ky5nAyvJmbJdRUCn5ITOwns30ybYAdg6VtiFobibqM8pG..0UPoCDcJfYgdLQ205mlBGptvotz
 zR1H_Bvr5sLqJOSB_ocN_Cn7t.yPZGC7C7IUs14J2BdoQunVg1VXbaWrR_lsyxb3gHvenNFaDyAZ
 5VYmV0dbDFzTOwhzHPy5uBzhu8xlHmsRHbpcBzyHKuEkQAcU.JwDPoFRj_QSxS2p3KQBJFNzrf1e
 _2hzA7QbOg7.sWRKZmMzWelgubiXNXr9SpYKM99hQ2lVJdCFgq8Ucn7YHm5CmbFtxJhM3UU1sCDd
 sWn9sMQVvyCkHn2tIYqVOjBZdD1MuA4gfCK7SeqUpgbRknJku_UVb0wtETHNdz7Ja.uwAALicNrP
 5nVIECp3A6WQK.HcOTdX3eQLuJcj9.0ub0lq7qsTaTlfFjM6BuPWdmsZK0..pgrRUgrDvvGLr5XF
 GcP7OCVhMPv1ptaxVxdD1QGr19XBJy.Js.3jLPQnFOfzpEeelRFiKtqLkJr5EIHlTOSKvBVx48hH
 xEBx5kTctpdwqgWrizATIVO3nsh_jVMeZbAMQ1qkfMh0ScZIqZQKKMkyyvpEstS2laF9XvTCB8IL
 70kmlkR35qtGPgIAacJSOzV4Tp2xTRQIpqyGdnX7Z_zuQDdVQDMnAZDjSaiM0TQfMaYWFA7vXlsM
 _JN.rBhNlaTRN6HAqc_on9j8gBWcdbp4OBkciWdMZAKAW6qCh5qI7d_HS2EWeVhdh385kB_6zKWM
 93dZQfUJ5bLKloAZAfGTlhYnhyUbxDn4RSnP4Q6pCtDiNqdRpMu1k5cL52ssHQBqfXvP8TNgxEBR
 K2viiw1gzh4KQGmHoM4binAjNhoTZoLBmJsK6sQbENzgtZBx2ExaVKFiDND2YOEIM037cePDMcba
 jDx6CkTdlUERAlMf8HRfkSsGBE4_UF6d21Nde0rnW0ifwuC3XwM56NqwMGg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.bf2.yahoo.com with HTTP; Sat, 30 May 2020 08:42:36 +0000
Date:   Sat, 30 May 2020 08:40:36 +0000 (UTC)
From:   "From Mr. Themba Williams" <sb14@gnabdc.in>
Reply-To: williamsthemba03@gmail.com
Message-ID: <1727636782.50782.1590828036123@mail.yahoo.com>
Subject: Assistance/ Fund Transfer
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1727636782.50782.1590828036123.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16037 YMailNodin Mozilla/5.0 (Windows NT 5.1; rv:39.0) Gecko/20100101 Firefox/39.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



From=C2=A0Mr.=C2=A0Themba=C2=A0Williams
Email:=C2=A0williamsthemba03@gmail.com

Dear=C2=A0,

I=C2=A0am=C2=A0Mr.=C2=A0Themba=C2=A0Williams=C2=A0a=C2=A0Southern=C2=A0Afri=
can=C2=A0to=C2=A0Late=C2=A0Col.Muammar=C2=A0Gaddafi=C2=A0financial=C2=A0adv=
iser=C2=A0to=C2=A0the=C2=A0former=C2=A0Libyan=C2=A0leader,=C2=A0I=C2=A0am=
=C2=A0sending=C2=A0you=C2=A0this=C2=A0email=C2=A0in=C2=A0respect=C2=A0of=C2=
=A0my=C2=A0client=E2=80=99s=C2=A0funds=C2=A0that=C2=A0was=C2=A0deposited=C2=
=A0in=C2=A0a=C2=A0reputable=C2=A0financial=C2=A0institute=C2=A0here=C2=A0in=
=C2=A0South=C2=A0Africa=C2=A0and=C2=A0my=C2=A0client=C2=A0thought=C2=A0the=
=C2=A0said=C2=A0funds=C2=A0has=C2=A0been=C2=A0seized=C2=A0before=C2=A0he=C2=
=A0died.=C2=A0Now=C2=A0the=C2=A0Government=C2=A0is=C2=A0trying=C2=A0to=C2=
=A0liquidate=C2=A0all=C2=A0late=C2=A0Gaddafi=E2=80=99s=C2=A0funds=C2=A0in=
=C2=A0the=C2=A0Southern=C2=A0Region.

I=C2=A0would=C2=A0need=C2=A0your=C2=A0assistance=C2=A0to=C2=A0move=C2=A0the=
=C2=A0funds=C2=A0out=C2=A0of=C2=A0South=C2=A0Africa=C2=A0to=C2=A0your=C2=A0=
country=C2=A0based=C2=A0on=C2=A0the=C2=A0fact=C2=A0that,=C2=A0all=C2=A0my=
=C2=A0activities=C2=A0are=C2=A0presently=C2=A0monitored=C2=A0and=C2=A0I=C2=
=A0cannot=C2=A0make=C2=A0any=C2=A0move=C2=A0to=C2=A0transfer=C2=A0the=C2=A0=
fund=C2=A0out=C2=A0on=C2=A0my=C2=A0own=C2=A0without=C2=A0the=C2=A0help=C2=
=A0of=C2=A0foreign=C2=A0beneficiary,=C2=A0hence=C2=A0I=C2=A0seek=C2=A0your=
=C2=A0assistance.=C2=A0I=C2=A0will=C2=A0send=C2=A0more=C2=A0information=C2=
=A0to=C2=A0you=C2=A0if=C2=A0you=C2=A0accept=C2=A0to=C2=A0assist=C2=A0me.=C2=
=A0If=C2=A0you=C2=A0read=C2=A0in=C2=A0news,=C2=A0you=C2=A0will=C2=A0see=C2=
=A0that=C2=A0the=C2=A0US=C2=A0government=C2=A0has=C2=A0already=C2=A0seized=
=C2=A0$200billion=C2=A0dollars=C2=A0of=C2=A0my=C2=A0late=C2=A0client=E2=80=
=99s=C2=A0wealth=C2=A0in=C2=A0the=C2=A0United=C2=A0State=C2=A0of=C2=A0Ameri=
ca=C2=A0and=C2=A0the=C2=A0British=C2=A0did=C2=A0the=C2=A0same=C2=A0too.=C2=
=A0So=C2=A0therefore,=C2=A0I=C2=A0am=C2=A0trying=C2=A0to=C2=A0make=C2=A0sur=
e=C2=A0they=C2=A0don=E2=80=99t=C2=A0find=C2=A0the=C2=A0$45Million=C2=A0that=
=C2=A0is=C2=A0deposited=C2=A0in=C2=A0South=C2=A0Africa=C2=A0through=C2=A0my=
=C2=A0help.

This=C2=A0is=C2=A0why=C2=A0I=C2=A0am=C2=A0trying=C2=A0to=C2=A0move=C2=A0the=
=C2=A0funds=C2=A0as=C2=A0soon=C2=A0as=C2=A0possible=C2=A0because=C2=A0prese=
ntly=C2=A0I=C2=A0have=C2=A0been=C2=A0questioned=C2=A0by=C2=A0the=C2=A0South=
=C2=A0African=C2=A0Government=C2=A0regarding=C2=A0the=C2=A0fund=C2=A0if=C2=
=A0there=C2=A0is=C2=A0any=C2=A0beneficiary=C2=A0attached=C2=A0to=C2=A0the=
=C2=A0fund=C2=A0and=C2=A0I=C2=A0said=C2=A0yes,=C2=A0that=C2=A0is=C2=A0why=
=C2=A0you=C2=A0need=C2=A0to=C2=A0come=C2=A0in=C2=A0to=C2=A0stand=C2=A0as=C2=
=A0the=C2=A0beneficiary,=C2=A0and=C2=A0I=C2=A0will=C2=A0make=C2=A0sure=C2=
=A0that=C2=A0I=C2=A0give=C2=A0all=C2=A0the=C2=A0backup=C2=A0documents.

I=C2=A0want=C2=A0you=C2=A0to=C2=A0know=C2=A0that=C2=A0I=C2=A0have=C2=A0a=C2=
=A0past=C2=A0and=C2=A0history=C2=A0to=C2=A0protect=C2=A0and=C2=A0I=C2=A0act=
ually=C2=A0came=C2=A0across=C2=A0your=C2=A0contact=C2=A0information=C2=A0wh=
ile=C2=A0using=C2=A0a=C2=A0soft-ware=C2=A0called=C2=A0the=C2=A0internet=C2=
=A0web=C2=A0detective.=C2=A0Having=C2=A0studied=C2=A0a=C2=A0bit=C2=A0of=C2=
=A0your=C2=A0profile=C2=A0as=C2=A0displayed=C2=A0by=C2=A0the=C2=A0web=C2=A0=
detective=C2=A0I=C2=A0came=C2=A0to=C2=A0the=C2=A0conclusion=C2=A0that=C2=A0=
you=C2=A0will=C2=A0be=C2=A0a=C2=A0very=C2=A0trustworthy=C2=A0and=C2=A0relia=
ble=C2=A0partner=C2=A0since=C2=A0you=C2=A0have=C2=A0had=C2=A0no=C2=A0crimin=
al=C2=A0records=C2=A0in=C2=A0the=C2=A0past=C2=A0or=C2=A0present,=C2=A0hence=
=C2=A0I=C2=A0contacted=C2=A0you=C2=A0because=C2=A0I=C2=A0know=C2=A0you=C2=
=A0are=C2=A0capable=C2=A0to=C2=A0handle=C2=A0this=C2=A0project=C2=A0and=C2=
=A0assist=C2=A0me=C2=A0to=C2=A0receive=C2=A0these=C2=A0funds.=C2=A0As=C2=A0=
soon=C2=A0as=C2=A0I=C2=A0receive=C2=A0your=C2=A0email=C2=A0I=C2=A0will=C2=
=A0send=C2=A0you=C2=A0more=C2=A0information=C2=A0and=C2=A0also=C2=A0the=C2=
=A0contact=C2=A0of=C2=A0the=C2=A0financial=C2=A0institute=C2=A0here=C2=A0to=
=C2=A0contact=C2=A0them=C2=A0and=C2=A0make=C2=A0further=C2=A0claims=C2=A0of=
=C2=A0these=C2=A0funds=C2=A0to=C2=A0your=C2=A0possession=C2=A0and=C2=A0hold=
=C2=A0it=C2=A0till=C2=A0I=C2=A0come=C2=A0over=C2=A0to=C2=A0your=C2=A0countr=
y=C2=A0for=C2=A0investment=C2=A0purpose.

But=C2=A0please=C2=A0I=C2=A0want=C2=A0you=C2=A0to=C2=A0know=C2=A0that=C2=A0=
I=C2=A0am=C2=A0working=C2=A0with=C2=A0you=C2=A0with=C2=A0full=C2=A0trust=C2=
=A0and=C2=A0honesty=C2=A0on=C2=A0this=C2=A0because=C2=A0the=C2=A0new=C2=A0G=
overnment=C2=A0of=C2=A0Libya=C2=A0is=C2=A0seriously=C2=A0looking=C2=A0for=
=C2=A0all=C2=A0funds=C2=A0under=C2=A0my=C2=A0late=C2=A0client=E2=80=99s=C2=
=A0name.
The=C2=A0total=C2=A0fund=C2=A0is=C2=A0$45Million=C2=A0and=C2=A0you=C2=A0sha=
ll=C2=A0have=C2=A030%=C2=A0of=C2=A0the=C2=A0total=C2=A0amount=C2=A0for=C2=
=A0assisting=C2=A0me=C2=A0in=C2=A0making=C2=A0this=C2=A0transfer=C2=A0a=C2=
=A0successful=C2=A0one.=C2=A0I=C2=A0also=C2=A0want=C2=A0you=C2=A0to=C2=A0kn=
ow=C2=A0that=C2=A0there=C2=A0is=C2=A0no=C2=A0legal=C2=A0implication=C2=A0of=
=C2=A0any=C2=A0kind=C2=A0or=C2=A0any=C2=A0unforeseen=C2=A0one=C2=A0and=C2=
=A0it=C2=A0is=C2=A0100%=C2=A0risk=C2=A0free=C2=A0and=C2=A0it=C2=A0is=C2=A0c=
ompulsory=C2=A0you=C2=A0keep=C2=A0every=C2=A0detail=C2=A0in=C2=A0this=C2=A0=
message=C2=A0confidential=C2=A0and=C2=A0secretive=C2=A0between=C2=A0us=C2=
=A0and=C2=A0the=C2=A0bank=C2=A0official=C2=A0that=C2=A0will=C2=A0be=C2=A0as=
sist=C2=A0us.=C2=A0I=C2=A0also=C2=A0want=C2=A0you=C2=A0to=C2=A0know=C2=A0th=
at=C2=A0none=C2=A0of=C2=A0my=C2=A0client=E2=80=99s=C2=A0relative=C2=A0know=
=C2=A0about=C2=A0these=C2=A0funds=C2=A0and=C2=A0everyone=C2=A0thought=C2=A0=
that=C2=A0the=C2=A0funds=C2=A0had=C2=A0been=C2=A0seized.=C2=A0As=C2=A0soon=
=C2=A0as=C2=A0we=C2=A0have=C2=A0the=C2=A0change=C2=A0ownership=C2=A0of=C2=
=A0the=C2=A0fund=C2=A0done=C2=A0to=C2=A0your=C2=A0name=C2=A0then=C2=A0we=C2=
=A0can=C2=A0make=C2=A0transfer=C2=A0of=C2=A0the=C2=A0funds=C2=A0out=C2=A0to=
=C2=A0your=C2=A0designated=C2=A0account=C2=A0in=C2=A0yuor=C2=A0country=C2=
=A0or=C2=A0else=C2=A0where=C2=A0in=C2=A0the=C2=A0world.

Please,=C2=A0kindly=C2=A0get=C2=A0back=C2=A0to=C2=A0me=C2=A0on=C2=A0my=C2=
=A0email=C2=A0address=C2=A0below=C2=A0to=C2=A0enable=C2=A0me=C2=A0forward=
=C2=A0you=C2=A0more=C2=A0information.=C2=A0We=C2=A0would=C2=A0need=C2=A0a=
=C2=A0mutual=C2=A0agreement=C2=A0which=C2=A0we=C2=A0will=C2=A0sign=C2=A0to=
=C2=A0that=C2=A0effect=C2=A0immediately.=C2=A0Please,=C2=A0as=C2=A0a=C2=A0r=
esult=C2=A0of=C2=A0the=C2=A0present=C2=A0issue=C2=A0in=C2=A0Libya,=C2=A0I=
=C2=A0would=C2=A0want=C2=A0you=C2=A0to=C2=A0keep=C2=A0this=C2=A0confidentia=
l=C2=A0because=C2=A0if=C2=A0the=C2=A0Government=C2=A0finds=C2=A0out=C2=A0ab=
out=C2=A0the=C2=A0funds,=C2=A0it=C2=A0would=C2=A0be=C2=A0confiscated.=C2=A0=
The=C2=A0transfer=C2=A0is=C2=A0100%=C2=A0risk=C2=A0free=C2=A0as=C2=A0all=C2=
=A0the=C2=A0paper=C2=A0works=C2=A0that=C2=A0would=C2=A0prove=C2=A0the=C2=A0=
legitimacy=C2=A0of=C2=A0the=C2=A0funds=C2=A0when=C2=A0it=C2=A0is=C2=A0trans=
ferred=C2=A0into=C2=A0your=C2=A0account,=C2=A0would=C2=A0be=C2=A0made=C2=A0=
available=C2=A0by=C2=A0the=C2=A0bank=C2=A0including=C2=A0the=C2=A0origin=C2=
=A0of=C2=A0funds=C2=A0that=C2=A0would=C2=A0be=C2=A0issued=C2=A0as=C2=A0a=C2=
=A0contract=C2=A0payment.
Please=C2=A0contact=C2=A0me=C2=A0here=C2=A0only=C2=A0for=C2=A0security=C2=
=A0reasons:=C2=A0williamsthemba03@gmail.com
Regards,

Mr.=C2=A0Themba=C2=A0Williams.
