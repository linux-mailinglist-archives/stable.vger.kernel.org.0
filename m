Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78682381D8E
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 11:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhEPJNa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 05:13:30 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:50799 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231258AbhEPJN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 05:13:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 7A3DEFB0;
        Sun, 16 May 2021 05:12:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 16 May 2021 05:12:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ogtwO8
        4csEYiCRV+tjmpLMpqYjb+VjuqbNEaETaUxrg=; b=CJLwxRvMQ+AgRnfzo2/Qbo
        cwGZSZnMd3ThciP/+Arfgbc4GA9V5p+cpReZLxh0KHljpdNAWAUtU0Iu/CIIe3I/
        AFCLfXErXkIXMlYlxKqHGlH+9KjDoEv4mBCkZ23A22mCYJjl+9YN3hUe1IPetYHb
        qcHbbttUFflivuQREtExFYWIQ+FC6aJL+e4chIPw4PbDZXXVzFRuB69+kxmV3fhE
        sj6xustWq1hQKLbIfdpnafZKmKaMyZXfqVok7M14I9qhc7pcwdJhGr8qJtJpVzeI
        cy2Fn4iK5xiTuG9NJ6vaA42PMSWAIEElR9MRwAm4wZEXV6t0GrNDJfcZCGL9ipcw
        ==
X-ME-Sender: <xms:7OGgYPYATP7lLFzMFYSZfsYYmukh2Fib7m8wAJ8JReTLtUEb0e8Wrg>
    <xme:7OGgYOaI9w2pUElU5qDtJbzput01rc7exQ9O5Y1xk3zvF00-c08tIawhhOGShzpfY
    vbZjIXxchvAqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeifedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:7OGgYB9GzPZ1YZOaZCyIdKaAzRHYP3YMqcdboP9ZqwtMM3cx75HGUw>
    <xmx:7OGgYFohcWcpu60JWX8kmGmis0m9q21KGnMz3d-P6chJETzYinmMlw>
    <xmx:7OGgYKrTXbZ4N0bMv5WD5x6jR5H_wIS8i3jr7qiwPIxQxiZp4Pvaqg>
    <xmx:7eGgYBRoqjt8wB4iQOMzShEr_MAFnNHb8-0ZVjDM-eBgSAJfwhNMay3kozg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 16 May 2021 05:12:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: fix link timeout refs" failed to apply to 5.11-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 May 2021 11:12:00 +0200
Message-ID: <16211563205623@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a298232ee6b9a1d5d732aa497ff8be0d45b5bd82 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Fri, 7 May 2021 21:06:38 +0100
Subject: [PATCH] io_uring: fix link timeout refs

WARNING: CPU: 0 PID: 10242 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
RIP: 0010:refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
Call Trace:
 __refcount_sub_and_test include/linux/refcount.h:283 [inline]
 __refcount_dec_and_test include/linux/refcount.h:315 [inline]
 refcount_dec_and_test include/linux/refcount.h:333 [inline]
 io_put_req fs/io_uring.c:2140 [inline]
 io_queue_linked_timeout fs/io_uring.c:6300 [inline]
 __io_queue_sqe+0xbef/0xec0 fs/io_uring.c:6354
 io_submit_sqe fs/io_uring.c:6534 [inline]
 io_submit_sqes+0x2bbd/0x7c50 fs/io_uring.c:6660
 __do_sys_io_uring_enter fs/io_uring.c:9240 [inline]
 __se_sys_io_uring_enter+0x256/0x1d60 fs/io_uring.c:9182

io_link_timeout_fn() should put only one reference of the linked timeout
request, however in case of racing with the master request's completion
first io_req_complete() puts one and then io_put_req_deferred() is
called.

Cc: stable@vger.kernel.org # 5.12+
Fixes: 9ae1f8dd372e0 ("io_uring: fix inconsistent lock state")
Reported-by: syzbot+a2910119328ce8e7996f@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/ff51018ff29de5ffa76f09273ef48cb24c720368.1620417627.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f46acbbeed57..9ac5e278a91e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6363,10 +6363,10 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	if (prev) {
 		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
 		io_put_req_deferred(prev, 1);
+		io_put_req_deferred(req, 1);
 	} else {
 		io_req_complete_post(req, -ETIME, 0);
 	}
-	io_put_req_deferred(req, 1);
 	return HRTIMER_NORESTART;
 }
 

