Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60403161B4B
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgBQTMJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:12:09 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:50917 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728444AbgBQTMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:12:09 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6943E210DB;
        Mon, 17 Feb 2020 14:12:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 14:12:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fS7pJU
        1qDes0cdoh5ADB76lQpae7xDGzsM92VoahHBU=; b=nGjiEFpmCGe3WSkzOorHwG
        0Tyyt81nMTJvJ13m8PgvqrdQgRGm2wZXBRmbJx7E9BuTxMuqcVzszbO0FKo/pz8+
        jzkcihpYfhwZ4mlFumQibizelEKqFQnpoUmmr6m1NVMujbUGUZQRJRrhXzXnqB7q
        1aifzdMb+Kff/YnirWwM4USknjo1Qsi0bMBOxAOgC1gsEM4gswtytN39JKdpf5IU
        hLrNlqfAmHd7fncRVdlfVQl0G/QAdTJoST3/lFnBo7BVRiL1aaKJlfnHbRb5WLQW
        n9yBSzQEH5wp3lK28VBaA4JkZeO8vwsns7r8qcBxZIYd8pcZncgYzfYU/7TLpyYQ
        ==
X-ME-Sender: <xms:h-VKXm9fvUl6zuuHu-mpC7x_J28qroz54JiXPdYFfAlxej0ppL2MsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:h-VKXhdt3x1ipPRYhuSATNXUhtCtIeQG29F-UojAgPsW6g2MHsUUHA>
    <xmx:h-VKXq7s-gP0jPi5rmIWNrx8dtadOVtpGfJtS50dzbsg6fNMkx5QGA>
    <xmx:h-VKXlNzK9OMGLbSchOHW-kmvvCdyWvQZ5oNnqkBzRcWm6ehNvobYQ>
    <xmx:iOVKXoI2tfApDIrL2iYEdmMGH0KzykHrlw6jeuQgSVTIhMCoFRFpew>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A84E93060EE4;
        Mon, 17 Feb 2020 14:12:07 -0500 (EST)
Subject: FAILED: patch "[PATCH] io-wq: add support for inheriting ->fs" failed to apply to 5.5-stable tree
To:     axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 20:12:06 +0100
Message-ID: <1581966726127197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9392a27d88b9707145d713654eb26f0c29789e50 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 6 Feb 2020 21:42:51 -0700
Subject: [PATCH] io-wq: add support for inheriting ->fs

Some work items need this for relative path lookup, make it available
like the other inherited credentials/mm/etc.

Cc: stable@vger.kernel.org # 5.3+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io-wq.c b/fs/io-wq.c
index cb60a42b9fdf..7ac4a8876a50 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/rculist_nulls.h>
+#include <linux/fs_struct.h>
 
 #include "io-wq.h"
 
@@ -59,6 +60,7 @@ struct io_worker {
 	const struct cred *cur_creds;
 	const struct cred *saved_creds;
 	struct files_struct *restore_files;
+	struct fs_struct *restore_fs;
 };
 
 #if BITS_PER_LONG == 64
@@ -151,6 +153,9 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
 		task_unlock(current);
 	}
 
+	if (current->fs != worker->restore_fs)
+		current->fs = worker->restore_fs;
+
 	/*
 	 * If we have an active mm, we need to drop the wq lock before unusing
 	 * it. If we do, return true and let the caller retry the idle loop.
@@ -311,6 +316,7 @@ static void io_worker_start(struct io_wqe *wqe, struct io_worker *worker)
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
 	worker->restore_files = current->files;
+	worker->restore_fs = current->fs;
 	io_wqe_inc_running(wqe, worker);
 }
 
@@ -481,6 +487,8 @@ static void io_worker_handle_work(struct io_worker *worker)
 			current->files = work->files;
 			task_unlock(current);
 		}
+		if (work->fs && current->fs != work->fs)
+			current->fs = work->fs;
 		if (work->mm != worker->mm)
 			io_wq_switch_mm(worker, work);
 		if (worker->cur_creds != work->creds)
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 50b3378febf2..f152ba677d8f 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -74,6 +74,7 @@ struct io_wq_work {
 	struct files_struct *files;
 	struct mm_struct *mm;
 	const struct cred *creds;
+	struct fs_struct *fs;
 	unsigned flags;
 };
 
@@ -81,10 +82,11 @@ struct io_wq_work {
 	do {						\
 		(work)->list.next = NULL;		\
 		(work)->func = _func;			\
-		(work)->flags = 0;			\
 		(work)->files = NULL;			\
 		(work)->mm = NULL;			\
 		(work)->creds = NULL;			\
+		(work)->fs = NULL;			\
+		(work)->flags = 0;			\
 	} while (0)					\
 
 typedef void (get_work_fn)(struct io_wq_work *);

