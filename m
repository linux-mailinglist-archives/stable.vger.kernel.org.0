Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB5F2350B4
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 07:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgHAFim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 01:38:42 -0400
Received: from sonic307-10.consmr.mail.ne1.yahoo.com ([66.163.190.33]:38157
        "EHLO sonic307-10.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725497AbgHAFil (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Aug 2020 01:38:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1596260320; bh=dGwizWYnZGK91DDxdP+Qz2TpW7F6J5jDYhhs+LKiHMg=; h=Date:From:Reply-To:Subject:References:From:Subject; b=b7UMN9CYh2knJmRaHgCaRYAn5Wk60zuutFYwEEszKMlnq0St/xn4oHg+zRtaWq50BnqnkmLUTyh5IDAYCczLJ47YAcHR7ynBF+U7RF3oAABxckuoe2a5fIrUl8LfIl6q+bkNpUseydtCieOwAOVqIIeCNkKFI3bndUFo6iuVJdtDEqrJvF9eSunWCRyD1nrLJP6ysPNOhktgRxs/u/zFeyIFFUO0ZteQGyua2Mq4B2upos/01eqSRrL1I3DdDt86Bs55WybsGaFJJtfyM1FRAH2gUTDzk4CTZlRY0g3Yv+0R9fUh6XCVAWSwJaEnCxQVf+4a3ixN9LUlhpqsqwEL0Q==
X-YMail-OSG: 9CO2tzYVM1nUPLO.pyJ79nVoxHst_R.SDvqahzbg2ub.F.z9WwjaxOT7DOKmx93
 ZV0Gr0e_NxtvHXDjA9BN5_pvI7C8BbSwGMP2KJhnBFdGMYr3yg8OX8x40AKylMckp4nt0nVuZ2e8
 UXnPQblJqN819g2PJuKokxWj2VGgJrPWXB1UCXDmm3avPgbO7N9.dX5jcP9m0PmyadKHCB7pgJNY
 3ASkdmGr26.7SpYVnLPmsJhI5zwWS8F7adg9EBXKwxvBXTV0a3W3exWPwywFIj7NcBOg9WYdvtMF
 KAz1izD0MWSCJMIFqhRJZ7hgQr8aIehAQDviql_p9vUllUWMq2du0W1l10kYouSdsnHh6xVnsNXJ
 bSKNuDlH2XgzymkbVSWxOTISvs27iwoR.aH4wCFnKhO5kcsLJQW51.17OG9FL_yhPZy4htk33dVL
 PiDG1SRNAnDWqIhtHC2J8NLbZeGpguxkUTI8yx5CMrcT2AMSNcjM1eLfUL8..2ZRVHkOCGeJs2Ta
 UMNZ0lMzY8taNEL4Rv6G4vRmuqRBKeslJXffFaCEA7Wwv5B5PmRKIQ6b0Kuik3N0DQSRBJyphyF3
 j7RhpyydfkDvoAF5KHJWxFPSHb3JZwdmbkrN3YuqHE7qPDB4rjAHfHNVjk_CF4EwqQPUwvKfWQ._
 vlVGbtOiugyH6OwKClvFovN1arZ4wX7tZ__D8wiVWsEHuZ17IA3mLPEL3IR7z4fhIvpndbNGlzqT
 EDWXfn0VYKJlZByBG43lRNE4pqmrLn7XCDupeWrowMEMhhW5JsrpSKITIvXPKWP4ldiWudahx_u_
 rxguqdCsq9bulD65R02RJmdOKXzvs2wxHWFi5cl3yhkrzFX2c3579NR2izbxKJTzMpCRzrLGxiRQ
 vRrWwhbgg29N01_yF8niSvmM4svc6KIcO9BPs3xtvG0wkbBk1sODTBZWDf5DWDXDwIlOjlr6oGJT
 A.CBmG8NUYPH5nwZbQLh08yzhIi_YVBVZjS5YAhnjbJ4e5zQtXa7zsOckTrxxGsdXCEy1nz1Rk2x
 rQxWbLIDgGjmYcZzfNHpscagyGRJSiQUY_g4hYPdJA35.6lcjSIw..3ev5T0xIf6OuzL3UJjZlLH
 KOwr23ZnIqC9gJpgm3.7MzxuVrL9J4SmV3Idem3G_CcEnSILYXNj9mxaQZik.806d2U88XMjbHIY
 jTmfoQ45qRSU.uJFrCVr03ASog0ja2E7Sawv.MUeZRSXnnbF3bDq4cmYw5YhrHbRe3mRuCt2t03p
 51aNWwFO1PJ1VRyEmx8GwlixbHMU2O9ZpmRQ-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Sat, 1 Aug 2020 05:38:40 +0000
Date:   Sat, 1 Aug 2020 05:38:40 +0000 (UTC)
From:   "Mr.Ahmed Muzashah" <ahmedmuzashah@gmail.com>
Reply-To: mrahmedmuzashah@gmail.com
Message-ID: <832534482.10423451.1596260320222@mail.yahoo.com>
Subject: =?UTF-8?Q?Sch=C3=B6nen_Tag,?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <832534482.10423451.1596260320222.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36
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
