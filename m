Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71350195DA3
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 19:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgC0S2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 14:28:19 -0400
Received: from sonic309-14.consmr.mail.bf2.yahoo.com ([74.6.129.124]:36491
        "EHLO sonic309-14.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726275AbgC0S2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 14:28:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1585333697; bh=NajTNMrfMLb6UXcjRhYpYerQX8PtVBLz0oFgaMINSWY=; h=Date:From:Reply-To:Subject:References:From:Subject; b=rOIC4rzYxQp5WdAp8ph5bb3hZ2dZio91O5HvDjn+M5rEbObypk0sFenC/IOAFwWN3uv9aBsx6/RyBiQ/mVGu51bPg1zWgS4wQDJJBpTJcZZDeE9z/nwwfp7ze5fR10kywfxP/9RsJcy3vXnAAa6pQes+vFBOHunE1EoQH/QKn8Duo01cnQu/s4NECi2hwt14iTPZirgqPCNAdcLdZYeOUPKVRi+5Gtwbv9OtJ9BlliORqlvw1+sH4qxLU64wFBU0NLZuieu7jirP0pRxCNRDprs5ZOGrcT9bF8tOsdzme2HgyfUCYcE9wg384I4E0GaIiPk3PaRQVBxf9yz9dbByCA==
X-YMail-OSG: A9RqzU4VM1mNc2XVonmbfwFO.cbIBlVAhPP7xm4xyawIltXopXWZPTiRlsmijlY
 MG4TwMb3yLYmQrnIGyrBg6U.eHVsHhn6SPsJTnMGpef6yEbKCqyoKDpSs0Ao.Uscg3vFg0bbCI81
 HlBBV9Z8G_sN46S08.MSvB_3heZeHQgIvNlxN2IGFfxt9OCZqW8Ua2yCqUV0WLBYSStb6lpGqPwE
 rTlKmrUrRhJOcB33qYl_kb4hMPLmBHPjpNVw59w5l6aWCs.eT4.3TBJp0wHUPbFPCUaJjDvz0gXL
 cXWMDZe6krnUcNXwnNtydMHoWj95lsvuziJoWMIIkQN37f37mewoKaPxUaGFx6X8PQJ6fxD9qHjA
 Nwx4_6vXK2Uinqu7PV8TZW_x.mW2Hz4cV.kdS7xmEQsyugTIn7ueDdgA_9kHtECbp88Pr8g9lgaB
 8flQfbps1gA.2BMtB7_hhzQaV4EDLeUKYL3btMB3nxFsZXRDIRXCXza4ymHn.blQHAIteqajFYC4
 VxiulRn.KHczb.CaNuXI5vX3FXJ0EaOw1_wjF0rlghKGg7BR8iFBj_09LsbDCoEQSPht2nYQfmSs
 GvoCAPSuxT93YmnWDm74rLJj9g35jJ6qLk.J.0bcgj1RLceV3RAyudAvQ5iHwHC0Z.785SHsqOvu
 FuAjngG8YElym6AkQ7e8HrAMyaAmhr64sWTkiNnS0q0WX1YCEN.FoVJWQNRUb_8kKFUX3emIqEim
 f4plYdpz6fwl6.c21Ar4JkZTPi.TACR8u4SeIFDtpSwcI0bNX7k1HZ0nIDT4MsZx3.25pgMoHmYR
 ORKzcERY8EFyexD5MyGxvlmKWr6FlMoYvDsL2A3BsYFXpCRLfjqNtO28CK4BAWOOsMrptFs5Lpk1
 zN5d9yZt4Tr15TyxE47g1UU0zvXMOL2UGm4WFh7irhu5T1uE4a32BGwsucNPEwx3jVvBINlanoIW
 XUSHJ5.PG04ETDNvYzigqaLrFN4aJUYAJlHxCrw4BiISt..AmKpBUaz6i2wbcx2hYjYEwV30HEcO
 a6jewt8A2RDGC2BJeMBzLQxmusUPWPtwbSWpFaNC4s202z.n_24vu_TS4ogoSfU6s.YrXet7P3LN
 GsCOjHNQt.IbJC9LAuxfbvl3YkEkFinXRuHZ5IwmOVYSz43RluCPgpf9VdiGYbBp0C.CHpG4Sjzh
 T4026fKyTcQEcmh3mHe.k3A.unq1Bl8RcbcXiSNYn5R2zA2tQMOegQW0faVA7JsWjoxsWBRXLl8k
 nqhHy0TDAcY6ERXExNUUAQ9Zhzl3LshQV_7VSzZuq.0LFZUxzxBdwen69cRtWAcLk03RL5gsTZBc
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.bf2.yahoo.com with HTTP; Fri, 27 Mar 2020 18:28:17 +0000
Date:   Fri, 27 Mar 2020 18:28:16 +0000 (UTC)
From:   Ms lisa Hugh <lisahugh531@gmail.com>
Reply-To: ms.lisahugh000@gmail.com
Message-ID: <1606147024.2045162.1585333696486@mail.yahoo.com>
Subject: BUSINESS CO-OPERATION OPPORTUNITY.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1606147024.2045162.1585333696486.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15518 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:74.0) Gecko/20100101 Firefox/74.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend,

I am Ms Lisa hugh, work with the department of Audit and accounting manager here in the Bank(B.O.A).

Please i need your assistance for the transferring of thIs fund to your bank account for both of us benefit for life time investment, amount (US$4.5M DOLLARS).

I have every inquiry details to make the bank believe you and release the fund in within 5 banking working days with your full co-operation with me for success.

Note/ 50% for you why 50% for me after success of the transfer to your bank account.

Below information is what i need from you so will can be reaching each other

1)Full name ...
2)Private telephone number...
3)Age...
4)Nationality...
5)Occupation ...


Thanks.

Ms Lisa hugh.
