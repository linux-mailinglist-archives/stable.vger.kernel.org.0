Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C733FB356
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 11:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbhH3JpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 05:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235733AbhH3JpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 05:45:21 -0400
X-Greylist: delayed 1460 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Aug 2021 02:44:28 PDT
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F63C061575;
        Mon, 30 Aug 2021 02:44:27 -0700 (PDT)
Received: from ip4d14bdef.dynamic.kabel-deutschland.de ([77.20.189.239] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1mKdSW-0000d5-Kl; Mon, 30 Aug 2021 11:20:04 +0200
Message-ID: <a11ba91f-a520-e6ab-5566-dfc9fd934440@leemhuis.info>
Date:   Mon, 30 Aug 2021 11:20:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [PATCH] Revert "floppy: reintroduce O_NDELAY fix"
To:     Denis Efremov <efremov@linux.com>, linux-block@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
        Mark Hounschell <markh@compro.net>,
        Jiri Kosina <jkosina@suse.cz>,
        Wim Osterholt <wim@djo.tudelft.nl>,
        Kurt Garloff <kurt@garloff.de>, stable@vger.kernel.org
References: <de10cb47-34d1-5a88-7751-225ca380f735@compro.net>
 <20210808074246.33449-1-efremov@linux.com>
Content-Language: en-US
In-Reply-To: <20210808074246.33449-1-efremov@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1630316668;fb9dddbd;
X-HE-SMSGID: 1mKdSW-0000d5-Kl
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08.08.21 09:42, Denis Efremov wrote:
> The patch breaks userspace implementations (e.g. fdutils) and introduces
> regressions in behaviour. Previously, it was possible to O_NDELAY open a
> floppy device with no media inserted or with write protected media without
> an error. Some userspace tools use this particular behavior for probing.
> 
> It's not the first time when we revert this patch. Previous revert is in
> commit f2791e7eadf4 (Revert "floppy: refactor open() flags handling").
> 
> This reverts commit 8a0c014cd20516ade9654fc13b51345ec58e7be8.
> 
> Link: https://lore.kernel.org/linux-block/de10cb47-34d1-5a88-7751-225ca380f735@compro.net/

FYI, I'm just starting to act as regression tracker again and will add
this to the list of tracked regressions.

Feel free to ignore the rest of this message, it's intended for the
regression tracking bot I'm writing. This "regzbot" in fact is running
now and this is the first regression that gets added to the database
(I'm sure despite a lot of testing something will go wrong, but don't
worry about it, I'll deal with it on my side). See also:
https://linux-regtracking.leemhuis.info/post/inital-regzbot-running/
https://linux-regtracking.leemhuis.info/post/regzbot-approach/

#regzbot ^introduced 8a0c014cd20516ade9654fc13b51345ec58e7be8
#regzbot monitor
https://lore.kernel.org/lkml/20210818154646.925351-1-efremov@linux.com/
#regzbot monitor
https://lore.kernel.org/lkml/388418f4-2b9a-6fed-836c-a004369dc7c0@linux.com/

Ciao, Thorsten

