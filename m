Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136D120C3E5
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 21:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgF0TzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Jun 2020 15:55:03 -0400
Received: from sonic309-25.consmr.mail.ir2.yahoo.com ([77.238.179.83]:38683
        "EHLO sonic309-25.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725900AbgF0TzD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Jun 2020 15:55:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1593287701; bh=DPYuw2gUpgtMJzJhlH/AVmRGu2wSKCY1C+f8nOCoxu0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=TcebUPn6vBA+SvAGJh0jsjbCvZ/nT9Yw5N89mk55OLcOFxij+4EFWk4FWbWF62/bIghXf+K+j/HiuVFLzM0rvjVdR7JRR1bk5Kf7hN/2D1HrG6OIapprGYUAmWoBqCXUTQddXRQ0FF5ASjHvI890Jk/usbl69lkFG1xgUj2dWbOUfXv2uVR1E0EdieYWQlubnRotdGkgZsb4WeE5CWFPD2ORFru9WHSvj1rpecsf1j7DsyiYL7hVelSRGpBUBRT0PzHnZhZcZwIm/+RNwMiY2y7MddS2WGONsX7frX2Fe0hzQyLevicAg3ACm8DZ9EMxN84XK8TZN8vNQ5BIhBgqUQ==
X-YMail-OSG: D1d..xAVM1mN4xc0TD4fVujc0GTCyKzZQtQ7iw895yIDexsFCpx12U5M7AfDmav
 80TxKhwXBR0.duF5ulRQZ9eA6IuB_ZkhTLFZwZuwolQbUcMb_0o6I6iLhaBWHvFAJlXUnjQc_rYh
 uAZF6s1Za7upHrIEz6GCmSgu4A.ahC4edlRyehflvmu3Ef3cad3KAPzJz6_8JqgqW1J4HU6ynJIv
 gMDC6jqqRJUddsIswrg1IAL7XBLletCfLrC841InjOr1WT6IHHLlORlXNTU7n6jn_EuSBts26num
 oiGr9yc1.CLfU9KPG4hzaSmlNAYG._A1ZO__zubyB7AgDILEygZsLGxY_hBTx69Z0kJXT6pq3F6n
 C12l6ctPUTF1y3hzH7D13qsQ.XmUHXHiwm3qwiAUwiEV1_KTaAQamAuctdO6RjMw2hZ9H9FiCFwV
 GKv6rKlCo4NoGDDWWQEm9CASmw6oBqQvJAVVKPtOCSxVs9Y83472lkDD9ppU4JUjFW0H08qCJPh6
 5cnt0KKgQtDiMSSSyQinyoww4jUVd.QzrND2j7U6At81L6hNF6tg4O6wahpaYpykiAXb8SE8R1Uk
 emtg3ByOKwbRd1ezduGRyeaN5Vm8Dz.6PBz68Xi2XuHt3xrW21UqsHViWGHSCcSQHh6N4cSUYiCK
 kyJGyuZ.Oq.9N5ixfKRconSDON7i74H6tu0AGiCHYGYeI83DnEgRhk6h7ksW.ux2VMTVWLjWJsnk
 AgRvpt1Weef5o6wOSJexMia7lrULryMCBgGqGzgJLky7bMqTyxd64fh9n5lbVR9yLh_7xELZAJzA
 MBrjKcL7ffTRXHL5DIlIZs6jBinTu1maTbI.6Z7h.8QGSPwlFl0WzSYytpYPl_A0lHi5P6X7r6kj
 Gr7c6eH5OaKukuMVY4ZhKCsGaz0flkQFf5Ie5zBlfSmsgrXHjs36WKHTTEQsgfNNJNs6VKXCZ0Zm
 dX_XiS8H5S4.AWhXE2JrkzvQRmkzR4QHREnygu5Uf1TsiW5KgEHYjhrA1hLCu7Uvva9TR0OPeQyz
 WKSNbbvQt0IuaVDby3eqzjra77wyWqVC7qooKS4qY6LIzcZWf9ZZxat01Jqhfr31WDRgFiPEA3A5
 FXwgVpsHtRjncFU1VcTQZEQ.wwVhO2CKKsHDyO0NmdRooM4oy_ZLXFV4VOe0sZyip.FVwYCNDNe2
 vcInsUaqxq4fhsZKVnEk.L53Y_XRiG.Kgz9sG1FacTxomMtlBtVvoDz5lp3BLQEw2ad9CR0btkV7
 GIJKzdtqOjLVoUp.RvbXFs4voovLrObpBzKL2pQUV.cP9J8whwdPhH64pos.o7Qy_Ig--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ir2.yahoo.com with HTTP; Sat, 27 Jun 2020 19:55:01 +0000
Date:   Sat, 27 Jun 2020 19:54:59 +0000 (UTC)
From:   "Mina A. Brunel" <mrsminaabrunel2334@gmail.com>
Reply-To: mrsminaabrunel57044@gmail.com
Message-ID: <126450270.8161920.1593287699543@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <126450270.8161920.1593287699543.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16138 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36
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
