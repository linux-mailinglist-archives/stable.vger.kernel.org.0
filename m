Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0922381D8C
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 11:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhEPJNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 05:13:18 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:49735 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231258AbhEPJNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 05:13:18 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 4BD97FD9;
        Sun, 16 May 2021 05:12:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 16 May 2021 05:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=GGECgD
        kQgpaPkFo5DtcQZYVvfdtmEpzlX7xV+fXcWVI=; b=YkUJTsPQ2uJx4FjdUGHb8o
        wBsyvaVFXtM4TuwlWALxxMakQhxrUCIa8aZ6TjpmEsk3reLuqntt/1BJmIfIUIIu
        YBVd5LHisxSBduUnQ9AwnQQQdbRxKZ+miv+3wAxigEzhgVr7UzmNdpgYwTDRLX7D
        4dbEOrn/V0ye/AbgZYwcS0YMNkEgB+sc0XVl3i6S0bG0FkI06PCo6T1BjlM++/4x
        tOE/0XhL/t6hCj2BEfKe2AdHsYQdrC7RNmuqT+Ed8U/EZR7LTYb90iBDJwHX/Egi
        NUDeCuYu6i/MAmTAN9GKlcI6nhBJIL6aK8vP5Y5vDgOh7fKP0FtSrIbw2aNF0BcQ
        ==
X-ME-Sender: <xms:4uGgYKgbCmVsP9l5nMOSd3bfyx5l7ZeBYTupdOk62nGL26GkKPyZaQ>
    <xme:4uGgYLDS_JDD8xBByXsa7M8MrYWdr4nDphvEFd2xqEfgW21-Sd4s99pbu8Be8Gh3q
    cH8mVatjhfKxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeifedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:4uGgYCEtkLKyUPgyVF4ECrqhDxxx42Bh_LyNMF1YUg66DWlxtFoyvA>
    <xmx:4uGgYDRJPg1LHQL7g2WQKZfY2dKrDJrHoztqb9sxoTJF6fi8BxsehQ>
    <xmx:4uGgYHynfWk0U7eoZAcIYWooXGDf6F_5sS4oci96apxT6oyEri0Y4Q>
    <xmx:4uGgYFZtr72E_69hpunSnX8brPLXU9xmVVh3foFShC78DhfW1Z5HoRTZ7UY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 16 May 2021 05:12:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: fix link timeout refs" failed to apply to 5.10-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 May 2021 11:11:59 +0200
Message-ID: <1621156319162132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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
 

