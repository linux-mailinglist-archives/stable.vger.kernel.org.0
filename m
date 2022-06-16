Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC6D54E1B3
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 15:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiFPNQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 09:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiFPNQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 09:16:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAC13CFF7;
        Thu, 16 Jun 2022 06:16:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A866EB823AA;
        Thu, 16 Jun 2022 13:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0A6C3411A;
        Thu, 16 Jun 2022 13:16:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="qEYhdwB+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1655385407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cGUeyZ8PR/wVW8IqlWgOlfoA6rSo7jK2kzvB2/EJIPM=;
        b=qEYhdwB+eG/dU0312YFqcYr9XdIzwWfTXTa0RTktw70V6Pzp9aSUDx812vt4KOpLHpeTiy
        aEOGTCI/Khe/WJVJw6yBKNhRZVXUrL4bc/SYLJvSpQf5tdoJfkBcqVA8ST2s9KTgjq67f7
        8RSUD4yqX62PdWfYhLJdbVWZCcxuCn0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 75d81ab3 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 16 Jun 2022 13:16:47 +0000 (UTC)
Date:   Thu, 16 Jun 2022 15:16:42 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Ron Economos <re@w6rz.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/11] 5.10.123-rc1 review
Message-ID: <YqstOrOfpkTl43Vh@zx2c4.com>
References: <20220614183719.878453780@linuxfoundation.org>
 <9e43b35e-31da-7e51-006c-1aa69acb10d4@nvidia.com>
 <a05678bb-29f8-23ea-9260-cc1cece3f480@w6rz.net>
 <51786b52-a33c-96c3-583b-2fd2d158ad5d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51786b52-a33c-96c3-583b-2fd2d158ad5d@nvidia.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jon,

On Thu, Jun 16, 2022 at 11:11:25AM +0100, Jon Hunter wrote:
> On 16/06/2022 10:46, Ron Economos wrote:
> > On 6/16/22 1:48 AM, Jon Hunter wrote:
> > I'm also seeing this on RISC-V. 5.15 and 5.17, but not 5.18.
> That's good to know. I don't see this on 5.18 either, just 5.10, 5.15 
> and 5.17.

Right. 5.18 has
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=48bff1053c172e6c7f340e506027d118147c8b7f
which I thought was a bit too risky to backport. So on 5.18 you're not
seeing this behavior because /dev/urandom is always seeded magically and
hence there is never an opportunity to warn about unseeded randomness.
Maybe we can think about backporting that if no issues come up after
several months, but I'd rather tread lightly with that one.

Anyway, as mentioned in the other message, I've got a patch I'll send
out in a minute for the unwanted pr_warn().

Jason
