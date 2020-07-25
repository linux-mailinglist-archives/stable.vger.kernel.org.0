Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D1322DAA8
	for <lists+stable@lfdr.de>; Sun, 26 Jul 2020 01:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgGYX4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 19:56:08 -0400
Received: from sonic315-14.consmr.mail.bf2.yahoo.com ([74.6.134.124]:41138
        "EHLO sonic315-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727789AbgGYX4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jul 2020 19:56:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1595721366; bh=+NKq2YP/4c3bLm2HmGhxa/KCZOXr0NIUKHs/ECuC0yk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=iW4seRVtbnpvvyI5BHItPFy1aZfVH6YEEGKDWJo4vLtvBkhQSMfkl/bcii5CynYjXMGJacM4tIAfEazh3Y4A3eIetFngBrEbzi7l/W6+mB9gXzFJ1Di33B2ipRunLWVrOELl+ELyhxqYzGk7hLeczOJo0m4Aa6uix0vBv2n3eCgqxfvVFZEbcJvAI+J8+VMfhOAZXFvm4RIdCpwXq68OOUSUWg9gcrqEuqsFiB+fSsurpkn68caAXuXG73O1a1MQi6haAcsLu7siTG9kHL6P+SySWXIFzm+LbNetfr3TiwisRU0WGRPDrPToWsP1PXFJHaIRhtRSE0GVtgcf9UNmMA==
X-YMail-OSG: eh3EeCwVM1kOxzwj9uvxR.g36_h5mRTBG0osEdUVI2ucvwKTbsERhTxSl7EdnVV
 iwjXSgaWW_ft91rhsILjZ86MDnKtwMvVQBDgwJKbhjcYatvS5HBX4d64w_0uxZuHgzGpd1u6Q56t
 2MNmIIhzgrv.AeQ9wJ0F10EN2VoY18aDWWTNy75tX9eUnh7PN6ob80FacIJ7f.BAXLmNSP6PlfBi
 SzyiAVICbNtVATYB1wYjVnLaSPsSW3p0M3IYQBnBC0UdySF2iIYVJi0WYo2bK7obSmdVWY8jvti3
 6nDc4baJXyFLkveD5jIe54AhnQgjYF8cYwFH55zlG8sR1b3mcsm18u3pG.3C9xfR0A5SjGbkkN8u
 mtUSsvSYVQxWh0uDfXH.UOXU1AbaNv.7ARsyPnf6VetSYb41Vd_RQs80g6KC1WQ.0imZ9uOIhpMe
 sNYboDDx3Uyf5ShszshXm_IaOyQV9Tvy5r6b59K67ZQEwFvunoBOUKfYVp81nAocG2mcuwRhYbuR
 ecAyHhzP2m5IcAL4HCBPVug.m31Rj450V8_rkPNb6gCmOIg5L9m5wt1oF16AH.5_Scfl7t4IP2pU
 4NG4gC5dSOJBNXCYYJhuz28GzY7lsXhrdFGVsjAk0lyYQQth72kVeDVURtMmyiBSYpc6CikPE81M
 4nGDSH.N4PQDmKputvMkOmyTsEmSaQUGYUNNMClqE3P_Zc.yEIItFznFJw5WkYpQ2xPLDgkleOPR
 7DH.f7AewcrReHZh8C2Anrg4fcVYOV9NkmUnTwHEEYl2.ok7eVPOai7vZDxVsdYpGXyD9ZwtJkV7
 J8OGPhrGY7QHDoPxqS6VgcfCTfwyMIfapb8WGq_DKiYHO3OBVRaK53ZPOC98a4iUDduGTzdp8gxW
 LKfbyoDGdcxWXvGi4Yod3d_H5AxKlHnEqHKfrMcNKiUtxcgfCBYtLj191n8KFYwqJH9j8eMM4sPO
 89.lm4QX5Fbwsvm7ZQKN5X3FmPzRPAsYXt7PR_4cotdm27xa.HfiNDtbDDbAEKJcX..sysgGMpDF
 GA9KHlRyrw4k09bEc2yVD5.nILOhFo.lKrnk1l7ZQmr8nszOrunvPcthyrfX2TdVk87TL.EDME60
 pZk6oryISAw7x.9nJDOSnbGvdscB2ysP1GhNuovX8jtOcxJ9mux7N3vQkfu7IlFivOWNYwu74qpo
 Z_fI9J7cnNujK0Jv_chHvVHXPxQyObTRBMKYt.EuVEY7gOEcveLM9n3xRqeAdvXjvEygYR3rgUoi
 b_7yrBorsuLIzT4gP54q1eJKHGpQOT_XnYikycdukXDfCIf2U9HW.8t3NmEN0EON2O1OSt9b_M0a
 18GZIt8ViIw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Sat, 25 Jul 2020 23:56:06 +0000
Date:   Sat, 25 Jul 2020 23:56:06 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <bmrsminaa4@gmail.com>
Reply-To: amrsminaabrunel@gmail.com
Message-ID: <2009430043.5047362.1595721366104@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <2009430043.5047362.1595721366104.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101 Firefox/78.0
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
