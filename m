Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3F025D7D1
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 13:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbgIDLtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 07:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728588AbgIDLtP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 07:49:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8E8120709;
        Fri,  4 Sep 2020 11:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599220154;
        bh=JXI5cvLeJAV/xlf6+L06NlHILFFzLKU0n4nxk+MeZUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vrj6Q0skKgiAmbovpbNkJ+ayLiBJhEIPCLmLE23jV1zSpmIBqAlumi4grov3b9nNQ
         miouXZAocn4l/oJAAlnx4am6c92FUg5+1LM6PdUJVzPXLGXFhd38BgxqDpqSVZ/Ofy
         B6Li5Ce97FW99qIQXAF+BcFkPcASscTyZW6WTiSA=
Date:   Fri, 4 Sep 2020 13:49:35 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     SeongJae Park <sjpark@amazon.com>
Cc:     Muchun Song <songmuchun@bytedance.com>,
        Filipe Manana <fdmanana@suse.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Alexander Tsoy <alexander@tsoy.me>,
        Takashi Iwai <tiwai@suse.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Taehee Yoo <ap420073@gmail.com>,
        Fabio Estevam <festevam@gmail.com>, Jan Kara <jack@suse.cz>,
        Dongli Zhang <dongli.zhang@oracle.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        Adam Ford <aford173@gmail.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Xiaochen Shen <xiaochen.shen@intel.com>, sashal@kernel.org,
        amit@kernel.org, sj38.park@gmail.com, stable@vger.kernel.org
Subject: Re: [5.4.y] Found 27 commits that might missed
Message-ID: <20200904114935.GE2831752@kroah.com>
References: <20200828152745.10819-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200828152745.10819-1-sjpark@amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 28, 2020 at 05:27:45PM +0200, SeongJae Park wrote:
> From: SeongJae Park <sjpark@amazon.de>
> 
> Hello,
> 
> 
> We found below 27 commits in the 'v5.5..linus/master (upstream)' seems fixing or mentioning
> commits in the 'v5.4..stable/linux-5.4.y (downstream)' but are not merged in the 'downstream' yet.
> Could you please review if those need to be merged in?
> 
> A commit is considered as fix of another if the complete 'Fixed:' tag is in the
> commit message.  If the tag is not found but the commit message contains the
> title or the hash id of the other commit, it is considered mentioning it.  So,
> the 'mentions' might have many false positives, but it could cover the typos (I
> found such cases before).
> 
> The commits are grouped as 'fixes cleanly applicable', 'fixes not cleanly
> applicable (need manual backporting to be applied)', 'mentions cleanly
> applicable', and 'mentions not cleanly applicable'.  Also, the commits in each
> group are sorted by the commit dates (oldest first).
> 
> Both the finding of the commits and the writeup of this report is automatically
> done by a little script[1].  I'm going to run the tool and post this kind of
> report every couple of weeks or every month.  Any comment (e.g., regarding
> posting period, new features request, bug report, ...) is welcome.
> 
> Especially, if you find some commits that don't need to be merged in the
> downstream, please let me know so that I can mark those as unnecessary and
> don't bother you again.
> 
> [1] https://github.com/sjp38/stream-track
> 
> 
> Thanks,
> SeongJae
> 
> 
> # v5.5: 4e3112a240ba9986cc3f67a6880da6529a955006
> # linus/master: 15bc20c6af4ceee97a1f90b43c0e386643c071b4
> # v5.4: 6e815efe19a99a33b16cc720c3d3a727565a4fa1
> # stable/linux-5.4.y: 6576d69aac94cd8409636dfa86e0df39facdf0d2
> 
> 
> Fixes cleanly applicable
> ------------------------
> 
> 2fb75ceaf71a ("remoteproc: Add missing '\n' in log messages")
> # commit date: 2020-04-22, author: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> # fixes 'remoteproc: Fix NULL pointer dereference in rproc_virtio_notify'

Not a real fix, right?

> 1b9ae0c92925 ("wireless: Use linux/stddef.h instead of stddef.h")
> # commit date: 2020-05-27, author: Hauke Mehrtens <hauke@hauke-m.de>
> # fixes 'wireless: Use offsetof instead of custom macro.'

Is this really needed?

> e4b0e41fee94 ("ALSA: usb-audio: Use the new macro for HP Dock rename quirks")
> # commit date: 2020-06-08, author: Takashi Iwai <tiwai@suse.de>
> # fixes 'ALSA: usb-audio: Add vendor, product and profile name for HP Thunderbolt Dock'

Alsa stuff has been covered already...

> efb94790852a ("drm/panel-simple: fix connector type for LogicPD Type28 Display")
> # commit date: 2020-06-21, author: Adam Ford <aford173@gmail.com>
> # fixes 'drm/panel: simple: Add Logic PD Type 28 display support'

Why is this applicable to 5.4.y?  It says "5.6+" in the commit itself,
right?

> 
> 2f57b8d57673 ("dmaengine: imx-sdma: Fix: Remove 'always true' comparison")
> # commit date: 2020-06-24, author: Fabio Estevam <festevam@gmail.com>
> # fixes 'dmaengine: imx-sdma: Fix the event id check to include RX event for UART6'

Does not change any logic

> 
> 10de795a5add ("kprobes: Fix compiler warning for !CONFIG_KPROBES_ON_FTRACE")
> # commit date: 2020-08-06, author: Muchun Song <songmuchun@bytedance.com>
> # fixes 'kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler'

Not needed, as mentioned.

> Fixes not cleanly applicable

<snip>

Stopping right here, if you have fixes that will not cleanly apply, and
you think they should be applied, please fix them and send the proper
backport.  I don't have the cycles to do these on my own.

Same for anything else here that you think should be applied but does
not cleanly build/apply.


> ----------------------------
> 
> 3907ccfaec5d ("crypto: atmel-aes - Fix CTR counter overflow when multiple fragments")
> # commit date: 2019-12-20, author: Tudor Ambarus <tudor.ambarus@microchip.com>
> # fixes 'crypto: atmel-aes - Fix counter overflow in CTR mode'
> 
> 9210c075cef2 ("nvme-pci: avoid race between nvme_reap_pending_cqes() and nvme_poll()")
> # commit date: 2020-05-27, author: Dongli Zhang <dongli.zhang@oracle.com>
> # fixes 'nvme/pci: move cqe check after device shutdown'
> 
> 6e2f83884c09 ("bnxt_en: Fix AER reset logic on 57500 chips.")
> # commit date: 2020-06-15, author: Michael Chan <michael.chan@broadcom.com>
> # fixes 'bnxt_en: Improve AER slot reset.'
> 
> 695cf5ab401c ("ALSA: usb-audio: Fix packet size calculation")
> # commit date: 2020-06-30, author: Alexander Tsoy <alexander@tsoy.me>
> # fixes 'ALSA: usb-audio: Improve frames size computation'
> 
> 2fb2799a2abb ("net: rmnet: do not allow to add multiple bridge interfaces")
> # commit date: 2020-07-04, author: Taehee Yoo <ap420073@gmail.com>
> # fixes 'net: rmnet: use upper/lower device infrastructure'
> 
> 
> 
> Mentions cleanly applicable
> ---------------------------
> 
> 32ada3b9e04c ("x86/resctrl: Clean up unused function parameter in mkdir path")
> # commit date: 2020-01-20, author: Xiaochen Shen <xiaochen.shen@intel.com>
> # mentions 'x86/resctrl: Fix a deadlock due to inaccurate reference'
> 
> 20f513091caf ("crypto: ccree - remove set but not used variable 'du_size'")
> # commit date: 2020-02-13, author: YueHaibing <yuehaibing@huawei.com>
> # mentions 'crypto: ccree - fix FDE descriptor sequence'

Oh come on, why is this tripping anything?

Please read the patches and see if you think they make sense for a
stable kernel, please tell me how the above one does?

stopping here...

greg k-h
