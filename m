Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21ACB234F02
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 03:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgHABBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jul 2020 21:01:49 -0400
Received: from sonic302-1.consmr.mail.bf2.yahoo.com ([74.6.135.40]:44242 "EHLO
        sonic302-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726099AbgHABBt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jul 2020 21:01:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1596243708; bh=Sq0m1vvm2SZTihycyLIp46MmEaT+M4u+5ZuM67ujUHw=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Hrzh7qICRPkfCBqdm2KVLOknD8FHdzZyb5qIYuy/bmlsxjtbdo7Cy+Qh17vjxWCnZv68IWD0iRA0Wuul7oxX0ByUkxwMjR7jiis3Fy3ZyxyaZy2j+N+WgUguTvO9ruViY6oOv3i6CFgn2G/oPUG3drmR3bP9tqSlIXOi6YoTReDCVas04usnvtyuGmTr7Tgoo2liIMAE6XmRUU5V5IVeYUHoCR4lQ/WTSaG7tM4uDqxqI2MveXHSvghd+RzLPf0L7i71fJopmOSzl0kJQv768E6zGC0us9ftkdhLyL1uuAJPspoN3/jRtgwQkHjw+Kp6e2WN4dhWq4qwD8pSCzVBkA==
X-YMail-OSG: oTxKo_IVM1nrUxuoKQr0EnnXrFo_xZhAzKo9WW_svIymXW4XN6AeUhYSk27i8Yq
 FfABEz9M3m6yFI3DDFeq1w.YMI9hGYyoMEWgYWqNhycq6lBjVmzZyEIJi2TsMutZhiXFbaLPiEqc
 r5aOl0fBSDW6fyZmrR0H.yxps.zQQk1ywvCL0i6Va96UE26qTSdDOZV_eWSMOF8t3m5Bdde9wGTC
 cDac.krmtEDMljcJEqLORLkUsMZIP0gOpeWLjfIrHt6Hcd7O5SO.lpfUNd7yt7x0QCJjaQLWwjBR
 .g7NzDKNVC7vs1.v1Y16U5Vd73GKzT2TL_5YjCxKOdFFegVx0.n6ofVwDsFSFljuucBv4fI5wrop
 C.1qsYDCxYFrVhqaDvu4dZTLe8KO9n_FJjJLjsDrI5nor.XGUhq.540xQPleVemKPIZASsxUQ9K4
 x61VrAfUAPvzqMz76TJRI1F9e0tVtG3O2kLIQmJae6dFvP7lWN9tQyTVW6rjnadmYF987M7CoITf
 K.f6zMR9nfZEJsSAVgSViMiO0P8K..KHuJGsn6QlZzNtniFM2JPDSxTceIhs2H.6mqjD9GFwVnYe
 Y_t9zVFbtJHtTa3OklhFkqyqBOiA2ih3yyi8O8aLk_vR1kBZ5lHkPJJoeOlC2v0PZEdJLyw01zSl
 n_FOSJNEyYEW5ejsiRDzTq6VqkT2tMZXLhlhfED7o.gfHcZfl2To2HPIsNzy0E.UZB.IfhO7ml7v
 l9e3Ap4P7OgNRTfDRTJIqUoTgHhmDu.1z_rSCfXPPNXdRV_0UlVCKQLUQYdyB00.XVP0X2RYEWs9
 su9sAUkE_lHJy0v5dEAcODIDf37Tf9qQzaFLaEt28HsJ8oTxI3ZuxfQBc87U0q2ANxmQKnpr5uU_
 VoR6Zt1JnhXXDAzm4t2fbAJSRpgdqrnoe7cdb8qnzEcqUczbVMF5t261d_Eve.vm4g2Q1C_dw4ut
 SZbK.HM1gMT17mCzkp_fT2PUW3C3nJ4BSiKJOjrWOaNSjPxk_q_rVyEW9hmjGQgTpyqmAHu2IHkC
 uFH9h1qM5k.t8t_lw66eIhyB8o4uzxFRpHwQTtsR4ua5ymTLQqtaw7ghztuJEyS_a6h6h7.Ttvy4
 5UGsMa0Kle.HkE_UpvaPjylOyxLbutzHq4xKO0CP8T1oGDSLmCeJT9_HmYIcH0P6s82XJZ5rjn50
 nyiWbyMhEr7_O8Cw8JWS7DJKP9QlrmVvJNLFEztffRcw88YAAlt4aYJRde1.ms4QZHVPXH1S_J7T
 Ia0LuzlrHGhLv01vKKHcYFbJOcA5xW1lFoceCJvnGhIyYhicGYfJcXNBWkH0wbhl64w--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.bf2.yahoo.com with HTTP; Sat, 1 Aug 2020 01:01:48 +0000
Date:   Sat, 1 Aug 2020 01:01:46 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <annahbruun6@gmail.com>
Reply-To: mrsminaabrunel653@gmail.com
Message-ID: <1427289683.456034.1596243706732@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1427289683.456034.1596243706732.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16398 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36
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
on Euro) Eight million, Five hundred thousand Euros in a bank in Rome the c=
apital city of Italy in Southern Europe. The money was from the sale of his=
 company and death benefits payment and entitlements of my deceased husband=
 by his company.

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
