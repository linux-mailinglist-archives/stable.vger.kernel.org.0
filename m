Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93BA623C910
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 11:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgHEJUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 05:20:38 -0400
Received: from sonic317-34.consmr.mail.ne1.yahoo.com ([66.163.184.45]:40394
        "EHLO sonic317-34.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728511AbgHEJRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 05:17:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1596619035; bh=dGwizWYnZGK91DDxdP+Qz2TpW7F6J5jDYhhs+LKiHMg=; h=Date:From:Reply-To:Subject:References:From:Subject; b=IjmFhclrG2pBO7pPAX/5qd0CcUY9/ueaPcTQnPb6SNttjxiqaIsPmTSC2dnLbmzG8+jetf+zFKjqF8ZyARav8cEUb5LLH2ksYrM2siTlNkwSfE8ul80pOPjqbxqmDxi7B3xF16t7VTLcLHpoFuIYYutG/ufwo74P8UlfkDruJfoOWsRm/8/HuH/twMxo9rnh3SySM0XYnhR9gzRA2K9/eWMXe/bpg1A1/Fa9gOv1kLPshbtlhRWZwJK8BfOXkvjwtMwAFT+X4hsso9DYDucf/OqIHW1IPu7jE4AVOnOzMdHlLxNrr/sXbb/JUdPUuhELNge+yhRVC9A3kx6pluhXhw==
X-YMail-OSG: MOfkdwUVM1n2dljO54Oy5F0yf8FvQ8Hta4wVKbONOBVTdNvkmf8Po_ogQYGLOkl
 ESNddd43rmjA6tXrqnPSGoSWkNnzULQHqJUuPMj8IuPFfwLzi8YLG4RtDz5b5eXBc9tJKT0DDo6M
 TZQpZnYTv2IkTZOhkL1iqCo9LuoEKIOzraIVFynEGtT6hs4T8AuY5Kgoa8RrzB69WSeq_STrucjr
 7OiiuWA9KLOGNNA6QNJZ06eVHNY5ukrrFodayaBydBaWtskVsg3ti.2DUGFDG8esFGv0RRzhnH2D
 z4L6a4zyJ1Hn0avvNDYuJ.e_eGY17LrRtADijcL6s833FoSskRmkrCPAjuZSPPkw2GRoD840WPdx
 ZREoUeuhe8UXQHIbAMyjMoBb19R7W3QkTpf4VvwnFBxinNOLwG8RKZdD1HPPkDIW96ycWm_q3ttu
 E0j_3xbOnvYP07R6kiqBs9QaNqCF8h9LsE.9NrtMA7BkTJBZYhFEx4Qq4jI_kj_hQyaJAkLrsd36
 ow0JCKrNUZD0hXqx41w1nV.lxyrhz02mTfRUcmjPakcljaCSP_hotsCIf2v8BC16XYhl.mu9Fvln
 0Tons3u150Qp8YT_C5U9udiV6CTbgm1H6q5Mi9woziJChlV1YXyc1MaMfasBdvx3eFuy6Oz7K.pp
 PBOmqk5KhYNA2qOjTfVrWIcKMSem0d.GzsJkBwXCZFCA56ofST8UGhlUk9L.Wi97oFWOfcDu6P4G
 mOE3ylMp1_PjC3nR7L21rS8d0SG70eF.dRAlpjDSPQ4KPvCnC7ocINw5EW18XK8wwa6LzfQQl9BL
 9aLLSpZhEQXr9rrVo9h0RG2R37PQQa6lXNE9P4pq2RnfZJsjByafWorrhtqEuf70npEc_EJfboQr
 uVGftVgHfSKd7nyPNGgUGrdVmHqMSQPqbsXHh7aF4ErTDaLiw2eU7RqWB13IUtocRIiOPDHX18eE
 MQQMXsrxF471TEmsZk7pFMcuMqat4ENBksQCTtwYJTcNO_ODYcYwa2kFQlrt036_NJ4L8189TyFU
 NV6mwu4FSWpkd8VxOabYpzjkzUn7zIgD2G54Z962peXEPLL5SCUgxoJRgbk_Fguhj3mD1r_SfF7L
 .e0oZdgh00N.z6nFpBSlb84qtftsRpM8YdTht7PA_1pPtxbCr481_TMCPY5NS2cxTOOllWW0H7i9
 _.khe.MLAp8XZCDpwitJIjh_RAoitIYgzoQnbZN.ZIWj8VSiBhgt7UlhgunCbpY4Rur.QEkobgTH
 vujit9W_nJSTEJwNEpb4V1e3GMhZPzAZ4PNk-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Wed, 5 Aug 2020 09:17:15 +0000
Date:   Wed, 5 Aug 2020 09:17:14 +0000 (UTC)
From:   "Mr.Ahmed Muzashah" <ahmedmuzashah@gmail.com>
Reply-To: mrahmedmuzashah@gmail.com
Message-ID: <448492924.173057.1596619034851@mail.yahoo.com>
Subject: =?UTF-8?Q?Sch=C3=B6nen_Tag,?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <448492924.173057.1596619034851.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16436 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36
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
