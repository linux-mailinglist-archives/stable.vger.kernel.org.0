Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5F5234EA6
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 01:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgGaXjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 19:39:47 -0400
Received: from sonic309-14.consmr.mail.bf2.yahoo.com ([74.6.129.124]:45864
        "EHLO sonic309-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726099AbgGaXjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 19:39:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1596238785; bh=+NKq2YP/4c3bLm2HmGhxa/KCZOXr0NIUKHs/ECuC0yk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=W7vk0xg1ouuO1KP4G+HzUrGLyQepVb4Dl5gtXKsYs+2E0yrs2Jj4/PX1nSXVjHf/g9BTaLsQM+U/s8qYRJj2Wr6vMWK3Femf1La/ylDUWQKTWCBl9JkWVoiql3s+9Oxk6yT/3NJ0B6gDfTO3DWvu0FhmjQa+yBZ9lSaRUlyhU3Apj3UPrTTvWwiJS9Ksu5RoEoC8/YHvRUFEqXRZpb4SlWlWE4zngmvvKiCWK5LM1tn3phw/Q9ZdazOF3bJPRF1aX5fpUlBxpeh9GehFIId33GKEk5PTpPn7+/jaQG0sgjjwF6q64k9C6fCDt3wQUhcp7aGA0u0TovyRG6WqmnomSQ==
X-YMail-OSG: Q1K7adYVM1l5cWxwJZ2otZLG1qBi264egRujr9EvRK7ZeV8NsJXhBnJ7QFZUztM
 udRh7bqcc01szA2Xla8TR6XI0AbiU1AJC9iWgJsrsPZqtcoAoEfOQR49SShlxdCKqLmOwuMe7BDy
 aD0ZPD2QkAgPfJap6qoETO8d3CtHmrx5z.smDaLqon7Omm6q9r_glIm35gthB1ApOhErH87CNpLd
 GBbQdYv_PhPRmkC7AW0xtbKzt_mMHjyUpfpwlFI1FJHvDKL0gbwq94H4a8mAhRf_UrTw1wgL5QFx
 Y_8HUdp1KIG3f3kU7HsbqnDwkLurOtXSdllMyhvBgbg2u5EWQ6672CAz5EoCEf5NE40ktF0vvCl8
 e0FcGrXxGnyhHPM7mjN4qy4uAPF8Hf_lO.wOKXAHrH_qY4CpLNx475hcQ1ToE7wbeT4QY2712_u6
 8q5QKoZ4eLYiS.rVbdfuxJp1SbTkfTJkc39V9_CHftxZj6tfXg_IsAKcdXcurCYWC2vwqv_ii6hs
 iklAkplHPEW3Ser8WcEa6WErVZJDR14_KUyY8rwWtR885PdeyrOGSrYxPslSfYId0yVTU.Qg.Kx4
 arqawCKHZT9UtwhbBQ5q6FlFglB1HH6HKlN8gKrCuM4HElR452IDhR4kcJzjbscYgiYaayoalEMn
 c7XucwzbiLEeltOs0QnkZm2JZjGzPOxm9w1Zr2J5kmNAIvuO4hJku8SenIiu77A3IoP1h6WGkYBm
 ORS6Ko_5DFQjQKoZ1.DvNDpkCpWRaWNH3FtqMKeCPgWGimyR7MELwCzApT_YNXJXYPp1qCIxRDhX
 m2bQ8gQy8oeXxaWiWHw75gflkRcQNbRB8fYNgYUjnfrK_efXw8y.Z_LN.GzMyJ0bSO4Fss7G8552
 sGBBgPaPHwtYhKxa7ZiAg_HAxFMw8CE_HO6WNX1kSMQDH2.Wxe7fV5PfxxQ8YYgu2zZsP_V2IX9m
 v32dS2aOPWg3dl1rOKQDwns_57QGdohDKXz54yN6MnZG.GuBF4GwORrvqPmnSkuk0h9kbyc1YJZk
 9g0KUIJNO9qTQZKL9FEtW9NLD98Z8I8pD1JDR475b4sXY4a1PLtRoKEwdO87gHhWeOQ7n2ytIu4K
 Wk1nqYGuELNFn8Z42ShL_bzEiWhC7wEaHC2WywN6.yi72WjwPKWDRmlGsVBX9Bt8ZtS19.m.3Ngx
 L9TbYNTkxeR3dt0aKRUGQ4bhfor6rW8s0xzRwj9KguMwtD4NugGifDc8J.p.h.CnvtNrFi5aQL1e
 aXeMise_DcamiN9Vb7WhgIE0qLa0XKBxP18JiE8pyXNyJ7Yd2GtKEDOWvQRU_YXVUb8hBqf0d2s8
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.bf2.yahoo.com with HTTP; Fri, 31 Jul 2020 23:39:45 +0000
Date:   Fri, 31 Jul 2020 23:39:43 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrsminaaaliyahbrunel@gmail.com>
Reply-To: mrsminaaaliyahbrunel1@gmail.com
Message-ID: <959959657.7224201.1596238783777@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <959959657.7224201.1596238783777.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:72.0) Gecko/20100101 Firefox/72.0
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
