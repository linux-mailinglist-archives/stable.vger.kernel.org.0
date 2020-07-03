Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68A52141C9
	for <lists+stable@lfdr.de>; Sat,  4 Jul 2020 00:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgGCWqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 18:46:16 -0400
Received: from sonic311-24.consmr.mail.ne1.yahoo.com ([66.163.188.205]:40963
        "EHLO sonic311-24.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726379AbgGCWqQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jul 2020 18:46:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1593816375; bh=TYgdp/zNeW9P5rVjVpFopjba7a+Fm8hxyemx2bQVZd8=; h=Date:From:Reply-To:Subject:References:From:Subject; b=A2ABv4b7nXLWj79bXDCj75YLydnL28lLD7xuZqyui0/2j9JrhJ51rdwRQgxsHo0Rzf5gkwV6yvsaxwBQlfINchzNCedjT8qs6qpUPkJF25sW4+JE2AS4w7QtWpb9mVckJxcPIngTkL9JySFxpuzLL0C8fs1C8YI8DYnVIvCcD5ykiSMz0SrM88KlfUzdH1V/8HuF0h48ljA5xl1ps6jqV4DsOqYMh+NZQ4WqUVHEq1Jx36SYOhQ7oDszeI2Ja8Zbp5zgR9kOPP+4om3It5G6GPBNPTwoE0U0C4mhjK/SMz9byEgJVPvqJsjcf9DGfkXKA8/0u98Bg42kf62Sxu20WA==
X-YMail-OSG: jBCdV8AVM1k_N9ZGdRFr_fXIHq8kxTLTEfPyf1oL6W2AZJKJrhuX2Af145lgQJo
 9dTTl5ylYRv_j8d86ygPtRhLn_RSeYrTg1ki.ZBU8IEpitzSYFZj7TvL1Qwu17YARX5pnQgz_lFo
 TMFq.QG2FEuUPaDpvhrSMd.c3CO5zx7lLLcc2lGV6uxDcrpp9q3nqAqbdKOteJi8AsO7vA6YCLDT
 Lp56oTxx.R3KXGTGKvMcxptUV3CRAPAKTXJujTEXYJaB7HgSL7OSICAmYm6K1aeISmlOMTVycxr_
 IqdygD4bnnftZ0amv958gGA7CUGpOwbvFXnhqvvZx58lUOEnoC3jn9iPb4YgWkmdrpDwn43J4qiu
 YkQoXXObkcaYuPNqHP.BbWDizSUjCsU_MNlWEUV3qBe9YDwA.dvYS.EvRHpBKN8DNBlLnzqcwJAq
 M2qivgl5lqI52EkD46visdnktC4ToA6zxP3X.AwwTHHrwqdlRKuX.YbK3q7wlxhbpdn2YPHK6.0c
 6jHmDfpobYEfZS2JWl0jUl0QQ4b7LO0eyH12dvygHrthc4cJ.6PoK.EnP79cYWLxeQmUwhpXaARO
 kbXdbRwJwKUKDsi16CHy_3nJVkci5nEdgED.Wqv3ZXehsrVcdow.zEH3mtRkvTkQbEhcQF0aNejs
 jLmiLbMpxKIKiZFaAui117vkbK7CJ38LFDbE0Igp58KSjlvctm6QzNFHEuZBstAtcoYZqH5K3_dG
 Rq0Oh_OlU.MY0B0i5lBRzJS7mW0loZJu7c0wwyKLg3J0qFV0efmy2PsoM.2Vz0e0JoKqmttWLuY4
 somdnnuIOIQdnszxECRXx_aHjDeuTsOG6gaQf.6TGvEPXp1Azmu0TG2NNGGj7fenzjtO5AdiMf52
 IPOqAwRxn4oxCEw8OKaNG5ZSlhV0Ck6Gv9POnVo9MvVjE2brCiTIoIkxLfwf.3yer7LDT.ENQcQO
 biBz.HKnM_4AKRt1hIEvp_uCLr83__VobTIULsKZShRtQD7U6TAXj8um01B.4MbFuY3ze3zW3ZSD
 oA6728C8qzPJxYI1.u9ykGMYxN6U5kz9OQ.c_BSFf.4bp064PrUdLQYSePZV8K_9PDyqnIkilbhj
 WsmAJEZnq.GfiiXWsbuO8qpIRtufDr35nM2B.JsLEmaRN7w01.vp_M4UeS.epukjPR8PYgZE7axu
 gX4RyDkf_cA.VfVlBs0rM91HAyoOSi9srZ16Um7ifsqJcG3rP4jmjUSksw0y5d_TW8jwWw7aTk3V
 T3tmH6MLKPD3Ka_u9FfBXPMRPwzOntcULifckiUXNjJtukaVEUWAIM0xLZUq4yYqeIIyMAeWY
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Fri, 3 Jul 2020 22:46:15 +0000
Date:   Fri, 3 Jul 2020 22:46:14 +0000 (UTC)
From:   "Mrs.mcompola" <mrs.muminwanta448@gmail.com>
Reply-To: mcompola444@gmail.com
Message-ID: <1223136631.2270469.1593816374450@mail.yahoo.com>
Subject: Dear Friend, My present internet connection is very slow in case
 you
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1223136631.2270469.1593816374450.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16197 YMailNodin Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Dear Friend, My present internet connection is very slow in case you
received my email in your spam

How are you today?.With due respect to your person and much sincerity
of purpose,Well it is a pleasure to contact you on this regard and i
pray that this will turn out to be everlasting relationship for both
of us. However it's just my urgent need for a Foreign partner that
made me to contact you for this Transaction,I got your contact from
internet, while searching for a reliable someone that I can go into
partnership with. I am Mrs.mcompola, from BURKINA FASO, West
Africa .Presently i work in the Bank as bill and exchange manager.

I have the opportunity of transferring the left over fund $5.4 Million
us dollars of one of my Bank clients who died in the collapsing of the
world trade center on september 11th 2001.I have placed this fund to
and escrow account without name of beneficiary.i will use my position
here in the bank to effect a hitch free transfer of the fund to your
bank account and there will be no trace.

I agree that 40% of this money will be for you as my foriegn
partner,50% for me while 10% will be for the expenses that will occur
in this transaction .If you are really interested in my proposal
further details of the Transfer will be forwarded unto you as soon as
I receive your willingness mail for successful transfer.

Yours Faithfully,
Mrs.mcompola444@gmail.com
