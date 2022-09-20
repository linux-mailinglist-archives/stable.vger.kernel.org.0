Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754055BDF5E
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 10:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiITIL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 04:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiITIK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 04:10:58 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210976716A;
        Tue, 20 Sep 2022 01:07:10 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oaYHc-0007Gk-En; Tue, 20 Sep 2022 10:07:08 +0200
Message-ID: <48bb6266-2d5c-ffcd-6982-4fd02bfdcfc3@leemhuis.info>
Date:   Tue, 20 Sep 2022 10:07:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US, de-DE
To:     hazem ahmed mohamed <hazem.ahmed.abuelfotoh@gmail.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc:     "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
References: <CACX6voDfcTQzQJj=5Q-SLi0in1hXpo=Ri28rX73Og3GTObPBWA@mail.gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: Ext4: Buffered random writes performance regression with
 dioread_nolock enabled
In-Reply-To: <CACX6voDfcTQzQJj=5Q-SLi0in1hXpo=Ri28rX73Og3GTObPBWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1663661230;c62e95cb;
X-HE-SMSGID: 1oaYHc-0007Gk-En
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19.09.22 17:18, hazem ahmed mohamed wrote:
> 
> I am sending this e-mail to report a performance regression that’s
> caused by commit 244adf6426(ext4: make dioread_nolock the default) , I
> am listing the performance regression symptoms below & our analysis
> for the reported regression.

FWIW, that patch went into v5.6-rc1~113^2~12

And BTW: it seems 0-day back then noticed that 244adf6426 caused a
performance regression as well, but it seems that was ignored:
https://lore.kernel.org/all/20201024120829.GK31092@shao2-debian/

Anyway, now to the main reason why I write this mail:

[TLDR: I'm adding this regression report to the list of tracked
regressions; all text from me you find below is based on a few templates
paragraphs you might have encountered already already in similar form.]

Thanks for the report. To be sure below issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
tracking bot:

#regzbot ^introduced 244adf6426
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply -- ideally with also
telling regzbot about it, as explained here:
https://linux-regtracking.leemhuis.info/tracked-regression/

Reminder for developers: When fixing the issue, add 'Link:' tags
pointing to the report (the mail this one replies to), as explained for
in the Linux kernel's documentation; the webpage mention at the end of
the last para explains why this is important for tracked regressions.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
