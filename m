Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D412177694
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 14:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbgCCNDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 08:03:01 -0500
Received: from sonic302-2.consmr.mail.bf2.yahoo.com ([74.6.135.41]:46681 "EHLO
        sonic302-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729157AbgCCNDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 08:03:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1583240578; bh=6u3qDl6yXWBH9oVBF6VmNFaXPPfmaUEmS0LDo6+oXlw=; h=Date:From:Reply-To:Subject:References:From:Subject; b=aFgTCMfoZTL530RNdww+G999yvlc5uMrmgviNF3OolnkUNrFf278IJhG0f6d220d9/hw7JTz6bs0nCmgCmiJVecBE33+1DDiUT45SQeS4FxcOsE6eXtPx6xahGUSzZ2sRAvRDNg1cHLZ5GESqknzzUHTVY69Eejthc+O54AHIsGc3Kg5DdiAIn+SJAkyQJYK89dp6voGSL7trlXeTajoKOPArC//jI/ksGxDKPaVO7nKy+2oohHWi1b+CsmfHExn9T2T+71WxyzKRhlXob44s/mxvrxGgvwTvWihMCgfaFGgdwNtBCuuc1I36+z2F8T6RSUZWdQNc2btXc+pGnMzAw==
X-YMail-OSG: wPZFc80VM1kkSLCbzuTZNOsHwL2Lv86F7iyC2WlWPAfZX_BgQyY4AXTa7Ehzp1s
 2vO3wvKkqkOJHpWxdgboMG4iKEhOkEedekLMWYCyO6l3PeXyp7TA3ywPQpoJucu6i7o33lkaOYsN
 DfyNZzOFX4PysuY1.pPNAWuNASxj3w8TN7ioEWp6FO2qvzwwZdnP3HOLamtoV46W56MXIg2mwlfR
 6seaTBCUaL.ugsd40cVqyil2DU66F8CZIUwrrtY9Tcz5IinzDr.suUoalGn95DaKKfbeU9cKKs4W
 NuHk1Oyq6.VZU4DbGJXblVwleDAPFfqV9XTLb7TEF_PT01O3JunIUkYxnNsS7PBMRwCrfFSVrsVJ
 WQsMbsprGBrZ.gp7TK0pER4pIGOR02c4EOGdWiJjrwtZVHcucjvXom4SR0MYGS63A21IAT89HMGO
 IVV4dK3w3uqZT6EzMdm4Q60BVmNpSjBfNXw6jkX2kQ3wlwfg18iXNdhF1pDf1hc7cjUA2iJ2_dL0
 qFsT.mYWQ9zHueGJjewRjB_giC01wdNGSH9GbxjKhgSZsY5bvNTcXlS4mxIBFE4e_8ew9S2A808E
 PJCPKzFx8qwEQIHFbPOUn_GynoFFofLDpnmRow.QuvYQhCjkxAWc4TBHDdQ2OENAgBDyyTXPkPzE
 1u7YgJmb0Bx66pPBgkII7b49GXPenxphhdn7AHvIfkQ1bFId_utfwduqKu9quaAkPqmVZ.EP2qSM
 aD97342CeUH06i4Rf22aUdR79efwhl3.zMZcI9MXPVAhOtTE.1ooRhLQzndSH1sVFlOugZzCjxG4
 OmxPZ1aCArbpqGTHHnKZ9jHtmv9S6vxRB2IzUqNAjJryJSGdkSa3Lup6NhqcbdGmQ1yP8e7rIwPH
 k0Iv9oIq4CXK3t7YdhBbWY8f82qyGH_oYHVSchwWYU31_7HkZXcJqyfQ5cbvQLTZwlC1TeCCAix_
 8qRNjugr1tyOcQbdM1eEA30_RZkYrf6nOeySvJTcKyCCuUdvsNWHsuh53EgqtafjxP2um0009LKl
 VIMusuLTQb4_fqdPbJXRCK0I.UIHlbAs9MAdli7nL_PE03d0kYUyDv2OO8a7V_3zYb7g5W6x4LWN
 MsoUIsSDWf.gq_2jaXMFcW9j2ADXwcJYRtrlDFRk1Q_zerEBVtr1I1MwhRwktH2ze9NXgkQ6wQxy
 GmjgDm2Rv.9RUryAB.2.BvG_mIhf6.lEr2pEx8uYw9gwnzXa_kvPvfz9fBnfbjA0DkDaVstjZQ2Y
 cePN.YzZNwm.1wR8G4.5C2VsuUWS9PJsP0RYMibVxbIUaOj56WPka.hPqwCzj6MGR8oBgvF1UcA-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.bf2.yahoo.com with HTTP; Tue, 3 Mar 2020 13:02:58 +0000
Date:   Tue, 3 Mar 2020 13:02:57 +0000 (UTC)
From:   Ms Lisa Hugh <lisa.hugh222@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <1855020851.2510146.1583240577164@mail.yahoo.com>
Subject: BUSINESS CO-OPERATION.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1855020851.2510146.1583240577164.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15302 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:73.0) Gecko/20100101 Firefox/73.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

I am Ms Lisa Hugh work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment and the amount is (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me after success.

Note/ 50% for you why 50% for me after success of the transfer to your bank account.

Below information is what i need from you so will can be reaching each other .

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa Hugh
