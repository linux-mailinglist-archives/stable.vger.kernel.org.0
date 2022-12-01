Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E779363F027
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 13:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiLAMG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 07:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiLAMG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 07:06:26 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A2990776;
        Thu,  1 Dec 2022 04:06:24 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1p0iKc-0002PQ-MH; Thu, 01 Dec 2022 13:06:22 +0100
Message-ID: <877f72a1-289d-1c39-e413-7332baa35dd1@leemhuis.info>
Date:   Thu, 1 Dec 2022 13:06:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: Boot failure regression on 6.0.10 stable kernel on iMX7
 #forregzbot
Content-Language: en-US, de-DE
To:     linux-arm-kernel@lists.infradead.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Cc:     devicetree@vger.kernel.org, stable@vger.kernel.org
References: <Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <Y4dgBTGNWpM6SQXI@francesco-nb.int.toradex.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1669896385;41a87b1f;
X-HE-SMSGID: 1p0iKc-0002PQ-MH
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Note: this mail contains only information relevant for regzbot, the
Linux kernel regression tracking bot. That's why I removed most
recipients of the quoted mail and only left what looked like a mailing
lists. These mails contain '#forregzbot' in the subject, to make them
easy to spot and filter out.]

On 30.11.22 14:52, Francesco Dolcini wrote:
> it looks like commit 753395ea1e45 ("ARM: dts: imx7: Fix NAND controller
> size-cells"), that was backported to stable 6.0.10, introduce a boot
> regression on colibri-imx7, at least.
> [...]

Thanks for the report. To be sure below issue doesn't fall through the
cracks unnoticed, I'm adding it to regzbot, my Linux kernel regression
tracking bot:

#regzbot ^introduced 753395ea1e45
#regzbot title ARM: dts: imx7: Boot failure on iMX7
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
