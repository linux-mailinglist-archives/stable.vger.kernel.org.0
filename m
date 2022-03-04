Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CB14CCE48
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 08:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238446AbiCDHHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 02:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbiCDHHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 02:07:44 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B6B18E43C
        for <stable@vger.kernel.org>; Thu,  3 Mar 2022 23:06:57 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nQ21e-0004zJ-Io; Fri, 04 Mar 2022 08:06:54 +0100
Message-ID: <f1b44e87-e457-7783-d46e-0d577cea3b72@leemhuis.info>
Date:   Fri, 4 Mar 2022 08:06:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] mtd: cfi_cmdset_0002: Use chip_ready() for write on
 S29GL064N
Content-Language: en-US
To:     Tokunori Ikegami <ikegami.t@gmail.com>, vigneshr@ti.com
Cc:     linux-mtd@lists.infradead.org,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, stable@vger.kernel.org
References: <20220214182011.8493-1-ikegami.t@gmail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220214182011.8493-1-ikegami.t@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1646377617;77304d7f;
X-HE-SMSGID: 1nQ21e-0004zJ-Io
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 14.02.22 19:20, Tokunori Ikegami wrote:
> The regression issue has been caused on S29GL064N and reported it.
> Also the change mentioned is to use chip_good() for buffered write.
> So disable the change on S29GL064N and use chip_ready() as before.
> 
> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> Cc: linux-mtd@lists.infradead.org
> Cc: stable@vger.kernel.org

This is missing a "Link:" tag pointing to the report:

Link:
https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/

'Documentation/process/submitting-patches.rst' and
'Documentation/process/5.Posting.rst' explain this in more detail. Such
tags are important for me, as it allows my regression tracking bot to
connect the report with any patches posted or committed to fix the
issue; this again allows the bot to show the current status of
regressions and automatically resolve the issue when the fix hits the
right tree.

BTW, what's the status of getting an improved fix merged? It seems the
progress slowed down quite a bit.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.

#regzbot ^backmonitor:
https://lore.kernel.org/lkml/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
