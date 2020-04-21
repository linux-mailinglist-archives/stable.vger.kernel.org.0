Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889851B2B85
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 17:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbgDUPrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 11:47:10 -0400
Received: from sonic316-20.consmr.mail.ne1.yahoo.com ([66.163.187.146]:34070
        "EHLO sonic316-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725613AbgDUPrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 11:47:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1587484027; bh=q1Er/SdqxATomBDx27mJAnsQxxrJWpCL+Y8MaW3053A=; h=Date:From:Reply-To:Subject:References:From:Subject; b=kL5eb4+VQSB/wuRPIIlBWw/rYhrYrvoX/M+RpFt/+fWUJzRS6owtayvYTXg21f6WP6sAbD7zTHUgU0Ir8YHnNQzOnxHj+G1wOx0H/IqRtiOLudOxlE3dtyDyq4vLyyIu3+mMUAq1gj2KhcJxNYjpFKti2LRO//aLyi8ub4ygYmgDAJNXp4r6PgtSfzrASgq9BlIcX3kugdHRNFJgfVuocsWFsDb7hH7BiyVO7hqCQtaKUqlXUFVl3qtxuUetmr/JH1yTA1kTTdU4uPaMw+ywkBecH2IE1Xss08sPVtF1h1/lbRLvTVmS4mHP5JpWqDooCQboF8E+oo+viLaPTLfmvA==
X-YMail-OSG: EIzC6S8VM1nhL53PlPZBj6EhqgFLYGcp0jq1BhRICOnK8pyWLtiPkPL_gpoF0zj
 UMQHD7oby8_bIDvAfqoXLy30UpPaoRvx6KMDWjwPU7UayWw2rHiXaW3pnBwRzHBDb4QSdBfDBT.M
 y8sG09QA.d5Q1ie6rHv3EkcnBwUSkjmSoTZigIFEbas02ySJUe.iA3TdrIA9_6.qEJMMOeID_tDx
 mze_GbdGRQ5aIAydqJvu6wfBceSIrfxdHM8gbNcpcCbX2tr.nRGDmHRD6NThpWnVA10Vqb17HjsM
 OHRD6Rg73HOM8VSbBAZYVGO8ENhc0qSSgA4pWCgHmAw4KEdyihTcyYroSc0ZaLbzTxVeKL3nk8nw
 LnmsPVx.GBOheWej30sBzwkVvAZPOU_HQX6DsVqj0xdlBGX7OKf6YNqgioLaugt8yEIipaJawuXI
 .5gLZQbnz2Cj0FgNZN7o9xhr3f01iDtj.7vKPjOhuIrq.GvSAbf10BFB.xrprXtXJh_i4CAkBsUr
 .HMNVxVeduCv5vJHtp5HJjjlRrpy2mfxN6X9jQo2tZUcVsgIO5rKHGTLbbLxd.8hjWmVvOqvEfuI
 e99OG7E0QKGkg04KyCHVsSUW.l.cZe.cNngIXHXAYUu8EF7Wbb5B2vd2aV1i6EVoX9SbXeEaEOEl
 XeQsLSABPy6.BIU5hRt2EOIIV14ZgTF3SULPnTeO_jfr2_UDpE3AWmeyAVmXJNVezfcujCVFF1Qd
 4t5XJVo3IHYn3Cygc_MpQNyAfG5EApnypOOeQ9SOPtk1PjIW5KETXZKP3eI68Rf.6NpWe8YUjkCe
 JyiRKS0yw3JWYIR89jyd1HIw6T6NgimMOLUngXHo1MAZWddHZUBHjG.nyurA9FKNwtERhM.wOrLv
 lS.p_4C238TfxybgFKH7xah.xMjI2Fzm2EyvSTi_N9m4Oj.PTFE7P_t7vblgQXBMtp7YPp.FwolF
 JEmACT6wKOSVYPAGbmjctguJ_TpzXV_Z5nDRSMrlngiNMd68B0_m5NGQwfoFofG270F5jigwusGX
 3_AYZJ_LHLMIgZ27HF0TUigM7ugt.vD58vsm3U81a3PrblkHQxVEOLRwAieeBSNhSFpU0yFjvz0M
 ubSvRappSVfE5kxhekJ0qEXB3KgeT5PR4SllI6v4hK_xUUy.mGfiDAobakaHl86Vvx7Ss06yrb0w
 pkcNOwFDQ01CnpbEQRrnzmFCX0n6vU._s0OIUqEJS654Lem_14ZO7UWnt2NpKQecdcmYBNHwrLMq
 qqMR2gV_JZJd2Vm6VyXDmUPmRHaPSrnCLDISPYTNu.a.FJnYJZKrWGt9lVN5gLrQbxAWoNsDd1A-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Tue, 21 Apr 2020 15:47:07 +0000
Date:   Tue, 21 Apr 2020 15:47:04 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrs.mainaabrunel126@gmail.com>
Reply-To: mrs.minaabrunel2021@aol.com
Message-ID: <767519345.330602.1587484024472@mail.yahoo.com>
Subject:  My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <767519345.330602.1587484024472.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15739 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.113 Safari/537.36
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
llion Euro) Eight million, Five hundred thousand Euros in a bank in Rome th=
e capital city of Italy in Southern Europe. The money was from the sale of =
his company and death benefits payment and entitlements of my deceased husb=
and by his company.

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
