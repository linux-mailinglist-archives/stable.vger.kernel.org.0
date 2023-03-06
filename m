Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355F36ABD3F
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 11:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjCFKtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 05:49:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCFKtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 05:49:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3171220699
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 02:49:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9C90B80D77
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 10:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AA1C433D2;
        Mon,  6 Mar 2023 10:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678099767;
        bh=0RhB2qzV+rlX4bTlneZFp2SDd21cM4yyuwqao2YtjP8=;
        h=Subject:To:Cc:From:Date:From;
        b=yF9PAsYp+BaAw/tmdQXJuPxVorZ/3Qm1WXb8BgNvGeKVbdDWNY2Tu0P+sVgtB1MyI
         mx9/SyInfMu8JD1bHZqNPEGWpdM+fSAX8lLt/JAofKYrsw1A4bw8Zq4a5VNmXN7rGy
         bZEFyjsa8X90lwHYs6LkSmgQ64728XuSme83Rlg0=
Subject: FAILED: patch "[PATCH] io_uring/rsrc: disallow multi-source reg buffers" failed to apply to 5.15-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 11:49:17 +0100
Message-ID: <1678099757152211@kroah.com>
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
git cherry-pick -x edd478269640b360c6f301f2baa04abdda563ef3
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678099757152211@kroah.com' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

edd478269640 ("io_uring/rsrc: disallow multi-source reg buffers")
735729844819 ("io_uring: move rsrc related data, core, and commands")
3b77495a9723 ("io_uring: split provided buffers handling into its own file")
7aaff708a768 ("io_uring: move cancelation into its own file")
329061d3e2f9 ("io_uring: move poll handling into its own file")
cfd22e6b3319 ("io_uring: add opcode name to io_op_defs")
92ac8beaea1f ("io_uring: include and forward-declaration sanitation")
c9f06aa7de15 ("io_uring: move io_uring_task (tctx) helpers into its own file")
a4ad4f748ea9 ("io_uring: move fdinfo helpers to its own file")
e5550a1447bf ("io_uring: use io_is_uring_fops() consistently")
17437f311490 ("io_uring: move SQPOLL related handling into its own file")
59915143e89f ("io_uring: move timeout opcodes and handling into its own file")
e418bbc97bff ("io_uring: move our reference counting into a header")
36404b09aa60 ("io_uring: move msg_ring into its own file")
f9ead18c1058 ("io_uring: split network related opcodes into its own file")
e0da14def1ee ("io_uring: move statx handling to its own file")
a9c210cebe13 ("io_uring: move epoll handler to its own file")
4cf90495281b ("io_uring: add a dummy -EOPNOTSUPP prep handler")
99f15d8d6136 ("io_uring: move uring_cmd handling to its own file")
cd40cae29ef8 ("io_uring: split out open/close operations")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From edd478269640b360c6f301f2baa04abdda563ef3 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Wed, 22 Feb 2023 14:36:48 +0000
Subject: [PATCH] io_uring/rsrc: disallow multi-source reg buffers

If two or more mappings go back to back to each other they can be passed
into io_uring to be registered as a single registered buffer. That would
even work if mappings came from different sources, e.g. it's possible to
mix in this way anon pages and pages from shmem or hugetlb. That is not
a problem but it'd rather be less prone if we forbid such mixing.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 4e6191904c9e..53845e496881 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1162,14 +1162,17 @@ struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages)
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
 			      pages, vmas);
 	if (pret == nr_pages) {
+		struct file *file = vmas[0]->vm_file;
+
 		/* don't support file backed memory */
 		for (i = 0; i < nr_pages; i++) {
-			struct vm_area_struct *vma = vmas[i];
-
-			if (vma_is_shmem(vma))
+			if (vmas[i]->vm_file != file) {
+				ret = -EINVAL;
+				break;
+			}
+			if (!file)
 				continue;
-			if (vma->vm_file &&
-			    !is_file_hugepages(vma->vm_file)) {
+			if (!vma_is_shmem(vmas[i]) && !is_file_hugepages(file)) {
 				ret = -EOPNOTSUPP;
 				break;
 			}

