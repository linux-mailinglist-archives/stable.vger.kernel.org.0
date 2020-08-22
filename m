Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17FD24E757
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 14:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgHVMR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 08:17:29 -0400
Received: from sonic301-2.consmr.mail.bf2.yahoo.com ([74.6.129.41]:45996 "EHLO
        sonic301-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727975AbgHVMR0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Aug 2020 08:17:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598098644; bh=+NKq2YP/4c3bLm2HmGhxa/KCZOXr0NIUKHs/ECuC0yk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=df5O1wYp5zwe9M6b8MDkN/zW0g9pjJD65+beiSaYAkKZ6bVnO9s740fPCvxjRpoSQYuzmd3QE6dPOcajugE0pzrwcv3hPg+zb4tgOwDxaKsTp1/jbhyF0Ghn1WfnLxhXH0aokiod6ohwb8ghP3vOqAJw/uYB2MJixIKrsgNm7VsQ8chbu+Iz7OYxbnXGmPXqvqsWe09yueIt02+tUZqP/FJqtpVauXDni6CHHuymEoW5isP5pV7iqlk3I+POrXv9Zygma+QJkyaB7O0a8OoXgPmZR3/i3moGcqUVKkiWFHn8Qd1IGAuauZfQ4i0Po3um8y4FVengG4zG/PUoTVScBQ==
X-YMail-OSG: oJJfDB4VM1lmAvWrfaXsKHeJGiTN8aKc1dShS0MWitdWu.cyVdo6He1XtkZgWLA
 kZflFKRK9TJLQbhwFyhSL5Qs311LI5139VOsvou04VgIeFEqFfUQJCaOGOcsoecaB_QazK9W7v9g
 JNOda3zuS8EYe79sUsLhrh3ZVLS99zQLEtmxv8CQ7XMAcQeYG6MIfEOT60bYksJnAso4sfYQ_XBr
 P3Jmg3CEfRpi8ej.TAzu3aJWjJrRTYg.2s2NQMqrmPuaaDKflb1vaY_oDyHn65TCHsP8dUfzbXWY
 IMiBY79izLTbmswUkVANTb8FvBCo96HRKT2XoZEkJaRsJgA.pGtVd_tVrmLgV7oTcG.LAkU6lyLQ
 aYYhOyXIu9.TLNHrG69vVppf5A1CavQFN52Txr6O5ozuk5Cg4rLlQK72iYXcJFCDNhV.AYuwQqL_
 u5Zc.lx35gglLr49F57rO19TQhBV01ImYrv4V7nukpyaFtfTguA901jv8wCVAnUuwpsz_IxU3uTg
 vQtMzFBcdCMF216Zd_QxuZhpti_0mfOdFl0b_7Z0Z2IgfZwCrt5WF9IN3kDIYjhtrTk63ofFWKGN
 ntFcmBL0NtMcTiG0p44MkiWvmbOhv0Vce9Tsp9BfvLK1gVPeDyyF5SpQ8jjAbfd1fcHjKuewn7i6
 7y3heU99x9c3h2ApDaG495ZJKSXWUwOkUEWy3O9bignyPnr8KKiYDyk1flj275X7.aojbfKndVuJ
 Hep1PqOKenJQL2RRetce96Z2Oj2p7SP3ldhcAvg3bo97D7vLfbqLhWHIx9KWxYemjsN6ZNNbaz0L
 mK0kahiXIHehP2CzYNtKzSLkdObzcaoFCbb3rFl6eeSK7j9LYOEqmavm610y9dXDiO8IJhqsNvLQ
 VieCHKoVkdfMGLK_2V7GV0kvodB58pMxc8W7uA43VwvLCPmTeyAO6.u9l7zhBc77GDHiutVmW9I8
 IMarwYbVfud2qfxqUUvpS92r958htkQ5NWF0Jc4er5mRtZhgsTWre4.nIoEoviOTrV91XTWMDlWj
 HOS_akTbnCi55mIqb9NDw3XDvKx4_LF3TeA22EBVbSUzPFf3YguUG9NTJj8Mp4Ysp4beyFBQsV.N
 xoJ.uwo3S0BjpkJH350N_W2mO42Qpok6RUNkzzhYx78AOJtyaNHVgxJ9gCcQaLk66RIDw0GSNdo8
 HdiJx9684Z5_BTicYLV4fy.G03vywDla_cue.Wh_ME.m1IxE9bdHLkrAZjrfr6498sBODqZg0.dS
 o9ynuyAs0b558L3T.VqDs.Nq4_JGM7DGhDdxYyrd1ga12ucO54NOVU9b01Z3Dsc7v9tau7HSL6JS
 vsn5ULt0yu2IXsF.hzZEVHpbV01RCq3sLHSnbp4Pp1AyiTEC7FdPBrJ46e69iyL6gU9CcP0w_gPM
 zISt6ET4QvjSE52w6.8nSV7Vh2GtHFvhF5owcYWlM
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.bf2.yahoo.com with HTTP; Sat, 22 Aug 2020 12:17:24 +0000
Date:   Sat, 22 Aug 2020 12:17:20 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrsminaabrunel21@gmail.com>
Reply-To: mrsminaabrunel373@gmail.com
Message-ID: <503334856.4416742.1598098640736@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <503334856.4416742.1598098640736.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16455 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:79.0) Gecko/20100101 Firefox/79.0
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
