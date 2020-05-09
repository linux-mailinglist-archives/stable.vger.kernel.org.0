Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EEB1CC3A9
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 20:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgEISVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 14:21:06 -0400
Received: from sonic304-22.consmr.mail.ir2.yahoo.com ([77.238.179.147]:32919
        "EHLO sonic304-22.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727950AbgEISVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 May 2020 14:21:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1589048464; bh=+NKq2YP/4c3bLm2HmGhxa/KCZOXr0NIUKHs/ECuC0yk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=pX0VkSZgBFEaBeKHr2zh1Im/6mDXVGfPAfpFcLOFBNXmES5OIZYOPK3NqKK7AVQ++C3nS0d1SYFaX+UxXYu8E358UhPrh4scoq6FqY+fQB7I2bhsCb1QmtrW+Y7fsMszNuAARtOETShZRdwQISSFXlQrCXNttieMMLQ+JX+309EEjBZEDAIbjNDHV+djXKklAbCDoQGHIDaSPiHiu0e43F/Pk0zH7/Wqudl7SPk+QjgFCET2onBy7+XxMHibejEq/zryWfPqqNXBaveoQ0YRwE7Q2zkVax3UXaJ/LZMKJm0Ek4QDhrEnqwBoTeRW8Pp75kNkIis9984AGsKBbLB0pw==
X-YMail-OSG: 7pCY7sQVM1mnnp0eI2dKqc8ulLf7.cs7GUhC4B5VHJBrzT9Qx2_l6asFQrwgHMY
 WgN.7s35MXYpsp9EiaxZjgg45IvkgJ6uuuXqBy06CJYWNqrjt2_SLzWA.SJto7KI961qhKpFxZjM
 uV_cJzbJBlCJO.B5pVLaWywDVIv2khJfbFrQDToRG_et1DhmzVH1VdyFXycGPHrUzug6YEMfLgeQ
 fjRhHr_M7Oo61jPESDItjaZx03T8zkKyHi6BvwPaQrDzMTGIePArkBBH5rTizHSEIabgpBy.kELz
 eye53_OZiLQIM19QRzKsQKUowfcw7NkUDQQQR5vEmJI6jvqhjmZOJXpt1N2_vcUUHk2UaDTzSjmg
 yyyzwegzTC5MyNM4j8GkQSmP4Ai.8MpJrvNWH_mC4wY53k7wd53htqA.0D3j.gX1AHiAdHZR1LbD
 He_Exv_thqjTCIaDoIjPnsMefFB7ti9sjwUze0jn8mJ17WY8rY4dnBk38yxLh9JK9QqdwqNZUd1m
 RGpbhXMbu8HlBHCgje05HoVpA4VwmOIcX4sHJ.pQ9apcx4V8xRr3VqKde11_Y7kotqMyt8ehVjM7
 v2GAAK5aOsivN_Fg6GWcakuQnKMus4GrMJeemaKDD_iVWFamGV9NBCO_RU8gmUwFFGL9WqLtM731
 2WgTCGa565P9_XmBdNHEtV_jTqRYzoi9ujpQFuoJrCWIGE2UT_jMM1Kue82eoW9ySApILSCxle1t
 Uz_BCRKhMdmZgCaMskjl2jn4zoa3qmga4NXdxqUcPy2IXN_vZznYDnsi2KqidxIKfHv1AKJgM1.1
 M5vXgOKJCL.kuvPSU32HY5ZMOS3GA9VG.6TIGKULk6Ez_dncX_S16dsyAfq4yEU7qkFpb9Wf3OmV
 51pTOiMHBPdTZDjWD8vgERhqDsTDkEj4AFuKXkLzqFb24mFiXGSV5cJsIXUdCqHNg.rMOTCHrWa0
 rtVSi_8XsjtdO8VDUaltVvJUf8IDoKFbu_JlalMIDqUCEERTkbNKDttVUbc_tX.fAXuanSlt1bQX
 l_kWXmMXzQ0k0dy9RpRbswr_19wiPqyuvoVLgyxumx2P1mK8P0wLbDenr3P3vy7qLC9kc0K_XO1Q
 pxc1YQOi4Eqpy4bxOI5cEAvlDzV_Is4GP9v2szkYooHWLhPoeFKxCN0xAw26VQmdNV3FYuTYsUz2
 8Aihsaj1jUxXY1CoHcK3NB6hwaHQMtr8Ge5J9GUnUN.tqCrTgU2z9SkpXb_ya6qOiPcjinqzL1yX
 rUdLHxoJUuyj6PTY0ft0lSg.EZlrJRWXIfDbiQSVRgfNkkQjVaxJQrIZJLq9aKWLn.p2P3qg0kFg
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ir2.yahoo.com with HTTP; Sat, 9 May 2020 18:21:04 +0000
Date:   Sat, 9 May 2020 18:21:03 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrs.mainaabrunel126@gmail.com>
Reply-To: mrs.minaabrunel30@gmail.com
Message-ID: <262998524.1270929.1589048463590@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <262998524.1270929.1589048463590.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15902 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:76.0) Gecko/20100101 Firefox/76.0
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
