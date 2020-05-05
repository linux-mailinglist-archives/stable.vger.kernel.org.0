Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408D81C5C88
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 17:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730251AbgEEPul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 11:50:41 -0400
Received: from sonic317-32.consmr.mail.ne1.yahoo.com ([66.163.184.43]:36486
        "EHLO sonic317-32.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729516AbgEEPuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 11:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1588693839; bh=+NKq2YP/4c3bLm2HmGhxa/KCZOXr0NIUKHs/ECuC0yk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=XeckbLYFLESY2/ClhkzF05PQnGmGoYBDhbiQf29lzxkZFDoHs3lfZozcCMvDpCiABPvHPZTPwtz67w/9fuK24GqqBv3teMUuvYkjgZ82nvZA2uvDSct3I4b05aoPtktdvrV6Nj8QPxtu3ymkXfHIX8RkIVKdqat+ekoysudDSUH+x6HcaZrqaZHA2Qp57p11H+NHPiQPNZ1ROGX5HYPjk8nCz+Hk+zp5n+/J33Mv20wUdkn3XaBpYT1gb/DyE7nZ7c2WOOawboDn1LhFkomxdt52oHayJ5BXFsEBbdTJcNHSSeIIRLU8eC6StkHcVP7AFAfrofTIDlLm2Dd/kr4+GQ==
X-YMail-OSG: XnYkUUEVM1le3keDa3ZcFeKFJ7hlq2rV2fDTWz1wHa0lcAZr_eOGcDc5BFI4R3R
 9Le.d4AyxBUAdXQZzBH4ukoAH8LUJJADdovVZbgCYByLJuJXrrdkAWfYUckwUD8LzQzajjKpdrPp
 pnWyw06dzyH.sFEyWCxLwXGjswqb8WgwGGj.70pdPKItXUMYWBw5AmZ2ZTUUGJG_07b27HvRASXy
 SkgAlTryRR3pGzlWWtGt2ScfrOnp3jPv2YKVy2JQBgtv09x8HWXYst_0KBbSSap42TB19IR8OVwa
 ehQsU2_DUpqzTPlfeS6UFZL86xZYgKYxUfFvTaW1bkLoNEr4JxCFF3KlBs9U.UWsZnNdMR083flT
 5Qr5GHCnqI33GxiCnpRnUzN6cYOqtaMWCuYICeeaybazhD8ByBoUb6mdGGQ9kUsn_ppZD0HCmfiu
 13DuqavN33C60I4am8nBYGrLOZsyAhWtXOW07tP3dZp_BfkzNU.iqmpbhGSPbdryqmIxe0Uj5M8Y
 h._hmdz6iF2TjHh_VvEt2ymoMrRy2CsAPQd_y92aM.6PyrILpFZeTROle8AnJDX25tShNgE0GyGe
 endnJL7vrvB6Y19AyUchnU2uMblNr627cDMbIV9iwify_ix364SrNuaHZO2do8p21Ho4Uip8O5mw
 gAGkOnrJZ.pbqUjXfR95L2I0xR6h9b9l51jXs7_9dMg1TNuL_hmV_JFPrym.FXGuQWc1kFHoAfVY
 UZmOhSHnDKMEJy5g37OtP9O34wo1_JMXFnELN2OEUJZLQ7Yr3CSEcs9aboT9G1v__NCJow2YTbT6
 RjDDYlULBzbWKd9hrIz2EWMFtx3CjpSyDCd3KF.Gr1tkpdGqStzt5r7AxbLVKDPNwfY0d8AEsN_q
 Ynl7E3mLHRz5.Q0zGKs58plKlT6u45oQqEI7vSglDnhZT2S8qs4OIhpO6hsIpUE_CdhoIgAYmaV4
 1sLrfxOXxOGI8QMUYUWqfYfOLIZuCEl13fmXIgCRm_ZyLNyixmow9V2aeJ38Uc_OBDKz9wRtEXkV
 BAlKbRjPg2XagerV6US2VIK6t_Lw59M9xGRBdGbqWZgzktNfGxgCdo0nrK.eSKUFLRmDf.m9Pmfg
 L47blin9H5gi5yS0GEwdgT_19ZCq2pizie9ciGt8aoHZUhdKX8tcmeq5MkR9BcV9WrYQQMnsNJHj
 1nJWn8hgZJsZtAPJn5uxb4tskD2TDG9fKW5J8xaU.zuFcbBEzwKV.Tq8iSHm5hOV6_8N_sZvjDRB
 dG9Nnb_0gfO_9Sdd62bAqtbazIvdWx1wgx23axGeeOE3P6ygkuONnvUMtbu2ld3tQhX20
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Tue, 5 May 2020 15:50:39 +0000
Date:   Tue, 5 May 2020 15:50:35 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrs.mainaabrunel126@gmail.com>
Reply-To: mrs.minaabrunel30@gmail.com
Message-ID: <677767966.1603621.1588693835581@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <677767966.1603621.1588693835581.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15756 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0
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
