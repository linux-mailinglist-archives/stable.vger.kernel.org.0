Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E247D24DD27
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 19:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgHURNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 13:13:15 -0400
Received: from sonic312-21.consmr.mail.bf2.yahoo.com ([74.6.128.83]:34584 "EHLO
        sonic312-21.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728272AbgHURNG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 13:13:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598029984; bh=+NKq2YP/4c3bLm2HmGhxa/KCZOXr0NIUKHs/ECuC0yk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=U1SjeBOzCYIJRtx7y/FBaCP228fucmN/EodwmeP9rqe1Uae2UNpu/G2B+8W29yrhCAkhFpZvwXrXAxB6/sj2Xns6V/flUdtbgtAgUGL+5KciKc8i5Sv3kkADRxmX9TBPhir4R5/+SIgNyADQs3+1sIBDBmNGXuvs6o5/RS6NeKEcODdw6JoRLSTdTn9pZDIbs06BtYKlDyAP7G4ZT7gO8bGZT6OBOk53v3Kli1XeK9RzNoZAuDGIdp2eiN2occxrr+gYg14FDHVxVMuu8Z9BLVVngWfpigOQ0tUucJYYkFgDxj1kxO8aN91yhL3epoTrZaYdWs665NpPCPERkD30qw==
X-YMail-OSG: ixmF2NkVM1lgr7eqtMfLam91TJHBRLG6nNEQcZzUFIRQ4shFsJdFYXS6vMDkOcN
 JSNhiyy6V_bWOMgNbR7rhFN_.kf.RgAy7_7qi9vrduz9K55OQUK7T3dfdlRhE6CrLELS2GteJ7cU
 bxmCovmTq5.l_y8HvnGl0L68tAMqFbL2qrIa.m1mY280hTLbsvMWyWopKAnH54CiOklUhaLBGtPM
 kmPIKsf5LrdufikeYk4fG3A_cG9eF9kY.ugfjC1mpuEQxPrHLdhh_Hhq1YxaE2ioNqIL654aiRdg
 WYHLZj1IiLXZOn8d8BlnN4ULsSJj7qORX_cw1t1_oB21Q2jp2XZffc53lsczxYVSMhCMOM66H_Se
 zwnT.8aPzqnbtltq85gOWL8DbM0m9I024MEe09rG5bjLjmhYxoQJOMG6SeDou3Yo_FlRSJsXa4Co
 gLXlVMnBUGr.PVDCmH5o9Pk7EDtGUw1xcFoNX_HcK.ZrvZpSCFdfOUJ01Kp6Xg_PMIIXPJRkdU.X
 Q.vGykpWM27pcHkrzIyNUKtrXkAalhkqZhzKd5lThR5YSNhrWx10TRDQpYscz.DeKDNnyvWK33cB
 wb2zTJK3cvGTGcYBjUoV_LqWi2zBnN0ADr2OtEhcAWIN6jJjX8XhG5GhgkkxTVbIqV1tjzFYM2Mo
 8HJ8EqSo70SPWxp6r99oYJTcCdLuwOfceVyk6PP7B2gZSya0NWAoQSJM0lErZJbFz2yZ8eXRp.fr
 vKV4O7i9nKsSkLtCPYNTrSdhIPb0E49Kzkdr2ZV5nGT0lCB58A9PGsTJ1ojPbSzuvYhZZ6y26qka
 vzE8ZKHG7XSINTnJpYXfDfp6OShH9EXqJ2psWiGRDWpuAiwrCOAsvRmu1pk1RHoe3_0kD5J9CgtK
 YGu1UFZUSNbw1L9232ngmUPgycdRC78.nl8lGfY02qe7tUjR_GiwHV8SfX2xYr4p.8JdPU63w1lQ
 vf4rglQAP2r0s5Z.lrAcxuGcbO94h1P0tvfWretqK2Yk.z4wnDQg9r22DF0A7zUNhky8op62Lnn9
 7NeIAiTNsPnKEDuvd4zPe9Qj6tICoS_NxJ.6D2MEIp1ed.qktaOGQRl3OwW9ZXPr7s3g31r3d_q2
 OxhAioXnwd3J0p4gKZUwQkoInOBGhjM7RrJgfb_gBnkaQbAe0cr0fwvflo50ZSE1GveguyP.PbUx
 Rl1ty5QDnIdiK0P7uTl9UYsv0YYTdxZ0uO47jdzUD3rDQsQeCAg1KkNDKFEgma1o3Su47p29F2Q0
 LgDjfSroXzA2RkssGG4oJXtw1MEAWIReXke4XAOgYSQe83aYUo2rsV9.iGtg4rynTMfTPwVzF.Pg
 mRr4tuqdOwYlNdYjHs2lnfNjY_p.dUc7U5sbW3CK45ia8kYdgJ6QOWVuHukiol3DrVYF354HUD5a
 0dRLPhcs7Smu7GewWmk8GmU6XsUx0ly5ZBWN6xBGPSbNctxkAVF3wNvA-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.bf2.yahoo.com with HTTP; Fri, 21 Aug 2020 17:13:04 +0000
Date:   Fri, 21 Aug 2020 17:13:02 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrs.minaaaliyahbrunel0001@gmail.com>
Reply-To: mrsminaabrunel@myself.com
Message-ID: <1501158460.4198168.1598029982258@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1501158460.4198168.1598029982258.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0
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
