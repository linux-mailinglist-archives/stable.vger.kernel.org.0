Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599341C7614
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 18:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgEFQSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 12:18:13 -0400
Received: from sonic310-24.consmr.mail.ne1.yahoo.com ([66.163.186.205]:39457
        "EHLO sonic310-24.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729479AbgEFQSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 12:18:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1588781892; bh=+NKq2YP/4c3bLm2HmGhxa/KCZOXr0NIUKHs/ECuC0yk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=ft5PkWMl17ue89Yf6+JsWFiGyrVC5JLzK0gAwmNtdODFBkPqX0Cw4jxNq/Xy4S+vLQxTVyCteoCvLJ9RnludXFSHZsDEfMlayG+W0MyttCHn3gEBevY0zJj8AG/b0sSQU2ztg+76P9sfqJrcmcItUbq5aJd8D18oWVHU9MSLST9AkFAJb3HPm17TeD6/4hBEq+1aG6RS7MKZVYEC8sUfcdbnmz1YDqdEdw20jR8PxXvrYn72ceF7xYXBChEU5R8ChAgG1H03yGgQVEl6VTV4KTqlig0fLcjWGy2e7ujTRFCzz8FQFtnbGCh2V2N6ej7pJQ55PNVL8aBDRwcUopmnQQ==
X-YMail-OSG: OO1O0lAVM1lwwMPIyRpnNj1seDHGXckr1jgkOigIyamE6xNFqVLYjaY0BurFOa4
 unO5JEQOKwj7wMIFGkAkK0ia5WDcRDZXULwIQCz9jWm1rpPyt2xu1eYkjVVOiRbWiX9fox.fOaV6
 vrY8oY9pVRBNbgv59HNS_3c2CKe0y1506DA4XOAqbn.W1YilzUi8nI1Ussy.pestC35ZJAwezs1N
 Axw3BggVBxUw0yhDjYwoyUJaNoehaRXFBDgrcrwvqC_tfXfAeDa3cMw7aVAVUd8.jEb.1v7SDOEz
 10NwNnDO6MSGDC.xtmZnMpaVhyHlHpfJ5wbzZOJbaoXLdOIOKGYHo1zA7nydobpVacN3n906UUVx
 IKITo00rftGStf8bmL06hXjlfY6Spe6009duo0atcIkVM24YB01C3AK.ctP3DJrP2GHtqy._tkkG
 Bm2nsFw0jX3S_xpz9UnXFKYNAhn7xmf.dj6MrdQCjFc48hioaYW0YvvHWJxVFARNvNrf0kqf7DBH
 wvpLfeIa5zngs4Jc6LU4UlfXKaFcaOkyCmBLm_3ikAxt4AzCCSHQJFG5sYKSQgAnKyny938NlhHM
 RmBMmEGla8.XlkfoVQCyajtRaMkfGv8Yz3WJq0cR7MjTCdDIQU0ziNcFo3W5B.cISu13aaFQfPHj
 oQRlpgJ3h67l81o6LfMuNYEicWOEGig5Q8lXayy3rxZCkRO6sS9gHWShaKeGWCfAIqc7MkJ08HEr
 vtxfQWIhl_f.xs9avZP7cVuVfvY1Xm2zExJBKs7KdJ07S4lI.FSqEhE5ZHNtJxY6ID8IkXwCqv29
 XS.ftUhXT5m77UC77WfYisdyOYDdXph8eeURQKbVZcnAFcDEhn9BXcgHae0umtyapzTOpRkXJyKw
 BWA3NIvBzXf4aPKg_mdtM2ttfeWKjLNGnYsxNXv45Nqm.3_jZTXKYuDSCvjxcNhce3MamCCuRAbk
 86qSpNnHaW4XJ5nP7ItKTSx08ojisry3TVoQw.zew1mxaC54gUKt_vAnqPxHUpp1Q8NWrlJQiwx7
 7WAt_tRm7ZDotLBfmH0KZ489O0wirldvl40Yubs5aLOf8kziHyFSD7xBGTnFOQe___dxm2m0q0ck
 MawMIlpfHV34IWhwUMb4M8E57YNQEV7neB_PjWp4YU2XsCZl5rUPzcXRAAOffT7vrQyKIdfkvZWz
 JKcXW93ZYC4nLJkwTbGcp7LDGHWXYv3.UKcLAAdh8lWQyEIYZ3fqptOanJ3gz9tWlzV0LfQVm8yD
 N.R6Fb85Bb4WLoKynnMBd6gdYnKutQYRgprjevqUwVkYOftehA3_BH1oZY12EYIZXvGjqO.LO9g-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic310.consmr.mail.ne1.yahoo.com with HTTP; Wed, 6 May 2020 16:18:12 +0000
Date:   Wed, 6 May 2020 16:18:06 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrs.minaabrunel209@gmail.com>
Reply-To: mrs.minaabrunel30@gmail.com
Message-ID: <1132585358.2245311.1588781886890@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1132585358.2245311.1588781886890.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15756 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:76.0) Gecko/20100101 Firefox/76.0
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
