Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0146D3EC7
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 10:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjDCITI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 04:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjDCITI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 04:19:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F2A59D4
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 01:19:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C161B812A1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 08:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1784AC433EF;
        Mon,  3 Apr 2023 08:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680509944;
        bh=9/bGWhtAmWJl3Hhxi0bm0hVBhdylDV8dPGdXfjQrfwU=;
        h=Subject:To:Cc:From:Date:From;
        b=lyYHsHhb4HsFocpOd7edRmnUiH+HYSyYvKiO1BO3jEiXfrXVYhfcGR1s28YwIkdIE
         coBj6DYpVvwF0DdP/jm9QHxskRqki3gCNbFgujX9E7ZBvjGU0J6h6pwYDFIG7I13bR
         Z/XKF1l9/F5+Kfo8trXgrEar+o5yOpeyBDANKJdc=
Subject: FAILED: patch "[PATCH] io_uring/poll: clear single/double poll flags on poll arming" failed to apply to 5.15-stable tree
To:     axboe@kernel.dk, pengfei.xu@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 03 Apr 2023 10:18:54 +0200
Message-ID: <2023040353-preview-jackknife-52f7@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
git cherry-pick -x 005308f7bdacf5685ed1a431244a183dbbb9e0e8
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023040353-preview-jackknife-52f7@gregkh' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

005308f7bdac ("io_uring/poll: clear single/double poll flags on poll arming")
5204aa8c43bd ("io_uring: add a helper for apoll alloc")
329061d3e2f9 ("io_uring: move poll handling into its own file")
cfd22e6b3319 ("io_uring: add opcode name to io_op_defs")
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
453b329be5ea ("io_uring: separate out file table handling code")
f4c163dd7d4b ("io_uring: split out fadvise/madvise operations")
0d5847274037 ("io_uring: split out fs related sync/fallocate functions")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 005308f7bdacf5685ed1a431244a183dbbb9e0e8 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 27 Mar 2023 19:56:18 -0600
Subject: [PATCH] io_uring/poll: clear single/double poll flags on poll arming

Unless we have at least one entry queued, then don't call into
io_poll_remove_entries(). Normally this isn't possible, but if we
retry poll then we can have ->nr_entries cleared again as we're
setting it up. If this happens for a poll retry, then we'll still have
at least REQ_F_SINGLE_POLL set. io_poll_remove_entries() then thinks
it has entries to remove.

Clear REQ_F_SINGLE_POLL and REQ_F_DOUBLE_POLL unconditionally when
arming a poll request.

Fixes: c16bda37594f ("io_uring/poll: allow some retries for poll triggering spuriously")
Cc: stable@vger.kernel.org
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 795facbd0e9f..55306e801081 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -726,6 +726,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	apoll = io_req_alloc_apoll(req, issue_flags);
 	if (!apoll)
 		return IO_APOLL_ABORTED;
+	req->flags &= ~(REQ_F_SINGLE_POLL | REQ_F_DOUBLE_POLL);
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
 

