Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295445F0411
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 07:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiI3FKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Sep 2022 01:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiI3FKS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Sep 2022 01:10:18 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02C367CBA
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 22:10:15 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oe8Ht-0001Ba-4F; Fri, 30 Sep 2022 07:10:13 +0200
Message-ID: <b85bc2cf-5ea5-c5fb-465c-cd6637f6d30f@leemhuis.info>
Date:   Fri, 30 Sep 2022 07:10:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: Regression on 5.19.12, display flickering on Framework laptop
Content-Language: en-US, de-DE
To:     Jerry Ling <jiling@cern.ch>, stable@vger.kernel.org
Cc:     regressions@lists.linux.dev
References: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1664514615;508711ea;
X-HE-SMSGID: 1oe8Ht-0001Ba-4F
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_PDS_OTHER_BAD_TLD autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 30.09.22 04:26, Jerry Ling wrote:
> 
> It has been reported by multiple users across a handful of distros that
> there seems to be regression on Framework laptop (which presumably is
> not that special in terms of mobo and display)
> 
> Ref:
> https://community.frame.work/t/psa-dont-upgrade-to-linux-kernel-5-19-12-arch1-1-on-arch-linux-gen-11-model/23171

A bisect would be good, as Greg already mentioned.

Not my area of expertise, so it's a wild guess, but display flickering
made me wonder if this change is the culprit:

https://lore.kernel.org/all/20220926100814.131449678@linuxfoundation.org/

If it is, simply starting with "i915.enable_psr=0" might already help.
but as I said, just a wild guess after briefly looking into the problem.

Anyway, for the rest of this mail:
[TLDR: I'm adding this regression report to the list of tracked
regressions; all text from me you find below is based on a few templates
paragraphs you might have encountered already already in similar form.]

Thanks for the report. To be sure below issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
tracking bot:

#regzbot ^introduced v5.19.11..v5.19.12
#regzbot title Display flickering on Framework laptop
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply -- ideally with also
telling regzbot about it, as explained here:
https://linux-regtracking.leemhuis.info/tracked-regression/

Reminder for developers: When fixing the issue, add 'Link:' tags
pointing to the report (the mail this one replies to), as explained for
in the Linux kernel's documentation; above webpage explains why this is
important for tracked regressions.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
