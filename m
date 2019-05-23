Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCD52778A
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 09:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfEWH5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 03:57:10 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58895 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725814AbfEWH5K (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 03:57:10 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DFCDF2CA7D;
        Thu, 23 May 2019 03:57:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 23 May 2019 03:57:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=g1gETw
        I81lx9/1bBuYPdLDi7aeg2B4pft9vX8Fy+XxA=; b=cmAKCYAi5KK/pgTjz60Mpv
        Qui/eAcxtQFDb2ilHULN0h/wG5al8Gx1yoWRwc3pe7zcSKZeqIt9H+5YyhTiozg/
        eUhG9NuZYxgepcZtDOIHQa1tEorOvk5eAaOtjwIKD785XubjdQj+62Y9HvHiDJhO
        4lseNuXWGH/TdB+JERUI/9a0g6eLRYz+s02cjnsASn6h8AitjdC16qs2YfEJq6eg
        x8Fj+qaFMJLv4/PW9pIQgwyqVkffCmh7wmAnXHvlAFukdo4wkSs7vYyF6w3iCpPr
        2++qHFu6VxyBSYxKBNx/Aji8P3jh9/1xG7gXZitPHW4Dcj2dzaU1dZjWKRSrQe2A
        ==
X-ME-Sender: <xms:VFLmXO0AtHKkEeRzSs6zhxquxoAR9xzTvsr0RdZXYkFapNpB8q_6-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddufedguddvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepmhgrrhgtrdhinhhfohenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:VFLmXCfqD1LwANFUb8L6b6wVYvHoHokufLLVXYlBiLY-nqxr2W1gig>
    <xmx:VFLmXAJ80IbF-M4EgT9Rwj0RiKJy-LzshBxvjB44Axx6srU6AlpBfQ>
    <xmx:VFLmXIFP_ccztQf5wkyQJCElcOVll-tit3v0We_si-b_O0cpA7AOtQ>
    <xmx:VFLmXKbiAF-easGxdL6PQHvQT6wdRFMh82y0d-iqIq3tOJfxjE5yzw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4303C8005A;
        Thu, 23 May 2019 03:57:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] blk-mq: free hw queue's resource in hctx's release handler" failed to apply to 4.9-stable tree
To:     ming.lei@redhat.com, axboe@kernel.dk, bart.vanassche@wdc.com,
        dongli.zhang@oracle.com, hare@suse.com, hch@lst.de,
        james.smart@broadcom.com, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 May 2019 09:57:04 +0200
Message-ID: <155859822494229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c7e2d94b3d1634988a95ac4d77a72dc7487ece06 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Tue, 30 Apr 2019 09:52:25 +0800
Subject: [PATCH] blk-mq: free hw queue's resource in hctx's release handler

Once blk_cleanup_queue() returns, tags shouldn't be used any more,
because blk_mq_free_tag_set() may be called. Commit 45a9c9d909b2
("blk-mq: Fix a use-after-free") fixes this issue exactly.

However, that commit introduces another issue. Before 45a9c9d909b2,
we are allowed to run queue during cleaning up queue if the queue's
kobj refcount is held. After that commit, queue can't be run during
queue cleaning up, otherwise oops can be triggered easily because
some fields of hctx are freed by blk_mq_free_queue() in blk_cleanup_queue().

We have invented ways for addressing this kind of issue before, such as:

	8dc765d438f1 ("SCSI: fix queue cleanup race before queue initialization is done")
	c2856ae2f315 ("blk-mq: quiesce queue before freeing queue")

But still can't cover all cases, recently James reports another such
kind of issue:

	https://marc.info/?l=linux-scsi&m=155389088124782&w=2

This issue can be quite hard to address by previous way, given
scsi_run_queue() may run requeues for other LUNs.

Fixes the above issue by freeing hctx's resources in its release handler, and this
way is safe becasue tags isn't needed for freeing such hctx resource.

This approach follows typical design pattern wrt. kobject's release handler.

Cc: Dongli Zhang <dongli.zhang@oracle.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: linux-scsi@vger.kernel.org,
Cc: Martin K . Petersen <martin.petersen@oracle.com>,
Cc: Christoph Hellwig <hch@lst.de>,
Cc: James E . J . Bottomley <jejb@linux.vnet.ibm.com>,
Reported-by: James Smart <james.smart@broadcom.com>
Fixes: 45a9c9d909b2 ("blk-mq: Fix a use-after-free")
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: James Smart <james.smart@broadcom.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-core.c b/block/blk-core.c
index 2af1040b2fa6..81d209568a26 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -375,7 +375,7 @@ void blk_cleanup_queue(struct request_queue *q)
 	blk_exit_queue(q);
 
 	if (queue_is_mq(q))
-		blk_mq_free_queue(q);
+		blk_mq_exit_queue(q);
 
 	percpu_ref_exit(&q->q_usage_counter);
 
diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index 61efc2a29e58..7593c4c78975 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -11,6 +11,7 @@
 #include <linux/smp.h>
 
 #include <linux/blk-mq.h>
+#include "blk.h"
 #include "blk-mq.h"
 #include "blk-mq-tag.h"
 
@@ -34,6 +35,11 @@ static void blk_mq_hw_sysfs_release(struct kobject *kobj)
 {
 	struct blk_mq_hw_ctx *hctx = container_of(kobj, struct blk_mq_hw_ctx,
 						  kobj);
+
+	if (hctx->flags & BLK_MQ_F_BLOCKING)
+		cleanup_srcu_struct(hctx->srcu);
+	blk_free_flush_queue(hctx->fq);
+	sbitmap_free(&hctx->ctx_map);
 	free_cpumask_var(hctx->cpumask);
 	kfree(hctx->ctxs);
 	kfree(hctx);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 741cf8d55e9c..1fdb8de92a10 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2268,12 +2268,7 @@ static void blk_mq_exit_hctx(struct request_queue *q,
 	if (set->ops->exit_hctx)
 		set->ops->exit_hctx(hctx, hctx_idx);
 
-	if (hctx->flags & BLK_MQ_F_BLOCKING)
-		cleanup_srcu_struct(hctx->srcu);
-
 	blk_mq_remove_cpuhp(hctx);
-	blk_free_flush_queue(hctx->fq);
-	sbitmap_free(&hctx->ctx_map);
 }
 
 static void blk_mq_exit_hw_queues(struct request_queue *q,
@@ -2908,7 +2903,8 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 }
 EXPORT_SYMBOL(blk_mq_init_allocated_queue);
 
-void blk_mq_free_queue(struct request_queue *q)
+/* tags can _not_ be used after returning from blk_mq_exit_queue */
+void blk_mq_exit_queue(struct request_queue *q)
 {
 	struct blk_mq_tag_set	*set = q->tag_set;
 
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 423ea88ab6fb..633a5a77ee8b 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -37,7 +37,7 @@ struct blk_mq_ctx {
 	struct kobject		kobj;
 } ____cacheline_aligned_in_smp;
 
-void blk_mq_free_queue(struct request_queue *q);
+void blk_mq_exit_queue(struct request_queue *q);
 int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr);
 void blk_mq_wake_waiters(struct request_queue *q);
 bool blk_mq_dispatch_rq_list(struct request_queue *, struct list_head *, bool);

