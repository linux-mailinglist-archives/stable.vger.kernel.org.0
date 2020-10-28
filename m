Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0788429D6A0
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgJ1WQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731136AbgJ1WQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:16:55 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C837C0613CF
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 15:16:55 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r10so653750pgb.10
        for <stable@vger.kernel.org>; Wed, 28 Oct 2020 15:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language;
        bh=W9DftUEI45xru0idEhXVo0USPZhsJmhI30J7lW/fCvM=;
        b=M1IR7iMSZqv43JT7IBCV3m/J3VKr/meg11GZU2jtlIxjKuqOhWvTdTufrtlmDiPs9V
         nT+llEJawUZoTzP7Q9TfJHI63y2GrQhlygiYjVaK0JnCtuVI5uWhbIyNENwzd/Ab+Vjz
         BFVdvPJoRWS5t2ZRbwQCZRffq+YgJe+ozON/pKgGNQ/KdxnYF+DBu7ic0P7bHofIuL0X
         TPBCWOW6L9etJNERpYCRVf1CoW1Fmfg0ewt8HqjdBwdiuOcsTDTFfilUFUReWGUojqIv
         szZdHOd7uKwF6KX5y4DmtXCGhQMCBnzXn4FITep7v/24ewy63nu3dEqQv/TqpF1ioaq/
         l8sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language;
        bh=W9DftUEI45xru0idEhXVo0USPZhsJmhI30J7lW/fCvM=;
        b=eVq966BwfNpKgvJgHluq84t7z+k1NI2ccN/i13U9SfsookRcMz+UjpnVdE/jPY/qF9
         SFAeHDus1V/8KEqXsoz7GlSbqNYtLv5HOA6GNCVVdFKTKKsYZy1TQMs+rLr3OvjTpPNU
         VRjbWanAs+eFY25eUUgg3EHnTJbA5XVStc2p7kmRKlfUwKJFJBHL/iOZQaVmPpE71ysC
         t+1I3sBxMQXJ6CbasTpQM4+f3lZyEMABZcKJz7VZi+CmmZXgmmQvNdPH60nEC6842bFv
         yb07efG6Bn+nY+iT1UeBpO2h5eaB3nGe75tibhm1thSwGBHG29mE9/LG68G74y2FGi0P
         R/Mg==
X-Gm-Message-State: AOAM531AyBwef/9Chf4B+Wv7xuuCPk65LB2HHHDdJNz1l2ayG4LU1G9l
        L2m8IQtICVpZ7WMU+9OavwfMH7A8K/TvhA==
X-Google-Smtp-Source: ABdhPJzqHqn6Cq48TSvBssy1VUgmRs9Vf9TWlFQzbYgvsFreJF7ROJ8okY8NGCG30ZwIVoQm3qVnGw==
X-Received: by 2002:a05:6602:2181:: with SMTP id b1mr176410iob.172.1603902685391;
        Wed, 28 Oct 2020 09:31:25 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g185sm2928811ilh.35.2020.10.28.09.31.23
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 09:31:23 -0700 (PDT)
To:     stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: 5.9 stable inclusion request
Message-ID: <115609b0-9167-dfda-85eb-de8d87f33e75@kernel.dk>
Date:   Wed, 28 Oct 2020 10:31:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------4A1C62D62F0A548A85843422"
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------4A1C62D62F0A548A85843422
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi,

Please include this series of patches for 5.9-stable, thanks.

-- 
Jens Axboe


--------------4A1C62D62F0A548A85843422
Content-Type: text/x-patch; charset=UTF-8;
 name="0014-io_uring-Convert-advanced-XArray-uses-to-the-normal-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0014-io_uring-Convert-advanced-XArray-uses-to-the-normal-.pa";
 filename*1="tch"

From 20a4be151c4ba3025e11acdd739fb420393a9ae5 Mon Sep 17 00:00:00 2001
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Fri, 9 Oct 2020 13:49:53 +0100
Subject: [PATCH 14/14] io_uring: Convert advanced XArray uses to the normal
 API

commit 5e2ed8c4f45093698855b1f45cdf43efbf6dd498 upstream.

There are no bugs here that I've spotted, it's just easier to use the
normal API and there are no performance advantages to using the more
verbose advanced API.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 82c5bd58042a..f333ead8dc4e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8365,27 +8365,17 @@ static int io_uring_add_task_file(struct file *file)
 static void io_uring_del_task_file(struct file *file)
 {
 	struct io_uring_task *tctx = current->io_uring;
-	XA_STATE(xas, &tctx->xa, (unsigned long) file);
 
 	if (tctx->last == file)
 		tctx->last = NULL;
-
-	xas_lock(&xas);
-	file = xas_store(&xas, NULL);
-	xas_unlock(&xas);
-
+	file = xa_erase(&tctx->xa, (unsigned long)file);
 	if (file)
 		fput(file);
 }
 
 static void __io_uring_attempt_task_drop(struct file *file)
 {
-	XA_STATE(xas, &current->io_uring->xa, (unsigned long) file);
-	struct file *old;
-
-	rcu_read_lock();
-	old = xas_load(&xas);
-	rcu_read_unlock();
+	struct file *old = xa_load(&current->io_uring->xa, (unsigned long)file);
 
 	if (old == file)
 		io_uring_del_task_file(file);
-- 
2.29.0


--------------4A1C62D62F0A548A85843422
Content-Type: text/x-patch; charset=UTF-8;
 name="0013-io_uring-Fix-XArray-usage-in-io_uring_add_task_file.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0013-io_uring-Fix-XArray-usage-in-io_uring_add_task_file.pat";
 filename*1="ch"

From b267238d1bf7c09f6f9c23b6b7547ab1e5b11cfc Mon Sep 17 00:00:00 2001
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Fri, 9 Oct 2020 13:49:52 +0100
Subject: [PATCH 13/14] io_uring: Fix XArray usage in io_uring_add_task_file

commit 236434c3438c4da3dfbd6aeeab807577b85e951a upstream.

The xas_store() wasn't paired with an xas_nomem() loop, so if it couldn't
allocate memory using GFP_NOWAIT, it would leak the reference to the file
descriptor.  Also the node pointed to by the xas could be freed between
the call to xas_load() under the rcu_read_lock() and the acquisition of
the xa_lock.

It's easier to just use the normal xa_load/xa_store interface here.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
[axboe: fix missing assign after alloc, cur_uring -> tctx rename]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9a428f0abdf6..82c5bd58042a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8336,27 +8336,24 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
  */
 static int io_uring_add_task_file(struct file *file)
 {
-	if (unlikely(!current->io_uring)) {
+	struct io_uring_task *tctx = current->io_uring;
+
+	if (unlikely(!tctx)) {
 		int ret;
 
 		ret = io_uring_alloc_task_context(current);
 		if (unlikely(ret))
 			return ret;
+		tctx = current->io_uring;
 	}
-	if (current->io_uring->last != file) {
-		XA_STATE(xas, &current->io_uring->xa, (unsigned long) file);
-		void *old;
+	if (tctx->last != file) {
+		void *old = xa_load(&tctx->xa, (unsigned long)file);
 
-		rcu_read_lock();
-		old = xas_load(&xas);
-		if (old != file) {
+		if (!old) {
 			get_file(file);
-			xas_lock(&xas);
-			xas_store(&xas, file);
-			xas_unlock(&xas);
+			xa_store(&tctx->xa, (unsigned long)file, file, GFP_KERNEL);
 		}
-		rcu_read_unlock();
-		current->io_uring->last = file;
+		tctx->last = file;
 	}
 
 	return 0;
-- 
2.29.0


--------------4A1C62D62F0A548A85843422
Content-Type: text/x-patch; charset=UTF-8;
 name="0012-io_uring-Fix-use-of-XArray-in-__io_uring_files_cance.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0012-io_uring-Fix-use-of-XArray-in-__io_uring_files_cance.pa";
 filename*1="tch"

From 68798e6df7ae32afddc3a3a5971620b92ff192c9 Mon Sep 17 00:00:00 2001
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Fri, 9 Oct 2020 13:49:51 +0100
Subject: [PATCH 12/14] io_uring: Fix use of XArray in __io_uring_files_cancel

commit ce765372bc443573d1d339a2bf4995de385dea3a upstream.

We have to drop the lock during each iteration, so there's no advantage
to using the advanced API.  Convert this to a standard xa_for_each() loop.

Reported-by: syzbot+27c12725d8ff0bfe1a13@syzkaller.appspotmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cdce7598b981..9a428f0abdf6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8415,28 +8415,19 @@ static void io_uring_attempt_task_drop(struct file *file, bool exiting)
 void __io_uring_files_cancel(struct files_struct *files)
 {
 	struct io_uring_task *tctx = current->io_uring;
-	XA_STATE(xas, &tctx->xa, 0);
+	struct file *file;
+	unsigned long index;
 
 	/* make sure overflow events are dropped */
 	tctx->in_idle = true;
 
-	do {
-		struct io_ring_ctx *ctx;
-		struct file *file;
-
-		xas_lock(&xas);
-		file = xas_next_entry(&xas, ULONG_MAX);
-		xas_unlock(&xas);
-
-		if (!file)
-			break;
-
-		ctx = file->private_data;
+	xa_for_each(&tctx->xa, index, file) {
+		struct io_ring_ctx *ctx = file->private_data;
 
 		io_uring_cancel_task_requests(ctx, files);
 		if (files)
 			io_uring_del_task_file(file);
-	} while (1);
+	}
 }
 
 static inline bool io_uring_task_idle(struct io_uring_task *tctx)
-- 
2.29.0


--------------4A1C62D62F0A548A85843422
Content-Type: text/x-patch; charset=UTF-8;
 name="0011-io_uring-no-need-to-call-xa_destroy-on-empty-xarray.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0011-io_uring-no-need-to-call-xa_destroy-on-empty-xarray.pat";
 filename*1="ch"

From b2275a21e9218c8de937169cb1260a4e37e4c07e Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 8 Oct 2020 07:46:52 -0600
Subject: [PATCH 11/14] io_uring: no need to call xa_destroy() on empty xarray

commit ca6484cd308a671811bf39f3119e81966eb476e3 upstream.

The kernel test robot reports this lockdep issue:

[child1:659] mbind (274) returned ENOSYS, marking as inactive.
[child1:659] mq_timedsend (279) returned ENOSYS, marking as inactive.
[main] 10175 iterations. [F:7781 S:2344 HI:2397]
[   24.610601]
[   24.610743] ================================
[   24.611083] WARNING: inconsistent lock state
[   24.611437] 5.9.0-rc7-00017-g0f2122045b9462 #5 Not tainted
[   24.611861] --------------------------------
[   24.612193] inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
[   24.612660] ksoftirqd/0/7 [HC0[0]:SC1[3]:HE0:SE0] takes:
[   24.613086] f00ed998 (&xa->xa_lock#4){+.?.}-{2:2}, at: xa_destroy+0x43/0xc1
[   24.613642] {SOFTIRQ-ON-W} state was registered at:
[   24.614024]   lock_acquire+0x20c/0x29b
[   24.614341]   _raw_spin_lock+0x21/0x30
[   24.614636]   io_uring_add_task_file+0xe8/0x13a
[   24.614987]   io_uring_create+0x535/0x6bd
[   24.615297]   io_uring_setup+0x11d/0x136
[   24.615606]   __ia32_sys_io_uring_setup+0xd/0xf
[   24.615977]   do_int80_syscall_32+0x53/0x6c
[   24.616306]   restore_all_switch_stack+0x0/0xb1
[   24.616677] irq event stamp: 939881
[   24.616968] hardirqs last  enabled at (939880): [<8105592d>] __local_bh_enable_ip+0x13c/0x145
[   24.617642] hardirqs last disabled at (939881): [<81b6ace3>] _raw_spin_lock_irqsave+0x1b/0x4e
[   24.618321] softirqs last  enabled at (939738): [<81b6c7c8>] __do_softirq+0x3f0/0x45a
[   24.618924] softirqs last disabled at (939743): [<81055741>] run_ksoftirqd+0x35/0x61
[   24.619521]
[   24.619521] other info that might help us debug this:
[   24.620028]  Possible unsafe locking scenario:
[   24.620028]
[   24.620492]        CPU0
[   24.620685]        ----
[   24.620894]   lock(&xa->xa_lock#4);
[   24.621168]   <Interrupt>
[   24.621381]     lock(&xa->xa_lock#4);
[   24.621695]
[   24.621695]  *** DEADLOCK ***
[   24.621695]
[   24.622154] 1 lock held by ksoftirqd/0/7:
[   24.622468]  #0: 823bfb94 (rcu_callback){....}-{0:0}, at: rcu_process_callbacks+0xc0/0x155
[   24.623106]
[   24.623106] stack backtrace:
[   24.623454] CPU: 0 PID: 7 Comm: ksoftirqd/0 Not tainted 5.9.0-rc7-00017-g0f2122045b9462 #5
[   24.624090] Call Trace:
[   24.624284]  ? show_stack+0x40/0x46
[   24.624551]  dump_stack+0x1b/0x1d
[   24.624809]  print_usage_bug+0x17a/0x185
[   24.625142]  mark_lock+0x11d/0x1db
[   24.625474]  ? print_shortest_lock_dependencies+0x121/0x121
[   24.625905]  __lock_acquire+0x41e/0x7bf
[   24.626206]  lock_acquire+0x20c/0x29b
[   24.626517]  ? xa_destroy+0x43/0xc1
[   24.626810]  ? lock_acquire+0x20c/0x29b
[   24.627110]  _raw_spin_lock_irqsave+0x3e/0x4e
[   24.627450]  ? xa_destroy+0x43/0xc1
[   24.627725]  xa_destroy+0x43/0xc1
[   24.627989]  __io_uring_free+0x57/0x71
[   24.628286]  ? get_pid+0x22/0x22
[   24.628544]  __put_task_struct+0xf2/0x163
[   24.628865]  put_task_struct+0x1f/0x2a
[   24.629161]  delayed_put_task_struct+0xe2/0xe9
[   24.629509]  rcu_process_callbacks+0x128/0x155
[   24.629860]  __do_softirq+0x1a3/0x45a
[   24.630151]  run_ksoftirqd+0x35/0x61
[   24.630443]  smpboot_thread_fn+0x304/0x31a
[   24.630763]  kthread+0x124/0x139
[   24.631016]  ? sort_range+0x18/0x18
[   24.631290]  ? kthread_create_worker_on_cpu+0x17/0x17
[   24.631682]  ret_from_fork+0x1c/0x28

which is complaining about xa_destroy() grabbing the xa lock in an
IRQ disabling fashion, whereas the io_uring uses cases aren't interrupt
safe. This is really an xarray issue, since it should not assume the
lock type. But for our use case, since we know the xarray is empty at
this point, there's no need to actually call xa_destroy(). So just get
rid of it.

Fixes: 0f2122045b94 ("io_uring: don't rely on weak ->files references")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 05ec385a6094..cdce7598b981 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7536,7 +7536,6 @@ void __io_uring_free(struct task_struct *tsk)
 	struct io_uring_task *tctx = tsk->io_uring;
 
 	WARN_ON_ONCE(!xa_empty(&tctx->xa));
-	xa_destroy(&tctx->xa);
 	kfree(tctx);
 	tsk->io_uring = NULL;
 }
-- 
2.29.0


--------------4A1C62D62F0A548A85843422
Content-Type: text/x-patch; charset=UTF-8;
 name="0010-io-wq-fix-use-after-free-in-io_wq_worker_running.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0010-io-wq-fix-use-after-free-in-io_wq_worker_running.patch"

From a5cd006e24750ef019a70836606a061b79ca69a3 Mon Sep 17 00:00:00 2001
From: Hillf Danton <hdanton@sina.com>
Date: Sat, 26 Sep 2020 21:26:55 +0800
Subject: [PATCH 10/14] io-wq: fix use-after-free in io_wq_worker_running

commit c4068bf898ddaef791049a366828d9b84b467bda upstream.

The smart syzbot has found a reproducer for the following issue:

 ==================================================================
 BUG: KASAN: use-after-free in instrument_atomic_write include/linux/instrumented.h:71 [inline]
 BUG: KASAN: use-after-free in atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
 BUG: KASAN: use-after-free in io_wqe_inc_running fs/io-wq.c:301 [inline]
 BUG: KASAN: use-after-free in io_wq_worker_running+0xde/0x110 fs/io-wq.c:613
 Write of size 4 at addr ffff8882183db08c by task io_wqe_worker-0/7771

 CPU: 0 PID: 7771 Comm: io_wqe_worker-0 Not tainted 5.9.0-rc4-syzkaller #0
 Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
 Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x198/0x1fd lib/dump_stack.c:118
  print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
  __kasan_report mm/kasan/report.c:513 [inline]
  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
  check_memory_region_inline mm/kasan/generic.c:186 [inline]
  check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
  instrument_atomic_write include/linux/instrumented.h:71 [inline]
  atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
  io_wqe_inc_running fs/io-wq.c:301 [inline]
  io_wq_worker_running+0xde/0x110 fs/io-wq.c:613
  schedule_timeout+0x148/0x250 kernel/time/timer.c:1879
  io_wqe_worker+0x517/0x10e0 fs/io-wq.c:580
  kthread+0x3b5/0x4a0 kernel/kthread.c:292
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

 Allocated by task 7768:
  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
  kasan_set_track mm/kasan/common.c:56 [inline]
  __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
  kmem_cache_alloc_node_trace+0x17b/0x3f0 mm/slab.c:3594
  kmalloc_node include/linux/slab.h:572 [inline]
  kzalloc_node include/linux/slab.h:677 [inline]
  io_wq_create+0x57b/0xa10 fs/io-wq.c:1064
  io_init_wq_offload fs/io_uring.c:7432 [inline]
  io_sq_offload_start fs/io_uring.c:7504 [inline]
  io_uring_create fs/io_uring.c:8625 [inline]
  io_uring_setup+0x1836/0x28e0 fs/io_uring.c:8694
  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

 Freed by task 21:
  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
  kasan_set_track+0x1c/0x30 mm/kasan/common.c:56
  kasan_set_free_info+0x1b/0x30 mm/kasan/generic.c:355
  __kasan_slab_free+0xd8/0x120 mm/kasan/common.c:422
  __cache_free mm/slab.c:3418 [inline]
  kfree+0x10e/0x2b0 mm/slab.c:3756
  __io_wq_destroy fs/io-wq.c:1138 [inline]
  io_wq_destroy+0x2af/0x460 fs/io-wq.c:1146
  io_finish_async fs/io_uring.c:6836 [inline]
  io_ring_ctx_free fs/io_uring.c:7870 [inline]
  io_ring_exit_work+0x1e4/0x6d0 fs/io_uring.c:7954
  process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
  worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
  kthread+0x3b5/0x4a0 kernel/kthread.c:292
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

 The buggy address belongs to the object at ffff8882183db000
  which belongs to the cache kmalloc-1k of size 1024
 The buggy address is located 140 bytes inside of
  1024-byte region [ffff8882183db000, ffff8882183db400)
 The buggy address belongs to the page:
 page:000000009bada22b refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2183db
 flags: 0x57ffe0000000200(slab)
 raw: 057ffe0000000200 ffffea0008604c48 ffffea00086a8648 ffff8880aa040700
 raw: 0000000000000000 ffff8882183db000 0000000100000002 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff8882183daf80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  ffff8882183db000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 >ffff8882183db080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                       ^
  ffff8882183db100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8882183db180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ==================================================================

which is down to the comment below,

	/* all workers gone, wq exit can proceed */
	if (!nr_workers && refcount_dec_and_test(&wqe->wq->refs))
		complete(&wqe->wq->done);

because there might be multiple cases of wqe in a wq and we would wait
for every worker in every wqe to go home before releasing wq's resources
on destroying.

To that end, rework wq's refcount by making it independent of the tracking
of workers because after all they are two different things, and keeping
it balanced when workers come and go. Note the manager kthread, like
other workers, now holds a grab to wq during its lifetime.

Finally to help destroy wq, check IO_WQ_BIT_EXIT upon creating worker
and do nothing for exiting wq.

Cc: stable@vger.kernel.org # v5.5+
Reported-by: syzbot+45fa0a195b941764e0f0@syzkaller.appspotmail.com
Reported-by: syzbot+9af99580130003da82b1@syzkaller.appspotmail.com
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 116 ++++++++++++++++++++++++++---------------------------
 1 file changed, 58 insertions(+), 58 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index c1a7ef85844b..19db17e99cf9 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -202,7 +202,6 @@ static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wqe_acct *acct = io_wqe_get_acct(wqe, worker);
-	unsigned nr_workers;
 
 	/*
 	 * If we're not at zero, someone else is holding a brief reference
@@ -230,15 +229,11 @@ static void io_worker_exit(struct io_worker *worker)
 		raw_spin_lock_irq(&wqe->lock);
 	}
 	acct->nr_workers--;
-	nr_workers = wqe->acct[IO_WQ_ACCT_BOUND].nr_workers +
-			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers;
 	raw_spin_unlock_irq(&wqe->lock);
 
-	/* all workers gone, wq exit can proceed */
-	if (!nr_workers && refcount_dec_and_test(&wqe->wq->refs))
-		complete(&wqe->wq->done);
-
 	kfree_rcu(worker, rcu);
+	if (refcount_dec_and_test(&wqe->wq->refs))
+		complete(&wqe->wq->done);
 }
 
 static inline bool io_wqe_run_queue(struct io_wqe *wqe)
@@ -641,7 +636,7 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 {
-	struct io_wqe_acct *acct =&wqe->acct[index];
+	struct io_wqe_acct *acct = &wqe->acct[index];
 	struct io_worker *worker;
 
 	worker = kzalloc_node(sizeof(*worker), GFP_KERNEL, wqe->node);
@@ -674,6 +669,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	if (index == IO_WQ_ACCT_UNBOUND)
 		atomic_inc(&wq->user->processes);
 
+	refcount_inc(&wq->refs);
 	wake_up_process(worker->task);
 	return true;
 }
@@ -689,28 +685,63 @@ static inline bool io_wqe_need_worker(struct io_wqe *wqe, int index)
 	return acct->nr_workers < acct->max_workers;
 }
 
+static bool io_wqe_worker_send_sig(struct io_worker *worker, void *data)
+{
+	send_sig(SIGINT, worker->task, 1);
+	return false;
+}
+
+/*
+ * Iterate the passed in list and call the specific function for each
+ * worker that isn't exiting
+ */
+static bool io_wq_for_each_worker(struct io_wqe *wqe,
+				  bool (*func)(struct io_worker *, void *),
+				  void *data)
+{
+	struct io_worker *worker;
+	bool ret = false;
+
+	list_for_each_entry_rcu(worker, &wqe->all_list, all_list) {
+		if (io_worker_get(worker)) {
+			/* no task if node is/was offline */
+			if (worker->task)
+				ret = func(worker, data);
+			io_worker_release(worker);
+			if (ret)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+static bool io_wq_worker_wake(struct io_worker *worker, void *data)
+{
+	wake_up_process(worker->task);
+	return false;
+}
+
 /*
  * Manager thread. Tasked with creating new workers, if we need them.
  */
 static int io_wq_manager(void *data)
 {
 	struct io_wq *wq = data;
-	int workers_to_create = num_possible_nodes();
 	int node;
 
 	/* create fixed workers */
-	refcount_set(&wq->refs, workers_to_create);
+	refcount_set(&wq->refs, 1);
 	for_each_node(node) {
 		if (!node_online(node))
 			continue;
-		if (!create_io_worker(wq, wq->wqes[node], IO_WQ_ACCT_BOUND))
-			goto err;
-		workers_to_create--;
+		if (create_io_worker(wq, wq->wqes[node], IO_WQ_ACCT_BOUND))
+			continue;
+		set_bit(IO_WQ_BIT_ERROR, &wq->state);
+		set_bit(IO_WQ_BIT_EXIT, &wq->state);
+		goto out;
 	}
 
-	while (workers_to_create--)
-		refcount_dec(&wq->refs);
-
 	complete(&wq->done);
 
 	while (!kthread_should_stop()) {
@@ -742,12 +773,18 @@ static int io_wq_manager(void *data)
 	if (current->task_works)
 		task_work_run();
 
-	return 0;
-err:
-	set_bit(IO_WQ_BIT_ERROR, &wq->state);
-	set_bit(IO_WQ_BIT_EXIT, &wq->state);
-	if (refcount_sub_and_test(workers_to_create, &wq->refs))
+out:
+	if (refcount_dec_and_test(&wq->refs)) {
 		complete(&wq->done);
+		return 0;
+	}
+	/* if ERROR is set and we get here, we have workers to wake */
+	if (test_bit(IO_WQ_BIT_ERROR, &wq->state)) {
+		rcu_read_lock();
+		for_each_node(node)
+			io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
+		rcu_read_unlock();
+	}
 	return 0;
 }
 
@@ -854,37 +891,6 @@ void io_wq_hash_work(struct io_wq_work *work, void *val)
 	work->flags |= (IO_WQ_WORK_HASHED | (bit << IO_WQ_HASH_SHIFT));
 }
 
-static bool io_wqe_worker_send_sig(struct io_worker *worker, void *data)
-{
-	send_sig(SIGINT, worker->task, 1);
-	return false;
-}
-
-/*
- * Iterate the passed in list and call the specific function for each
- * worker that isn't exiting
- */
-static bool io_wq_for_each_worker(struct io_wqe *wqe,
-				  bool (*func)(struct io_worker *, void *),
-				  void *data)
-{
-	struct io_worker *worker;
-	bool ret = false;
-
-	list_for_each_entry_rcu(worker, &wqe->all_list, all_list) {
-		if (io_worker_get(worker)) {
-			/* no task if node is/was offline */
-			if (worker->task)
-				ret = func(worker, data);
-			io_worker_release(worker);
-			if (ret)
-				break;
-		}
-	}
-
-	return ret;
-}
-
 void io_wq_cancel_all(struct io_wq *wq)
 {
 	int node;
@@ -1117,12 +1123,6 @@ bool io_wq_get(struct io_wq *wq, struct io_wq_data *data)
 	return refcount_inc_not_zero(&wq->use_refs);
 }
 
-static bool io_wq_worker_wake(struct io_worker *worker, void *data)
-{
-	wake_up_process(worker->task);
-	return false;
-}
-
 static void __io_wq_destroy(struct io_wq *wq)
 {
 	int node;
-- 
2.29.0


--------------4A1C62D62F0A548A85843422
Content-Type: text/x-patch; charset=UTF-8;
 name="0009-io_wq-Make-io_wqe-lock-a-raw_spinlock_t.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0009-io_wq-Make-io_wqe-lock-a-raw_spinlock_t.patch"

From cfb93658f4cd3d2f57ec4af646a0bc77877d935f Mon Sep 17 00:00:00 2001
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date: Tue, 1 Sep 2020 10:41:46 +0200
Subject: [PATCH 09/14] io_wq: Make io_wqe::lock a raw_spinlock_t

commit 95da84659226d75698a1ab958be0af21d9cc2a9c upstream.

During a context switch the scheduler invokes wq_worker_sleeping() with
disabled preemption. Disabling preemption is needed because it protects
access to `worker->sleeping'. As an optimisation it avoids invoking
schedule() within the schedule path as part of possible wake up (thus
preempt_enable_no_resched() afterwards).

The io-wq has been added to the mix in the same section with disabled
preemption. This breaks on PREEMPT_RT because io_wq_worker_sleeping()
acquires a spinlock_t. Also within the schedule() the spinlock_t must be
acquired after tsk_is_pi_blocked() otherwise it will block on the
sleeping lock again while scheduling out.

While playing with `io_uring-bench' I didn't notice a significant
latency spike after converting io_wqe::lock to a raw_spinlock_t. The
latency was more or less the same.

In order to keep the spinlock_t it would have to be moved after the
tsk_is_pi_blocked() check which would introduce a branch instruction
into the hot path.

The lock is used to maintain the `work_list' and wakes one task up at
most.
Should io_wqe_cancel_pending_work() cause latency spikes, while
searching for a specific item, then it would need to drop the lock
during iterations.
revert_creds() is also invoked under the lock. According to debug
cred::non_rcu is 0. Otherwise it should be moved outside of the locked
section because put_cred_rcu()->free_uid() acquires a sleeping lock.

Convert io_wqe::lock to a raw_spinlock_t.c

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 09e20bbf0d37..c1a7ef85844b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -88,7 +88,7 @@ enum {
  */
 struct io_wqe {
 	struct {
-		spinlock_t lock;
+		raw_spinlock_t lock;
 		struct io_wq_work_list work_list;
 		unsigned long hash_map;
 		unsigned flags;
@@ -149,7 +149,7 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
 
 	if (current->files != worker->restore_files) {
 		__acquire(&wqe->lock);
-		spin_unlock_irq(&wqe->lock);
+		raw_spin_unlock_irq(&wqe->lock);
 		dropped_lock = true;
 
 		task_lock(current);
@@ -168,7 +168,7 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
 	if (worker->mm) {
 		if (!dropped_lock) {
 			__acquire(&wqe->lock);
-			spin_unlock_irq(&wqe->lock);
+			raw_spin_unlock_irq(&wqe->lock);
 			dropped_lock = true;
 		}
 		__set_current_state(TASK_RUNNING);
@@ -222,17 +222,17 @@ static void io_worker_exit(struct io_worker *worker)
 	worker->flags = 0;
 	preempt_enable();
 
-	spin_lock_irq(&wqe->lock);
+	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
 	if (__io_worker_unuse(wqe, worker)) {
 		__release(&wqe->lock);
-		spin_lock_irq(&wqe->lock);
+		raw_spin_lock_irq(&wqe->lock);
 	}
 	acct->nr_workers--;
 	nr_workers = wqe->acct[IO_WQ_ACCT_BOUND].nr_workers +
 			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers;
-	spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock_irq(&wqe->lock);
 
 	/* all workers gone, wq exit can proceed */
 	if (!nr_workers && refcount_dec_and_test(&wqe->wq->refs))
@@ -508,7 +508,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		else if (!wq_list_empty(&wqe->work_list))
 			wqe->flags |= IO_WQE_FLAG_STALLED;
 
-		spin_unlock_irq(&wqe->lock);
+		raw_spin_unlock_irq(&wqe->lock);
 		if (!work)
 			break;
 		io_assign_current_work(worker, work);
@@ -542,17 +542,17 @@ static void io_worker_handle_work(struct io_worker *worker)
 				io_wqe_enqueue(wqe, linked);
 
 			if (hash != -1U && !next_hashed) {
-				spin_lock_irq(&wqe->lock);
+				raw_spin_lock_irq(&wqe->lock);
 				wqe->hash_map &= ~BIT_ULL(hash);
 				wqe->flags &= ~IO_WQE_FLAG_STALLED;
 				/* skip unnecessary unlock-lock wqe->lock */
 				if (!work)
 					goto get_next;
-				spin_unlock_irq(&wqe->lock);
+				raw_spin_unlock_irq(&wqe->lock);
 			}
 		} while (work);
 
-		spin_lock_irq(&wqe->lock);
+		raw_spin_lock_irq(&wqe->lock);
 	} while (1);
 }
 
@@ -567,7 +567,7 @@ static int io_wqe_worker(void *data)
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		set_current_state(TASK_INTERRUPTIBLE);
 loop:
-		spin_lock_irq(&wqe->lock);
+		raw_spin_lock_irq(&wqe->lock);
 		if (io_wqe_run_queue(wqe)) {
 			__set_current_state(TASK_RUNNING);
 			io_worker_handle_work(worker);
@@ -578,7 +578,7 @@ static int io_wqe_worker(void *data)
 			__release(&wqe->lock);
 			goto loop;
 		}
-		spin_unlock_irq(&wqe->lock);
+		raw_spin_unlock_irq(&wqe->lock);
 		if (signal_pending(current))
 			flush_signals(current);
 		if (schedule_timeout(WORKER_IDLE_TIMEOUT))
@@ -590,11 +590,11 @@ static int io_wqe_worker(void *data)
 	}
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
-		spin_lock_irq(&wqe->lock);
+		raw_spin_lock_irq(&wqe->lock);
 		if (!wq_list_empty(&wqe->work_list))
 			io_worker_handle_work(worker);
 		else
-			spin_unlock_irq(&wqe->lock);
+			raw_spin_unlock_irq(&wqe->lock);
 	}
 
 	io_worker_exit(worker);
@@ -634,9 +634,9 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 
 	worker->flags &= ~IO_WORKER_F_RUNNING;
 
-	spin_lock_irq(&wqe->lock);
+	raw_spin_lock_irq(&wqe->lock);
 	io_wqe_dec_running(wqe, worker);
-	spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock_irq(&wqe->lock);
 }
 
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
@@ -660,7 +660,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 		return false;
 	}
 
-	spin_lock_irq(&wqe->lock);
+	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
 	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
 	worker->flags |= IO_WORKER_F_FREE;
@@ -669,7 +669,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	if (!acct->nr_workers && (worker->flags & IO_WORKER_F_BOUND))
 		worker->flags |= IO_WORKER_F_FIXED;
 	acct->nr_workers++;
-	spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock_irq(&wqe->lock);
 
 	if (index == IO_WQ_ACCT_UNBOUND)
 		atomic_inc(&wq->user->processes);
@@ -724,12 +724,12 @@ static int io_wq_manager(void *data)
 			if (!node_online(node))
 				continue;
 
-			spin_lock_irq(&wqe->lock);
+			raw_spin_lock_irq(&wqe->lock);
 			if (io_wqe_need_worker(wqe, IO_WQ_ACCT_BOUND))
 				fork_worker[IO_WQ_ACCT_BOUND] = true;
 			if (io_wqe_need_worker(wqe, IO_WQ_ACCT_UNBOUND))
 				fork_worker[IO_WQ_ACCT_UNBOUND] = true;
-			spin_unlock_irq(&wqe->lock);
+			raw_spin_unlock_irq(&wqe->lock);
 			if (fork_worker[IO_WQ_ACCT_BOUND])
 				create_io_worker(wq, wqe, IO_WQ_ACCT_BOUND);
 			if (fork_worker[IO_WQ_ACCT_UNBOUND])
@@ -825,10 +825,10 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	}
 
 	work_flags = work->flags;
-	spin_lock_irqsave(&wqe->lock, flags);
+	raw_spin_lock_irqsave(&wqe->lock, flags);
 	io_wqe_insert_work(wqe, work);
 	wqe->flags &= ~IO_WQE_FLAG_STALLED;
-	spin_unlock_irqrestore(&wqe->lock, flags);
+	raw_spin_unlock_irqrestore(&wqe->lock, flags);
 
 	if ((work_flags & IO_WQ_WORK_CONCURRENT) ||
 	    !atomic_read(&acct->nr_running))
@@ -955,13 +955,13 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 	unsigned long flags;
 
 retry:
-	spin_lock_irqsave(&wqe->lock, flags);
+	raw_spin_lock_irqsave(&wqe->lock, flags);
 	wq_list_for_each(node, prev, &wqe->work_list) {
 		work = container_of(node, struct io_wq_work, list);
 		if (!match->fn(work, match->data))
 			continue;
 		io_wqe_remove_pending(wqe, work, prev);
-		spin_unlock_irqrestore(&wqe->lock, flags);
+		raw_spin_unlock_irqrestore(&wqe->lock, flags);
 		io_run_cancel(work, wqe);
 		match->nr_pending++;
 		if (!match->cancel_all)
@@ -970,7 +970,7 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 		/* not safe to continue after unlock */
 		goto retry;
 	}
-	spin_unlock_irqrestore(&wqe->lock, flags);
+	raw_spin_unlock_irqrestore(&wqe->lock, flags);
 }
 
 static void io_wqe_cancel_running_work(struct io_wqe *wqe,
@@ -1078,7 +1078,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		}
 		atomic_set(&wqe->acct[IO_WQ_ACCT_UNBOUND].nr_running, 0);
 		wqe->wq = wq;
-		spin_lock_init(&wqe->lock);
+		raw_spin_lock_init(&wqe->lock);
 		INIT_WQ_LIST(&wqe->work_list);
 		INIT_HLIST_NULLS_HEAD(&wqe->free_list, 0);
 		INIT_LIST_HEAD(&wqe->all_list);
-- 
2.29.0


--------------4A1C62D62F0A548A85843422
Content-Type: text/x-patch; charset=UTF-8;
 name="0008-io_uring-reference-nsproxy-for-file-table-commands.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0008-io_uring-reference-nsproxy-for-file-table-commands.patc";
 filename*1="h"

From e745bd4141a553b8a3f6ee94fe5efa1fa84b0310 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 18 Sep 2020 20:13:06 -0600
Subject: [PATCH 08/14] io_uring: reference ->nsproxy for file table commands

commit 9b8284921513fc1ea57d87777283a59b05862f03 upstream.

If we don't get and assign the namespace for the async work, then certain
paths just don't work properly (like /dev/stdin, /proc/mounts, etc).
Anything that references the current namespace of the given task should
be assigned for async work on behalf of that task.

Cc: stable@vger.kernel.org # v5.5+
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    | 4 ++++
 fs/io-wq.h    | 1 +
 fs/io_uring.c | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 414beb543883..09e20bbf0d37 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -60,6 +60,7 @@ struct io_worker {
 	const struct cred *cur_creds;
 	const struct cred *saved_creds;
 	struct files_struct *restore_files;
+	struct nsproxy *restore_nsproxy;
 	struct fs_struct *restore_fs;
 };
 
@@ -153,6 +154,7 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
 
 		task_lock(current);
 		current->files = worker->restore_files;
+		current->nsproxy = worker->restore_nsproxy;
 		task_unlock(current);
 	}
 
@@ -318,6 +320,7 @@ static void io_worker_start(struct io_wqe *wqe, struct io_worker *worker)
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
 	worker->restore_files = current->files;
+	worker->restore_nsproxy = current->nsproxy;
 	worker->restore_fs = current->fs;
 	io_wqe_inc_running(wqe, worker);
 }
@@ -454,6 +457,7 @@ static void io_impersonate_work(struct io_worker *worker,
 	if (work->files && current->files != work->files) {
 		task_lock(current);
 		current->files = work->files;
+		current->nsproxy = work->nsproxy;
 		task_unlock(current);
 	}
 	if (work->fs && current->fs != work->fs)
diff --git a/fs/io-wq.h b/fs/io-wq.h
index ddaf9614cf9b..2519830c8c55 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -88,6 +88,7 @@ struct io_wq_work {
 	struct files_struct *files;
 	struct mm_struct *mm;
 	const struct cred *creds;
+	struct nsproxy *nsproxy;
 	struct fs_struct *fs;
 	unsigned long fsize;
 	unsigned flags;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index ee75ba7113cf..05ec385a6094 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5678,6 +5678,7 @@ static void io_req_drop_files(struct io_kiocb *req)
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
 	put_files_struct(req->work.files);
+	put_nsproxy(req->work.nsproxy);
 	req->work.files = NULL;
 }
 
@@ -6086,6 +6087,8 @@ static int io_grab_files(struct io_kiocb *req)
 		return 0;
 
 	req->work.files = get_files_struct(current);
+	get_nsproxy(current->nsproxy);
+	req->work.nsproxy = current->nsproxy;
 	req->flags |= REQ_F_INFLIGHT;
 
 	spin_lock_irq(&ctx->inflight_lock);
-- 
2.29.0


--------------4A1C62D62F0A548A85843422
Content-Type: text/x-patch; charset=UTF-8;
 name="0007-io_uring-don-t-rely-on-weak-files-references.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0007-io_uring-don-t-rely-on-weak-files-references.patch"

From 47f8ab595b4845cef33a51d9ea57c4f3262e6618 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sun, 13 Sep 2020 13:09:39 -0600
Subject: [PATCH 07/14] io_uring: don't rely on weak ->files references

commit 0f2122045b946241a9e549c2a76cea54fa58a7ff upstream.

Grab actual references to the files_struct. To avoid circular references
issues due to this, we add a per-task note that keeps track of what
io_uring contexts a task has used. When the tasks execs or exits its
assigned files, we cancel requests based on this tracking.

With that, we can grab proper references to the files table, and no
longer need to rely on stashing away ring_fd and ring_file to check
if the ring_fd may have been closed.

Cc: stable@vger.kernel.org # v5.5+
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/exec.c                |   6 +
 fs/file.c                |   2 +
 fs/io_uring.c            | 306 ++++++++++++++++++++++++++++++++++-----
 include/linux/io_uring.h |  53 +++++++
 include/linux/sched.h    |   5 +
 init/init_task.c         |   3 +
 kernel/fork.c            |   6 +
 7 files changed, 344 insertions(+), 37 deletions(-)
 create mode 100644 include/linux/io_uring.h

diff --git a/fs/exec.c b/fs/exec.c
index a91003e28eaa..07910f5032e7 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -62,6 +62,7 @@
 #include <linux/oom.h>
 #include <linux/compat.h>
 #include <linux/vmalloc.h>
+#include <linux/io_uring.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1895,6 +1896,11 @@ static int bprm_execve(struct linux_binprm *bprm,
 	struct files_struct *displaced;
 	int retval;
 
+	/*
+	 * Cancel any io_uring activity across execve
+	 */
+	io_uring_task_cancel();
+
 	retval = unshare_files(&displaced);
 	if (retval)
 		return retval;
diff --git a/fs/file.c b/fs/file.c
index 21c0893f2f1d..4559b5fec3bd 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -21,6 +21,7 @@
 #include <linux/rcupdate.h>
 #include <linux/close_range.h>
 #include <net/sock.h>
+#include <linux/io_uring.h>
 
 unsigned int sysctl_nr_open __read_mostly = 1024*1024;
 unsigned int sysctl_nr_open_min = BITS_PER_LONG;
@@ -452,6 +453,7 @@ void exit_files(struct task_struct *tsk)
 	struct files_struct * files = tsk->files;
 
 	if (files) {
+		io_uring_files_cancel(files);
 		task_lock(tsk);
 		tsk->files = NULL;
 		task_unlock(tsk);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 046d06266a11..ee75ba7113cf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -79,6 +79,7 @@
 #include <linux/splice.h>
 #include <linux/task_work.h>
 #include <linux/pagemap.h>
+#include <linux/io_uring.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -284,8 +285,6 @@ struct io_ring_ctx {
 	 */
 	struct fixed_file_data	*file_data;
 	unsigned		nr_user_files;
-	int 			ring_fd;
-	struct file 		*ring_file;
 
 	/* if used, fixed mapped user buffers */
 	unsigned		nr_user_bufs;
@@ -1433,7 +1432,12 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 		WRITE_ONCE(cqe->user_data, req->user_data);
 		WRITE_ONCE(cqe->res, res);
 		WRITE_ONCE(cqe->flags, cflags);
-	} else if (ctx->cq_overflow_flushed) {
+	} else if (ctx->cq_overflow_flushed || req->task->io_uring->in_idle) {
+		/*
+		 * If we're in ring overflow flush mode, or in task cancel mode,
+		 * then we cannot store the request for later flushing, we need
+		 * to drop it on the floor.
+		 */
 		WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
 	} else {
@@ -1591,8 +1595,12 @@ static bool io_dismantle_req(struct io_kiocb *req)
 
 static void __io_free_req_finish(struct io_kiocb *req)
 {
+	struct io_uring_task *tctx = req->task->io_uring;
 	struct io_ring_ctx *ctx = req->ctx;
 
+	atomic_long_inc(&tctx->req_complete);
+	if (tctx->in_idle)
+		wake_up(&tctx->wait);
 	put_task_struct(req->task);
 
 	if (likely(!io_is_fallback_req(req)))
@@ -1907,6 +1915,7 @@ static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 	if (rb->to_free)
 		__io_req_free_batch_flush(ctx, rb);
 	if (rb->task) {
+		atomic_long_add(rb->task_refs, &rb->task->io_uring->req_complete);
 		put_task_struct_many(rb->task, rb->task_refs);
 		rb->task = NULL;
 	}
@@ -1922,8 +1931,10 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 		io_queue_next(req);
 
 	if (req->task != rb->task) {
-		if (rb->task)
+		if (rb->task) {
+			atomic_long_add(rb->task_refs, &rb->task->io_uring->req_complete);
 			put_task_struct_many(rb->task, rb->task_refs);
+		}
 		rb->task = req->task;
 		rb->task_refs = 0;
 	}
@@ -3978,8 +3989,7 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EBADF;
 
 	req->close.fd = READ_ONCE(sqe->fd);
-	if ((req->file && req->file->f_op == &io_uring_fops) ||
-	    req->close.fd == req->ctx->ring_fd)
+	if ((req->file && req->file->f_op == &io_uring_fops))
 		return -EBADF;
 
 	req->close.put_file = NULL;
@@ -5667,6 +5677,7 @@ static void io_req_drop_files(struct io_kiocb *req)
 		wake_up(&ctx->inflight_wait);
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
+	put_files_struct(req->work.files);
 	req->work.files = NULL;
 }
 
@@ -6067,34 +6078,20 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req,
 
 static int io_grab_files(struct io_kiocb *req)
 {
-	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_req_init_async(req);
 
 	if (req->work.files || (req->flags & REQ_F_NO_FILE_TABLE))
 		return 0;
-	if (!ctx->ring_file)
-		return -EBADF;
 
-	rcu_read_lock();
+	req->work.files = get_files_struct(current);
+	req->flags |= REQ_F_INFLIGHT;
+
 	spin_lock_irq(&ctx->inflight_lock);
-	/*
-	 * We use the f_ops->flush() handler to ensure that we can flush
-	 * out work accessing these files if the fd is closed. Check if
-	 * the fd has changed since we started down this path, and disallow
-	 * this operation if it has.
-	 */
-	if (fcheck(ctx->ring_fd) == ctx->ring_file) {
-		list_add(&req->inflight_entry, &ctx->inflight_list);
-		req->flags |= REQ_F_INFLIGHT;
-		req->work.files = current->files;
-		ret = 0;
-	}
+	list_add(&req->inflight_entry, &ctx->inflight_list);
 	spin_unlock_irq(&ctx->inflight_lock);
-	rcu_read_unlock();
-
-	return ret;
+	return 0;
 }
 
 static inline int io_prep_work_files(struct io_kiocb *req)
@@ -6459,6 +6456,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	refcount_set(&req->refs, 2);
 	req->task = current;
 	get_task_struct(req->task);
+	atomic_long_inc(&req->task->io_uring->req_issue);
 	req->result = 0;
 
 	if (unlikely(req->opcode >= IORING_OP_LAST))
@@ -6494,8 +6492,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	return io_req_set_file(state, req, READ_ONCE(sqe->fd));
 }
 
-static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
-			  struct file *ring_file, int ring_fd)
+static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 {
 	struct io_submit_state state;
 	struct io_kiocb *link = NULL;
@@ -6516,9 +6513,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 
 	io_submit_state_start(&state, ctx, nr);
 
-	ctx->ring_fd = ring_fd;
-	ctx->ring_file = ring_file;
-
 	for (i = 0; i < nr; i++) {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
@@ -6687,7 +6681,7 @@ static int io_sq_thread(void *data)
 
 		mutex_lock(&ctx->uring_lock);
 		if (likely(!percpu_ref_is_dying(&ctx->refs)))
-			ret = io_submit_sqes(ctx, to_submit, NULL, -1);
+			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 		timeout = jiffies + ctx->sq_thread_idle;
 	}
@@ -7516,6 +7510,34 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+static int io_uring_alloc_task_context(struct task_struct *task)
+{
+	struct io_uring_task *tctx;
+
+	tctx = kmalloc(sizeof(*tctx), GFP_KERNEL);
+	if (unlikely(!tctx))
+		return -ENOMEM;
+
+	xa_init(&tctx->xa);
+	init_waitqueue_head(&tctx->wait);
+	tctx->last = NULL;
+	tctx->in_idle = 0;
+	atomic_long_set(&tctx->req_issue, 0);
+	atomic_long_set(&tctx->req_complete, 0);
+	task->io_uring = tctx;
+	return 0;
+}
+
+void __io_uring_free(struct task_struct *tsk)
+{
+	struct io_uring_task *tctx = tsk->io_uring;
+
+	WARN_ON_ONCE(!xa_empty(&tctx->xa));
+	xa_destroy(&tctx->xa);
+	kfree(tctx);
+	tsk->io_uring = NULL;
+}
+
 static int io_sq_offload_start(struct io_ring_ctx *ctx,
 			       struct io_uring_params *p)
 {
@@ -7551,6 +7573,9 @@ static int io_sq_offload_start(struct io_ring_ctx *ctx,
 			ctx->sqo_thread = NULL;
 			goto err;
 		}
+		ret = io_uring_alloc_task_context(ctx->sqo_thread);
+		if (ret)
+			goto err;
 		wake_up_process(ctx->sqo_thread);
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
 		/* Can't have SQ_AFF without SQPOLL */
@@ -8063,7 +8088,7 @@ static bool io_wq_files_match(struct io_wq_work *work, void *data)
 {
 	struct files_struct *files = data;
 
-	return work->files == files;
+	return !files || work->files == files;
 }
 
 /*
@@ -8218,7 +8243,7 @@ static bool io_uring_cancel_files(struct io_ring_ctx *ctx,
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (req->work.files != files)
+			if (files && req->work.files != files)
 				continue;
 			/* req is being completed, ignore */
 			if (!refcount_inc_not_zero(&req->refs))
@@ -8254,18 +8279,217 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 	return io_task_match(req, task);
 }
 
+static bool __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
+					    struct task_struct *task,
+					    struct files_struct *files)
+{
+	bool ret;
+
+	ret = io_uring_cancel_files(ctx, files);
+	if (!files) {
+		enum io_wq_cancel cret;
+
+		cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, task, true);
+		if (cret != IO_WQ_CANCEL_NOTFOUND)
+			ret = true;
+
+		/* SQPOLL thread does its own polling */
+		if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
+			while (!list_empty_careful(&ctx->iopoll_list)) {
+				io_iopoll_try_reap_events(ctx);
+				ret = true;
+			}
+		}
+
+		ret |= io_poll_remove_all(ctx, task);
+		ret |= io_kill_timeouts(ctx, task);
+	}
+
+	return ret;
+}
+
+/*
+ * We need to iteratively cancel requests, in case a request has dependent
+ * hard links. These persist even for failure of cancelations, hence keep
+ * looping until none are found.
+ */
+static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
+					  struct files_struct *files)
+{
+	struct task_struct *task = current;
+
+	if (ctx->flags & IORING_SETUP_SQPOLL)
+		task = ctx->sqo_thread;
+
+	io_cqring_overflow_flush(ctx, true, task, files);
+
+	while (__io_uring_cancel_task_requests(ctx, task, files)) {
+		io_run_task_work();
+		cond_resched();
+	}
+}
+
+/*
+ * Note that this task has used io_uring. We use it for cancelation purposes.
+ */
+static int io_uring_add_task_file(struct file *file)
+{
+	if (unlikely(!current->io_uring)) {
+		int ret;
+
+		ret = io_uring_alloc_task_context(current);
+		if (unlikely(ret))
+			return ret;
+	}
+	if (current->io_uring->last != file) {
+		XA_STATE(xas, &current->io_uring->xa, (unsigned long) file);
+		void *old;
+
+		rcu_read_lock();
+		old = xas_load(&xas);
+		if (old != file) {
+			get_file(file);
+			xas_lock(&xas);
+			xas_store(&xas, file);
+			xas_unlock(&xas);
+		}
+		rcu_read_unlock();
+		current->io_uring->last = file;
+	}
+
+	return 0;
+}
+
+/*
+ * Remove this io_uring_file -> task mapping.
+ */
+static void io_uring_del_task_file(struct file *file)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	XA_STATE(xas, &tctx->xa, (unsigned long) file);
+
+	if (tctx->last == file)
+		tctx->last = NULL;
+
+	xas_lock(&xas);
+	file = xas_store(&xas, NULL);
+	xas_unlock(&xas);
+
+	if (file)
+		fput(file);
+}
+
+static void __io_uring_attempt_task_drop(struct file *file)
+{
+	XA_STATE(xas, &current->io_uring->xa, (unsigned long) file);
+	struct file *old;
+
+	rcu_read_lock();
+	old = xas_load(&xas);
+	rcu_read_unlock();
+
+	if (old == file)
+		io_uring_del_task_file(file);
+}
+
+/*
+ * Drop task note for this file if we're the only ones that hold it after
+ * pending fput()
+ */
+static void io_uring_attempt_task_drop(struct file *file, bool exiting)
+{
+	if (!current->io_uring)
+		return;
+	/*
+	 * fput() is pending, will be 2 if the only other ref is our potential
+	 * task file note. If the task is exiting, drop regardless of count.
+	 */
+	if (!exiting && atomic_long_read(&file->f_count) != 2)
+		return;
+
+	__io_uring_attempt_task_drop(file);
+}
+
+void __io_uring_files_cancel(struct files_struct *files)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	XA_STATE(xas, &tctx->xa, 0);
+
+	/* make sure overflow events are dropped */
+	tctx->in_idle = true;
+
+	do {
+		struct io_ring_ctx *ctx;
+		struct file *file;
+
+		xas_lock(&xas);
+		file = xas_next_entry(&xas, ULONG_MAX);
+		xas_unlock(&xas);
+
+		if (!file)
+			break;
+
+		ctx = file->private_data;
+
+		io_uring_cancel_task_requests(ctx, files);
+		if (files)
+			io_uring_del_task_file(file);
+	} while (1);
+}
+
+static inline bool io_uring_task_idle(struct io_uring_task *tctx)
+{
+	return atomic_long_read(&tctx->req_issue) ==
+		atomic_long_read(&tctx->req_complete);
+}
+
+/*
+ * Find any io_uring fd that this task has registered or done IO on, and cancel
+ * requests.
+ */
+void __io_uring_task_cancel(void)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	DEFINE_WAIT(wait);
+	long completions;
+
+	/* make sure overflow events are dropped */
+	tctx->in_idle = true;
+
+	while (!io_uring_task_idle(tctx)) {
+		/* read completions before cancelations */
+		completions = atomic_long_read(&tctx->req_complete);
+		__io_uring_files_cancel(NULL);
+
+		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
+
+		/*
+		 * If we've seen completions, retry. This avoids a race where
+		 * a completion comes in before we did prepare_to_wait().
+		 */
+		if (completions != atomic_long_read(&tctx->req_complete))
+			continue;
+		if (io_uring_task_idle(tctx))
+			break;
+		schedule();
+	}
+
+	finish_wait(&tctx->wait, &wait);
+	tctx->in_idle = false;
+}
+
 static int io_uring_flush(struct file *file, void *data)
 {
 	struct io_ring_ctx *ctx = file->private_data;
 
-	io_uring_cancel_files(ctx, data);
-
 	/*
 	 * If the task is going away, cancel work it may have pending
 	 */
 	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
-		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, current, true);
+		data = NULL;
 
+	io_uring_cancel_task_requests(ctx, data);
+	io_uring_attempt_task_drop(file, !data);
 	return 0;
 }
 
@@ -8379,8 +8603,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			wake_up(&ctx->sqo_wait);
 		submitted = to_submit;
 	} else if (to_submit) {
+		ret = io_uring_add_task_file(f.file);
+		if (unlikely(ret))
+			goto out;
 		mutex_lock(&ctx->uring_lock);
-		submitted = io_submit_sqes(ctx, to_submit, f.file, fd);
+		submitted = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 
 		if (submitted != to_submit)
@@ -8590,6 +8817,7 @@ static int io_uring_get_fd(struct io_ring_ctx *ctx)
 	file = anon_inode_getfile("[io_uring]", &io_uring_fops, ctx,
 					O_RDWR | O_CLOEXEC);
 	if (IS_ERR(file)) {
+err_fd:
 		put_unused_fd(ret);
 		ret = PTR_ERR(file);
 		goto err;
@@ -8598,6 +8826,10 @@ static int io_uring_get_fd(struct io_ring_ctx *ctx)
 #if defined(CONFIG_UNIX)
 	ctx->ring_sock->file = file;
 #endif
+	if (unlikely(io_uring_add_task_file(file))) {
+		file = ERR_PTR(-ENOMEM);
+		goto err_fd;
+	}
 	fd_install(ret, file);
 	return ret;
 err:
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
new file mode 100644
index 000000000000..c09135a1ef13
--- /dev/null
+++ b/include/linux/io_uring.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LINUX_IO_URING_H
+#define _LINUX_IO_URING_H
+
+#include <linux/sched.h>
+#include <linux/xarray.h>
+#include <linux/percpu-refcount.h>
+
+struct io_uring_task {
+	/* submission side */
+	struct xarray		xa;
+	struct wait_queue_head	wait;
+	struct file		*last;
+	atomic_long_t		req_issue;
+
+	/* completion side */
+	bool			in_idle ____cacheline_aligned_in_smp;
+	atomic_long_t		req_complete;
+};
+
+#if defined(CONFIG_IO_URING)
+void __io_uring_task_cancel(void);
+void __io_uring_files_cancel(struct files_struct *files);
+void __io_uring_free(struct task_struct *tsk);
+
+static inline void io_uring_task_cancel(void)
+{
+	if (current->io_uring && !xa_empty(&current->io_uring->xa))
+		__io_uring_task_cancel();
+}
+static inline void io_uring_files_cancel(struct files_struct *files)
+{
+	if (current->io_uring && !xa_empty(&current->io_uring->xa))
+		__io_uring_files_cancel(files);
+}
+static inline void io_uring_free(struct task_struct *tsk)
+{
+	if (tsk->io_uring)
+		__io_uring_free(tsk);
+}
+#else
+static inline void io_uring_task_cancel(void)
+{
+}
+static inline void io_uring_files_cancel(struct files_struct *files)
+{
+}
+static inline void io_uring_free(struct task_struct *tsk)
+{
+}
+#endif
+
+#endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index afe01e232935..8bf2295ebee4 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -63,6 +63,7 @@ struct sighand_struct;
 struct signal_struct;
 struct task_delay_info;
 struct task_group;
+struct io_uring_task;
 
 /*
  * Task state bitmask. NOTE! These bits are also
@@ -935,6 +936,10 @@ struct task_struct {
 	/* Open file information: */
 	struct files_struct		*files;
 
+#ifdef CONFIG_IO_URING
+	struct io_uring_task		*io_uring;
+#endif
+
 	/* Namespaces: */
 	struct nsproxy			*nsproxy;
 
diff --git a/init/init_task.c b/init/init_task.c
index f6889fce64af..a56f0abb63e9 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -114,6 +114,9 @@ struct task_struct init_task
 	.thread		= INIT_THREAD,
 	.fs		= &init_fs,
 	.files		= &init_files,
+#ifdef CONFIG_IO_URING
+	.io_uring	= NULL,
+#endif
 	.signal		= &init_signals,
 	.sighand	= &init_sighand,
 	.nsproxy	= &init_nsproxy,
diff --git a/kernel/fork.c b/kernel/fork.c
index da8d360fb032..a3795aaaab5c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -95,6 +95,7 @@
 #include <linux/stackleak.h>
 #include <linux/kasan.h>
 #include <linux/scs.h>
+#include <linux/io_uring.h>
 
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
@@ -728,6 +729,7 @@ void __put_task_struct(struct task_struct *tsk)
 	WARN_ON(refcount_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
+	io_uring_free(tsk);
 	cgroup_free(tsk);
 	task_numa_free(tsk, true);
 	security_task_free(tsk);
@@ -1983,6 +1985,10 @@ static __latent_entropy struct task_struct *copy_process(
 	p->vtime.state = VTIME_INACTIVE;
 #endif
 
+#ifdef CONFIG_IO_URING
+	p->io_uring = NULL;
+#endif
+
 #if defined(SPLIT_RSS_COUNTING)
 	memset(&p->rss_stat, 0, sizeof(p->rss_stat));
 #endif
-- 
2.29.0


--------------4A1C62D62F0A548A85843422
Content-Type: text/x-patch; charset=UTF-8;
 name="0006-io_uring-enable-task-files-specific-overflow-flushin.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0006-io_uring-enable-task-files-specific-overflow-flushin.pa";
 filename*1="tch"

From 062be0e7ae80f9450d04fc4e4b8911dda02e2a75 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 28 Sep 2020 13:10:13 -0600
Subject: [PATCH 06/14] io_uring: enable task/files specific overflow flushing

commit e6c8aa9ac33bd7c968af7816240fc081401fddcd upstream.

This allows us to selectively flush out pending overflows, depending on
the task and/or files_struct being passed in.

No intended functional changes in this patch.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ddb8b2fe3e5..046d06266a11 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1344,12 +1344,24 @@ static void io_cqring_mark_overflow(struct io_ring_ctx *ctx)
 	}
 }
 
+static inline bool io_match_files(struct io_kiocb *req,
+				       struct files_struct *files)
+{
+	if (!files)
+		return true;
+	if (req->flags & REQ_F_WORK_INITIALIZED)
+		return req->work.files == files;
+	return false;
+}
+
 /* Returns true if there are no backlogged entries after the flush */
-static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
+static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
+				     struct task_struct *tsk,
+				     struct files_struct *files)
 {
 	struct io_rings *rings = ctx->rings;
+	struct io_kiocb *req, *tmp;
 	struct io_uring_cqe *cqe;
-	struct io_kiocb *req;
 	unsigned long flags;
 	LIST_HEAD(list);
 
@@ -1368,13 +1380,16 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		ctx->cq_overflow_flushed = 1;
 
 	cqe = NULL;
-	while (!list_empty(&ctx->cq_overflow_list)) {
+	list_for_each_entry_safe(req, tmp, &ctx->cq_overflow_list, compl.list) {
+		if (tsk && req->task != tsk)
+			continue;
+		if (!io_match_files(req, files))
+			continue;
+
 		cqe = io_get_cqring(ctx);
 		if (!cqe && !force)
 			break;
 
-		req = list_first_entry(&ctx->cq_overflow_list, struct io_kiocb,
-						compl.list);
 		list_move(&req->compl.list, &list);
 		if (cqe) {
 			WRITE_ONCE(cqe->user_data, req->user_data);
@@ -1988,7 +2003,7 @@ static unsigned io_cqring_events(struct io_ring_ctx *ctx, bool noflush)
 		if (noflush && !list_empty(&ctx->cq_overflow_list))
 			return -1U;
 
-		io_cqring_overflow_flush(ctx, false);
+		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 	}
 
 	/* See comment at the top of this file */
@@ -6489,7 +6504,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	/* if we have a backlog and couldn't flush it all, return BUSY */
 	if (test_bit(0, &ctx->sq_check_overflow)) {
 		if (!list_empty(&ctx->cq_overflow_list) &&
-		    !io_cqring_overflow_flush(ctx, false))
+		    !io_cqring_overflow_flush(ctx, false, NULL, NULL))
 			return -EBUSY;
 	}
 
@@ -7993,7 +8008,7 @@ static void io_ring_exit_work(struct work_struct *work)
 	 */
 	do {
 		if (ctx->rings)
-			io_cqring_overflow_flush(ctx, true);
+			io_cqring_overflow_flush(ctx, true, NULL, NULL);
 		io_iopoll_try_reap_events(ctx);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 	io_ring_ctx_free(ctx);
@@ -8013,7 +8028,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 
 	/* if we failed setting up the ctx, we might not have any rings */
 	if (ctx->rings)
-		io_cqring_overflow_flush(ctx, true);
+		io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	io_iopoll_try_reap_events(ctx);
 	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
 
@@ -8069,12 +8084,6 @@ static bool io_match_link(struct io_kiocb *preq, struct io_kiocb *req)
 	return false;
 }
 
-static inline bool io_match_files(struct io_kiocb *req,
-				       struct files_struct *files)
-{
-	return (req->flags & REQ_F_WORK_INITIALIZED) && req->work.files == files;
-}
-
 static bool io_match_link_files(struct io_kiocb *req,
 				struct files_struct *files)
 {
@@ -8365,7 +8374,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		if (!list_empty_careful(&ctx->cq_overflow_list))
-			io_cqring_overflow_flush(ctx, false);
+			io_cqring_overflow_flush(ctx, false, NULL, NULL);
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sqo_wait);
 		submitted = to_submit;
-- 
2.29.0


--------------4A1C62D62F0A548A85843422
Content-Type: text/x-patch; charset=UTF-8;
 name="0005-io_uring-return-cancelation-status-from-poll-timeout.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-io_uring-return-cancelation-status-from-poll-timeout.pa";
 filename*1="tch"

From bde6369157b2e0ee1ae65d2c337ee1bb13b68106 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Sat, 26 Sep 2020 15:05:03 -0600
Subject: [PATCH 05/14] io_uring: return cancelation status from
 poll/timeout/files handlers

commit 76e1b6427fd8246376a97e3227049d49188dfb9c upstream.

Return whether we found and canceled requests or not. This is in
preparation for using this information, no functional changes in this
patch.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 53392f22b212..5ddb8b2fe3e5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1229,16 +1229,23 @@ static bool io_task_match(struct io_kiocb *req, struct task_struct *tsk)
 	return false;
 }
 
-static void io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk)
+/*
+ * Returns true if we found and killed one or more timeouts
+ */
+static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk)
 {
 	struct io_kiocb *req, *tmp;
+	int canceled = 0;
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
-		if (io_task_match(req, tsk))
+		if (io_task_match(req, tsk)) {
 			io_kill_timeout(req);
+			canceled++;
+		}
 	}
 	spin_unlock_irq(&ctx->completion_lock);
+	return canceled != 0;
 }
 
 static void __io_queue_deferred(struct io_ring_ctx *ctx)
@@ -5013,7 +5020,10 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 	return do_complete;
 }
 
-static void io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk)
+/*
+ * Returns true if we found and killed one or more poll requests
+ */
+static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk)
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
@@ -5033,6 +5043,8 @@ static void io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk)
 
 	if (posted)
 		io_cqring_ev_posted(ctx);
+
+	return posted != 0;
 }
 
 static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
@@ -8178,11 +8190,14 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 	}
 }
 
-static void io_uring_cancel_files(struct io_ring_ctx *ctx,
+/*
+ * Returns true if we found and killed one or more files pinning requests
+ */
+static bool io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
 	if (list_empty_careful(&ctx->inflight_list))
-		return;
+		return false;
 
 	io_cancel_defer_files(ctx, files);
 	/* cancel all at once, should be faster than doing it one by one*/
@@ -8218,6 +8233,8 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 		schedule();
 		finish_wait(&ctx->inflight_wait, &wait);
 	}
+
+	return true;
 }
 
 static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
-- 
2.29.0


--------------4A1C62D62F0A548A85843422
Content-Type: text/x-patch; charset=UTF-8;
 name="0004-io_uring-unconditionally-grab-req-task.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0004-io_uring-unconditionally-grab-req-task.patch"

From 88f9bcf0b379c8fc571c77045c8a3b05b730a212 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 24 Sep 2020 08:45:57 -0600
Subject: [PATCH 04/14] io_uring: unconditionally grab req->task

commit e3bc8e9dad7f2f83cc807111d4472164c9210153 upstream.

Sometimes we assign a weak reference to it, sometimes we grab a
reference to it. Clean this up and make it unconditional, and drop the
flag related to tracking this state.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 47 +++++++++--------------------------------------
 1 file changed, 9 insertions(+), 38 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d24e0322bd1d..53392f22b212 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -553,7 +553,6 @@ enum {
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
 	REQ_F_WORK_INITIALIZED_BIT,
-	REQ_F_TASK_PINNED_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -599,8 +598,6 @@ enum {
 	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
 	/* io_wq_work is initialized */
 	REQ_F_WORK_INITIALIZED	= BIT(REQ_F_WORK_INITIALIZED_BIT),
-	/* req->task is refcounted */
-	REQ_F_TASK_PINNED	= BIT(REQ_F_TASK_PINNED_BIT),
 };
 
 struct async_poll {
@@ -942,14 +939,6 @@ struct sock *io_uring_get_socket(struct file *file)
 }
 EXPORT_SYMBOL(io_uring_get_socket);
 
-static void io_get_req_task(struct io_kiocb *req)
-{
-	if (req->flags & REQ_F_TASK_PINNED)
-		return;
-	get_task_struct(req->task);
-	req->flags |= REQ_F_TASK_PINNED;
-}
-
 static inline void io_clean_op(struct io_kiocb *req)
 {
 	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
@@ -957,13 +946,6 @@ static inline void io_clean_op(struct io_kiocb *req)
 		__io_clean_op(req);
 }
 
-/* not idempotent -- it doesn't clear REQ_F_TASK_PINNED */
-static void __io_put_req_task(struct io_kiocb *req)
-{
-	if (req->flags & REQ_F_TASK_PINNED)
-		put_task_struct(req->task);
-}
-
 static void io_sq_thread_drop_mm(void)
 {
 	struct mm_struct *mm = current->mm;
@@ -1589,7 +1571,8 @@ static void __io_free_req_finish(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	__io_put_req_task(req);
+	put_task_struct(req->task);
+
 	if (likely(!io_is_fallback_req(req)))
 		kmem_cache_free(req_cachep, req);
 	else
@@ -1916,16 +1899,13 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 	if (req->flags & REQ_F_LINK_HEAD)
 		io_queue_next(req);
 
-	if (req->flags & REQ_F_TASK_PINNED) {
-		if (req->task != rb->task) {
-			if (rb->task)
-				put_task_struct_many(rb->task, rb->task_refs);
-			rb->task = req->task;
-			rb->task_refs = 0;
-		}
-		rb->task_refs++;
-		req->flags &= ~REQ_F_TASK_PINNED;
+	if (req->task != rb->task) {
+		if (rb->task)
+			put_task_struct_many(rb->task, rb->task_refs);
+		rb->task = req->task;
+		rb->task_refs = 0;
 	}
+	rb->task_refs++;
 
 	WARN_ON_ONCE(io_dismantle_req(req));
 	rb->reqs[rb->to_free++] = req;
@@ -2550,9 +2530,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (kiocb->ki_flags & IOCB_NOWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
-	if (kiocb->ki_flags & IOCB_DIRECT)
-		io_get_req_task(req);
-
 	if (force_nonblock)
 		kiocb->ki_flags |= IOCB_NOWAIT;
 
@@ -2564,7 +2541,6 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
-		io_get_req_task(req);
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
@@ -3132,8 +3108,6 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	kiocb->ki_flags |= IOCB_WAITQ;
 	kiocb->ki_flags &= ~IOCB_NOWAIT;
 	kiocb->ki_waitq = wait;
-
-	io_get_req_task(req);
 	return true;
 }
 
@@ -4965,7 +4939,6 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	apoll->double_poll = NULL;
 
 	req->flags |= REQ_F_POLLED;
-	io_get_req_task(req);
 	req->apoll = apoll;
 	INIT_HLIST_NODE(&req->hash_node);
 
@@ -5148,8 +5121,6 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 #endif
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP |
 		       (events & EPOLLEXCLUSIVE);
-
-	io_get_req_task(req);
 	return 0;
 }
 
@@ -6336,7 +6307,6 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			return ret;
 		}
 		trace_io_uring_link(ctx, req, head);
-		io_get_req_task(req);
 		list_add_tail(&req->link_list, &head->link_list);
 
 		/* last request of a link, enqueue the link */
@@ -6461,6 +6431,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
 	req->task = current;
+	get_task_struct(req->task);
 	req->result = 0;
 
 	if (unlikely(req->opcode >= IORING_OP_LAST))
-- 
2.29.0


--------------4A1C62D62F0A548A85843422
Content-Type: text/x-patch; charset=UTF-8;
 name="0003-io_uring-stash-ctx-task-reference-for-SQPOLL.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-io_uring-stash-ctx-task-reference-for-SQPOLL.patch"

From 2951cff0148a9e1069201bd3c73c04e8bb13b19a Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 14 Sep 2020 10:45:53 -0600
Subject: [PATCH 03/14] io_uring: stash ctx task reference for SQPOLL

commit 2aede0e417db846793c276c7a1bbf7262c8349b0 upstream.

We can grab a reference to the task instead of stashing away the task
files_struct. This is doable without creating a circular reference
between the ring fd and the task itself.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 47 ++++++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 73c5dbb1591d..d24e0322bd1d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -265,7 +265,16 @@ struct io_ring_ctx {
 	/* IO offload */
 	struct io_wq		*io_wq;
 	struct task_struct	*sqo_thread;	/* if using sq thread polling */
-	struct mm_struct	*sqo_mm;
+
+	/*
+	 * For SQPOLL usage - we hold a reference to the parent task, so we
+	 * have access to the ->files
+	 */
+	struct task_struct	*sqo_task;
+
+	/* Only used for accounting purposes */
+	struct mm_struct	*mm_account;
+
 	wait_queue_head_t	sqo_wait;
 
 	/*
@@ -969,9 +978,10 @@ static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
 {
 	if (!current->mm) {
 		if (unlikely(!(ctx->flags & IORING_SETUP_SQPOLL) ||
-			     !mmget_not_zero(ctx->sqo_mm)))
+			     !ctx->sqo_task->mm ||
+			     !mmget_not_zero(ctx->sqo_task->mm)))
 			return -EFAULT;
-		kthread_use_mm(ctx->sqo_mm);
+		kthread_use_mm(ctx->sqo_task->mm);
 	}
 
 	return 0;
@@ -7591,11 +7601,11 @@ static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages,
 	if (ctx->limit_mem)
 		__io_unaccount_mem(ctx->user, nr_pages);
 
-	if (ctx->sqo_mm) {
+	if (ctx->mm_account) {
 		if (acct == ACCT_LOCKED)
-			ctx->sqo_mm->locked_vm -= nr_pages;
+			ctx->mm_account->locked_vm -= nr_pages;
 		else if (acct == ACCT_PINNED)
-			atomic64_sub(nr_pages, &ctx->sqo_mm->pinned_vm);
+			atomic64_sub(nr_pages, &ctx->mm_account->pinned_vm);
 	}
 }
 
@@ -7610,11 +7620,11 @@ static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages,
 			return ret;
 	}
 
-	if (ctx->sqo_mm) {
+	if (ctx->mm_account) {
 		if (acct == ACCT_LOCKED)
-			ctx->sqo_mm->locked_vm += nr_pages;
+			ctx->mm_account->locked_vm += nr_pages;
 		else if (acct == ACCT_PINNED)
-			atomic64_add(nr_pages, &ctx->sqo_mm->pinned_vm);
+			atomic64_add(nr_pages, &ctx->mm_account->pinned_vm);
 	}
 
 	return 0;
@@ -7918,9 +7928,12 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_finish_async(ctx);
 	io_sqe_buffer_unregister(ctx);
-	if (ctx->sqo_mm) {
-		mmdrop(ctx->sqo_mm);
-		ctx->sqo_mm = NULL;
+
+	if (ctx->sqo_task) {
+		put_task_struct(ctx->sqo_task);
+		ctx->sqo_task = NULL;
+		mmdrop(ctx->mm_account);
+		ctx->mm_account = NULL;
 	}
 
 	io_sqe_files_unregister(ctx);
@@ -8665,8 +8678,16 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ctx->user = user;
 	ctx->creds = get_current_cred();
 
+	ctx->sqo_task = get_task_struct(current);
+
+	/*
+	 * This is just grabbed for accounting purposes. When a process exits,
+	 * the mm is exited and dropped before the files, hence we need to hang
+	 * on to this mm purely for the purposes of being able to unaccount
+	 * memory (locked/pinned vm). It's not used for anything else.
+	 */
 	mmgrab(current->mm);
-	ctx->sqo_mm = current->mm;
+	ctx->mm_account = current->mm;
 
 	/*
 	 * Account memory _before_ installing the file descriptor. Once
-- 
2.29.0


--------------4A1C62D62F0A548A85843422
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-move-dropping-of-files-into-separate-helper.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-io_uring-move-dropping-of-files-into-separate-helper.pa";
 filename*1="tch"

From 851be0ed1af0a5cbeac216cfdd04e2695ca091ca Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 22 Sep 2020 10:19:24 -0600
Subject: [PATCH 02/14] io_uring: move dropping of files into separate helper

commit 0444ce1e0b5967393447dcd5adbf2bb023a50aab upstream.

No functional changes in this patch, prep patch for grabbing references
to the files_struct.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 867145fb149c..73c5dbb1591d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5648,6 +5648,20 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return -EIOCBQUEUED;
 }
 
+static void io_req_drop_files(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->inflight_lock, flags);
+	list_del(&req->inflight_entry);
+	if (waitqueue_active(&ctx->inflight_wait))
+		wake_up(&ctx->inflight_wait);
+	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
+	req->flags &= ~REQ_F_INFLIGHT;
+	req->work.files = NULL;
+}
+
 static void __io_clean_op(struct io_kiocb *req)
 {
 	struct io_async_ctx *io = req->io;
@@ -5697,17 +5711,8 @@ static void __io_clean_op(struct io_kiocb *req)
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
 
-	if (req->flags & REQ_F_INFLIGHT) {
-		struct io_ring_ctx *ctx = req->ctx;
-		unsigned long flags;
-
-		spin_lock_irqsave(&ctx->inflight_lock, flags);
-		list_del(&req->inflight_entry);
-		if (waitqueue_active(&ctx->inflight_wait))
-			wake_up(&ctx->inflight_wait);
-		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
-		req->flags &= ~REQ_F_INFLIGHT;
-	}
+	if (req->flags & REQ_F_INFLIGHT)
+		io_req_drop_files(req);
 }
 
 static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-- 
2.29.0


--------------4A1C62D62F0A548A85843422
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-allow-timeout-poll-files-killing-to-take-ta.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-io_uring-allow-timeout-poll-files-killing-to-take-ta.pa";
 filename*1="tch"

From 5ca57677cda6ea463276c72b3eddcd5482de081c Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 22 Sep 2020 08:18:24 -0600
Subject: [PATCH 01/14] io_uring: allow timeout/poll/files killing to take task
 into account

commit 07d3ca52b0056f25eef61b1c896d089f8d365468 upstream.

We currently cancel these when the ring exits, and we cancel all of
them. This is in preparation for killing only the ones associated
with a given task.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aae0ef2ec34d..867145fb149c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1226,13 +1226,26 @@ static void io_kill_timeout(struct io_kiocb *req)
 	}
 }
 
-static void io_kill_timeouts(struct io_ring_ctx *ctx)
+static bool io_task_match(struct io_kiocb *req, struct task_struct *tsk)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!tsk || req->task == tsk)
+		return true;
+	if ((ctx->flags & IORING_SETUP_SQPOLL) && req->task == ctx->sqo_thread)
+		return true;
+	return false;
+}
+
+static void io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk)
 {
 	struct io_kiocb *req, *tmp;
 
 	spin_lock_irq(&ctx->completion_lock);
-	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list)
-		io_kill_timeout(req);
+	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
+		if (io_task_match(req, tsk))
+			io_kill_timeout(req);
+	}
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
@@ -5017,7 +5030,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 	return do_complete;
 }
 
-static void io_poll_remove_all(struct io_ring_ctx *ctx)
+static void io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk)
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
@@ -5028,8 +5041,10 @@ static void io_poll_remove_all(struct io_ring_ctx *ctx)
 		struct hlist_head *list;
 
 		list = &ctx->cancel_hash[i];
-		hlist_for_each_entry_safe(req, tmp, list, hash_node)
-			posted += io_poll_remove_one(req);
+		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
+			if (io_task_match(req, tsk))
+				posted += io_poll_remove_one(req);
+		}
 	}
 	spin_unlock_irq(&ctx->completion_lock);
 
@@ -7989,8 +8004,8 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	percpu_ref_kill(&ctx->refs);
 	mutex_unlock(&ctx->uring_lock);
 
-	io_kill_timeouts(ctx);
-	io_poll_remove_all(ctx);
+	io_kill_timeouts(ctx, NULL);
+	io_poll_remove_all(ctx, NULL);
 
 	if (ctx->io_wq)
 		io_wq_cancel_all(ctx->io_wq);
@@ -8221,7 +8236,7 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct task_struct *task = data;
 
-	return req->task == task;
+	return io_task_match(req, task);
 }
 
 static int io_uring_flush(struct file *file, void *data)
-- 
2.29.0


--------------4A1C62D62F0A548A85843422--
