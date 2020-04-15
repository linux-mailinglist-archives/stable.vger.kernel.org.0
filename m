Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E0F1A9B6A
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 12:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896377AbgDOKPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 06:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896390AbgDOKPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 06:15:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2097D20775;
        Wed, 15 Apr 2020 10:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586945744;
        bh=O1PpAQGForc85eklx83LamsIkxr4MJ7B6w9Wiyjh1Ow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b8+IMKKkd4AL5ZG/JvLvpW/AblVWoiGU8J/oeMNlWnotX5lsFjFYa/L0mudDUovgi
         S/uhBqSI4v+JV6L1f98x+ziDEn7p/Qnm2dO+jCXRP+0r9Ilvy04JtvVLw3ADsORuYK
         0CPp7IfHljPBliffVQ969LfIfeoXy5wOLUgvJ4yU=
Date:   Wed, 15 Apr 2020 12:15:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Patches to apply to stable releases
Message-ID: <20200415101542.GD2568572@kroah.com>
References: <20200415003148.GA114493@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415003148.GA114493@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 05:31:48PM -0700, Guenter Roeck wrote:
> Upstream commit 538d92912d31 ("xen-netfront: Rework the fix for Rx stall during OOM and network stress")
>     Fixes: 90c311b0eeea ("xen-netfront: Fix Rx stall during network stress and OOM")
>     in linux-4.4.y: 230fe9c7d814
>     Applies to:
>         v4.4.y

Now queued up.

> Upstream commit 183ab39eb0ea ("ALSA: hda: Initialize power_state field properly")
>     Fixes: 98081ca62cba ("ALSA: hda - Record the current power state before suspend/resume calls")
>     in linux-4.4.y: 2569eed24d93
>     in linux-4.9.y: 5ee86945565e
>     in linux-4.14.y: 886e8316b599
>     Applies to:
>         v4.4.y, v4.9.y, v4.14.y

Now queued up.

> Upstream commit 24e52b11e0ca ("Btrfs: incremental send, fix invalid memory access")
>     Fixes: e1cbfd7bf6da ("Btrfs: send, fix file hole not being preserved due to inline extent")
>     in linux-4.4.y: 266bbc907c3f
>     Applies to:
>         v4.4.y

Now queued up.

> Upstream commit 1f80bd6a6cc8 ("IB/ipoib: Fix lockdep issue found on ipoib_ib_dev_heavy_flush")
>     Fixes: b4b678b06f6e ("IB/ipoib: Grab rtnl lock on heavy flush when calling ndo_open/stop")
>     in linux-4.4.y: 26c66554d7bf
>     Applies to:
>         v4.4.y

ChromeOS cares about IB devices?  That's funny...

Anyway, now queued up.

> Upstream commit 56a49d704870 ("net: rtnl_configure_link: fix dev flags changes arg to __dev_notify_flags")
>     Fixes: 5025f7f7d506 ("rtnetlink: add rtnl_link_state check in rtnl_configure_link")
>     in linux-4.14.y: 23557c5d34b9
>     Applies to:
>         v4.14.y

Nice catch, now queued up.

> Upstream commit 11dd34f3eae5 ("powerpc/pseries: Drop pointless static qualifier in vpa_debugfs_init()")
>     Fixes: c6c26fb55e8e ("powerpc/pseries: Export raw per-CPU VPA data via debugfs")
>     in linux-4.14.y: 27b1ef75f579
>     in linux-4.19.y: ee35e01b0f08
>     Applies to:
>         v4.14.y, v4.19.y

Also needed in 5.4.y, thanks.

> Upstream commit 34d66caf251d ("x86/speculation: Remove redundant arch_smt_update() invocation")
>     Fixes: a74cfffb03b7 ("x86/speculation: Rework SMT state change")
>     in linux-4.14.y: 36a4c5fc9285
>     in linux-4.19.y: f55e301ec4d5
>     Applies to:
>         v4.14.y, v4.19.y

4.9.y and 4.4.y also need this.  4.9.y was simple, ugh, 4.4.y doesn't
care about speculation issues so I didn't attempt the backport.

> Upstream commit cc41f11a21a5 ("scsi: mpt3sas: Fix kernel panic observed on soft HBA unplug")
>     Fixes: c666d3be99c0 ("scsi: mpt3sas: wait for and flush running commands on shutdown/unload")
>     in linux-4.14.y: 3748694f1b91
>     Applies to:
>         v4.14.y

This also belongs to 4.19.y, 5.4.y, 5.5.y, and 5.6.y as it is cc:
stable.  But it doesn't backport cleanly to all, so I need a working
backport in order to be able to take it...

> Upstream commit 82f04bfe2aff ("tools: gpio: Fix out-of-tree build regression")
>     Fixes: 0161a94e2d1c ("tools: gpio: Correctly add make dependencies for gpio_utils")
>     in linux-4.14.y: f71e52cb3270
>     in linux-4.19.y: 036588ec6888
>     Applies to:
>         v4.14.y, v4.19.y

Also belongs to 4.9.y, 5.6.y, 5.5.y, and 5.4.y.  Also has a cc: stable
that I hadn't gotten to yet, now applied.

> Upstream commit 3e487d2e4aa4 ("PCI: pciehp: Fix indefinite wait on sysfs requests")
>     Fixes: 157c1062fcd8 ("PCI: pciehp: Avoid returning prematurely from sysfs requests")
>     in linux-4.19.y: 248e65f3220e
>     in linux-5.4.y: 9bd9d123399b
>     Applies to:
>         v4.19.y, v5.4.y

Already queued up yesterday, and to 5.5.y and 5.6.y.

> Upstream commit 8644772637de ("mm: Use fixed constant in page_frag_alloc instead of size + 1")
>     Fixes: 2c2ade81741c ("mm: page_alloc: fix ref bias in page_frag_alloc() for 1-byte allocs")
>     in linux-4.14.y: a977209627ca
>     in linux-4.19.y: 33e83ea302c0
>     Applies to:
>         v4.14.y, v4.19.y

Also needed in 4.9.y, now queued up.

> Upstream commit 2abb5792387e ("net: qualcomm: rmnet: Allow configuration updates to existing devices")
>     Fixes: 1dc49e9d164c ("net: rmnet: do not allow to change mux id if mux id is duplicated")
>     in linux-4.19.y: 48c5bfbbcec1
>     in linux-5.4.y: 835bbd892683
>     Applies to:
>         v4.19.y, v5.4.y

Normally I wait for DavidM to send me these as they are also applicable
to 5.6.y and 5.5.y.  Now queued up.

> Upstream commit 36eb7dc1bd42 ("cpufreq: imx6q: Fixes unwanted cpu overclocking on i.MX6ULL")
>     Fixes: 2733fb0d0699 ("cpufreq: imx6q: read OCOTP through nvmem for imx6ul/imx6ull")
>     in linux-4.19.y: 4ef576e99d29
>     Applies to:
>         v4.19.y

Queued up yesterday.

> Upstream commit 4c7eeb9af3e4 ("arm64: dts: allwinner: h6: Fix PMU compatible")
>     Fixes: 7aa9b9eb7d6a ("arm64: dts: allwinner: H6: Add PMU mode")
>     in linux-4.19.y: 8f1046b33f1b
>     in linux-5.4.y: 02dfae36b03f
>     Applies to:
>         v4.19.y, v5.4.y

Also needed in 5.5.y and 5.6.y.

> Upstream commit ae769d355664 ("ALSA: pcm: oss: Fix regression by buffer overflow fix")
>     Fixes: f2ecf903ef06 ("ALSA: pcm: oss: Avoid plugin buffer overflow")
>     in linux-4.14.y: 5ac3462e1921
>     in linux-4.19.y: 8c5bd5520334
>     in linux-5.4.y: 07ec940ceda5
>     Applies to:
>         v4.14.y, v4.19.y, v5.4.y

Already queued up yesterday all the way back to 4.4.y and 4.9.y as well
because f2ecf903ef06 ("ALSA: pcm: oss: Avoid plugin buffer overflow")
went that far back.  Did your scripts miss that?

> Upstream commit 82e0516ce3a1 ("sched/core: Remove duplicate assignment in sched_tick_remote()")
>     Fixes: ebc0f83c78a2 ("timers/nohz: Update NOHZ load in remote tick")
>     in linux-5.4.y: 166d6008fa2a
>     Applies to:
>         v5.4.y

Also applied to 5.5.y and 5.6.y

> Upstream commit 4ae7a3c3d7d3 ("arm64: dts: allwinner: h5: Fix PMU compatible")
>     Fixes: c35a516a4618 ("arm64: dts: allwinner: H5: Add PMU node")
>     in linux-5.4.y: 5a241d7bf1e6
>     Applies to:
>         v5.4.y

Also applied to 5.5.y and 5.6.y

> Upstream commit 9b8b17541f13 ("mm, memcg: do not high throttle allocators based on wraparound")
>     Fixes: e26733e0d0ec ("mm, memcg: throttle allocators based on ancestral memory.high")
>     in linux-5.4.y: 61cfbcce9e09
>     Applies to:
>         v5.4.y

Hadn't gotten to it yet, also queued up for 5.5.y and 5.6.y

> Upstream commit 8c5c66052920 ("nvme-fc: Revert "add module to ops template to allow module references"")
>     Fixes: 863fbae929c7 ("nvme_fc: add module to ops template to allow module references")
>     in linux-4.14.y: a123233fc320
>     in linux-4.19.y: 6c786e656cd9
>     in linux-5.4.y: 6b49a5a9eb46
>     Applies to:
>         v4.14.y, v4.19.y, v5.4.y

Queued up yesterday, also for 5.5.y and 5.6.y.

Many thanks for these, I think they should now all be handled.

greg k-h
