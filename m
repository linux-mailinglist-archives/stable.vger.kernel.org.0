Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837FB1F95A0
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 13:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbgFOLwP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 07:52:15 -0400
Received: from sonic311-30.consmr.mail.ir2.yahoo.com ([77.238.176.162]:39223
        "EHLO sonic311-30.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729643AbgFOLwP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 07:52:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1592221933; bh=+NKq2YP/4c3bLm2HmGhxa/KCZOXr0NIUKHs/ECuC0yk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Y1RMoN3QuOjJetFg8e2XZhVRs/dthXMFrTWBjwtxvPb3UDX3y14x1TIzKXvUCNEHXfoIL1mNLqIdAz9O/ANiDTjgfRpBI0l1HdxcxPRwWnBrX3qLOvlUmfDDdghEMx7VGG5AP/uLxqd3ltS3HK1p1kg4Y6bClUFdSfv2xQNGNEIeNlrbmOIcxJWFEvXbv1YuoQQBwChYChHzQiUXnBhC5RbEfvtAtxh7/qHIoYeNcKrJZHe3Npbei+Giei4qDsdxM/Hdqg5r1NT0MolazwfucRaXDas1TKtSX7fRa3ZtfX4s+zrFau8XxRfriDit/lUCNV1ZENRi1ZfGm+YwVOdPXQ==
X-YMail-OSG: XOuJOXMVM1ncEgNaDnWgApxZCwN07uQ39klrsimz51ZOIzdmpNud_1ux.gytQ_j
 hLg60McYwG.M.frTFdISibW9aBZ94eE01BDvh4HRluYY64bRbfC.z2mU2DrfgOMDyxnS0bY8NNXH
 00_UecU0eJwltraS_ZBakHQrOx_1Gt1aDjrq1kFp9p634RS8fqJXSLX4pmufpEXrpEtltego8xS4
 tQCT3aKKvHsMKxAp4GawllgDMoMZqZ8HvzVobzeRw0NaVWBDym29ELhNUIDt731W7FBranOWcVlm
 gSbxQiWE_L7p8Vw5BIC1n5Bd6CiF2a9nHl4vndBCDOkrztsIorifhUiXvdILuAgEgpXTy.A5Ptmx
 VzfXmLiuyntX55d9K9N_8_DucexQIJYYkixAWgY5Y01lhaVpK_Ik2KHxofmbS8.YlDk9BUFpGkBF
 Ps7jDbqhfJeZQszU6IUBPIU2FA3SLFcBP2sfSYtwP37CTQS9slhgx6LTucQYA1RjusAvRc44gLTF
 bHtr77njDPDhv3j1UxNgiQ_LMMtDAivQuTW8FKKuF2rJrvCI.zxP8aTZt56A3hX4OM08JQXwsJkq
 j8xtt32n5waSPVABl2kZD6P4WxnZEo8Bal3T8SDB9WnuZ2mkMoZmvsxRkf00n6OUZUq1QO50vfck
 _2WFMTyGC9JgExKCfLxrrY4CV.z5l2cxAqX2goTiGXOqZAGf.Zr6VB4SJC2aMeYTyiZRmnnCCUrU
 W51y4iezVAA4tN3AYyC7wIeCr.pc4Od9XWSwQNurEhseu41I3C5GRv1SCd4WCshXrBaQKwHHZLyD
 OFRGkaDWZWs4TOQBJAV9d2jMr1ogilf6PWwNSuzQxteWe.fuTaZKGHFE8EKSufrLMrsePiqCpIxE
 oRwXn.U5S6k4j_KdvgQlNDkluYi2_Ua7dDEYqg8anGBS40dB8RiK99Tju8O19jDes9bB029DA1xJ
 hn.e.OgnH5hpTTDA4VhmLazryB_PCvW_AMZTGDaUAGLbsMqvuhqPppi8fTwCUd3itEyWDmx_1tP9
 PT5gsLNundT_2KId.kPGrnFuqFv.aPwvsNqpFoAGwOHTB_2BDLY5UBqgD_JRAR0n0Pw3V2GYitRS
 kHqA7o8NUjNuCFE1IFfJLlFN1viY_bSPUFHSRhvRv0hiiNj3QZCS44tRBKWDxoIfyShh8jx_BAio
 ZO0fcj3mgqtcin8x.3m8ju8tXJcfdRPY5FX2zSE_bV0NM.vnIT_iE_jmf1vbPLZQkwqvXx7.0HjK
 d1Ps6nUiFijIPVVqBVG2ng5YVBNTjXR_ED6nFvNsA0rwiSy7Y.1eyQq1FCecKMKpF7E6NqJ3TzTh
 SUiM-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ir2.yahoo.com with HTTP; Mon, 15 Jun 2020 11:52:13 +0000
Date:   Mon, 15 Jun 2020 11:52:08 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrs.minaabrunel209@gmail.com>
Reply-To: mrsminaaaliyahbrunel344@gmail.com
Message-ID: <1042728165.1621442.1592221928161@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1042728165.1621442.1592221928161.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16119 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:77.0) Gecko/20100101 Firefox/77.0
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
