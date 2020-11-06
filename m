Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F04D2A951F
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 12:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbgKFLRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 06:17:11 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:37229 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726694AbgKFLRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 06:17:11 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id EC789608;
        Fri,  6 Nov 2020 06:17:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 06 Nov 2020 06:17:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Vk2ssG
        DsY6dDBhdUYgVxtHdpZJXbWuWQfFn0DONtpjo=; b=kEmJ1zfDQBwjdEasgh9uKu
        wiWw4xoIEqn+3EkcLU1eDCpiDuEcaEuR46BLg15Qr+4uwy/EvoRYVVk9C7wa7q9G
        nAmMkkSnm+usfJ+EP5IDWHg8r9I1zd5Q0iPw76xxAutmIiYiqQGnxw4s4vqiUFst
        E4ymZ8RqwSOJE6DI61w3lHKqddUgRte0lWrU3jiT4au6WvCzPIOBskBuA8JSmFlr
        3jljP1T0pjyhd2IZ2QGToHZBpn/LzAYu0v5V9uJIhKSIKsPqSzHy02i+jzxQtl9B
        dvJ2xqxrfh6gVuURdJeF5xs9QbwkcRUBWvqwquQTih6ok6lkO5SEJF84wo9V/96Q
        ==
X-ME-Sender: <xms:tTClX9vP6Irxk81NyzpNa8Ub74voK9dgazQfhAM3MsTsE92yO5a2lQ>
    <xme:tTClX2deuR8QgFHT4dBRjyYHHEny5_5Zv1GtlHBSSJIsKmmrfTEbTRU3-CAaD0je1
    Ms-G9LSaFybAQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtledgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:tTClXwwUEl3To70AUjY0Qpcin7UUmn-ebH60HHckU0towI4ZWaWbuA>
    <xmx:tTClX0O9qAa3AXksYXiCkdVKGUQ-c4tv3fyGYe5hoqK6hwLOU1YxWw>
    <xmx:tTClX9-L6j-8sVr70Z9lOFc5McSS_FfVh01WZDfztQrZqB44wBt4Aw>
    <xmx:tTClX6Em0bsAcfxdjLrhCsYpk0__6BvGy8KaSOxxy1vt2_zooH9xnxx_HWE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 18DD2306005E;
        Fri,  6 Nov 2020 06:17:09 -0500 (EST)
Subject: FAILED: patch "[PATCH] RDMA/ucma: Rework ucma_migrate_id() to avoid races with" failed to apply to 5.9-stable tree
To:     jgg@ziepe.ca, jgg@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 06 Nov 2020 12:17:54 +0100
Message-ID: <160466147449214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f5449e74802c1112dea984aec8af7a33c4516af1 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Mon, 14 Sep 2020 08:59:56 -0300
Subject: [PATCH] RDMA/ucma: Rework ucma_migrate_id() to avoid races with
 destroy

ucma_destroy_id() assumes that all things accessing the ctx will do so via
the xarray. This assumption violated only in the case the FD is being
closed, then the ctx is reached via the ctx_list. Normally this is OK
since ucma_destroy_id() cannot run concurrenty with release(), however
with ucma_migrate_id() is involved this can violated as the close of the
2nd FD can run concurrently with destroy on the first:

                CPU0                      CPU1
        ucma_destroy_id(fda)
                                  ucma_migrate_id(fda -> fdb)
                                       ucma_get_ctx()
        xa_lock()
         _ucma_find_context()
         xa_erase()
        xa_unlock()
                                       xa_lock()
                                        ctx->file = new_file
                                        list_move()
                                       xa_unlock()
                                      ucma_put_ctx()

                                   ucma_close(fdb)
                                      _destroy_id()
                                      kfree(ctx)

        _destroy_id()
          wait_for_completion()
          // boom, ctx was freed

The ctx->file must be modified under the handler and xa_lock, and prior to
modification the ID must be rechecked that it is still reachable from
cur_file, ie there is no parallel destroy or migrate.

To make this work remove the double locking and streamline the control
flow. The double locking was obsoleted by the handler lock now directly
preventing new uevents from being created, and the ctx_list cannot be read
while holding fgets on both files. Removing the double locking also
removes the need to check for the same file.

Fixes: 88314e4dda1e ("RDMA/cma: add support for rdma_migrate_id()")
Link: https://lore.kernel.org/r/0-v1-05c5a4090305+3a872-ucma_syz_migrate_jgg@nvidia.com
Reported-and-tested-by: syzbot+cc6fc752b3819e082d0c@syzkaller.appspotmail.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index a5595bd489b0..b3a7dbb12f25 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -1587,45 +1587,15 @@ static ssize_t ucma_leave_multicast(struct ucma_file *file,
 	return ret;
 }
 
-static void ucma_lock_files(struct ucma_file *file1, struct ucma_file *file2)
-{
-	/* Acquire mutex's based on pointer comparison to prevent deadlock. */
-	if (file1 < file2) {
-		mutex_lock(&file1->mut);
-		mutex_lock_nested(&file2->mut, SINGLE_DEPTH_NESTING);
-	} else {
-		mutex_lock(&file2->mut);
-		mutex_lock_nested(&file1->mut, SINGLE_DEPTH_NESTING);
-	}
-}
-
-static void ucma_unlock_files(struct ucma_file *file1, struct ucma_file *file2)
-{
-	if (file1 < file2) {
-		mutex_unlock(&file2->mut);
-		mutex_unlock(&file1->mut);
-	} else {
-		mutex_unlock(&file1->mut);
-		mutex_unlock(&file2->mut);
-	}
-}
-
-static void ucma_move_events(struct ucma_context *ctx, struct ucma_file *file)
-{
-	struct ucma_event *uevent, *tmp;
-
-	list_for_each_entry_safe(uevent, tmp, &ctx->file->event_list, list)
-		if (uevent->ctx == ctx)
-			list_move_tail(&uevent->list, &file->event_list);
-}
-
 static ssize_t ucma_migrate_id(struct ucma_file *new_file,
 			       const char __user *inbuf,
 			       int in_len, int out_len)
 {
 	struct rdma_ucm_migrate_id cmd;
 	struct rdma_ucm_migrate_resp resp;
+	struct ucma_event *uevent, *tmp;
 	struct ucma_context *ctx;
+	LIST_HEAD(event_list);
 	struct fd f;
 	struct ucma_file *cur_file;
 	int ret = 0;
@@ -1641,43 +1611,52 @@ static ssize_t ucma_migrate_id(struct ucma_file *new_file,
 		ret = -EINVAL;
 		goto file_put;
 	}
+	cur_file = f.file->private_data;
 
 	/* Validate current fd and prevent destruction of id. */
-	ctx = ucma_get_ctx(f.file->private_data, cmd.id);
+	ctx = ucma_get_ctx(cur_file, cmd.id);
 	if (IS_ERR(ctx)) {
 		ret = PTR_ERR(ctx);
 		goto file_put;
 	}
 
 	rdma_lock_handler(ctx->cm_id);
-	cur_file = ctx->file;
-	if (cur_file == new_file) {
-		mutex_lock(&cur_file->mut);
-		resp.events_reported = ctx->events_reported;
-		mutex_unlock(&cur_file->mut);
-		goto response;
-	}
-
 	/*
-	 * Migrate events between fd's, maintaining order, and avoiding new
-	 * events being added before existing events.
+	 * ctx->file can only be changed under the handler & xa_lock. xa_load()
+	 * must be checked again to ensure the ctx hasn't begun destruction
+	 * since the ucma_get_ctx().
 	 */
-	ucma_lock_files(cur_file, new_file);
 	xa_lock(&ctx_table);
-
-	list_move_tail(&ctx->list, &new_file->ctx_list);
-	ucma_move_events(ctx, new_file);
+	if (_ucma_find_context(cmd.id, cur_file) != ctx) {
+		xa_unlock(&ctx_table);
+		ret = -ENOENT;
+		goto err_unlock;
+	}
 	ctx->file = new_file;
+	xa_unlock(&ctx_table);
+
+	mutex_lock(&cur_file->mut);
+	list_del(&ctx->list);
+	/*
+	 * At this point lock_handler() prevents addition of new uevents for
+	 * this ctx.
+	 */
+	list_for_each_entry_safe(uevent, tmp, &cur_file->event_list, list)
+		if (uevent->ctx == ctx)
+			list_move_tail(&uevent->list, &event_list);
 	resp.events_reported = ctx->events_reported;
+	mutex_unlock(&cur_file->mut);
 
-	xa_unlock(&ctx_table);
-	ucma_unlock_files(cur_file, new_file);
+	mutex_lock(&new_file->mut);
+	list_add_tail(&ctx->list, &new_file->ctx_list);
+	list_splice_tail(&event_list, &new_file->event_list);
+	mutex_unlock(&new_file->mut);
 
-response:
 	if (copy_to_user(u64_to_user_ptr(cmd.response),
 			 &resp, sizeof(resp)))
 		ret = -EFAULT;
 
+err_unlock:
 	rdma_unlock_handler(ctx->cm_id);
 	ucma_put_ctx(ctx);
 file_put:

