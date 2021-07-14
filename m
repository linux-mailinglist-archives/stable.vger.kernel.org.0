Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D113C859C
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 15:53:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbhGNN4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 09:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbhGNN4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 09:56:03 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816D0C061762
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 06:53:11 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so2533926otl.3
        for <stable@vger.kernel.org>; Wed, 14 Jul 2021 06:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LD0zUI7guc2XP54Q5Kxn20fLqM8O66uBYKWZO+0h1eo=;
        b=SYrwEi2oCQf5MnxznMGCctDGiXw1JWgplVy5ceB7EBIxDdUYZuoauEYZdgoy7f9yro
         UoyPV5odKbH1xOFFF8M/oCz74Ia3/cId0dqH6Ju9y2AhLA9CaPitWs9xQQ+QJMdorilm
         uwAr6pl+yfKwR4B+Dsl9lbNSz38OgBvpfxlSAzTcKFFt5OvdyEbuUYFViwLt0L3itAu7
         O2vs8O/FA472q/PYWX+xxqgebwYHjvlY4NWljyPv3Pq2B5u+AXe7baVKp1KRdkwtA5oW
         D1/wU1tJYpEa6d55qLEm4we4s+M6+WMXFbXr/lRIBXWV6ZMTq8vN9gNkqQCYws+6rhhW
         jCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LD0zUI7guc2XP54Q5Kxn20fLqM8O66uBYKWZO+0h1eo=;
        b=jdKLqLbyTtCNButi5nFgxa5MrKyObprgYYR+MoS7rTm2dkFipV786PYXBP7x4KfctP
         +Mvz5fwPDq5+qvXtyoy4Rgjglk3A1H/ttz77mrSuEORQNcQqs2HbIQf1A4mfbUPdgAlr
         VtfOlkLk67qfeMWVtJKQAR/yZmGiNmywhCQ7j+7W3xXE7flk43nkxLjwTOoXu9I2Cwht
         Lo1E3McOGhtdZAN1TGuuUwD0XanMDLLynAFb5YRBWY8eV/mIuOn+ToOGl90XCZpjCxuG
         alsA+GYwqB46YpQIOATqJ+0n+4+cdMJxzbRDT9NM5Ajs9Z/ruqDRtvWE2wH9j4GuBSZF
         +nFg==
X-Gm-Message-State: AOAM530/kQ4Ct3zlWFItPDfZCWsVg2BjE1j8x6d2pwy0GMgdmtN8aaUL
        PZHhDJuu815gKh5shZvYjpF0UCe89YR45bWhHxvjqw==
X-Google-Smtp-Source: ABdhPJwL0AW2A1gBb45Va21zUYLzLWltQ9iclUc0bnMrzn+m+7qBvcYcEDtNcavVj0mtWlGyKhTdG7OrsmpcHw5R6E4=
X-Received: by 2002:a9d:27a4:: with SMTP id c33mr8463777otb.281.1626270790600;
 Wed, 14 Jul 2021 06:53:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210712060912.995381202@linuxfoundation.org> <68b6051-09c-9dc8-4b52-c4e766fee5@praktifix.dwd.de>
 <YO56HTE3k95JLeje@kroah.com> <50fb4713-6b5d-b5e0-786a-6ece57896d2f@praktifix.dwd.de>
 <df63b875-f140-606a-862a-73b102345cd@praktifix.dwd.de> <YO7nHhW2t4wEiI9G@kroah.com>
In-Reply-To: <YO7nHhW2t4wEiI9G@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 14 Jul 2021 19:22:59 +0530
Message-ID: <CA+G9fYuhbE6sY3ykoiyqZqYSG=+V0r3z0TiaVL8LptbXWw=duQ@mail.gmail.com>
Subject: Re: [PATCH 5.13 000/800] 5.13.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Holger Kiehl <Holger.Kiehl@dwd.de>, Jan Kara <jack@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Jul 2021 at 19:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jul 14, 2021 at 01:26:26PM +0000, Holger Kiehl wrote:
> > On Wed, 14 Jul 2021, Holger Kiehl wrote:
> >
> > > On Wed, 14 Jul 2021, Greg Kroah-Hartman wrote:
> > >
> > > > On Wed, Jul 14, 2021 at 05:39:43AM +0000, Holger Kiehl wrote:
> > > > > Hello,
> > > > >
> > > > > On Mon, 12 Jul 2021, Greg Kroah-Hartman wrote:
> > > > >
> > > > > > This is the start of the stable review cycle for the 5.13.2 release.
> > > > > > There are 800 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > >
> > > > > > Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> > > > > > Anything received after that time might be too late.
> > > > > >
> > > > > With this my system no longer boots:
> > > > >
> > > > >    [  OK  ] Reached target Swap.
> > > > >    [   75.213852] NMI watchdog: Watchdog detected hard LOCKUP on cpu 0
> > > > >    [   75.213926] NMI watchdog: Watchdog detected hard LOCKUP on cpu 2
> > > > >    [   75.213962] NMI watchdog: Watchdog detected hard LOCKUP on cpu 4
> > > > >    [FAILED] Failed to start Wait for udev To Complete Device Initialization.
> > > > >    See 'systemctl status systemd-udev-settle.service' for details.
> > > > >             Starting Activation of DM RAID sets...
> > > > >    [      ] (1 of 2) A start job is running for Activation of DM RAID sets (..min ..s / no limit)
> > > > >    [      ] (2 of 2) A start job is running for Monitoring of LVM2 mirrors, snapshots etc. using dmeventd or progress polling (..min ..s / no limit)
> > > > >
> > > > > System is a Fedora 34 with all updates applied. Two other similar
> > > > > systems with AMD CPUs (Ryzen 4750G + 3400G) this does not happen
> > > > > and boots fine. The system where it does not boot has an Intel
> > > > > Xeon E3-1285L v4 CPU. All of them use a dm_crypt root filesystem.
> > > > >
> > > > > Any idea which patch I should drop to see if it boots again. I already
> > > > > dropped
> > > > >
> > > > >    [PATCH 5.13 743/800] ASoC: Intel: sof_sdw: add quirk support for Brya and BT-offload
> > > > >
> > > > > and I just see that this one should also be dropped:
> > > > >
> > > > >    [PATCH 5.13 768/800] hugetlb: address ref count racing in prep_compound_gigantic_page
> > > > >
> > > > > Will still need to test this.
> > > >
> > > > Can you run 'git bisect' to see what commit causes the problem?
> > > >
> > > Yes, will try to do that. I think it will take some time ...
> > >
> > With the help of Pavel Machek and Jiri Slaby I was able 'git bisect'
> > this to:
> >
> >    yoda:/usr/src/kernels/linux-5.13.y# git bisect good
> >    a483f513670541227e6a31ac7141826b8c785842 is the first bad commit
> >    commit a483f513670541227e6a31ac7141826b8c785842
> >    Author: Jan Kara <jack@suse.cz>
> >    Date:   Wed Jun 23 11:36:33 2021 +0200
> >
> >        bfq: Remove merged request already in bfq_requests_merged()
> >
> >        [ Upstream commit a921c655f2033dd1ce1379128efe881dda23ea37 ]
> >
> >        Currently, bfq does very little in bfq_requests_merged() and handles all
> >        the request cleanup in bfq_finish_requeue_request() called from
> >        blk_mq_free_request(). That is currently safe only because
> >        blk_mq_free_request() is called shortly after bfq_requests_merged()
> >        while bfqd->lock is still held. However to fix a lock inversion between
> >        bfqd->lock and ioc->lock, we need to call blk_mq_free_request() after
> >        dropping bfqd->lock. That would mean that already merged request could
> >        be seen by other processes inside bfq queues and possibly dispatched to
> >        the device which is wrong. So move cleanup of the request from
> >        bfq_finish_requeue_request() to bfq_requests_merged().
> >
> >        Acked-by: Paolo Valente <paolo.valente@linaro.org>
> >        Signed-off-by: Jan Kara <jack@suse.cz>
> >        Link: https://lore.kernel.org/r/20210623093634.27879-2-jack@suse.cz
> >        Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >        Signed-off-by: Sasha Levin <sashal@kernel.org>
> >
> >     block/bfq-iosched.c | 41 +++++++++++++----------------------------
> >     1 file changed, 13 insertions(+), 28 deletions(-)
> >
> > Holger
>
> Wonderful!



My two cents,
While running ssuite long running stress testing we have noticed deadlock.

> So if you drop that, all works well?  I'll go drop that from the queues
> now.

Let me drop that patch and test it again.

Crash log,

[ 1957.278399] ============================================
[ 1957.283717] WARNING: possible recursive locking detected
[ 1957.289031] 5.13.2-rc1 #1 Not tainted
[ 1957.292703] --------------------------------------------
[ 1957.298016] kworker/u8:7/236 is trying to acquire lock:
[ 1957.303241] ffff8cc203f92c38 (&bfqd->lock){-.-.}-{2:2}, at:
bfq_finish_requeue_request+0x55/0x500 [bfq]
[ 1957.312643]
[ 1957.312643] but task is already holding lock:
[ 1957.318467] ffff8cc203f92c38 (&bfqd->lock){-.-.}-{2:2}, at:
bfq_insert_requests+0x81/0x1750 [bfq]
[ 1957.327334]
[ 1957.327334] other info that might help us debug this:
[ 1957.333852]  Possible unsafe locking scenario:
[ 1957.333852]
[ 1957.339762]        CPU0
[ 1957.342206]        ----
[ 1957.344651]   lock(&bfqd->lock);
[ 1957.347873]   lock(&bfqd->lock);
[ 1957.351097]
[ 1957.351097]  *** DEADLOCK ***
[ 1957.351097]
[ 1957.357008]  May be due to missing lock nesting notation
[ 1957.357008]
[ 1957.363783] 3 locks held by kworker/u8:7/236:
[ 1957.368136]  #0: ffff8cc2009c5938
((wq_completion)writeback){+.+.}-{0:0}, at:
process_one_work+0x207/0x5e0
[ 1957.377782]  #1: ffff9ba980d57e68
((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at:
process_one_work+0x207/0x5e0
[ 1957.388640]  #2: ffff8cc203f92c38 (&bfqd->lock){-.-.}-{2:2}, at:
bfq_insert_requests+0x81/0x1750 [bfq]
[ 1957.397938]
[ 1957.397938] stack backtrace:
[ 1957.402291] CPU: 1 PID: 236 Comm: kworker/u8:7 Not tainted 5.13.2-rc1 #1
[ 1957.408989] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[ 1957.416374] Workqueue: writeback wb_workfn (flush-8:0)
[ 1957.421513] Call Trace:
[ 1957.423966]  dump_stack+0x76/0x95
[ 1957.427283]  __lock_acquire+0xb70/0x1a50
[ 1957.431203]  ? lock_is_held_type+0xa0/0x110
[ 1957.435388]  ? bfq_init_rq+0x30e/0x1140 [bfq]
[ 1957.439748]  lock_acquire+0x258/0x2e0
[ 1957.443413]  ? bfq_finish_requeue_request+0x55/0x500 [bfq]
[ 1957.448923]  ? __lock_acquire+0x4a6/0x1a50
[ 1957.453016]  ? __lock_acquire+0x3e0/0x1a50
[ 1957.457107]  _raw_spin_lock_irqsave+0x3f/0x60
[ 1957.461466]  ? bfq_finish_requeue_request+0x55/0x500 [bfq]
[ 1957.466950]  bfq_finish_requeue_request+0x55/0x500 [bfq]
[ 1957.472256]  ? rcu_read_lock_sched_held+0x4f/0x80
[ 1957.476960]  blk_mq_free_request+0x3e/0x140
[ 1957.481146]  blk_put_request+0xe/0x10
[ 1957.484804]  blk_attempt_req_merge+0x1d/0x30
[ 1957.489075]  elv_attempt_insert_merge+0x34/0x90
[ 1957.493599]  blk_mq_sched_try_insert_merge+0x2c/0x50
[ 1957.498556]  bfq_insert_requests+0x8d/0x1750 [bfq]
[ 1957.503342]  ? find_held_lock+0x35/0xa0
[ 1957.507180]  ? writeback_sb_inodes+0x35a/0x550
[ 1957.511618]  blk_mq_sched_insert_requests+0xd9/0x2a0
[ 1957.516580]  blk_mq_flush_plug_list+0x138/0x270
[ 1957.521110]  blk_flush_plug_list+0xd1/0x100
[ 1957.525295]  blk_finish_plug+0x2c/0x40
[ 1957.529045]  wb_writeback+0x1ab/0x430
[ 1957.532702]  ? _raw_spin_unlock_bh+0x30/0x40
[ 1957.536970]  wb_workfn+0xcb/0x660
[ 1957.540286]  ? wb_workfn+0xcb/0x660
[ 1957.543770]  ? lock_acquire+0x258/0x2e0
[ 1957.547600]  ? process_one_work+0x207/0x5e0
[ 1957.551778]  process_one_work+0x289/0x5e0
[ 1957.555782]  ? inode_wait_for_writeback+0x40/0x40
[ 1957.560477]  ? process_one_work+0x289/0x5e0
[ 1957.564656]  worker_thread+0x3c/0x3f0
[ 1957.568315]  ? process_one_work+0x5e0/0x5e0
[ 1957.572500]  kthread+0x14c/0x170
[ 1957.575733]  ? set_kthread_struct+0x40/0x40
[ 1957.579921]  ret_from_fork+0x22/0x30
Waiting for transitory to terminate: 5[0KWaiting for transitory to
terminate: 4[0K[ 2106.390977] systemd[1]: systemd-resolved.service:
Watchdog timeout (limit 3min)!
[ 2106.398454] systemd[1]: systemd-resolved.service: Killing process
349 (systemd-resolve) with signal SIGABRT.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

ref:
https://lkft.validation.linaro.org/scheduler/job/3058868#L2922

- Naresh
