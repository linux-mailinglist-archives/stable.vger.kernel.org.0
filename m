Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B480F38E257
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 10:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbhEXIeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 04:34:16 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:60927 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232347AbhEXIeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 04:34:16 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 759E519408A0;
        Mon, 24 May 2021 04:32:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 24 May 2021 04:32:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kSkeM0
        fIw/2zNuOI7Z7CqItKFznZkvdOigGLvfRvKN4=; b=drgkcXKGTBWd9cPiBbZ8Bt
        6UiOWKJYuwFZgJUyFTvzPCEDDj4s7im78GU2JDHMngi6u+RrsSaYOUa205jEAkKp
        X6f6sT3Aum7wqD+Phd9Cs7Na5nHN4yqEfb+28O8jAwhbQKunt2tSrM/UUCy4uXDI
        TQgVcK3hrv/cKSFUHkC1utdITYn3Q5omXLOtwDqF37CFMeAA7VTS9YT9kUduMYnJ
        czuAQ5yZDcDqSy38fYR98P4Sp+5hEjuuEkD2Xq2o5GWQJZCZzzjfA0kkV5wHHTED
        EuTCiVhyCtE3N186jnzID0Q2+JRLy2Ud0bJbRP5hgg06ENUV5OBBsyTFGU0rj1Sg
        ==
X-ME-Sender: <xms:r2SrYNWhgdJP07mwTylBbxySXRosf8cnWAJjbngsbjCuQ9XC_fiVlg>
    <xme:r2SrYNlh6UY4PfBx5md_C1Fov58cwGbFwkEtx20Cv9LzcxWUtTElEQHzTbY2-1FmX
    58oKt3kYHf_OQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:r2SrYJb3szgILMLjdZquXG8IU1u9Hkhez5fR92H4RUzEKDsv5U0VUA>
    <xmx:r2SrYAWbPGyG5A0sHZDiEGmq3iwuTAskL21pj90woM31Xj9JsT27vg>
    <xmx:r2SrYHlD9AP2WFoABYT1KClaX5NWrmtcWW-uxyxmfYMq8SeIYFABHw>
    <xmx:sGSrYPshKDYCel2rqJ5cKNfLidxByjrtxK50qfGFHUOHdSB73P5BYg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 04:32:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: avoid RCU stalls while running delayed iputs" failed to apply to 4.14-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, riel@surriel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 May 2021 10:32:37 +0200
Message-ID: <162184515744137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 71795ee590111e3636cc3c148289dfa9fa0a5fc3 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 29 Apr 2021 10:51:34 -0400
Subject: [PATCH] btrfs: avoid RCU stalls while running delayed iputs

Generally a delayed iput is added when we might do the final iput, so
usually we'll end up sleeping while processing the delayed iputs
naturally.  However there's no guarantee of this, especially for small
files.  In production we noticed 5 instances of RCU stalls while testing
a kernel release overnight across 1000 machines, so this is relatively
common:

  host count: 5
  rcu: INFO: rcu_sched self-detected stall on CPU
  rcu: ....: (20998 ticks this GP) idle=59e/1/0x4000000000000002 softirq=12333372/12333372 fqs=3208
   	(t=21031 jiffies g=27810193 q=41075) NMI backtrace for cpu 1
  CPU: 1 PID: 1713 Comm: btrfs-cleaner Kdump: loaded Not tainted 5.6.13-0_fbk12_rc1_5520_gec92bffc1ec9 #1
  Call Trace:
    <IRQ> dump_stack+0x50/0x70
    nmi_cpu_backtrace.cold.6+0x30/0x65
    ? lapic_can_unplug_cpu.cold.30+0x40/0x40
    nmi_trigger_cpumask_backtrace+0xba/0xca
    rcu_dump_cpu_stacks+0x99/0xc7
    rcu_sched_clock_irq.cold.90+0x1b2/0x3a3
    ? trigger_load_balance+0x5c/0x200
    ? tick_sched_do_timer+0x60/0x60
    ? tick_sched_do_timer+0x60/0x60
    update_process_times+0x24/0x50
    tick_sched_timer+0x37/0x70
    __hrtimer_run_queues+0xfe/0x270
    hrtimer_interrupt+0xf4/0x210
    smp_apic_timer_interrupt+0x5e/0x120
    apic_timer_interrupt+0xf/0x20 </IRQ>
   RIP: 0010:queued_spin_lock_slowpath+0x17d/0x1b0
   RSP: 0018:ffffc9000da5fe48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
   RAX: 0000000000000000 RBX: ffff889fa81d0cd8 RCX: 0000000000000029
   RDX: ffff889fff86c0c0 RSI: 0000000000080000 RDI: ffff88bfc2da7200
   RBP: ffff888f2dcdd768 R08: 0000000001040000 R09: 0000000000000000
   R10: 0000000000000001 R11: ffffffff82a55560 R12: ffff88bfc2da7200
   R13: 0000000000000000 R14: ffff88bff6c2a360 R15: ffffffff814bd870
   ? kzalloc.constprop.57+0x30/0x30
   list_lru_add+0x5a/0x100
   inode_lru_list_add+0x20/0x40
   iput+0x1c1/0x1f0
   run_delayed_iput_locked+0x46/0x90
   btrfs_run_delayed_iputs+0x3f/0x60
   cleaner_kthread+0xf2/0x120
   kthread+0x10b/0x130

Fix this by adding a cond_resched_lock() to the loop processing delayed
iputs so we can avoid these sort of stalls.

CC: stable@vger.kernel.org # 4.9+
Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 69fcdf8f0b1c..095e452f59f0 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3246,6 +3246,7 @@ void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info)
 		inode = list_first_entry(&fs_info->delayed_iputs,
 				struct btrfs_inode, delayed_iput);
 		run_delayed_iput_locked(fs_info, inode);
+		cond_resched_lock(&fs_info->delayed_iput_lock);
 	}
 	spin_unlock(&fs_info->delayed_iput_lock);
 }

