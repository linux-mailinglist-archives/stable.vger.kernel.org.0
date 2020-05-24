Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3391DFF14
	for <lists+stable@lfdr.de>; Sun, 24 May 2020 15:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgEXNOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 May 2020 09:14:52 -0400
Received: from sonic301-20.consmr.mail.sg3.yahoo.com ([106.10.242.83]:34412
        "EHLO sonic301-20.consmr.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726064AbgEXNOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 May 2020 09:14:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1590326087; bh=DPYuw2gUpgtMJzJhlH/AVmRGu2wSKCY1C+f8nOCoxu0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=iMkY+qn0jUTmEg3F9kBffm+ttDRYO5kCwVYq455grOZ2S84uk8IYSgJt66deONUeNCQhDqYLzw/iuMbYiR73V38lOn1IGmyDuEMfTLBgfIZltqvRzlrdOQuf+U870jBJa2Wg9Z/F57sp7YMJ3dvwneI8R1+bJepCIqRn8jboewTZ35KeYXWl7uyM+PX+RwaOMcJHqtU+BW3qlYwG7HYmJwToMm0TugDsUg5OMXyLArlcprnlPOKbxoK69pTuHxdk1/vqYPBoLxVtf5OtTTr134OFAXzgwuzwfs7BVEQ+A/6maIVtLcTZzMT83VBbaiLkAjp9MtNo1Z452Zc5EkHNdg==
X-YMail-OSG: ZIZXTJYVM1kLzw6Qho06SOWZm0dLaTQdOd11HNR.I7Pv7O9w7blCBV7vaVMnArC
 Jte7agFUH5bhQMjFyOltdJUzAOyrrF7.fyN6lJMvgIVytyTLv8rYhsvrQUkkfuwAuRZrRyIS3_JK
 vDPdAzfGu2bPKnMGhmsGyAZ3GUCd6h_aGWu1QJn1px8fCwSx2dQ0QgMnjVxqFxWzD8W9a9n1uwgl
 H4JVzuHgLXY5K_0ie1DrG4_pWrVGYCSeRZvcRj9_BvF.fdC4d6Y9wzntHeepCxP5tTx9b0671Pck
 SHxaXlk2.bZ3Y6e_RcIEj3qMjvwx1PUWFYVsWUBkxJBef7APkTAkM7V1GSn4k9BMAG1LRcEAIRGs
 FpFr1p1iESgFumklM2c6Z18iyARxrm45nHCXgvHoLC8v1QjayIlMHt8YOivyM0tBr6Z71NHNfQlr
 hSwwuusPH2_GJhMUpPqZLvX1fRVyDRH2DpPKEEjEPKhwWGevr1PjPblx13VH7KkZJ9lEbVsOMJZX
 BOqtwx4gewfQRBdf9fRglzxdjIAnOiqynSY7GYkxR2mKkhS_p9Fj0mpsgd_J5MZ15v19iByLcYvb
 BL59qS5n3DzqhEHKRDTlIF0eaCw_bwLW0kYvVsvBbqE1D5rODezvI0fP7u0a6lUGtu2P31ba5416
 u1k3HlyXjcKWbGObb__Dtrcphtmwf8YwfiOa8qOTJs0907Z4XPAupMg1xmQEDm6dLHYyim5Imqme
 bQYyapWJt5SOkJDSDetSnIoX0hU6.rswJsYQpfPSV27lS48NWUVIwihLT3w2xtaciU9JHknDqR_0
 PMDg3PidnRyLBkYNxe8YeRCxU24Em0zrowI4EeyBWt6qm1LbKOQ7uxWxPEuvowEMuEfPQZgE612Y
 2AaWn7kRbTqAnbDa8vRs2P1XBQa9pGD5_R4TJvYq5I7_m6lBpRXp5N.0f.z0UCmB3RZ1CegY9Qhs
 CmdMoFwn0075j_vVPCwrxnmsIXXe4VWE7lNFA7D28O7MdNWbK52GDLPxeflsKBpUTwHpkyt.LVwK
 01R8K21kvSWzMXGIEnlzV2sf_gqWK4WUnadumcH7G9bG.xjL6oVxJKxIz6yM4FxNnpdBDqU15KQP
 Be3AysczGsZyHZzxBruc78K05regTg0cIPe0vChTg_a3LEYKls1t3ygX06tGRo3FiZZp4NrVlEe3
 _LzFgpErCZmo16gpGIiS6uUK3J2E4opjKpjJcvGGb6u.aadJ.YYFkTuoWP8Wa678jdIlZ3gBCIO9
 FKRJY.U9qX.73NKVaJZ0aGIR2EMz19YRvhxZA27sjfvjyOCW6VeOOPjcN3ERIaapCqgo9fOinCEP
 wycre
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.sg3.yahoo.com with HTTP; Sun, 24 May 2020 13:14:47 +0000
Date:   Sun, 24 May 2020 13:14:43 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrsminaabrunel2@gmail.com>
Reply-To: smrsminaabrunel63@gmail.com
Message-ID: <1293788827.2723546.1590326083379@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1293788827.2723546.1590326083379.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15960 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36
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
