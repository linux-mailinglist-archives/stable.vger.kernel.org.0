Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1FD267AF3
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 16:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbgILOiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 10:38:00 -0400
Received: from sonic312-23.consmr.mail.ne1.yahoo.com ([66.163.191.204]:35955
        "EHLO sonic312-23.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbgILOhY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Sep 2020 10:37:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1599921443; bh=DPYuw2gUpgtMJzJhlH/AVmRGu2wSKCY1C+f8nOCoxu0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=Zqzx6k+wEXSDklolrl4PyfjSe0Jlsfke3ETxPkfyl8mNFtibASVYExGcc/ZprlUcL3rx5Jm/R7ylALnALDLaCOc2S4cFa82A0OOMsLAD02abXwXRUI5BnzJnY45bwQH4eCMC6wgPPV6IP1VGEw9kxjIEbjG1Zw+GYJzkYw5f1nbcgSu/jzD/WMSTpCFbp57SducilqLDCdZSPc+TxPquls7LiU36cop/LHaGH9ilQ53IaAHFESDLKMHH2u3Jc62x/KRPcMLrwdLlCFXsCNzjmGwQRUgzbD4QxwwbCCcDMAJv59ehNzaE+M4V5GAHhA0xuaj5Vc3U6bzsxM+9ql5aZw==
X-YMail-OSG: lvfoKWEVM1k84KG_XH_YAdRyf9tTnvoTfeoVBiUBSleRbf7mU_C9r1airxK6f8Y
 SFxJ0OnfS2TnWQlk7KN9Wsl.m.QEwMh4SYNSWm_6fDP3cp2X9QK6X2dGgJfj207vrCf4TD7CFx4s
 5WjX4wivBhTX4k5tesoq1oNWRRsDU_HGbDXyDmfdTPC8uIVOGNeJifh.inTk9Lnu_KyyYFv4UmWw
 ospooJcbqB5VVso2uaAIMOeTU3tWfOcuFo0oQq.02ybyM3qZL3nc1g6DET68YOZZnS5lxuEtznMR
 1XGSBvQHMINsW9XGszvq.h6GCIuApaODlkGnyDMYYKpgsg2ezdYXhD3N2LOQ.EVH3yKFDq68pfBW
 _XlNHWFRYhfPlVapMmt9Vsf0ntEM3ttlNcizxvL2yBqQ3jqHYTDJDCQJ5STaLeVDJlJ6hD2lrv_B
 KxHdLCeo8_FQVF6ER5gdZVV0kugwc.5LzlTaYnKOyAbc4EHg1htlK0qmsV2xgtEDdfdvsUL9cvMk
 JZQny5gI7RJ1YqageZOd_G6L4juaG4Ccrbacce1XYLPZlFIJzJUFkQ4CKK4CcrgAyRqDrXs5iSTE
 lwjQFHQLvWzJrlI3sGlWTlqnggbWCDjw0TuwFc7FcUsEqPV_Y6iVwH03FGSJyfUQPruMFzPElpQ5
 T0QVcOJ4cykgRV_Pn5v5xFgTtP0etZH0Ukl6VCai4oDZzSmNV7to1flIdfVw2t8uLQ4G49xOlYxK
 T0N_lhB1UHttvz0dbL9l_EUz3mER06O.3Jc.xY.6SRhnLCq1cYnx3NLElNr5pGzO0wU1HnUBC5An
 XGWtItIcNBI7RFuZaHL757.DU9uUChn_kECUUc1Ck8mglTyida1To34T4Hrx6kMVnMSss6Liomab
 4Xu47qGvugzyWJzOrgHrSLmWhLY1qC5.ScpGJPSLP2I2ID7dVVh7OmhuhBHkJtW5toT1OfZ4qOoj
 Eq9gs5g3jPTDd4BgWJjdsB8T1QKClarNUX8R2Zn5UnjPEJS5cb2pd.qcVVSXoHmQ5ySKhu6qd8eE
 Z0yQXVng2deClxDGUdiPiMexgwZf1Wvkhb8BhLPt7KpfHSZnbwZYhbAlzT6.6zDZdUIO1FO86rCj
 9fC.CKVuNCIbR_2q0ZvXBpyM20kfZCeqJIgJkFciEoARAsevcVk3WfWJcccniJ69g5aNngOqCE9K
 .k37GJDGd0WyN.JyQ.pzTMkOW3QGngO_u7uQcESxtI3H_RRhMA1YdCxqp1v2elrkQC5CXQVE103R
 x.B7DlIO92AhXtQJjfJmLDKh6xWhJgIa8WVy5IW6XkISL5dOkgi5Ia5KCDTx1x.YoKdXN4wrvRHn
 3X5xvFJZHqElB38.U_aN_P1IXcUNAhP7SZBvPZPxlksgEaIxpEOswWCn58Sbriigv0NQM9.Wetm7
 VnUXopoLKa8WLc2xelpbPO4bdt0mjdpKfZgYSsTKULys4dnrSJA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.ne1.yahoo.com with HTTP; Sat, 12 Sep 2020 14:37:23 +0000
Date:   Sat, 12 Sep 2020 14:37:19 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <brunelminaa2@gmail.com>
Reply-To: mrsminaabrunel7@gmail.com
Message-ID: <618514927.1518164.1599921439413@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <618514927.1518164.1599921439413.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16583 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36
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
