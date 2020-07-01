Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B34210BD8
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 15:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbgGANLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 09:11:39 -0400
Received: from sonic313-56.consmr.mail.ne1.yahoo.com ([66.163.185.31]:38643
        "EHLO sonic313-56.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728159AbgGANLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 09:11:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1593609098; bh=DPYuw2gUpgtMJzJhlH/AVmRGu2wSKCY1C+f8nOCoxu0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=F614QC0FUbgkrbyfm0gmEynHgWec+Uq0M+DZdQ/9dUsNqrzuOMSjfJ4VnpjXSB00pR91tbN3lzhIX8KKG9JMiMkpHa7KOF8v5oX3jz6Y/Z/bqfBRJx/74HxHCK4975y55/kyqAel7iWKjjfAX8yjidk161QXR01JPAnNm2r2+ds7CoL48FHXLdgTh6s4ojhpc9rfK+yHbMTmBX35e4bMpS50JEIn2ucT41RfuRk1A3HKHdedH0nHi046X2eFPIkVhzb0P1yxnSLPN9UCrnowpCwDEg9RfP5d6RdJ38fdMQaY0Qi92S9lEXjwhrEAoxOB6ZKEoSILq3GPEydNBYdlhw==
X-YMail-OSG: GF7wSxIVM1muovtr.oN8zmyLJhD5klye31J_saSQI.WuyfP1Qc.Iuw31S6tJVu7
 qEkARdmC3mPTdeQjpIv8fjQ7dLWuviQaGeWZ0iKP6WyTSxOc2HDULkxO6zFNQoLzB_KWMSOHJbUp
 .oR9cXKTRk6ic8aA06gH_esLUdSFVVhpA7_7b7F2SpNwZLXKi9PzxP6m6sHPMzOvkSpnXwH9n.iF
 x.Ww0KYF9ZG5.PD2LSOuzOW_yrwyl075uv4EmdOWqjY7VUwyVDxLjCkMl4.4ZZL8l5Z_78Ck6kA8
 CzPSUJGonRMH2qWNU4XI7jEjHfkorq3IlUUbAZljR5XXS4FwzrepfaVWF9fQaZ.aAo86EqG2OUPe
 8.6py0lNiCsMAFp9PCwAQvjPZU_kq54lZC7p5PK4fOdBRrVeNkAC6MHyiwvFgmFAVCS72NEGTfRh
 Fv4CdsUO0w9s0Sdkgzi35eSBnsJqXetIG3YKYWToTdOttCG8kJH1yZXjWdPYDUspZeE9jTQH3Dsp
 rZQvnwJviIZ0Vvx4IztkolJRgnPeJOO13nSNP2XoRX7wmNHl9Hm61TzMVAAI6IkyMk3UtuYmTd5V
 OLDNXGNjbbN1epjyXvWUpGQblpe5.eLIt8aREu1sXVMPAkkDGwq3wDYnuSmJHx5A8JF4RD6jfuDj
 yVHWjfI.bjb8iEpziTC.VUM0_W64Gxh1zRyzYMZJCXv_BkQ3x3UybAv9bWt_Fve4NhI9usGWvKjg
 FVfdMZg0HA5oJby0x6Em7plYmGaFqHoTP3rVKC2BNwxhlU30a.XMbmUOvEFrAf5U8ZXPnxIFbsJO
 HCfnUk2TtQowQvaGdoH14VWcbjAYWY91XF4QiV1sc.fC6Xr6s_tTBqW_ol59I3Va37oox9lqcaws
 ktPO0gNwntGdwiZoXqOk3Gwg4Fty4WlyW5b.Jmf7BMZIG3irtc1dfxCc0vF5NLEz0Vj1TXP4KeAR
 3nIlFB8OBF713OLGDsn1_BnK.qgYtxIjuT0nBDgEy7IO8o3sHt2XXqYA46uS1mfGZlcXoyAq6IN8
 6cISt.6M5NpE74BjVtDXIzu2fxEuR212C9SEFOVMFxtJLfi9GLFIgVJ5LT6YJPl2OXsY.Tk7BrYO
 LDwQet4YxSOzQQoBixTiz87U3MsbBFFQbuLVfuwycMNTx6pEbFNgYEYZYN4qCEz45WelYgVwDsm1
 Ou09xxrjbAs1NM.a5hHT3WONg1WjSHdg0ZG1e3u7onSqjc85cggkkj1kpuWwjuSaf76ye8hK_xAP
 59A_i9Bwa_XsB_Ij6mEufV_0rAFASxJKEO9tTgBxTdEyzDKI.ACf69jl1HaeQoHSFhhVWDuXhGw-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Wed, 1 Jul 2020 13:11:38 +0000
Date:   Wed, 1 Jul 2020 13:11:35 +0000 (UTC)
From:   " Mrs. Mina A. Brunel" <mrsminaabrunel2334@gmail.com>
Reply-To: mrsminaabrunel57044@gmail.com
Message-ID: <563862330.914166.1593609095773@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <563862330.914166.1593609095773.ref@mail.yahoo.com>
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
