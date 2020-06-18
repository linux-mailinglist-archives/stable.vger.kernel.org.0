Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE331FE169
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgFRByi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:54:38 -0400
Received: from sonic313-22.consmr.mail.ir2.yahoo.com ([77.238.179.189]:39348
        "EHLO sonic313-22.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731533AbgFRBZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 21:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1592443553; bh=+NKq2YP/4c3bLm2HmGhxa/KCZOXr0NIUKHs/ECuC0yk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=N2lwg812GwPpiTS4iqO9ykinfCgsLawHRj1BUy+6/KF45iNoRdhYW3WzVS5emneIieyJED09zJTHtUpFP3luCB/hYsnAb7TSqVlbtBaS09VXIjYCScDamlrLuwDR7Pc/rCQsR94QJ0x9mydy54NXiUTyCHij9nY9G5is29C9+hCp3AKenv8XPKkT1QJFUY45NQXNyBUztVX5IcTVq6pJxuSSSuZJ4SFotVIxkaNxJgIopv2IxgNYEzu7JQT8jkKElDoXy+S1EMPVFxTXHvaHvPLFiaI8JT1Jn5hQnMkwDUz0tscWbkF8paW3ICSObyz7N4eGvxkEG1FQjQgik962fg==
X-YMail-OSG: ptlCYzoVM1nMFORtpRlcrn33UEafr1yKwfASbWRUUKdQ.5gdngsRaPsgv5jrVF7
 y_N5yek44t.jXXnFWPOYHR9sZRhR6GoJxykL4R1tphQrrVjjJHYSwHSfhokX.8NWJjToRkkOCezf
 MX0I679XD74sbDcK0ctg.WQ1cEhCGvDf6MvlZrCWLwB5go1Mex7amG.gehrxR6FMdVl4STiTbTfX
 AJhqg9x_9ze8qXmroyclLQ2Ru_nHgl8v6S2Ur47RGVe_yFmhiZaqsPFcnSyIYi.KjcAHXmBfh59h
 kyzXo71wcd_P4DRtiNW1f18QV7cx5gN4ySgZHS.dFbwRHEgGVBNjLpRqfnurONbkmfkR98tKBN4T
 TQb1vT54DZdRGQ2OFoVh2lnmHqaSfBg.5tbXydbVEevVVDpS88FjK5a9ovW1C96bo.C26PGwJ._7
 woQVavfrzpIQ3G3NOVndVAfnORyXapfCli1HR_whGUMxqRTOsB4_Xfk9hHoD0SktFehDSzzMb.PF
 L1n4IL0MtuMRCXEXsvlmtNQOVGJ.9c84uSCyXULkR5VOuDJOeYXNUylVVSHmYUPz9Na_iVbzcZPi
 qG8H1yQqBrUc6nBL8D6_XDQMhFYRmBmKrd4NCuFrTeMd8bsPatWnU8PymwEhauRYAQDs52WbtrUQ
 jTeelKy6shdtD_Mhgjm81IVP8d1nX.ZQNSNjyJy8LdJ3TEtzW20m_5fRiI6VkRuP_2taATVyhViv
 lhYPkjLyHks.CrrfSOFcHrODVjx86DKJtMooe6z9mcSBysBowU17ltfeKchAZ9yoNLeRYdyQcuse
 v8luWnWALjuWVqtrO_wZPn8lsfNLuqnw1rg80.wzIgmofYD9jysn7VkQPoiWODMv0bc6ulnQvhQH
 6MN0cE4598g2aAy.NnRDvC2E.o73xUnr15Pua_ixduJlmrudQSGMROs1upfZLlbTsb1RT92YTYZb
 hN1rMRDyCcdfUWQozgJ0JzZ6zIDqy0KDQKH1erONfgweNdk.3KeHHgQUuEpRcDobYIGHraOIE8yZ
 ZIBAuaYlXXaFgTdgRdjJaOmEPBxIUBfG3H_Me43EFk7YX3zcUshxKpH9j0WC9kJZxuXZRn3afiwG
 rnsGEj2.ICuqCXjbDGt0OKzCareXIlMlTwNN33usEyaJZAFDDqn0dt1NBUOcqiajmEOrlHKgpFzT
 TOLYbRewrSzFkgIgnQ3IsjY1UxmlgD64aiOTu43_gVHHSgWsrlZFNCMcgbHFhi4GRXh9MsUIIavF
 5K8PTfLpSmKTq212kDmE_mvczM_TwaO9S6.ntghrrUS2OnpK1rwgcTTsmoGlw1ZkQrRklSbiz907
 7MPw-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ir2.yahoo.com with HTTP; Thu, 18 Jun 2020 01:25:53 +0000
Date:   Thu, 18 Jun 2020 01:25:53 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrs.mainaabrunel126@gmail.com>
Reply-To: mrsminaaaliyahbrunel344@gmail.com
Message-ID: <1329745505.4360115.1592443553580@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1329745505.4360115.1592443553580.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16119 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:77.0) Gecko/20100101 Firefox/77.0
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
