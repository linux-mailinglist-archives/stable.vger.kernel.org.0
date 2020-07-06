Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C34215B09
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 17:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgGFPms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 11:42:48 -0400
Received: from sonic317-26.consmr.mail.bf2.yahoo.com ([74.6.129.81]:45502 "EHLO
        sonic317-26.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729565AbgGFPmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jul 2020 11:42:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1594050166; bh=DPYuw2gUpgtMJzJhlH/AVmRGu2wSKCY1C+f8nOCoxu0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=h5O3JtPcaMPi1wJyswpuHQixpEVup3TzBfUrgIPZTEg6gqNxTpurgukHspFy+qx4uh3ZJEHIAGIOI8K1ImUa0b4XHg9MAs0LgpoQB+c9S5YCAEiU7jf+hj8FblygFt3e2febwlyKZpSylDAZl7Z48IxGPZpp3/mbSk9xi02QiwDjXQFYxiQTvtuTme51GMZKvPwsXlnE/pj0AXlz2C8h/1JsfR4/0apsP7YShmySILq/f140DggtJAiuOmBa2D4HsJPO3Ui0bOELFJVCWvJOiWc8TY+20gdVbuWIRTWxFEhzJrI1Mrp94PdKpJy41u0FjPphP5JDEn0h3VFdd+Pe9w==
X-YMail-OSG: FA6WhxsVM1klmneschtaAGkxPCkkKl5bWjOIAB_m7qgigB3J8S0oQ59_rA6A5RD
 9tFesttaipZW5AnA8700AXyAwZ2s9SBRu4H1s13DO1UNeAhBZquJShLT1C0GlWZ7oCOUzkw5s3Zq
 Yb1oMabZY_Gy6cNxoPcG.HQbEr.4zEtLhpU9bg.sTbI0PoswPNJ6H6rBOmU.DAkjdUx6wtoYhHJt
 kyLiIWIYSf7PKx4zdOK3fwsVGJzwWQEdK0G0ZdozY2NKg97he48FL8WS0C5b6ySewAaCllZJYNCl
 PFDnKxSVwrXRhR3_SMPyXRJDy.mSQxxEHWqgnrY0msdGhmyMqjz_5r9RkbmSJfm2GmGwgVB2mubZ
 Yx2KS5DnECNtfcTIcca9S1DM4cKCg1M1sLz9iUMNrYkqPo0qrmRLo8FEtaBMeVuiLyeJdnFZ5L.d
 CSbggNCJdF99B1VJQubl1nTBR1v2fWspLN74lp_wzeiJ6DFd0eGnL0Kckwj2GfAXSpUlrnWAFnkB
 mestahdXVvRNclQA8wHawOSjvUzPyoN0kauyWGbnu_GutTnjV2NGTbHqkcVNC85DwB7FWQPtfdXp
 e0UJfbfxSk0iknrQpB29h8TQdah9NyUcizotdG8VAdSTrpj4SUm9c48tIZ8a4M9wKM3VMmGmsvbw
 hKADk_ceo6evSQiJ9lSinMZrEv29K2CQtignJ9aO7NQ1Vvlq2abQlNFTKwCtDoU.mIr2pCLWm8MD
 hCQwkqiANmZ4tT.W9p0O4ZoGV8xfa2rGyJmX8i6o_PbthnL1Pt6PcQW3kZ8C2WgaTyBtCZyUJRwk
 Mmmf9_qN_ATtzucxsysPnRfCpQiBd1AcKrKTkXYQ0wkLxsza5srMqjYA5eLLcLdNqlFRW84._fSO
 MRhBUOSDk6EUTo8ev.sUmSjFOHNT5uXt.f2LIPOJj0sz8_1Ce9wJ9s9z40wj9.hApt1_j_fVNnK9
 .9w6DAL3S2JpC0bSr870H6nztoGxmZKLdA11DRlORyml8MzD.rEp7Akoxh.Zwtw6ZMNWTn.XOIjy
 e4hwBWtz9NU48v.S0Axb_VQ9xf8LAFKukL3u1diqx_GTS2NJKPeUpTRyoFzAgstLQk0b0rjd3CxR
 ifcYljTmu3SQjHPPb6ckfbhEpOUlAzosQmXnQ7rNoQ4KPF2fGap9M3UMe300zMWZrJDQ03cHxNZb
 K0xs7nkSPJ7qm1mmAqftwUrvpjQYw25aGMsG7h.G1ZlImZoun01hVLZkyUOeisu7Jh9uL4CXiKu3
 0sxBSnUXaFb6wXaXIx0ToYHPYi1iwq0NOYzK3RQuqLPo0cCgAo4SkOxzug8KZdFJUlAqbLFvCdM8
 XKg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.bf2.yahoo.com with HTTP; Mon, 6 Jul 2020 15:42:46 +0000
Date:   Mon, 6 Jul 2020 15:42:43 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrsminaabrunel2334@gmail.com>
Reply-To: mrsminaabrunel57044@gmail.com
Message-ID: <492390149.1312531.1594050163407@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <492390149.1312531.1594050163407.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16197 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36
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
