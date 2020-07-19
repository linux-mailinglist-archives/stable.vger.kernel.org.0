Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F02225333
	for <lists+stable@lfdr.de>; Sun, 19 Jul 2020 19:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgGSRsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jul 2020 13:48:14 -0400
Received: from sonic310-11.consmr.mail.ir2.yahoo.com ([77.238.177.32]:33954
        "EHLO sonic310-11.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725783AbgGSRsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jul 2020 13:48:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1595180891; bh=DPYuw2gUpgtMJzJhlH/AVmRGu2wSKCY1C+f8nOCoxu0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=KaMv7V6XxPgUIojwlqB3guPdGZxIq7VBPxo8G9mpDgp8xDxaCbjwhTbF4+qWFNAXBgLreWftBXguGaVtq/MbvyGoXttjXtGd2cbqg/0+00aTJ/zfkFyR1vlx7+aVGssxlBMBk1c+3AndnGxtAbSnWslZMnecmpEjHbFpOfSOo2PbL7jsrgbERq2juOV1RBmmN8Bh0+Hq7cremSvEU61/oxXsIt78YfGxxZ12TNIWDbIA0EZIJL3yvFxHY4zp33g7kQW1oAAF3S31lOFqZFAGPUdB9vYs4zdTLwOeziFKnKoibKnMoW8GsYWsSl0X2EGtvq5/YTzx2E86Jx3FxzFBHA==
X-YMail-OSG: P7NAoqgVM1mocrTyBuY6cnMcbLEIs9kGEcSWRmVNyMXQbN_Cdpe0Ep7iftj_jTF
 rFJPT3rs7dIub8MVWIOPKzKp0o7nGc2KvpE_gmAd6JqcBH58SAStQ3I8PZ4B7lBb6lOVORAHXwT3
 eqwZ7GwS0OABMfLnSGaB.6k2jqhlTk9CMrZbgv.EsByXsFOcAimmXIqI2QyFFWWfcT3avcA6mCH7
 WoZ_CZHyyakmNuhFeSqoM49e5IxoX15AO3E69RDTmAN4NCkpZL63p.IqT2mc15SExAokcuaI63wm
 OD8BtEK1FwSfAdlXk6rqPeKx_Yy.1VPMVzCcZbok.Fc_kGfxMKl7hAWJ4Faw8TNsRWbwzme0jSXj
 s434emZmtNWbTu4zlPL.PEAWZgRwq4qNXfRM4zcNDigJH9IDAFQI8yu8ILJaV7EvlBRqprG1fSkC
 OEh.Jnj6Yibm85GLwO4aImcTPoDV03X2M_z6coZVGn3dFS1M8vrVFmuhXRXPVg6yCVOKifrznZtq
 6dnu6.mQW95gOnxR18MQBgv3K5Tot1y0c3kFUP5mprhUh61X5.FZPXhL_A1G3mJ3rXmDtxo1DIeY
 nH_k88SfMZH5cWr4xTalMRRrI6fiN9WW.U2QpX1vG3lnadoG48OXstPceSH2mJnNSQoJRfmkwZXi
 i.mIFUCjbSsgciyVFOHSAKkvbj_AX.gTdq.TO_7BlHeNkMnx3RADpKi0iT_O4_ivtspwz0w6XLcm
 hINHvq6tlhTuaK1J4sMWbvtFQCOR53gCsT7GabxJNjTJR8DsYoEL6djaY03kvbyjexClqCyEqgn2
 TB8teU4FdhcpgxK3_7w6EGYwXjvQQE4_JJPezVSp.0PAEek8NNl8saCWJJhFycMhnbUVazZLM7yU
 W5uww2XYQ77X2XFcPtMLfAzdPiBbr0DHpEuLTYtW8AgSl0ZoWIBSITvroKcSCjHjqMd0pqJ6lCI9
 cY2oCi3GXkcfXsYKCk85yVnRt_wfmVIey55lgGj4OMSKjixSFLvZka2vx.QzWxsSC8gukzpVLL3G
 UTB.i.1Htr.kp72l1ZuZDifZXvbeCeY5GSkmIZrDcLIYnsYAD..dgAsbG4HG2ICyLu40jlJuAByn
 Pmcc45rClbeGCu51nJX6JNXqVggvOwsDHM99coJiXFsXBwxiDjth9oNSFweAw5jsSUVePBtSOA7V
 2E6O5vSMulKaSJtEQUiBAC4hDbz2ste6D7U4flAj_O8H9bUC4anAb201ETvRTJi1IbVM7b6pjVQK
 ciTFg3gxGwmn__m3vcpicmqApsr5.IQofpUmWCC1D
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ir2.yahoo.com with HTTP; Sun, 19 Jul 2020 17:48:11 +0000
Date:   Sun, 19 Jul 2020 17:48:09 +0000 (UTC)
From:   " Mrs. Mina A. Brunel" <mrsminaabrunel2334@gmail.com>
Reply-To: mrsminaabrunel57044@gmail.com
Message-ID: <1377706240.5936826.1595180889760@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1377706240.5936826.1595180889760.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36
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
