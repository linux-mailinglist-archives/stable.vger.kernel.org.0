Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D0323059D
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 10:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgG1IjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 04:39:25 -0400
Received: from sonic315-15.consmr.mail.bf2.yahoo.com ([74.6.134.125]:42742
        "EHLO sonic315-15.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727869AbgG1IjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 04:39:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1595925563; bh=Wbb5kU9+nuXHtr27nxpSCllVwLyRvN526jc5ol4mfd0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=n1HmA0EAAlqqiFZxunGt6keOwMIP2pmeIRE9gES0ArTZqcNpNv+Bqn/3YBoUa+IngWS2pQInnxOGYH0sXUVoCaSaRw6nel1LhL1xVOkN41xsRAS+TcUU0rOgbloNx1zCOax/kbSBKWDNdALGgvR9KzSTzPjX6Cs70mbyXjNPUvU06ut9MLOaUaxTf40newXzEVKE+dbnmUQ/B6+4VqriukX2qthUk46LH6jXSgyO66KBnj8PdCUZezuifZibfnUThQZdZPZiFT+iDA1IEEh8KoB1u16p4rPDUb/0nXSeFc/eyGvtmxziZOuNhKQs6hBSo4FJxeGbC1kIvJgucd4Mqw==
X-YMail-OSG: yrpBDZ0VM1kfMGR5PD0XMIrH5ZmSi0.dmYE65tF_xn6nEwirBBIuRcf3Dnpjvw9
 Gw00nUaomU0aafz_rjJyE.1PeJNPFoMZfmqt1OKgD6ooVp2WwpHY1jxhBVmDTXD4yrXfusKxinBo
 0aH.56M6gg2.3aEpKB0_XiLER25Si6KxiRssHCvR8dnDvVG8YfXbRQlCa8aSfjN9Ua1KlMYgOtSZ
 5HxXM1MVKOsXA2TbaQYDO3xNWtgYttXM4UpHqasTrzaL4p8i6UALOQOUynwGUKpXT0.OQx8fGXAb
 y6nWB5oBr8TzLLE8aN_WMdpQIUepN.0ATKEi74vrXEDGcIL.Q0byX9ayrLvUW4O83bpIiDJCEzyy
 p0fOhGEOzZQ6k8JmO2TzvPN6TXvajuG0_R7v.OzAInOUKH.atuVfgww9_.n31hwQd6pPiOoCpZ1y
 4Ap1FPg0lHdQLOTeYtEDwstXnUdB4HKmMFst4lFdjpyFS0H3acSVtvBwMxpFr5h8L6R68pKreo_V
 ozn1T7nVNU9UAKHwjxGHd7uIuba753ytDnu7ozwpDTB5MHeAkzyjw7XLp5ddQ3TxPAIFZZ.AQvN1
 X8GnreUFPtT0T5d61OsyJ1i7PU4qMsuPNxP0syTS9.6Ocf9z65KJJ549QxSb1M.aTLxvVph2gukG
 wdGXneNGDzOX18neXj2azboDZU4gqETrP4yxjDAmOp85oZDcKVsNBOSzyO8W5eC7Ix3xzH7hmakL
 ZC.cT0qX2uaD.R5qzxNvGYpSHJYHRAKflq0wHpoOHrbEzxNUC1qg935GiVn1ULVcm4Wsp9qhVcnc
 YgJDZ_T0WUwPZJ1NiwM4UlNJQzLjSf7VQzt3.J6qHXCszzu9qmk.rajW4JrKj_6zGnoZTF7sOIZk
 RkFBiGlgxpRFIlyNbhjf5woC9LjA41.eADk.1z0LOLHij_jU0x68J5RyJ0uKYN_XyTCmCgBcxzEk
 BtDC.KBV4Mqa9Kt8QV31FzDgm3vSXOfbIT_UZZoe_H2zY7hUQ37TlMu2lZPgrd0jH0fM57THAhjG
 XSNnWBzITWop1qOgMM8zx2bliklQhiyu_bftTw4v5broS1uRL1E0Lad.oVLQMUWoRXCVfi5rSsL9
 ldVWux7qXvHEM885XJot_GhziDVGPC5Sac3LMsfET_KovtjuQoITfMo_yze8leueJi_w7dnz2DB8
 JvznuLXYGWVUDJ2XgPPPrb3sLKXyBB1umQCxp2NyFbIAM3cUhImbLZIQBuYW4aRBFnWje4uPCtAn
 kyFQNRkqgso7lwVUo8uiyZup6fva.YaLNUTyH4E2mwBwXXGjWGVxpDECOJ1Mi_jOY_6oAnR6uxg-
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Tue, 28 Jul 2020 08:39:23 +0000
Date:   Tue, 28 Jul 2020 08:39:19 +0000 (UTC)
From:   "Mr.Sawadogo Michel" <sawadogomichel38@gmail.com>
Reply-To: mr.sawadogomichel1@gmail.com
Message-ID: <1711783040.5746929.1595925559453@mail.yahoo.com>
Subject: Hello Dear Friend,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1711783040.5746929.1595925559453.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16271 YMailNodin Mozilla/5.0 (Windows NT 5.1; rv:46.0) Gecko/20100101 Firefox/46.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear Friend,

My name is Mr.Sawadogo Michel. I have decided to seek a confidential co-operation  with you in the execution of the deal described here-under for our both  mutual benefit and I hope you will keep it a top secret because of the nature  of the transaction, During the course of our bank year auditing, I discovered  an unclaimed/abandoned fund, sum total of {US$19.3 Million United State  Dollars} in the bank account that belongs to a Saudi Arabia businessman Who unfortunately lost his life and entire family in a Motor Accident.

Now our bank has been waiting for any of the relatives to come-up for the claim but nobody has done that. I personally has been unsuccessful in locating any of the relatives, now, I sincerely seek your consent to present you as the next of kin / Will Beneficiary to the deceased so that the proceeds of this account valued at {US$19.3 Million United State Dollars} can be paid to you, which we will share in these percentages ratio, 60% to me and 40% to you. All I request is your utmost sincere co-operation; trust and maximum confidentiality to achieve this project successfully. I have carefully mapped out the moralities for execution of this transaction under a legitimate arrangement to protect you from any breach of the law both in your country and here in Burkina Faso when the fund is being transferred to your bank account.

I will have to provide all the relevant document that will be requested to indicate that you are the rightful beneficiary of this legacy and our bank will release the fund to you without any further delay, upon your consideration and acceptance of this offer, please send me the following information as stated below so we can proceed and get this fund transferred to your designated bank account immediately.

-Your Full Name:
-Your Contact Address:
-Your direct Mobile telephone Number:
-Your Date of Birth:
-Your occupation:

I await your swift response and re-assurance.

Best regards,
Mr.Sawadogo Michel.
