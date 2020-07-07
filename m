Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAA321681A
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 10:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgGGIRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 04:17:04 -0400
Received: from sonic306-19.consmr.mail.ir2.yahoo.com ([77.238.176.205]:45888
        "EHLO sonic306-19.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbgGGIRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 04:17:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1594109821; bh=DPYuw2gUpgtMJzJhlH/AVmRGu2wSKCY1C+f8nOCoxu0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=UoIl8oW++MtgYV10YvmBv3k0nz+LC9C4Je5jlcMM3UzQ7/tVefy6p04tZfYSRrUFkoJUv+NoEtADxgCTNgDcZUyHppdI7q1n1jV/unQzL570aJbl8lhiLYQ2kIifTl2GDaxptFCQev6gk2lOFdVHrTL8URG5auOShQwHwuyBBF530jQD92m3EOCw27JeU+RjyPmvlCpGeTo6KnHTWhCZlDRYnrqTHN917RIvYtjOicrFaZkv/4hsK7jtlDGxzS2fbRlfaEE87mjCkNKx/hSdlP+/6jkAK5A+tzjuul4GIMIIwpn9R/8F2Tc/W0XonKmCFnBEm/XnYjRobN40Xzcm6w==
X-YMail-OSG: DdGeNrgVM1mvwn77fuVw1Qizg8NbONlT1yuf.DHheAjS320oMnCVLstHGDNxKXF
 tqLb9hMOowv65ua7hmUNqQt8WbZa5SvOR7r0KE8Z0VW7FYsfJqMxgFY6r_.PXson2hsT0lL1dhui
 OSBrf.7.xEEYjCERMKTtGJROx4kkBjHPSYS07yMrg.wbtbGyyBSjix2tnYBtq5pvBMCbuRV5y9V_
 eBG34T6ZAndH5RTFEC00O_YGBst0ImdYP0lZwABhVHJnaOpd.CPLOPoCN43pIz8YBK_jWKAzRuIA
 pDU4Fizq80jmEc2hPdHpCTkmoPkiaXLtzWSpGaJqKdJrP_2mBryAV8vMwcbPSqJGj0csotag_QPx
 cO3LKvWrH3HT1cI1BP2ZP54Nh6FLKs.cMBJjMcPT0H9Yo8xHkfW3ViD8hKw5Xg6DysO71wbEkm8o
 oo2qnVRCNjgP5d0ns285H1_oyZD2PA5InY7Og2z1MY3ML6KmJJ5iLiLi0y.rzFj6ecxPoddnJIuC
 uL421NtKQsxYrOaRqrGQb5T6O9O0CkmeXb.q31rwkjszLuh5UthqEvnt_As88I8MR.9R3giJKWTk
 QM_u10xcEcwoq3uURdgbWdUMilxri2ZaGERDieBW93Lt7yv9ewp8R7ZlW1OmZlP4UYIpEpeQnmXb
 ddp7s8KpSrZdkYzcGXeArQhrdpvJynfLth25siBeZ7ma.fcfoH3Qx0l9R8a82F6r8NBAErp0ltRz
 0c8h4GQgdGRKFUR8cDDxd74Z2sRH6R1ygTPLSyDQ6pKjxGauPMCLQBNfRu_T8K91ycS7ElsewO4O
 TsLwXUId1ZbQiUJZaI8RVhjQcIcZ2n_BKStzPVOao5ZuSnDPDgg2CRlMzXNT6MBkOkLslcqEpMK8
 10y9TlSGuwrrattTZLihdxFAWcCJ1SoWX0hijkdSl8wUNLNiIGgsTQ3Zvr.wybEc9Aj2Iv0UT7jy
 pjXWip26TNNTL4hu6GdDjeOpxim.vsCKRp..7BPfyOf9Q3Qlu.JRZcRXjiKB9YVIvw_ACtLqq0O7
 YBuIOPl0nKDwHatYni5ZkZiI23UeB8.W4zwVwd9ElquqmyBk09KhcvBYE3_.3NILQF0p8ja8AaiQ
 GfyxhfPBmtGxx.GChKCSYOpRVyNQueHQ7JXKcZxVSta8a_dvJqaICqM_0Eb40ozbdOE6LCwegZsT
 vqJvaCVcLBfq5dBb0n007ud9J_ZR_B8_Ge_U7qULUlmf.iIzaZkvxwJhpfRI5FJCHV9O6SJQYXEW
 O2IZ3zX5c043gs8b3oZpC7U5n4M5TCBc8TJbwdRSNvV7BMxSDAIRceCWys64KMKckIE5n2.rpchp
 .
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ir2.yahoo.com with HTTP; Tue, 7 Jul 2020 08:17:01 +0000
Date:   Tue, 7 Jul 2020 08:16:57 +0000 (UTC)
From:   " Mrs. Mina A. Brunel" <mrsminaabrunel2334@gmail.com>
Reply-To: mrsminaabrunel57044@gmail.com
Message-ID: <627593231.6247983.1594109817817@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <627593231.6247983.1594109817817.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16197 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



My Dear in the lord


My name is Mrs. Mina A. Brunel I am a Norway Citizen who is living in Burki=
na Faso, I am married to Mr. Brunel Patrice, a politicians who owns a small=
 gold company in Burkina Faso; He died of Leprosy and Radesyge, in year Feb=
ruary 2010, During his lifetime he deposited the sum of =E2=82=AC 8.5 Milli=
on Euro) Eight million, Five hundred thousand Euros in a bank in Ouagadougo=
u the capital city of of Burkina in West Africa. The money was from the sal=
e of his company and death benefits payment and entitlements of my deceased=
 husband by his company.

I am sending you this message with heavy tears in my eyes and great sorrow =
in my heart, and also praying that it will reach you in good health because=
 I am not in good health, I sleep every night without knowing if I may be a=
live to see the next day. I am suffering from long time cancer and presentl=
y I am partially suffering from Leprosy, which has become difficult for me =
to move around. I was married to my late husband for more than 6 years with=
out having a child and my doctor confided that I have less chance to live, =
having to know when the cup of death will come, I decided to contact you to=
 claim the fund since I don't have any relation I grew up from an orphanage=
 home.

I have decided to donate this money for the support of helping Motherless b=
abies/Less privileged/Widows and churches also to build the house of God be=
cause I am dying and diagnosed with cancer for about 3 years ago. I have de=
cided to donate from what I have inherited from my late husband to you for =
the good work of Almighty God; I will be going in for an operation surgery =
soon.

Now I want you to stand as my next of kin to claim the funds for charity pu=
rposes. Because of this money remains unclaimed after my death, the bank ex=
ecutives or the government will take the money as unclaimed fund and maybe =
use it for selfishness and worthless ventures, I need a very honest person =
who can claim this money and use it for Charity works, for orphanages, wido=
ws and also build schools and churches for less privilege that will be name=
d after my late husband and my name.

I need your urgent answer to know if you will be able to execute this proje=
ct, and I will give you more information on how the fund will be transferre=
d to your bank account or online banking.

Thanks
Mrs. Mina A. Brunel
