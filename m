Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFEFACC773
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 05:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbfJEDDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 23:03:21 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:45339 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfJEDDV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 23:03:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1570244600; x=1601780600;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=l+ae4mI+rKkfNaUZlrYvscNA5v1ibw33eQ5cRR1lRck=;
  b=ovdqGHsKgHeRPMPHJcf+jUyk/fytIVzOKZi62ScyPLk0Qp+loTznezLs
   nn2UFOHBNHMQt4u/8xmPrfMNveoQeLPJ+T8lXV3vFBSg8lNu/CmeBbyvU
   E81dz8C47/Py2mjT9EfPF2BPjCLGZ8PmmPZMZDLYqhLL4HbAldIIjGUXh
   NLEjYJY9p3lUjIo2mN/xvSohWMFVpieBUgng6p9Dk3M1CWrlVWlhtYj+J
   Rp+KpOj5jR05G+ecS8WpQ1O8+28F3EPJzkAS0u1g8hhLteYRK7YfYtm6w
   9WDLDNyfS/KIguQAnANOzi4lKokgUGsBzDUDH0OsDVEJnCz6xPKumf+A6
   A==;
IronPort-SDR: bfZ+Sof0SH1H1GbCLPDKW6RV9+yi4A6/ZB2BtGSyj89vOm2OYKNj+fwYdo8Guzg0wX/Eyj+weJ
 xyU6GppUr6Oj0Q+1FBm/fB6XoRtqkDTyAnaFA42GxkPc1nQFkaYwIX9jl/u1bIHJxwPI5vqflk
 Lw1gPFDHDtLz6pnrd4yy/3c+0hgHMPxwCGmkh2MbJNz9ECze5LJgRNwP79mDkBVkutsD831FAU
 OKuk8ELIaC6szcZAi0fFYKRR2+QgJUoPEGK9JL4rRZbsLcWuH/Yevr9aI9RVm7k5WgbhjQ8PYU
 uzw=
X-IronPort-AV: E=Sophos;i="5.67,258,1566835200"; 
   d="scan'208";a="119847696"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Oct 2019 11:03:20 +0800
IronPort-SDR: 1InCJYkVPhhiysQxZN78PR2+C+ULhb6Ju6DI0JQtbl6vC0kQymZgYJozJMzLbT8h9+Dlj42aZM
 +d2DLsaS2/Zi4vOO9t/vMDbh3N4EY4rGgSNk1Fz+/JQM+dfH3rREm6xtwaLiMD2PKx/FC76Phn
 zi5GjcqYWOl15g+ghHRXIkgmw/xb5MgbwWnp5huggWJJ8cvbgZJVGaKCQXQ4Xoi+oe+GxqMs3P
 QromRvOrVher0OAuvNJrLSffiWrFU8JY9p9kGFjBKj+VIE2VMGIi9HTBneViPLVdRsfEkM6iMz
 66Pk63xm6LzgbM2P2ywF2Laa
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 19:59:26 -0700
IronPort-SDR: I140Z8YAAG+6T/4vJnfZCzNGSeWEfvOxADc0earE6rzn2tM0rTc9JvyZc0cUx/VSOj0gNUdWrd
 HTTeBLiIdd4FAVNrx3ell8V6i+nvRmbWKhNuKoILbZTEE7GQFfVUNgKlDUCq0Lz3SHLDriUJjh
 MwkIv07cOrVQtK8eLPdYo5oEvCH8hCpj9gFSRmEEMZIpEj98CpxE1CDAK4PTrh9BvTZ3dXOJfV
 Khc3oFV67qW0th9mlnurBncvrU5KN/GQ7KvlCXcq6CbXpZjgyF5H903ZpIaDQik6M+vZlEm8Kp
 gHw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Oct 2019 20:03:19 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block: mq-deadline: Fix queue restart handling
Date:   Sat,  5 Oct 2019 12:03:18 +0900
Message-Id: <20191005030318.3786-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit cb8acabbe33b110157955a7425ee876fb81e6bbc ]

Commit 7211aef86f79 ("block: mq-deadline: Fix write completion
handling") added a call to blk_mq_sched_mark_restart_hctx() in
dd_dispatch_request() to make sure that write request dispatching does
not stall when all target zones are locked. This fix left a subtle race
when a write completion happens during a dispatch execution on another
CPU:

CPU 0: Dispatch			CPU1: write completion

dd_dispatch_request()
    lock(&dd->lock);
    ...
    lock(&dd->zone_lock);	dd_finish_request()
    rq = find request		lock(&dd->zone_lock);
    unlock(&dd->zone_lock);
    				zone write unlock
				unlock(&dd->zone_lock);
				...
				__blk_mq_free_request
                                      check restart flag (not set)
				      -> queue not run
    ...
    if (!rq && have writes)
        blk_mq_sched_mark_restart_hctx()
    unlock(&dd->lock)

Since the dispatch context finishes after the write request completion
handling, marking the queue as needing a restart is not seen from
__blk_mq_free_request() and blk_mq_sched_restart() not executed leading
to the dispatch stall under 100% write workloads.

Fix this by moving the call to blk_mq_sched_mark_restart_hctx() from
dd_dispatch_request() into dd_finish_request() under the zone lock to
ensure full mutual exclusion between write request dispatch selection
and zone unlock on write request completion.

Fixes: 7211aef86f79 ("block: mq-deadline: Fix write completion handling")
Cc: stable@vger.kernel.org
Reported-by: Hans Holmberg <Hans.Holmberg@wdc.com>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/mq-deadline.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index d5e21ce44d2c..69094d641062 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -376,13 +376,6 @@ static struct request *__dd_dispatch_request(struct deadline_data *dd)
  * hardware queue, but we may return a request that is for a
  * different hardware queue. This is because mq-deadline has shared
  * state for all hardware queues, in terms of sorting, FIFOs, etc.
- *
- * For a zoned block device, __dd_dispatch_request() may return NULL
- * if all the queued write requests are directed at zones that are already
- * locked due to on-going write requests. In this case, make sure to mark
- * the queue as needing a restart to ensure that the queue is run again
- * and the pending writes dispatched once the target zones for the ongoing
- * write requests are unlocked in dd_finish_request().
  */
 static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 {
@@ -391,9 +384,6 @@ static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
 
 	spin_lock(&dd->lock);
 	rq = __dd_dispatch_request(dd);
-	if (!rq && blk_queue_is_zoned(hctx->queue) &&
-	    !list_empty(&dd->fifo_list[WRITE]))
-		blk_mq_sched_mark_restart_hctx(hctx);
 	spin_unlock(&dd->lock);
 
 	return rq;
@@ -559,6 +549,13 @@ static void dd_prepare_request(struct request *rq, struct bio *bio)
  * spinlock so that the zone is never unlocked while deadline_fifo_request()
  * or deadline_next_request() are executing. This function is called for
  * all requests, whether or not these requests complete successfully.
+ *
+ * For a zoned block device, __dd_dispatch_request() may have stopped
+ * dispatching requests if all the queued requests are write requests directed
+ * at zones that are already locked due to on-going write requests. To ensure
+ * write request dispatch progress in this case, mark the queue as needing a
+ * restart to ensure that the queue is run again after completion of the
+ * request and zones being unlocked.
  */
 static void dd_finish_request(struct request *rq)
 {
@@ -570,6 +567,12 @@ static void dd_finish_request(struct request *rq)
 
 		spin_lock_irqsave(&dd->zone_lock, flags);
 		blk_req_zone_write_unlock(rq);
+		if (!list_empty(&dd->fifo_list[WRITE])) {
+			struct blk_mq_hw_ctx *hctx;
+
+			hctx = blk_mq_map_queue(q, rq->mq_ctx->cpu);
+			blk_mq_sched_mark_restart_hctx(hctx);
+		}
 		spin_unlock_irqrestore(&dd->zone_lock, flags);
 	}
 }
-- 
2.21.0

