Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30481C2735
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 19:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgEBRSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 13:18:07 -0400
Received: from sonic313-21.consmr.mail.ir2.yahoo.com ([77.238.179.188]:37840
        "EHLO sonic313-21.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728419AbgEBRSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 May 2020 13:18:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1588439884; bh=+NKq2YP/4c3bLm2HmGhxa/KCZOXr0NIUKHs/ECuC0yk=; h=Date:From:Reply-To:Subject:References:From:Subject; b=qBP2lcjSr8q7TgpLQLiuz97xVGP2/Z7qiZFuoll9UYBZPqQEGCmI5TYmRsjDebluGFxObWhzJDJwtqv8TrEl924CRjX9djR9BsSdvJHBdX5r5IoYws7c1VfnEwTxxuRsB+XqLaFU6s3HP6p5xag9pFos8eJSZzQd+grUoXUMaUxHtr/oSucTp7Wqfr6gvvwwuCOYNfUd7piYH9vTUXlSrCGyDMdfzeRk3rCAPRxsOOpWAE+XKFkVtWqbM7PAtLOmgKxdmu8nKQwcQw1UPbDwWFDr09OGlswiTs6JQakIArYjAptSX8ceMxTpsP1cTiXZ+BHacRDnP//xrxww5JTSsQ==
X-YMail-OSG: 2ZbRMtcVM1nsAfGKsl6cKABpw5JZCCLY9VCQTJDTj_j2nR5wZQaONxBw7xVqyPo
 n377WWssMESuxsLR4RyuYV7ja6Xr4T.SvXMHSSSVpmF_QR.BW.5CgH8oGlCs8ECSC35OpTU3uWPb
 HwOxpsPe5m9qld6Gg8vhmg9UQ668SbIYkvtoTjTFkMKcJ15M9AvbVxlMF.Kud2iX5hSEWjds75Gj
 VBxoe5dWa9hJ7J6IgaL_2tuogM92jM.LxFQWotObxO833anoUlkg.gHaWtzbUotaCDh1pC6V9_um
 U7sVUy2HNQ3lgWXt5WgTGNOdO5vkNimQ4xDPeVkiLZ3P_tIiU1rIK6aOlDznbWHPpkVX8jURwBIN
 c11DtbtPlevp4BRTJr2egwFUo9Xjt1VeqoeKzAizl4i_zJ4bSVq5R3Izm1xh6AKUmv9q4VSpvj3u
 GkdR8oXgVCHVnEkEWws87xDV1tLKHmavaX9vonm_txawplevwe3EQ6nGlUHLzbxJYQsmzr5Rhs4H
 m.uZCglC2_vvVlJCyLqn.HrA5f0UQqEg5vXKp05JqJRF4opOijJ6JHQbkr2RiyQ9m9PUfpY2yMpj
 86T8He8j0Susl_Ib0DBhbJLBicI8LAih3vt21xL8sKKmROPZ4mxKS_zH0vqEwJH1G2ROu0Qqm2G9
 6H9f3xlFxo5pPXW8qW1Pb58F_mGol_1MZkoJ.oOAaecrL0637sZ6kfOSuE7r8HhxP0ys7tCfw5hU
 gqx54BbPnfy7oZmfhf6jXcd5DlxRiwbNbYyspbWK81eGJcH.6v2whDP0lGNPvfVVcy.X.TuK_fFX
 zYVyQDxfdVlmBwr53gYW.XrGzBzuh3Xh8uVEKvMgSemZ5EWEtZetiCySWaQo.2mVKMRCTRCDl6gO
 P0Nj5wn1kZYxeNmtDUa440oZm1P0tEcUJ19N2WliHWuDwXIQZMLspxLQQOVWwtNh_uUkeRDcz4vy
 IyDDe2E0HKxmS86Fg1ulrTk7cHWQNYCyofSlmzGaruPORxHMme5n_BHa7VivCjCsLtz1Y6eReaLw
 zXOUpOyECNOvzxJ40f5E9JlfqaxiicdqJDWM_MkV11kyLXv6VOkrWcN9d9Ro5Ysk_Tuo4gkw88TW
 zdhnGQJ81IS7COSXYyaxc6VNCA2iMqC1BzYzsCj_WvNqpwnrzVE1FFWuFczSu6AIDkB3tuXzB73j
 TOIE60LYAvFYRlxSBIkJwrwBdkwCsUYn8vkdGkLpZgcN_isPIDR0K2X7FFob1yQolG8vs5zWmmtp
 rOhCtsJSexPpnl49pYTq.EzlmtZwyPY2GuBY0T92wa.eKp.9cMb_DqX3.QRQFMpsr7OSinGk1g1g
 DtAJbC3.k1jI-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ir2.yahoo.com with HTTP; Sat, 2 May 2020 17:18:04 +0000
Date:   Sat, 2 May 2020 17:18:01 +0000 (UTC)
From:   "Mrs. Mina A. Brunel" <mrs.minaabrunel209@gmail.com>
Reply-To: mrs.minaabrunel30@gmail.com
Message-ID: <570800982.467049.1588439881918@mail.yahoo.com>
Subject: My Dear in the lord
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <570800982.467049.1588439881918.ref@mail.yahoo.com>
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
