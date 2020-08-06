Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0837A23D526
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 03:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgHFBnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 21:43:55 -0400
Received: from sonic310-25.consmr.mail.ne1.yahoo.com ([66.163.186.206]:42980
        "EHLO sonic310-25.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725998AbgHFBnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 21:43:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1596678234; bh=DPYuw2gUpgtMJzJhlH/AVmRGu2wSKCY1C+f8nOCoxu0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=nfAzp9oID9tc26Xd+UWVsZxM8LmFMJxRR8BfU6AGFiFLHt8sQMA/aNRODHFO8jDekeDtYtkeSdnQXqJ4srW1W77SGK3CElarWLgUQGRskp4NwXVCDFTrX5ABQssa5X/iqoWCSCvfYy4upQn24xHthV8b41YhM3R1aDXjrQna3UX7Qsfw03DY+h0yqdTZ0TwQAbjLADNBuGzhdHjdMZ/nzv8H9rHbMvZHREaFpIC8BVPWOKCCCIq3EiSMf2oq0s5Dp/yla+wL73uVKkMy9xyRsKnErgHqiJcPaEqMJv8SXHvpWMdHYslyE7QsK0mYVSJGyBhCFqXcVaag+2MBn1dWIQ==
X-YMail-OSG: eTma_fAVM1nrhnGUA8s6AABxND0kR_DRJfyKDZ5QyuwdzB6yNHuUqeESEWkt0yT
 KlyEnoOGIQoEHaw8tu.U369wy3AoiegNHi3TMCYQo6yOZfiXnVeG2xQgCSXOfKIQ.BymMPKIq7W.
 wqoprxS4594.9D3_cb72.YVJ61DmSJFWpanuaS2WWgiufL4xUFziiAtQjgQ3vhXm9RqhgJbNntI5
 UWib5cWzZY8Fjut9bN01c9Q2gVyk_OGBceTQ0Oy0fQfQS772mTrTbw3prmYUQJzGj1ttt2xF1bSw
 xsDRcslUAyGaTdSHAWe1eb.Dhsd31JWEmS9Mpt0jl1tV22Kw2fHuniJptD4nT8uH1ItO6R_wQr8d
 kzQSa8CMEqUQbF8Kp2yPmdHrZSKqsHBR.zFg_5fRR.gj0OgTap8T7gcRYDOgheRMFTYgMrN7GGM1
 nwm_1O0JUFnRZ1l0JA2VXcTXspSHKzFhJt_OcO_wGLESshB_UHjxUeFsAR12t9YD6cA9Pz06Rglh
 jQB19pqFpF77LfDW6Y4PNIqqEskPiceNhs4h.7g.3LykoE3O6mI_8XQPdFfuXGuVbhSBC.c31tnw
 YRlRI6q54hM4mTT9.JPzzQeo4p06KVCwj2nDwgxkDf1HK7zjv1Lv9X_5FFidm3NR._O.sR1cPBYl
 FATPrLvxge7i4EwJG1pKwfXzbysJBzLUyeU0FgtG1NzRkzUFRGr15P2L8mvpJkKZlwvC9g7vzIuW
 eWdSugBeD4A5DDEcX5nzukuNUjkX_HAGWFioWmcC_WC9if3VKlt7vy63aNCY5NIVOTo9K6rOsZMM
 SSfW3DNtHrZNrG0FmCOuwyHzFIU3aEnEZ4n16Sg.M1vkACJ3eVkUEYYMZ5xcD4rzdcYyqmvP4zQx
 vdm_PmSNsTU3NTJwbwneIPkXsG3TmNeuFp8Bxw3ntlCaJ11p2idsU_KuDcj316VWojDxQaMry7rO
 91q1axy4VN8QY6bg68l2YGHpisr1Asyh5Z89BtPy52_T2xYTn1qTWMBWIUDONAzUNZIOMl82_7k8
 Nvy_5jvsO30lnG_OAMDkpMV0oJlA_sbMaU3PAHc6bupQI7h5RiX7rfrfGirK4.fU1RBF83UURzle
 LIgJ1gLMPjaw.7R_Y1Y7ZQItRJXT89KKQCbbNC5lfmwvCD2qeKmJIvh.zWD7v8aDl2.L7iabas.y
 Dnjapo1C8smXHxGzRgaA_JwLjuM5645iL61QTsOWL9I7phLQFnWWPeMfoqWWRAGeXu1WlalE3O5t
 VonaxnFI6RcTrDJV8KluiC.EDCbm2
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Thu, 6 Aug 2020 01:43:54 +0000
Date:   Thu, 6 Aug 2020 01:43:51 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <minaa6868154@gmail.com>
Reply-To: mrsminaabrunel763@gmail.com
Message-ID: <1208809628.659162.1596678231415@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1208809628.659162.1596678231415.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16436 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36
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
