Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C4D201B27
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 21:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387739AbgFSTWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 15:22:31 -0400
Received: from sonic314-14.consmr.mail.bf2.yahoo.com ([74.6.132.124]:34220
        "EHLO sonic314-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387719AbgFSTWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 15:22:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1592594549; bh=+NKq2YP/4c3bLm2HmGhxa/KCZOXr0NIUKHs/ECuC0yk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=JmbzbaBRTEMVJ7epvvwuMXLScRVp7WsHheoyrmAWx3zkMTvbbgFNIRNWbIfs6tGrLs7nIVYVz3MdiH3YByJnsbHFPMaxDYgj1qdcfxjDfjU6oN9TG5ytuZjYabayYtMw8UMTh1BjpBebWVjS9/uMFb6XRRVF6RYTqZSGAkhHorcbx+X8Ar28QbA/2R4+Ojig2wnE2CgFqUxPpj6MAE9qZd+y/sQUIr8Sim+8yR99sbyk/tIFDaaWklBggYUdI4YWXelpxBkFnFvF1R30tM9OQlOFggOSlpfdgSS3W6GNGTKVq/hsD/WjhnXSnEjXT9EulTEz2qmBsJQBLbVMEsyLHQ==
X-YMail-OSG: 6BpdqoYVM1kTz8Jr170rrsSFutFrk0fI3OK8vufumB9wk4Jb3llx6FeALSYXJ0J
 BQjhZZ_BAR1i0N.CGbJkBWc6B_75I7tzWbxqSnB6yiJqbfrdm6nA.4m.iilNzC9BN3UIk0pRdtXF
 eOpshwyP1BqJgrPMxrnpfaQA5JkWNehT05NfJoOWnMAdG.9xm778JOTs69MRSyJ1fKrPjUnimLY_
 RBU_HIYbGuhh_5q7yngVQSwRYIrSeiuGKMHJ6_Erns1Sm0K6hOMMBRvwKqxhWQly9C8iDnZ80EqM
 iPd.o5o1D_cU.0OdSikqMAcSgVEZXV6GvGUD7iRHKxc0sgGDWQZnv5IGfxU6TXMeOZpnwKODIK_z
 WjHmzCZ7YVzgdUbQ298RMrzUSwKZl6exIail_PERKvC328Bn0.HXuvw_sNItD8_1aqCWZsK5OWlb
 MCZRE89anN3RAm34NBIcZKeV.pEyNFOWnA1rIxx5..Bj2Z8CZhCEkeX.6KeBebFTOBsZyt4PSqlN
 r7q9VB7syJTm5PH7UBcFgyBecgsr4UNqPVPt3DJMeHSNpF2sOh0eq.a0NLmMnqPFE0aI2Vr67.aF
 r0u5JGPP_XLowLzVvtj6Me1h8I6AuUjKtrNd6gQULtPlv3seKb5nMvG1kkBKhYVgTMDUFLXEZ5wN
 XjqiF2zzqpS7o3JgmEpLMct9ej6Jp445Bphe0g9x.j_czyZkl8tRwpEGDcfMrp_tgPjni63.pcrJ
 rgj9pcBGwgMH3t4HMAiJ4jA3A_HH7NpGafdYnb7pRbhG7PmQ_NH4lzgIxqtfarMIkg.0s700hOtE
 s9sPVi7JhnTDKmVyLezvV4TETaZBUNrVxu47oLxKrxbDJEyBGsWRUeaUWrDQUgEcdjyQlkj2zy4p
 OEWe_VRJWL6V9wegcIG1ObJAPITEZmVg.WTLOdCme8DzJlk9JD4qnUgy57J2yTeqhsCBmGQkkVNm
 p.ZEh8Bx2fl0Qk.gjg8ha2_.KQEk14GZEfE6t_5e4qMmBxGFYzAusIrMueKCX8DY5YwRTZ.mkRUX
 w.IfoJse70HERv394ePs.eobehDxaTVSWJvY2ioK9AzztUyxXZjOBAdbLAOAAYKmVfLEML9p2kRY
 FqPV3MwxDWnhmOm._xObLOaw8cWBd3q8epsACxM5mYArRZ5kXTiS1In6444ivLLhVbg9O2pWpIGB
 skdT4WkN1GvY9a4G36hPuG3afHsTwhFY53VWYu.hzXax16WJjZCCszDFe7LvfYQvIsTDeVOBjrqW
 XE3WaqRuH9Awo6B3ZkXsM1f5DwLIPQMADXWRxMSJX9tumPFEApr3kDTYkYC9vd24NNwReZ_uxvDM
 dWPlPNyWf9MV.Mr0x8dWM4_24Tfvmc3rSBFXJr96OgoY-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.bf2.yahoo.com with HTTP; Fri, 19 Jun 2020 19:22:29 +0000
Date:   Fri, 19 Jun 2020 19:22:24 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrsminaabrunelm@gmail.com>
Reply-To: mrs.minaabrunel2021@aol.com
Message-ID: <1296699669.635478.1592594544242@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1296699669.635478.1592594544242.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16138 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:77.0) Gecko/20100101 Firefox/77.0
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
