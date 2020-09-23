Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A377D274DC4
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 02:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgIWAXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 20:23:09 -0400
Received: from sonic314-14.consmr.mail.bf2.yahoo.com ([74.6.132.124]:34173
        "EHLO sonic314-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727034AbgIWAXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 20:23:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1600820588; bh=SPM6acYNk1tVNzUKuM5Fomz7Xr9Y+awh0MQ1SoFGZok=; h=Date:From:Reply-To:Subject:References:From:Subject; b=oFhBCYrvnQVEQbuNtl1TW+XSwUpadYc1LsPGRkXCmLnlUQxjEIJxV2PpH3EI3Ev2RzsIgW6JwFt27tbyEkC6RvZB8YnMDAzsXtS6hW8xaALpCOiGArz0MM2LYREtTYnug1nii9sir7MZitfb5IWZuHx88cfU/Fdh9Y/ZyGom0kLNOIqw7ydf6ZEXYdcCxXh2B/gg97ThnfaJd9oy4LncC1ickbscjIozyx3+qn7oxVMnifcwtCE+OSJEAz19k1iesmCmiokoJPvZtFbwr1ptsT9JyZ92ChQ+tRmo2EOb7yegkFH3FFU570JGk7pYqa4BUFvZjEALXxzUrJRTL90gYw==
X-YMail-OSG: AFUBNQAVM1nqPCMQZ2H54hFI.Ft7kvhgRqe.1vNoLZ3COpkasd0BchmzZG7ks8O
 QXbg9Om_92PTMtdbqStRbDK6Qbn48iFKvmKKN3mfGBDj1r1Wv1uw29cQoEZHDNvLgvIHXS87FsWl
 fklClxcR2y.V7CMj9AsheqzVi_PSNZJOaqQT737SHSZ7lorlkkey3beZ0n9dRx2R5ehor4Vudy5q
 rJVMERNf9H38557KOpnCjLXNv15AVe42SF07D7S7BQrNIv_v6Tz6eSI3Gn2g8pQNxmxZtauh38N.
 nP3hbNUf798vNZfRmiYOcLWf7fYqsbzx605EoB092riXIwu_vnh0ltdh_C5nh4NHRhROjV92bmYc
 3Ivsi9uf24_55PSHzw6wLpK4eIMxANhZD6aeS2621SVf_CUU0XAgeSTEPnqnvYBsNHQfM75V8fHL
 LEh_BS9PBStHuYPClKe9ywwuZ3nO2BaltaIVgTIuXIKqUVXEx7jNqCyzgMfeL8lBD2QsVq4A3b7w
 VtNKx_xwjI9rrLsBdJozard3z2H19VpMXYNAEOMbQMMP_aw_g.XSfIrigIzdkjpuQsm1f0oo3ovv
 rq9sS00O6.pR2I5rNH.0FZWoLNMIHrAB8m_wmvQSFjprnHQQbXSgEcWMBMMYH23lqEqSfkphgcQ9
 Akn0eV.PvTe9elYkKDBZyBJ9NAFp6QpPlHdolKj34u15zfFHIvZIqJOHKttZPjttatkJa43oekbq
 PGOH7cVyDmCvQEjqYxo.P5QlHUULiAWJYJERLXnaq0cn2stkgltBTTBk9HifG7ut09G6ABpcIwKP
 NaFDY6y4Hy4t0WuyNgH8xtKjldCDp3P1qw53wAzZfoZATb3RdxP1uEThRgxBJlLSl9s0diarGSXE
 PxBtNFm8n_QK_DKHBf3F.c73hcZaQb1r1Rm4ysTV9AsyoJzcRB2Ugxd7j1zUymhPo2PeokheJSEC
 10NO_MsUljZz4sqopemxZuQJsH23ooQT7OkzJVKzj7wm3DN.hqs2zwB1W9pa6gvq2NwBR7WHc9.Q
 JomGLvWGHH7tlNuoFS.MKupxLPXHKJrkqBAf6jUYnCQ1ZX8cUCz2fMHj.S7Ws9uf8.k_MTB8xXDp
 ZnEzD_LC4Co0e0v5Q3PYI5A9oQw4v9GU_RW.2ADuxz9pmI752rtGsIg05MGj6vlydwfgFSztEhGe
 i6CxdId5Lw7b6jkzPwlBfV60Rx03xCOvm9T7vBjftlEtg3Lt7TOvcBl1O9I12YCJ_DNMGzKKWghg
 AMzRJEdN8LSz2YLi7rhODRb2WTXa1ALbHh.PU7EcUQZLpRt3UseK8QPgSY7DX6xdA5eDCn.Lb4U_
 t7HHAbU1msSngLY9ZnvEY6hE_eyR__GfEsl.gtoiqfAQUIEtW98xPSfOLrPCnMcaQZser28GvWRW
 zeC3VpHyXoXmEku6nn6iRZrpwBvYPRfTBODSYOWAAwFa7LzK3hrPW3vA-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.bf2.yahoo.com with HTTP; Wed, 23 Sep 2020 00:23:08 +0000
Date:   Wed, 23 Sep 2020 00:23:02 +0000 (UTC)
From:   "Gen. Bella Logan" <bellalogan33@gmail.com>
Reply-To: bellalogan211@gmail.com
Message-ID: <1893238450.5010542.1600820582899@mail.yahoo.com>
Subject: Good day,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1893238450.5010542.1600820582899.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16583 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:80.0) Gecko/20100101 Firefox/80.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Good day,

Am Bella Logan, a staff general in the US Army presently serving in Syria a=
s a combat instructor, I sincerely apologize for intruding into your privac=
y, this might come as a surprise to you, but nothing is more distressing to=
 me at this time as i find myself forced by events beyond my control, i hav=
e summoned courage to contact you. Am 45 years old lady, am a widow and I h=
ad a son who is now 16 years of age.

Some money in various currencies where discovered in barrels at a farm hous=
e in the middle East during a rescue operation in Iraq War,and it was agree=
d by Staff Sergeant Kenneth Buff and myself that some part of these money b=
e shared between both of us, I was given a total of ($5 Million US Dollars)=
 as my own share , I kept this money in a consignment for a long while with=
 a security Company which i declared and deposit as my personal effects and=
 it has been secured and protected for years now with the diplomatic Delive=
ry Service.

Now, the WAR in Iraq is over, and all possible problems that could have ema=
nated from the shared money has been totally cleaned up and all file closed=
, all what was discovered in the Middle East is no more discussed, am now r=
eady to retire from active services by the end of this month, but, i need a=
 trustworthy person that can help me take possession of this funds and keep=
 it safe while i work on my relief letters to join you so that we could dis=
cuss possible business partnership together with the money.

But I tell you what! No compensation can make up for the risk we are taken =
with our lives.You can confirm the genuineness of the findings by clicking =
on this web site: http://news.bbc.co.uk/2/hi/middle_east/2988455.stm

I=E2=80=99m seeking your kind assistance to move the sum of US$5 Million Do=
llars to you as far as I can be assured that the money will be safe in your=
 care until I complete my service here in (SYRIA). The most important thing=
 is; =E2=80=9CCan I Trust you=E2=80=9D?,As an officers on ACTIVE DUTY am no=
t allowed access to money, therefore, i have declared the content of the co=
nsignment as personal effect that i would like to be delivered to a friend.=
 You will be rewarded with 30% of this funds for your help, all that i requ=
ired is your trust between us till the money get to you.

Sincerely,
Gen. Bella Logan.
Email: bellalogan211@gmail.com
