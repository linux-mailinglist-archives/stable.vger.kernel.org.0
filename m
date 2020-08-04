Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35CC123BA76
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 14:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgHDMh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 08:37:28 -0400
Received: from sonic315-13.consmr.mail.bf2.yahoo.com ([74.6.134.123]:46239
        "EHLO sonic315-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726333AbgHDMh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 08:37:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1596544647; bh=+NKq2YP/4c3bLm2HmGhxa/KCZOXr0NIUKHs/ECuC0yk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=M87E3x2wdWuLkyJ7nrQr+TaIwjkrvsfKGHDVJctxFQnoOZB78/YLhOYmKRt/buy1HXZnGlCl1cwHewoh6YfrzEL/R3ieKfW+t5A97zgh+NBjSrHeC9QbGyssGfyB+jFkm+CUQubEsrDLGe30NSQo4s44mRPDZj1DP/07tk7od0k3dowS7hN7LpStnlP7juXTl1NhDQAFLfsYZy4Oq/1tt0TMk2iSS06/dsAk/iaK82P8UxNOvkWW4J7fgg1RKSf9WJhso2e6vf4Ao1c4COgpvBmRYi9GTNjZ3cLDpd3gE+HHiXbOWk1iLmjyGPNv5Qew79fz8auAa1RQDXZkZdDYtQ==
X-YMail-OSG: zWBYfy8VM1lZ0R8Aii91tRY_MfFydI3XwePexgDYXJ2.iOQQYSWVJHjPxTQSwRO
 ulc2YiORP._obj8wye2263YQfgvrtjon.hObcRACwM23ilOF7XqTWkgY06kgVrtgt6fNva.D00kj
 2lyMrcFlxq9OIGJWvSXCBQ2JInQNFXyteJ5WzSjsQRSos2UDAmoksioNNCzl_Bl.gyMG165Pf8WT
 rqerRrbNkUtSMrMRJzWWLiUWs_M2P4KstucBJ53ueZnqLnyVB0ZhkHwS4fiKghMSxCbr1Ym3pBKz
 5442xxCTaCdhrqJW6Ucei0WPvjJKQkuFknVhdvWS5HslTpckNwZm7v2r0mlJHQEDTCM0XjMIoeLf
 WQLoyKhYPuSDz8Lh.1fZAay4g15Us0o60RDSlq3Eum4GK5dnp3NLv3iwlneHdj_Ur2eg.EucOgQz
 7PLBaWJaueFpTHaGh5VR3jc78fx4w7Egn7E9qP26E9D2rlUO34UmsBtjF0LG9maD1GsCouf10kY4
 zIlqrpWT9T8Mp_7bfaz6x7nt8TnYDuQOe.Naccqs8ffn0SHF.PZV2YL1PpWPHfjibW6LbIcfnZRF
 CDZbEl7CXCwhsur06gyDX2WKdn_JE.dzkWLEhjtoHcJyUlpmc0F18awGaTdgJygR3cfuaIhcx5pt
 BFEuzVyhC6Mt7KYv0g92jL.rX9OA2XDjCZCb.k0TDaBLLKwb06_J0_4ZE2LpPOfnQCKzBE6ljAI4
 VCJ56q0X6D2b1FGdDEhnGSqIoWv0AH6SYpMjWJ.wJDTeTMjyUoxvzo0wvAYcjVR055jOGBJgmplQ
 2CkRAt4AiwS.hC8Zp6b7Pz0Ip6jeYFSsByADmqkwnb4l2mst1BXKCNY4NzUTsm75xShACRQeB2FV
 oM2shkAwdEfJuM6VgyUsxbIG8KeTB7cK95n9E9Y5tImMV8CKmaDGUaZWGyje4ZMnsJUwMgVrWgQi
 dtW_VL7yDq0ZTz1Ea0ZMPZFqUK6ObpIp03vXurV5TMedoex0kGk_o0e78FENKPEEYDeVOQyGKXS6
 6MC99VcGSQP8NkKekg0MBzwsqkjwpyLlLF85feOINJCGJdeosTcBoJtlsQVPni.IHyKkFnOKvt0d
 n7tdYy445lOj7iqIZZf29wB4Qy.h.FZ43mWE7rcCRuA9vEsi2xcFMutsu8h.W6z7ZPpjqrZ01vqf
 kJKXTGjuDgVSb.QO.0E5D_WTG4giIwj00ukRmrEDGDIkZnW5KEKBrcPOQxHtFckays3TyG3LWR4m
 amMNnZmRQOVjbyyGtASrE0xtTLf.R8rxN7NRTdIU_4_uHA_jYib71pLTrKQWzCQNwmisaLlf7u20
 2
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Tue, 4 Aug 2020 12:37:27 +0000
Date:   Tue, 4 Aug 2020 12:37:24 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <bmrsminaa4@gmail.com>
Reply-To: amrsminaabrunel@gmail.com
Message-ID: <324990117.248248.1596544644405@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <324990117.248248.1596544644405.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16397 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



My Dear in the lord


My name is Mrs. Mina A. Brunel I am a Norway Citizen who is living in Burki=
na Faso, I am married to Mr. Brunel Patrice, a politician who owns a small =
gold company in Burkina Faso; He died of Leprosy and Radesyge, in the year =
February 2010, During his lifetime he deposited the sum of =E2=82=AC 8.5 Mi=
llion Euro) Eight million, Five hundred thousand Euros in a bank in Ouagado=
ugou the capital city of Burkina Faso in West Africa. The money was from th=
e sale of his company and death benefits payment and entitlements of my dec=
eased husband by his company.

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
