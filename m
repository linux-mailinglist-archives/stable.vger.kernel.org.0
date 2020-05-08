Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359041CB8F3
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 22:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgEHU2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 16:28:00 -0400
Received: from sonic317-32.consmr.mail.ne1.yahoo.com ([66.163.184.43]:43561
        "EHLO sonic317-32.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726811AbgEHU2A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 May 2020 16:28:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1588969679; bh=DPYuw2gUpgtMJzJhlH/AVmRGu2wSKCY1C+f8nOCoxu0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=nFYSstvHXkJXIPEWqTtuZKHmEaqGPWiY6WHdbxxNLUE1gyxqUufszmGt1I5EGCDFmrL9oc7iDwS+ay2v2+ERM1K9bkSox9z5jaFS968Dl/4v1Ox5thGIf5Kg2sCGaXL4JcJgTGX8X45r+vMyBb0QbOl6H+apgleJ2ZGrmugymVuAKZiArc2v66fMd7SZ2QFOThOrP6bEHc6Xh5quA85my2MfQKiRrk0Ndrd4Xyyx5JuQqVhZ3Nbmf7MQr8K1k1lyHAKyf14vGTTfNp/CU5zBn/PZdUHIZNnvc5Vefweh+NRESe0WB9Bi84UdA5SUo82YMF4+a0z90qwAlGISSIhLcg==
X-YMail-OSG: bS9SgDwVM1lh76x4yLQYZCEIEZ2cKFaohYLbDQbUtPLg1sL0ir9ujFSYp6Yfndw
 Zk1d3eiWhqiFh8Nt1ia18uHVUzXDpyCdkRBIUSP_y_VYSyXbt0YQuiEzpZN640h.wOKRlTdGFFGu
 UKfGxFX5t7S0uFYY7POh745qIgmFAZgoc9TjBxNikehIChfMBMt2SqWih.30V9gm8UdBcU6NLtGy
 ..Z41xMTBO3GHp1pIG0z9timL.fYMX8vyqODksNEmkgEmi5knuFwKn8HVLgi7IbeDReX2kfuv0i4
 MMMzVyCPPPb.8RVHMvX6.4YNGqTC6SXJFPdVNtNAXalOOag0XLf6FwfYZPH4VqlcY7al.LFwEc6O
 fTDerMygPOEE4J1PVXR2WS1PoyecUl.cMoykcV8kkIz3ScywI6ci1URf48SKGmyAQ8Bw_Cd9Uhma
 C8xmsy8YE2DfZiznzjlLbtb1IPnG.C0x04VYdfkuvARMdUjCllghPcsSn3Cltl9L5uvjxh8voSW4
 vOFlJV.HMzMaFl51guWT2823L4kWoEkJxQi4oN2EjHlNcCEBraXe0gLKXVrcch.DatlvHpumqxv5
 Qfl3w80wrtkVNRKC4vxOsiMnyuABTpWgmB4JuOoE2WpgFUiGVlSEuAehMxWoV_cR9HKE28jm7Bbd
 eI45rdnpgoaWssKqS8m0lukAm9exxaLPCNQZEgljmOXIBoDjB6_85ChGVkrb29qDJ0IQe0EXJ.Xb
 AXha7zAnp7wRXqKNnSmxyrWtufN.x7FGmOPo5HmJ1EmKXUB956c0ctP8EWn2BiY7GLr9GVu_UMir
 LCJ4hGABvttHke5HCJ_Yy_e9YUZp84cDuaf4dbi4Yi6pH6lZnBQn0P5JjjPz_alpsJ9s1rcngP0M
 GOwpneS9ititSpnyGQ42r2nr0Xg77bR_tzNfuGmlt1InmkD_TMYSy75hP2lus7QxkH5pgB94xcuV
 fulAWUGtOMfK0v5ELiNuyVzblD7WpA1f_9hZLVoWBsi1tv7bPpFEkhi3yzhcVYiv1eqwL5pp0Z69
 u6saTKNA8Ws93LJukz4yryM4bm81dKaa7rXF7J8VTdU5cjGMr1g3JAzR_JFa1qAqLpJcCOeSYs2e
 1OS.qj2NCS_OsMWZfPAjyo2QIHC0mWksWPjvPzMRFqt39ZU67dmqJCiCaTXo9fHGEO7RBHAjH6wR
 IUJ9fBzaFkVxbrDgndVnLgZ8x7sFMyCaglaKGRsnBSBm8N9gA8ripNeoLrSup6HySWf6iw5qROMT
 5hF8TcyWNBIVJ1xkld5Y.Cyubbf_UXy1BpkX0x8sFKWpWpkcsX.f9V74YLcBpXJcfVo_qR25.1Q-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Fri, 8 May 2020 20:27:59 +0000
Date:   Fri, 8 May 2020 20:27:54 +0000 (UTC)
From:   "Mrs.A.Mina" <brunel.m@aol.com>
Reply-To: brunelmrsminaa@gmail.com
Message-ID: <362888928.391273.1588969674588@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <362888928.391273.1588969674588.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15902 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0
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
