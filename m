Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0907826A162
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 10:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgIOI7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 04:59:05 -0400
Received: from sonic312-20.consmr.mail.bf2.yahoo.com ([74.6.128.82]:34870 "EHLO
        sonic312-20.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726222AbgIOI7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 04:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1600160343; bh=DPYuw2gUpgtMJzJhlH/AVmRGu2wSKCY1C+f8nOCoxu0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=jSO5O4mwDskEoSbYp1gAJwyO1fi8buXnXsG5g7UwoXig59tA5h5XHnusRaowyO5q8n9Ta0SW8nndsAdFw+o+ak3K1404PCSWbrumOYzD/tKnj2VRs/5eiBcQ40PaIbKmZuOIbd0vgUfQwjWlwi+9F4b2SKHH/JdtI+rj2qzkY/vcObqrgUX0NyG4GmoMV36Om93sNtuNtHYHo7FRI1QiVN/ZwSh/x3UAvK6zhjDohktEH0blJZvXLY5jWGnB7/qzDP75N47tToam0iI/TeJ7AE/wuW3Bcn3uv2NAJohkO94xkLjoh0S6UN/YKqvHYsOj2wDqtI/Tg2dRdNTEl1aPpw==
X-YMail-OSG: pMFfp5YVM1lJmYhBW9eTBAvNp2dYXslKLM0q54SBGNF5lmZibMz6tLGNJI0lETX
 7Y4vKG8yiO70F.hSpFGtVB327T8EYR1flm0t8HPsBRWKOnP9PJ7FEC3MqIxYszsc04dwmM3zsTx8
 gU8Wly2du81TdK1xhJsGNSwb2KMTivz5dchh9LO2Gyh9O4pdJwT2nsYsY8lCDexe._st5xx75agu
 L9iVQ6kQJbWHLqEWcDJfjoKx.8rksLFuDW9ANB.nZk3gUyxSIOyCLOdgo5avPuGuL_DlAVFBsXH_
 Kbj3YdbF.1_eze.cnv.7mhAKwHW.0vZRtZPa3Dm3Hfeb0z68WYkvzLZn2O4vbcwxfbQWHP0mRtGx
 yB2nsBHFPRq7D5rdlHqk0U3VEJtYw9ekzouyApqqpzjr75pC0Uql6omCqqvUn4C5JbH2W6X9dzNo
 jZ3UhxzYZh40UIOsVGtQDgK3LIEwxJ3AK61YjKzFtdrFfqVn8ZI61c9PCgBpCvyR3B2.J9DyGGyv
 ySC26ZyJ6Jf995SIjTIgmKwhiIYHWxIZdNuuEgErVmIAgOfDhlI3ygsAGpixqVU0uKEtEiKnJE4a
 KBxuFVSLsFV2jVLl19.zO_atlVZVT.3nPdrXeeI4go_oqObq7G6WORuUh.qOC72Hrlmksi3eInO7
 kBaqokU5JV_Ro8rPa5lshTFtXpyXkrEaw_yozbESPjnfcJcI2HiSgh6RmgIizKLwSAE_TnyyAv99
 9L050XVXnKwOuH_8iD.B7JiIiQUXOXPiLgnZHnIwoKa5Dzxel0fFtRDPkRvZ4LXR71nm1vy24p7.
 7oLVkkaGiTvyKNxAEANxL.fLECm8DpE08ku73IYUgZI3MBgO.O_w_c3OzewZS1dKoX06gHCWQvzW
 AE.BYrDc0c565gKDSw9ldW4hNLogWg9FYYZlexx90A4QhSKGcijU_SkrtCKpOhlKdozmspe081eX
 84TQCjGq1EwnM37v9FlmiPIpHLImk_Vt5Iz.hUVL30gk1zIyebKQZxt0JVLr5e1u9E65uCcEpxIR
 JpdACflDuv2NyQx_KeTu2WOwjmqYD.1qorsSoBgpbovomNxb7i9FZWBPIK.FFIFB7jh1fQAEZ2MF
 dfZ64Ue7TI0uxsEOpDKnzoqBCHaM2I.gYyK5X2du61tNbP7T3oDtEMVt3m0SeJMxMvFaN0R7BFRD
 tjKL7ppJNEgF8QQnCvN50zvDRwPiWq8xFbAd0LZgbaFDyzUVfDtCovfVbmJV8_lWdtmSdlxDo.Tt
 6Ggbqv1RrbR5Vd_GbX7b_6fUv1bf99kH_otkMzs9hDn_4yaPdLTSjP8j9pbyHGaMZxFrAhych9yG
 9u4YpAmPIyyPbuadLeX.PpF8wS7Bznd5ujEnGWD9Fm6pLriQsB5HfXaLvIa7OMGGgRCVd0JRFZD9
 IwNvRHnqzqPekVxW2fQNSCy62DDyQH7FhXxj4tKIHoTRUqrw3a0kqKyo-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.bf2.yahoo.com with HTTP; Tue, 15 Sep 2020 08:59:03 +0000
Date:   Tue, 15 Sep 2020 08:59:02 +0000 (UTC)
From:   "Mrs. Mina A, Brunel " <mrs.minaaaliyahbrunel216@gmail.com>
Reply-To: mrs.minaaaliyahbrunel31@gmail.com
Message-ID: <172940523.2267838.1600160342770@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <172940523.2267838.1600160342770.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16583 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:80.0) Gecko/20100101 Firefox/80.0
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
