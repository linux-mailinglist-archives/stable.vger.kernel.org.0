Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7FE91D3033
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 14:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgENMqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 08:46:18 -0400
Received: from sonic305-21.consmr.mail.ne1.yahoo.com ([66.163.185.147]:40786
        "EHLO sonic305-21.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726037AbgENMqS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 08:46:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1589460377; bh=+NKq2YP/4c3bLm2HmGhxa/KCZOXr0NIUKHs/ECuC0yk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=FGrd93FwKvkMEAfo2ya0gPZpz4EYdjLcl1jxv08SgSFsVCAVQp4gEDczvk//wPeOLcy8A9wltPVg6ItIGb2/OhSFkGVavZo9328oW1TyCv7Tf5ynoLZP741i0Te5yz3SJtgcVFelJ8ESV4cTSx8Grx2PPrmP66HrqDKBuHKKWXPmwnQXMxapJlH0piD6pGJGOoyEoXDMk2B1acITIyaX97NxCsAlJJxzxqIjKOv9x2Ka5mwSQBKSELpqnDuBtrALxVYTaubqFGSeq3ZO+ThbhRayNIHBW3FmMlun/rlwFK/izw4+JL6o61lMVqAcw1qV3r65c6YO6/MGFcaNOdB7rg==
X-YMail-OSG: NFjme_UVM1ma33R8Jk204u6oTWI2ggTQRkToFfsC8JiBSwQXvFJ9jFnu0eC2bmv
 1EXlk_BrDi7qQgGnBWdnuAaNm3IGjjvOXqxB2ntKlGHW39YeQlDx1vyg9gpKFGpcQiXqjSsQVCZz
 AJSw35oU3IoOyt5B6aFIzL9unx6Oc8oJpCvF85IkLrlNuXOFSPqP_13az4dfjQWqjrq_cs.QC92D
 9.r9YO74rN5.czjOncnKsrMgDOfp_bmLGsnhoizBDJgs26UKzmxjpH7JNDaOO_nSQuzk5VKOxswg
 fbcaDfBgkDDbRuHoXG0KkZUdivnefBjkcqpY0ImK_GRnEbz9d1ljqeYakfBRko1hrwraPocn9mgm
 GDGtV3alXzmorJBiC7MVrdx07hvBddDCaZ1VlymjEUm.gUXvA7JyoGRZNPDPEtxLn248A8QIIQi6
 fCc9NW5mKA7ipwISOui2lQhmIKK36Mdrr_ZH6ldnpkoZvChmGFThh0blKP4Egx0RyZk451Eu_OsF
 fjeQF3tIuxoud.ld8CrSyUwaFzbG_sXL_IFzqhnFU_H2zK8WVrvIfwuTHvWxzwV7D6Flog2VE6gU
 uIoflECcsWsMj3_oOvzXOsBflaM_4Y3DkEGRFUvzwAR4Jm2yFChEPHiEUsFZes7NC29nMI8Tb6fe
 RnAl0roYYxx4fVx0NUrjOeku6i8iIRqS1HWBc7FEDw7j0xk5znHWK84GmOqOcL7gPMWftNY2NXma
 8i0x82howSVNmn_R4nG82wu.09uhYi686xdwyRa51hapnfeBosUcNotBjvBg8Bs6o13Qfvl2KeMr
 zcgvYJxY8vj8E6Q8XU_7TBOXInQBBkT0W6oBdAws.ZRyniUC74DvG9oQ0.4O_gUuPwn6vzj7QsRb
 KI45x0B11SHhMKTPMRWHxgsHbX_RXFDlvBsSNpXG_2R4V8ipNgNulXp7GkDSVgx15Bbe4lNNXM9C
 Au4fVPrgPpWetp_DFaQmIoU8C3wbB9Vnz9tmwmYFkscRysv0ixMUteMeUsWuJ89DA3FCBqYFtDEm
 cdsssTCIUIaAdZNi5RdGkXSJRwPtIDzU0wcR.l92BwMMvIniEYWs_BCi0FlX7g4dRAGlXSjvCGSt
 eon6HO4MkR262ZXYAzIheXQ3TGAZTzhcMObaROVRR66ji.d7dn5vyaTZ5P9R3pHite_bQujBj2hy
 X0Q1C1YVwMjvSNSFO.77i276vP4a5VqAt1fleD5NiFV009xNVIFpl85ChIvttKjc.WC16ZmcNr98
 AD55KRhPem6r9xNMeL.khyJOYU9XYMBF_P19.Gp7fY6hHeXxL0R5HrmGAXQNQDooiEAxE_D.oSHi
 .7Q--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ne1.yahoo.com with HTTP; Thu, 14 May 2020 12:46:17 +0000
Date:   Thu, 14 May 2020 12:46:17 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrs.minaabrunel209@gmail.com>
Reply-To: mrs.minaabrunel30@gmail.com
Message-ID: <128063437.104418.1589460377514@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <128063437.104418.1589460377514.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15941 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:76.0) Gecko/20100101 Firefox/76.0
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
