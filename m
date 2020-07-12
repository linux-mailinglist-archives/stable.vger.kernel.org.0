Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C866021CAC6
	for <lists+stable@lfdr.de>; Sun, 12 Jul 2020 19:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgGLRjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Jul 2020 13:39:03 -0400
Received: from sonic317-38.consmr.mail.ne1.yahoo.com ([66.163.184.49]:34577
        "EHLO sonic317-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729311AbgGLRjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Jul 2020 13:39:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1594575542; bh=AEu8nK9QzTA2tbqo2l5BVwPShMs+2VsmLoZOZv6b3Lc=; h=Date:From:Reply-To:Subject:References:From:Subject; b=s+pahdZSS/dJSkkEs5F5iExAzoMHVQD6D6+QyWbydYo4bfcQ3X1gmkxSbH4JDqdqXi2S/u+qzNa7bjBNrKmjQsHqxVeKbM+GYa3hs88DwP4MM6W7nSGjZV2upzyjc9t7Th5FP82VfGFVSs5J5b6ZTwdr8sv0rhTn34IyyVmU0nUGDLAttGMthxAyGidJ63VGnKCx7aQ6kFgsIyrzRAZItpBxTILQC98gjBeD9spoXoEFoNqfVuMlVB6NEKgw2Cp7GFacq1s4nJQKaKtJzxBNWRht6PDzs08o6R4GdQD0CBRjBWQ9Z4YO63Vc/HSNEbnJO8OEXRWHjp/mS3577xl2Mw==
X-YMail-OSG: olM7ltQVM1lXjBOtlewgXdRHYPX_BBg0XQUQU_Rc3pKNlhsFzCxMcJx8jJrr5Gt
 biogDNf6LqzgtiaWzFnEAqHX.gtnv1nP9AKiF_hd2J5S9c0qoG64hQfMVf1DmBswUMdJk60otFwr
 oprXyh6bs5Ek6rk6YmME8nHB2zHH_5NqioLEtvK2yMr4R9ziq07L1kaWzEXytkSupIIqKV2hYDIY
 P26aMO5vkswDBVjzomzGdw.QGdKFf8g.WinWIk44sXnPmCkQCSuRR8H2Gci1kFzZCO_CYCyAixUH
 oxFxHko_xRoS5h_bVttQHauk095LIjLe6dr9rhP29IB6xzR8MNvJma4US2ck4FLRCa51AnEPd7VJ
 1Iwg2dEIg_ZIJCSGQyvlRghy82H9yLnGfhWwbst2zLlSE.EuVzB2Ex8hE6hMEAS18P8loqFkHFEE
 LRdZGOt2rsaFcNVaKJGHsI_O4kPOUHOPfBEzn.D2d_drcaI5xUD2TsBC5uNHbZ5AT2oyLDVNfGbj
 CtFAt7nwANQdnfVJapJo764IF6tOcymXtLPsHAi5nPs8k8KgOQHL7H2Bc6Ix61vRtrkqYftDc50b
 Ky5pdQyI16kzlEg8Vd1FvAXTEQGEiWX7Vk_5zW.KQNBPXRZ_5N4n0DSkNEdTCqTPCSElQCPYfQcY
 WFv.H25n42M3XQ70niRgMyGSldwRg73GRz6p59ezhnK5qXbIKXb0bXLKIYDdIYvmZOqhNfdGmjFU
 nnnOfG9p2SQYyoAVp0EfCAgoU.KKM6lyKgUwTIAAMN6Au.gSXOcOwN9PUWCj1eeAZz5lNSoWq1.0
 UbADSYJMsvMGSZXmA.nmmy3b3lJCfwHaKrijdtyZjX7VlU6o4SN5q2FKYy4Yhat3rIUmFtYmtCQA
 l8374i.7yOf7q8sCGMH.TsfqWiOVeGt_r.NqCN17Kr87Y61BMVJVX7rfOC6r.bRyofp6Qxqnz.M8
 3luL5a2xneZiIXrklWfAg6MSkQ6MF0V9cyR4cJNY6ynPYnZXTdYTlw15H4xvbtrl8IrArpcR.bjn
 T5diQFp8bsy_EUkjf108D04U2KOoUyMJ8SOcrSuSMFFWJbCgW5TycyJQx5pJC3C9CjT016WLiyLz
 JOx8fpZevLKNA.3oGbQdErFnIucAyfcm1_5etBgmXtPMoGA6kSyOxPyCsxV9IjaC1Slw5xo_rhjk
 zQavOgH8YBdnb.Rb4DzCr8JnimOcgx4fSF37f0hQ2hkrvuDChPojTTm.ZWB0LNeSQzckl098vnzQ
 VIDZmQKPziEYfO8QIcHUjJt_rjvf4rFvTLqj17qiPb1CL8htLrCN7XpcNzwi4fgi16Q--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Sun, 12 Jul 2020 17:39:02 +0000
Date:   Sun, 12 Jul 2020 17:38:57 +0000 (UTC)
From:   "Mrs. Maureen Hinckley" <mau56@hgvt.in>
Reply-To: maurhinck8@gmail.com
Message-ID: <368984903.464034.1594575537802@mail.yahoo.com>
Subject: RE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <368984903.464034.1594575537802.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



I am Maureen Hinckley and my foundation is donating (Five hundred and fifty=
 thousand USD) to you. Contact us via my email at (maurhinck8@gmail.com) fo=
r further details.

Best Regards,
Mrs. Maureen Hinckley,
Copyright =C2=A92020 The Maureen Hinckley Foundation All Rights Reserved.
