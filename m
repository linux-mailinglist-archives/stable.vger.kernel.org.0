Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B5824E769
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 14:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgHVMee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 08:34:34 -0400
Received: from sonic313-13.consmr.mail.bf2.yahoo.com ([74.6.133.123]:39198
        "EHLO sonic313-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727975AbgHVMed (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Aug 2020 08:34:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598099672; bh=dsIiYcLX9+LjVvHnRlLd8/GRc857N8PErPyJu+2yOn4=; h=Date:From:Reply-To:Subject:References:From:Subject; b=aEZserRIuGNPx95sxtuTjODVXi+KacfdL16o+FIGUcMEEAloHMUJZd4gyiuqhOBk4pWGzigbcaN7eAEYFZpTzbfyIFwjigjL9C44VagjOxP0iKp+twdINCG+TuLBFbTuozzGtfRBtkbaAvxJ+O7TrrkHbwFJ6laDV23nHFTC981rmLEtX3OfeawU1tl4HQiIm8V6U0Cu8Cyo2BwG3/fID0xzyVeH1DYvJ/zPsS97eGVU50X22zbfLnoXSiMmwl0WovwWK2WR1WQ40OOqPOYkfRhtkR2FkACXy0Mzs+/7ysWXVn2MqUGFZFku+YWFZGgI7PvDuCtR4IOuAlSwgyalFg==
X-YMail-OSG: elfSOV8VM1mlrWx40hNXjhrVkF77t4nZNZrxp97TZnLtirvaTJCZb82zm3C3UHK
 c9S4iKh1keELe4AY4qMkN9ea4PTVMvIJvq4vF4u95UzExuneQ.ZsvyrLoE1ixKRytog9yQroCzoy
 l2T6CO22ajIDswjr2df4KM6IED9gpkYz2d7xW23dunTh.ZUZ.SqHcqKHnfrER4HciEAnEmHT4vHV
 fNYQhOFS.uCqWWZH4_ZvizhjZYzIdNGADit_tz8C_EqJLsjM_a1yZSpiZ7yarDOQwILOomAMHQ00
 3HD_B0zGwh.arjfb58KKzoLbA3u8.FcL73r1nm9_EN033uAnZ49KPXxioJ8MRBLkufhEPZZwJ8bG
 xPXdXxYTzp6I41Ar6pltR7nd.xUxRtBCzp0wNkizX6Rqej6JntNAuDVU0b0wu4Ygaoln2d4WefwY
 TmOOVGmz0piAthMI7jmLgSp_AlQgIB2HagUHIcu4PQ_52iLHSq6OVxEzdsapkbVrc3GE6mjPyoyW
 MB0JB.RampOYW0wIOzYWx6rdXvN3oYO8FtLWi2Yqdn3IfY6QMda2f2SdCsoLeY5wA6198i_PRuAj
 bLnioSW9AkCCjBNNBxuxtzYxAH6bHtVnAYsGpejHC_I6eA87ulq1U15OHuJ2_iepEzYS5HUC29Mi
 Zw3iSP4eeaocD.do6Iyh1q4uikrnW_WdZZW_JujUhSv7diKAL1mi_Z1qhmWZ_392iHZGu4pTehAK
 XdFnAaG9VEYDNJAMK5Qq8Y_VLW8iTR1sQEwCjWQwmORN16O8Scx5m.gGsyAbxo1.FkJwuD0tNZF0
 AeNr7Tz7_.AXSjBkO3Xm1L7j_RN2MiyRiNyCz922H8GznvogCJkWlMFblXCgGaglvoMCg3OctBRo
 JjRatkaZ6AvdFSy0UxzISPu7mOSJaYb4LrwFZGC9YnL9ym81XWlXkcS6B3l4unrKxkuGxIkUyhrP
 dddTHkvFygK9yuqK7tll2zYwDYE.kUDoYDgspk_g7vqHV2cwcVMNvMX8aIuk_WzsNx7VoVjcmKYw
 Y5OV4Tg1TXK_DEX1hg0chGJ9XgX65HQZYRqHLINI29LIXWjo2jMcDNUl4xRjjcKhiQrmoiGzhJu8
 rKJorb7y25sSrxLwtVEs1qlrPPY8GibqFTWVwPwGPMqzGVM42UVIDLawoVddEnGpaoJoKyh6PswJ
 euWW4KmaLQJjSte4Hc_FciUUy5Fr4WqxVtYsgTWoZNc7GwX8CIE_HLcvyPtswln_0RZX2S7dxOkG
 T86Rirpc5KOewnHjwWY4j.93z1CE9eRQ.MHv9ojFL0bd35EXBqt5IFdUt6QPcIMBXO.Gfvnf4vZJ
 pogsrsQB4zvTwJgegunTTfR0JsHleh4aNgPRz4N48NYoJr6smOn9NRwn0KdFiGV.58NNhzKJVbye
 aJVDFek0EC_mEdczOClVlLW49_a6MBmNVOGsg279RWk7EXCmzwNWRS050
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.bf2.yahoo.com with HTTP; Sat, 22 Aug 2020 12:34:32 +0000
Date:   Sat, 22 Aug 2020 12:34:29 +0000 (UTC)
From:   Elisabeth John <elisabethj451@gmail.com>
Reply-To: elisabethj451@gmail.com
Message-ID: <101417592.4416107.1598099669163@mail.yahoo.com>
Subject: Greetings My Dear,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <101417592.4416107.1598099669163.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings=C2=A0My=C2=A0Dear,

I=C2=A0sent=C2=A0this=C2=A0mail=C2=A0praying=C2=A0it=C2=A0will=C2=A0found=
=C2=A0you=C2=A0in=C2=A0a=C2=A0good=C2=A0condition=C2=A0of=C2=A0health,=C2=
=A0since=C2=A0I=C2=A0myself=C2=A0are=C2=A0in=C2=A0a=C2=A0very=C2=A0critical=
=C2=A0health=C2=A0condition=C2=A0in=C2=A0which=C2=A0I=C2=A0sleep=C2=A0every=
=C2=A0night=C2=A0without=C2=A0knowing=C2=A0if=C2=A0I=C2=A0may=C2=A0be=C2=A0=
alive=C2=A0to=C2=A0see=C2=A0the=C2=A0next=C2=A0day.=C2=A0I=C2=A0am=C2=A0Mrs=
.Elisabeth=C2=A0John=C2=A0a=C2=A0widow=C2=A0suffering=C2=A0from=C2=A0long=
=C2=A0time=C2=A0illness.=C2=A0I=C2=A0have=C2=A0some=C2=A0funds=C2=A0I=C2=A0=
inherited=C2=A0from=C2=A0my=C2=A0late=C2=A0husband,=C2=A0the=C2=A0sum=C2=A0=
of=C2=A0($11,000,000.00,=C2=A0Eleven=C2=A0Million=C2=A0Dollars)=C2=A0my=C2=
=A0Doctor=C2=A0told=C2=A0me=C2=A0recently=C2=A0that=C2=A0I=C2=A0have=C2=A0s=
erious=C2=A0sickness=C2=A0which=C2=A0is=C2=A0cancer=C2=A0problem.=C2=A0What=
=C2=A0disturbs=C2=A0me=C2=A0most=C2=A0is=C2=A0my=C2=A0stroke=C2=A0sickness.=
=C2=A0Having=C2=A0known=C2=A0my=C2=A0condition,=C2=A0I=C2=A0decided=C2=A0to=
=C2=A0donate=C2=A0this=C2=A0fund=C2=A0to=C2=A0a=C2=A0good=C2=A0person=C2=A0=
that=C2=A0will=C2=A0utilize=C2=A0it=C2=A0the=C2=A0way=C2=A0i=C2=A0am=C2=A0g=
oing=C2=A0to=C2=A0instruct=C2=A0herein.=C2=A0I=C2=A0need=C2=A0a=C2=A0very=
=C2=A0honest=C2=A0and=C2=A0God.

fearing=C2=A0person=C2=A0who=C2=A0can=C2=A0claim=C2=A0this=C2=A0money=C2=A0=
and=C2=A0use=C2=A0it=C2=A0for=C2=A0Charity=C2=A0works,=C2=A0for=C2=A0orphan=
ages,=C2=A0widows=C2=A0and=C2=A0also=C2=A0build=C2=A0schools=C2=A0for=C2=A0=
less=C2=A0privileges=C2=A0that=C2=A0will=C2=A0be=C2=A0named=C2=A0after=C2=
=A0my=C2=A0late=C2=A0husband=C2=A0if=C2=A0possible=C2=A0and=C2=A0to=C2=A0pr=
omote=C2=A0the=C2=A0word=C2=A0of=C2=A0God=C2=A0and=C2=A0the=C2=A0effort=C2=
=A0that=C2=A0the=C2=A0house=C2=A0of=C2=A0God=C2=A0is=C2=A0maintained.=C2=A0=
I=C2=A0do=C2=A0not=C2=A0want=C2=A0a=C2=A0situation=C2=A0where=C2=A0this=C2=
=A0money=C2=A0will=C2=A0be=C2=A0used=C2=A0in=C2=A0an=C2=A0ungodly=C2=A0mann=
er.=C2=A0That's=C2=A0why=C2=A0I'm=C2=A0taking=C2=A0this=C2=A0decision.=C2=
=A0I'm=C2=A0not=C2=A0afraid=C2=A0of=C2=A0death=C2=A0so=C2=A0I=C2=A0know=C2=
=A0where=C2=A0I'm=C2=A0going.=C2=A0I=C2=A0accept=C2=A0this=C2=A0decision=C2=
=A0because=C2=A0I=C2=A0do=C2=A0not=C2=A0have=C2=A0any=C2=A0child=C2=A0who=
=C2=A0will=C2=A0inherit=C2=A0this=C2=A0money=C2=A0after=C2=A0I=C2=A0die.=C2=
=A0Please=C2=A0I=C2=A0want=C2=A0your=C2=A0sincerely=C2=A0and=C2=A0urgent=C2=
=A0answer=C2=A0to=C2=A0know=C2=A0if=C2=A0you=C2=A0will=C2=A0be=C2=A0able=C2=
=A0to=C2=A0execute=C2=A0this=C2=A0project,=C2=A0and=C2=A0I=C2=A0will=C2=A0g=
ive=C2=A0you=C2=A0more=C2=A0information=C2=A0on=C2=A0how=C2=A0the=C2=A0fund=
=C2=A0will=C2=A0be=C2=A0transferred=C2=A0to=C2=A0your=C2=A0bank=C2=A0accoun=
t.=C2=A0I=C2=A0am=C2=A0waiting=C2=A0for=C2=A0your=C2=A0reply.

May=C2=A0God=C2=A0Bless=C2=A0you,
Mrs.Elisabeth=C2=A0John.
