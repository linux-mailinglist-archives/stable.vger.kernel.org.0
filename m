Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174871B864E
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 13:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgDYLuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Apr 2020 07:50:17 -0400
Received: from sonic314-46.consmr.mail.ir2.yahoo.com ([77.238.177.172]:41058
        "EHLO sonic314-46.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726060AbgDYLuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Apr 2020 07:50:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1587815414; bh=DPYuw2gUpgtMJzJhlH/AVmRGu2wSKCY1C+f8nOCoxu0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=hZJAfxthB3InYt/y5Rc7iZMNqAxkTkJL+Q6Anxrb8mKiCkXffckombO74VbUVJmPWTrt/MGf/jpDxrsyUAXRxyuy7vPPHaDqsj2JKTELCJa5xRHFsbTFi0RSI+5AQVNlqs4LpyMWiDoFJWZMHdUR6KdOpzSZpWpzJpx/jyS9wPDtYch6pf9YJW/m8De7Kgus0ifGpX2/u8il0AmAHFAbjCK0nUxQUCrD30nOwhmqKtqm6phlzZfwY5Mkylou2U/uzv+htDv++nJkpMt2Fd+47UIEx6ZXgNYV9MmmEp5iJt1pYBnNBcfpNl6iwb3dQ7c9IHaFpPEgVtebWL5vCJAJHA==
X-YMail-OSG: zH987Y4VM1llvcj1npBt3dUD0e58hptlyKZ.5q3OQuT0qWa.xUOUpRf2ol3GHYx
 qAiioT0Qj_5cV2pp8yNw_Aq5KjkFqpooT355SSFwCC0PKPiLZJNbHM8R3tfutkim3om0jCF1Hjqu
 lBANxb_pO41AOcymFjjN6WaohOMYQX3I70wG._Cwm7QqqYjhyA0b_HFuV8aQ0I95bot0JpfwjLt3
 .r7MT9bGPZxFqk8NDCm6mdJDSeCyMOUNG_z4pIyDiL6dqQ96FDp_d9Yr7a3Kzj1QIbLUrD9gzqOf
 c1YqsEB06h11dCnPKJR8rySeBpjW_ByN05HvavBfKHuJwFS2auJTLyPYy.y2AyMCybSKvgtYWXLF
 YaO7rOjCVFfJn3ColV7ECZufQa0LUjOCy0O7jjRYWUB0WD6Q4lwP.T.UiV.H3ml2IUwFBPQhsN_I
 C.R4eU4zqsazSbMwb5xIbTDHtpvOg7kV2SiQh0PPxn.xsxAGBHRjPpisBIg3deEHxPFyREFA7kDM
 Aqd2Q2le.fdHdXhpLnFjJGg8jXt0Es9GyhfypAJnMLKroINxe4KcdflEvZf33lNb6PVG1yJEGBOz
 ot1dP.pZopFhxLSXjb4pxoaxWr7pMxOxlo9b1obPAs.RolIV4xmzsJm6PjtfeLuo9E.ADJNDpE2j
 kzOvWWiRpgnyLeJCibLlOYqVEk5619AqyBrD0HpSfOCTt4SnSoV5RJI9m1AWeP_p7hFGv5wVMTkD
 kkkLKPe4oAu.Fp5FfeGSiSm.amVIhds9rByuZEeXiNOITlpyTddtN1LuZIPE4tjzGlbcwBMd3RsQ
 mQ_nAHsWhk2oUs_2ye8lEY4xsI74ccpevH2MXBvd5P.OZ4e5ztJsSj7TVyiHSN003sg6Z8.DCO_y
 WIPKpyy2VFtiQOKHUcEAi39oa40co3h4YmqLZGKKuAOT7xqBrCvkaPyZVSnmmbe7GVdmDArER6Zw
 iRH3ByMX017DKykuFPDL7Yd66Oe99tSKJ57GBQfOaqEYB2yBmQHJp5VStcKEPYBCuhHn04Ir9V6k
 3tXEv2nz3UBCsdG_VRLf08FTtD5kTUEB4Nss9vzrPswwnuvlCLGxcz8YD4NzYH4f.fHSKXpHEK9q
 AhdmmSkBDUoLljBbbGrzZnK7Obrdr50JJbq6u7FG_VVlm1C90lzDHPT_UoU22cxIMbp9zqgHdabc
 8VNadW8bKQP_GTwTA1nLq5X1mH_XvfC5V3xYu50qgCPq1F5TpzAwaVxCW4UDuU4kcH_AoEtDGsZL
 X3qDNjsgbc.GT7E9DHPKCtpzuApicJOha5i0CWi06RLR9nzicul4mLsGt5mf8o29NTr8RqIg_BDv
 ._fl52UBAhjYyWvEiQA3tsuROd1HE_QjktSW8mPA-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ir2.yahoo.com with HTTP; Sat, 25 Apr 2020 11:50:14 +0000
Date:   Sat, 25 Apr 2020 11:48:12 +0000 (UTC)
From:   "Mina A. Brunel" <mrsminaabrunel2334@gmail.com>
Reply-To: bmrsminaa232@gmail.com
Message-ID: <1026359262.230706.1587815292964@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1026359262.230706.1587815292964.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15756 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.122 Safari/537.36
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
