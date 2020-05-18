Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D117A1D793B
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 15:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgERNEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 09:04:15 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:50917 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726989AbgERNEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 09:04:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 518341940726;
        Mon, 18 May 2020 09:04:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 18 May 2020 09:04:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gTW08H
        eGvQh3v55uAZr6iYZhC/NDz71YELNev97YnEU=; b=gfKQ44pWaZnUsJ4r8qq57q
        RRd+Mf2UbxnJOO51rCMNgSfS9opUoDEbP962hokuYSKtvuwtoJYChRCxBR508Nue
        CmEFgB/C2GnyoKvHxF0b3Uo6Cr7qcaV28+5mRYZXTsXs9PWTVnGo/6UILM/PpaGb
        7gqtZH7g11wjnYmmAi8I/L/HXyMnn4hbQFoWN9T221kDqXgH28D3JsVD3+Q+e0X9
        UuEjJYQ/PjmzkzibGnRd5wkwTUsG3lVhGLcqi9QdgM/BTgyXB6NJpPPk30XFpu9/
        wTwNc3va04Qb65wIiY4FD34ue3o9+6MwO6LNe/FWqu/uIU/gQAkeTfIO/L9gcihw
        ==
X-ME-Sender: <xms:zYfCXoLTPrs0cqlWH630Zl8cF8xogAc7am2vqHPs20y4SuZi6FUXqQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:zYfCXoL2lCvLguApHXtuAwRupec8x_NmUX97ZHeyCQGtEvJ_nxgItQ>
    <xmx:zYfCXosZHlcqyYrjkjBG-aJDIiHJi0-QlsIoFIFK6rMH8Rz8z-yWNw>
    <xmx:zYfCXlYuy30QxSjUnffl2t95btD93H-3PeiRzpBFuem-mvnvWpOJfw>
    <xmx:zofCXmxuvaDjqv4Bg3I4uJkWFJ-ySimD3v5-DPXy0wUW5JOtEXVJtQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 60078328005D;
        Mon, 18 May 2020 09:04:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: core: Fix recursive locking issue in CQE recovery path" failed to apply to 4.19-stable tree
To:     sartgarg@codeaurora.org, adrian.hunter@intel.com,
        stable@vger.kernel.org, stummala@codeaurora.org,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 15:04:10 +0200
Message-ID: <1589807050123171@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 39a22f73744d5baee30b5f134ae2e30b668b66ed Mon Sep 17 00:00:00 2001
From: Sarthak Garg <sartgarg@codeaurora.org>
Date: Thu, 7 May 2020 21:45:33 +0530
Subject: [PATCH] mmc: core: Fix recursive locking issue in CQE recovery path

Consider the following stack trace

-001|raw_spin_lock_irqsave
-002|mmc_blk_cqe_complete_rq
-003|__blk_mq_complete_request(inline)
-003|blk_mq_complete_request(rq)
-004|mmc_cqe_timed_out(inline)
-004|mmc_mq_timed_out

mmc_mq_timed_out acquires the queue_lock for the first
time. The mmc_blk_cqe_complete_rq function also tries to acquire
the same queue lock resulting in recursive locking where the task
is spinning for the same lock which it has already acquired leading
to watchdog bark.

Fix this issue with the lock only for the required critical section.

Cc: <stable@vger.kernel.org>
Fixes: 1e8e55b67030 ("mmc: block: Add CQE support")
Suggested-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Sarthak Garg <sartgarg@codeaurora.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/1588868135-31783-1-git-send-email-vbadigan@codeaurora.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 25bee3daf9e2..b5fd3bc7eb58 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -107,7 +107,7 @@ static enum blk_eh_timer_return mmc_cqe_timed_out(struct request *req)
 	case MMC_ISSUE_DCMD:
 		if (host->cqe_ops->cqe_timeout(host, mrq, &recovery_needed)) {
 			if (recovery_needed)
-				__mmc_cqe_recovery_notifier(mq);
+				mmc_cqe_recovery_notifier(mrq);
 			return BLK_EH_RESET_TIMER;
 		}
 		/* No timeout (XXX: huh? comment doesn't make much sense) */
@@ -127,18 +127,13 @@ static enum blk_eh_timer_return mmc_mq_timed_out(struct request *req,
 	struct mmc_card *card = mq->card;
 	struct mmc_host *host = card->host;
 	unsigned long flags;
-	int ret;
+	bool ignore_tout;
 
 	spin_lock_irqsave(&mq->lock, flags);
-
-	if (mq->recovery_needed || !mq->use_cqe || host->hsq_enabled)
-		ret = BLK_EH_RESET_TIMER;
-	else
-		ret = mmc_cqe_timed_out(req);
-
+	ignore_tout = mq->recovery_needed || !mq->use_cqe || host->hsq_enabled;
 	spin_unlock_irqrestore(&mq->lock, flags);
 
-	return ret;
+	return ignore_tout ? BLK_EH_RESET_TIMER : mmc_cqe_timed_out(req);
 }
 
 static void mmc_mq_recovery_handler(struct work_struct *work)

