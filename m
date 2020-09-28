Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E7627B149
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 17:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgI1P7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 11:59:03 -0400
Received: from sonic313-13.consmr.mail.bf2.yahoo.com ([74.6.133.123]:35473
        "EHLO sonic313-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726497AbgI1P7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 11:59:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1601308742; bh=4GgFxXkhC86dj48BmrELV5zlxicqlhhIXyZgiwEolDI=; h=Date:From:Reply-To:Subject:References:From:Subject; b=aC/W8KgjQEm/E3oGNTmcGxDGkLN2HuJ7RDH4ZMalwp+x7r6UbfCc/VEOwqXEKsv7I4udQY4TwSya5GF8DRj05abe+jAIPqW7Z/wue30J3fLy4TtFfuugluXImuCmkHpZHLbvuN/Rtv00uhHPx0cQWeNiQPkqmA2rbVdNcCfcH7ebIH5sAN6iY1NQTzBnjRpl7FFU7a+PZPlPeOJCE4Y4bLfAN132pJeapSzV6wAMxMngiSVXmO4Fgb+fVR9c0MGBWdZibTUiP81rqJ9NJ+FoWsnKdM/eNIi62tpIcngTsqFnPQc600VyNWGhgPqc9KxWaHUgQBLfypRh38jxNgx7Og==
X-YMail-OSG: b4Zo7PIVM1lizVoEuuJZJ3_dibvl0M_RJGj13Z01W38NwFAfFLoM2N9Sk7ngM18
 yTKsaN0gO_XZWWx4kTx0z2RYrIZL7ZeTaqIYxhmigkDHleUq9_1DOu8uwuamils253qcagLSMLqt
 AOAVU2XhzNsq2BV54ehCgrUdgPlGthvNJGVXFs.Jzh44nd0rcPXfCHQE_Qc_2X.fANOUGBKVXMVn
 ftJmE7oSnosVrJhfQXOo0C03VF_MLu1NnBTNieNFQ.AHsNx1USWLDVUPOfJE6_kxM7HxdgvF7f_n
 kS9kDF6Am4jmGixcEeIO.pRkwNw3Ue9TKh2Qj9E.mpE5L_YcpWP8Le1kIsJMIU30OoaelEI7NbRl
 0mgpCiXMH1sLpGCxbTo5IWFMqdEdzbHOuI0NLRNcj9wG25g0AYG.yyrV3Jg71QA2CEbqrtHyjnrC
 Yzfor9J2McTZNl1lVGp5KaBRed0R_Fml4HFxniywX0837I5Eam8BBgoYKpk0_iGrauGV1b1GgrFB
 ZXGyxpPiWqIerhTqGoXgziieKdfL_E_uYsbl8oZVJMrmDoPjRpsrJmh7cTK_E4nb4fb9LEaJEoLQ
 CgG1YoEJPJ9yzzD6L6Vy.b6Mycdlxo5Kp589LkWa1pZFo8OYwbRn3GnHEHCsggplL55OO0EjwZ4c
 E2I3PSpM7A5QhRwAJwwBiMumh5Qoj8Zkilj3fO6LAyDKXmMPzgi_e6SNOkdtWwbdXkFno6ATaEBl
 NkRDhJb40ZgAeNHcFwyq5yy3hnVegDVO5cfII5y1nlNHxuk1_.dFQ.Y0mYrc09cvZDjGMa4yXXyg
 e60i2aPGnrgdiWDw3FqmbHsfS9xJyP4N1Rvq.Xsi2kIfnQRkDxQwYpt2mTXZX_pv7rI.yXDWk8qY
 mX.g.cLziNdT1EujlfbQ4_yq.vyO4jGXLaydolSeEvhyKnqef_gt5pBdFxvWjoPWbDaDdfth5n.O
 0go1vPq4YmURizdpA1NmMKNLcNL2z.ZSa5hKXWS7RpXnMR3Gckfge3YZMT5VMZRcaCu_1oFwLWHA
 3XOyC7yGDC4CjFAhiB9WfoLn1Gq0JZ6NhH_4aQQRDsQf1kZNhz98nmX4ZAi6Lh.flE9wfqb_J.k_
 yqJH1k6tmlxduU.NE2LRThd6piKPDiLQBZTPUygD.UPPu6oZHGnPL2q9wUqpfyvCODEFHd58FG2m
 dfNKMmLkoJLj2Ywz4TGyMEo6B.Q6uM01ss016j3pgrjCLSzCiG7vth.5kK9KvwrvjFUpRPaNW3K5
 rZPkLz6Q1XjMlXxHO4kscYkrHK1P1Krd412AUVYIdF3_RfywHIFhacGkc6YnJMimi1zV9cdRAErO
 WLGBPMzKp1O8Qu54WiD8xITEQN9it6qCacYUmRl4xfOfIE1Mue5Y_mXMA0F78FvVzheZX6EzjRJJ
 4Yov4pgqPOBRCuR3wmxrHb4vQ9b_Wf4069Pb8
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.bf2.yahoo.com with HTTP; Mon, 28 Sep 2020 15:59:02 +0000
Date:   Mon, 28 Sep 2020 15:59:00 +0000 (UTC)
From:   Zeena Hamad <zeena.hamad121@aol.com>
Reply-To: zeenahamad@aol.com
Message-ID: <518343691.1501211.1601308740787@mail.yahoo.com>
Subject: Hello Dear.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <518343691.1501211.1601308740787.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16674 YMailNodin Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear,

How are you today, I hope you are doing great. It is my great pleasure
to contact you and i hope you don't mind, I was just surfing through
the Internet search when I found your email address, I want to make a
new and special friend, I hope you don't mind.

My name is Zeena Hamad, I am from the South Sudan but presently
I live in a mission house in Burkina Faso and I will give you pictures
and details of me as soon as I hear from you.

Bye

Zeena Hamad
