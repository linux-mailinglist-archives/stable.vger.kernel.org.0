Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30566AB701
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 08:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCFH0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 02:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCFH0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 02:26:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2901E9D6
        for <stable@vger.kernel.org>; Sun,  5 Mar 2023 23:26:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 328C860BC2
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 07:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4545FC433D2;
        Mon,  6 Mar 2023 07:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678087580;
        bh=dWPetDKE3qq/8sTP92gmOSlx3DxAo+hGQPVXD735YZU=;
        h=Subject:To:Cc:From:Date:From;
        b=yGF8sNN4N9EnC+H1HtodyvaSEFJPZWYADqNNtKcIoPspCU6IU1hnvnk0kjAik2cto
         P4QBR0zJgJm2IB1E4KpszT6yU63vN5cnBqmdylD2ffAXTrZ0t2P4r6aRJ8/WZlb6wy
         6zvrM7queuZW/rRPwF3g7YK49ufjLg1rP+3x9VdM=
Subject: FAILED: patch "[PATCH] block: be a bit more careful in checking for NULL bdev while" failed to apply to 5.15-stable tree
To:     axboe@kernel.dk, kbusch@kernel.org, wzhang@meta.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 08:26:18 +0100
Message-ID: <16780875786811@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 310726c33ad76cebdee312dbfafc12c1b44bf977
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '16780875786811@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

310726c33ad7 ("block: be a bit more careful in checking for NULL bdev while polling")
69fe0f298920 ("block: add ->poll_bio to block_device_operations")
7f36b7d02a28 ("block: move blk_crypto_bio_prep() out of blk-mq.c")
a650628bde77 ("block: move submit_bio_checks() into submit_bio_noacct")
9d497e2941c3 ("block: don't protect submit_bio_checks by q_usage_counter")
a08ed9aae8a3 ("block: fix double bio queue when merging in cached request path")
5f480b1a6325 ("blk-mq: use bio->bi_opf after bio is checked")
5b13bc8a3fd5 ("blk-mq: cleanup request allocation")
0c5bcc92d94a ("blk-mq: simplify the plug handling in blk_mq_submit_bio")
95febeb61bf8 ("block: fix missing queue put in error path")
b637108a4022 ("blk-mq: fix filesystem I/O request allocation")
b131f2011115 ("blk-mq: rename blk_attempt_bio_merge")
10c47870155b ("block: ensure cached plug request matches the current queue")
900e08075202 ("block: move queue enter logic into blk_mq_submit_bio()")
c98cb5bbdab1 ("block: make bio_queue_enter() fast-path available inline")
71539717c105 ("block: split request allocation components into helpers")
a1cb65377e70 ("blk-mq: only try to run plug merge if request has same queue with incoming bio")
e94f68527a35 ("block: kill extra rcu lock/unlock in queue enter")
179ae84f7ef5 ("block: clean up blk_mq_submit_bio() merging")
1497a51a3287 ("block: don't bloat enter_queue with percpu_ref")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 310726c33ad76cebdee312dbfafc12c1b44bf977 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 24 Feb 2023 10:01:19 -0700
Subject: [PATCH] block: be a bit more careful in checking for NULL bdev while
 polling

Wei reports a crash with an application using polled IO:

PGD 14265e067 P4D 14265e067 PUD 47ec50067 PMD 0
Oops: 0000 [#1] SMP
CPU: 0 PID: 21915 Comm: iocore_0 Kdump: loaded Tainted: G S                5.12.0-0_fbk12_clang_7346_g1bb6f2e7058f #1
Hardware name: Wiwynn Delta Lake MP T8/Delta Lake-Class2, BIOS Y3DLM08 04/10/2022
RIP: 0010:bio_poll+0x25/0x200
Code: 0f 1f 44 00 00 0f 1f 44 00 00 55 41 57 41 56 41 55 41 54 53 48 83 ec 28 65 48 8b 04 25 28 00 00 00 48 89 44 24 20 48 8b 47 08 <48> 8b 80 70 02 00 00 4c 8b 70 50 8b 6f 34 31 db 83 fd ff 75 25 65
RSP: 0018:ffffc90005fafdf8 EFLAGS: 00010292
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 74b43cd65dd66600
RDX: 0000000000000003 RSI: ffffc90005fafe78 RDI: ffff8884b614e140
RBP: ffff88849964df78 R08: 0000000000000000 R09: 0000000000000008
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88849964df00
R13: ffffc90005fafe78 R14: ffff888137d3c378 R15: 0000000000000001
FS:  00007fd195000640(0000) GS:ffff88903f400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000270 CR3: 0000000466121001 CR4: 00000000007706f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 iocb_bio_iopoll+0x1d/0x30
 io_do_iopoll+0xac/0x250
 __se_sys_io_uring_enter+0x3c5/0x5a0
 ? __x64_sys_write+0x89/0xd0
 do_syscall_64+0x2d/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x94f225d
Code: 24 cc 00 00 00 41 8b 84 24 d0 00 00 00 c1 e0 04 83 e0 10 41 09 c2 8b 33 8b 53 04 4c 8b 43 18 4c 63 4b 0c b8 aa 01 00 00 0f 05 <85> c0 0f 88 85 00 00 00 29 03 45 84 f6 0f 84 88 00 00 00 41 f6 c7
RSP: 002b:00007fd194ffcd88 EFLAGS: 00000202 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007fd194ffcdc0 RCX: 00000000094f225d
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000007
RBP: 00007fd194ffcdb0 R08: 0000000000000000 R09: 0000000000000008
R10: 0000000000000001 R11: 0000000000000202 R12: 00007fd269d68030
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000

which is due to bio->bi_bdev being NULL. This can happen if we have two
tasks doing polled IO, and task B ends up completing IO from task A if
they are sharing a poll queue. If task B completes the IO and puts the
bio into our cache, then it can allocate that bio again before task A
is done polling for it. As that would necessitate a preempt between the
two tasks, it's enough to just be a bit more careful in checking for
whether or not bio->bi_bdev is NULL.

Reported-and-tested-by: Wei Zhang <wzhang@meta.com>
Cc: stable@vger.kernel.org
Fixes: be4d234d7aeb ("bio: add allocation cache abstraction")
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-core.c b/block/blk-core.c
index 5fb6856745b4..5d7e2ca75234 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -854,10 +854,16 @@ EXPORT_SYMBOL(submit_bio);
  */
 int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
 {
-	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	blk_qc_t cookie = READ_ONCE(bio->bi_cookie);
+	struct block_device *bdev;
+	struct request_queue *q;
 	int ret = 0;
 
+	bdev = READ_ONCE(bio->bi_bdev);
+	if (!bdev)
+		return 0;
+
+	q = bdev_get_queue(bdev);
 	if (cookie == BLK_QC_T_NONE ||
 	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
 		return 0;
@@ -926,7 +932,7 @@ int iocb_bio_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
 	 */
 	rcu_read_lock();
 	bio = READ_ONCE(kiocb->private);
-	if (bio && bio->bi_bdev)
+	if (bio)
 		ret = bio_poll(bio, iob, flags);
 	rcu_read_unlock();
 

