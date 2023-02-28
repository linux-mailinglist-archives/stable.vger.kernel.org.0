Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561906A5784
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 12:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjB1LLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 06:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjB1LLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 06:11:18 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026FB27D40
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 03:11:17 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pWxt6-0005iO-7n; Tue, 28 Feb 2023 12:11:16 +0100
Message-ID: <ae9753d2-6bc5-b99e-6462-ed83f8cad474@leemhuis.info>
Date:   Tue, 28 Feb 2023 12:11:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [REGRESSION] 5.15.88 and onwards no longer return EADDRINUSE from
 bind
Content-Language: en-US, de-DE
To:     Winter <winter@winter.cafe>, stable@vger.kernel.org
Cc:     regressions@lists.linux.dev
References: <EF8A45D0-768A-4CD5-9A8A-0FA6E610ABF7@winter.cafe>
From:   "Linux regression tracking #update (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <EF8A45D0-768A-4CD5-9A8A-0FA6E610ABF7@winter.cafe>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1677582678;6b55824e;
X-HE-SMSGID: 1pWxt6-0005iO-7n
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[TLDR: This mail in primarily relevant for Linux kernel regression
tracking. See link in footer if these mails annoy you.]

On 13.02.23 04:38, Winter wrote:
> Hi all,
> 
> I'm facing the same issue as https://lore.kernel.org/stable/CAFsF8vL4CGFzWMb38_XviiEgxoKX0GYup=JiUFXUOmagdk9CRg@mail.gmail.com/, but on 5.15. I've bisected it across releases to 5.15.88, and can reproduce on 5.15.93.
> 
> However, I cannot seem to find the identified problematic commit in the 5.15 branch, so I'm unsure if this is a different issue or not.
> 
> There's a few ways to reproduce this issue, but the one I've been using is running libuv's (https://github.com/libuv/libuv) tests, specifically tests 271 and 277.
> 
> #regzbot introduced v5.15.88..

#regzbot fix: fdaf88531cfd17b
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.



