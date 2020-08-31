Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D65257707
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 11:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgHaJ73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 05:59:29 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:50285 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726081AbgHaJ7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 05:59:18 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 0CD5C69B;
        Mon, 31 Aug 2020 05:59:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 05:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kH4AB0
        Mz95vAQaZoGgvE8jgRlPHAZIGLyWLAXm6i0PY=; b=NPBbFQs/C0hsa7bpxkQ/04
        WGQmMWJbWx5c9JNXaD6ajYvIcAe4W6fuqkgAK9R9zCg+O3jtfgChDZh80tPF0+f1
        zOShVAVAeuaQhK6q7akoIIBu8CD575wHTU7UqBUsE/p3BKupeWPJ7h0LrpOEXxYd
        1PS2BzIAKAuxD9pHsRSzqQseZRNNGFU+An1gWtUcPUD6dflBPWoK/UDTbWZ0j1r1
        qnIDQTT/Jh4MAaLtnqcjQmSGzwRnxw8HwGxEqn0n7jljjnnLkskDK8BMm2T1euZg
        MAYuRsbqEEQxuouv9D15bf28/koobS1KpMltxidtDu/aumy6g7+4+58ptlxjI7dw
        ==
X-ME-Sender: <xms:9MlMX8p_FY9y-p3Qv1qkWS3SHFKFvS4VSu0Gaf25pY7sA4c-V3JJLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:9MlMXyoBJX_xXN2H_ayal1NhRtWYrSYuNv3fsIGZggluZ5nKQwgN6w>
    <xmx:9MlMXxOT5deqbJm9mA4bxMSQjLX4dR3g-yGaH_jZTtZ12Vx0XndFtQ>
    <xmx:9MlMXz4dSoMmmLID9EywF6LWPAP0EjhoVfhgu5BBH90XptH7-bWxkQ>
    <xmx:9MlMX0VvVBCPzXNtJTRbnnbQwHULkwJOTrG9rGktVkcozCis_oOZ0rXbDxU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 34C7E3280064;
        Mon, 31 Aug 2020 05:59:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: make offset == -1 consistent with preadv2/pwritev2" failed to apply to 5.8-stable tree
To:     axboe@kernel.dk, wisp3rwind@posteo.eu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 11:59:25 +0200
Message-ID: <1598867965216125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0fef948363f62494d779cf9dc3c0a86ea1e5f7cd Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Wed, 26 Aug 2020 10:36:20 -0600
Subject: [PATCH] io_uring: make offset == -1 consistent with preadv2/pwritev2

The man page for io_uring generally claims were consistent with what
preadv2 and pwritev2 accept, but turns out there's a slight discrepancy
in how offset == -1 is handled for pipes/streams. preadv doesn't allow
it, but preadv2 does. This currently causes io_uring to return -EINVAL
if that is attempted, but we should allow that as documented.

This change makes us consistent with preadv2/pwritev2 for just passing
in a NULL ppos for streams if the offset is -1.

Cc: stable@vger.kernel.org # v5.7+
Reported-by: Benedikt Ames <wisp3rwind@posteo.eu>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d9b88644d5e8..bd2d8de3f2e8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2866,6 +2866,11 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	return iov_iter_count(&req->io->rw.iter);
 }
 
+static inline loff_t *io_kiocb_ppos(struct kiocb *kiocb)
+{
+	return kiocb->ki_filp->f_mode & FMODE_STREAM ? NULL : &kiocb->ki_pos;
+}
+
 /*
  * For files that don't have ->read_iter() and ->write_iter(), handle them
  * by looping over ->read() or ->write() manually.
@@ -2901,10 +2906,10 @@ static ssize_t loop_rw_iter(int rw, struct file *file, struct kiocb *kiocb,
 
 		if (rw == READ) {
 			nr = file->f_op->read(file, iovec.iov_base,
-					      iovec.iov_len, &kiocb->ki_pos);
+					      iovec.iov_len, io_kiocb_ppos(kiocb));
 		} else {
 			nr = file->f_op->write(file, iovec.iov_base,
-					       iovec.iov_len, &kiocb->ki_pos);
+					       iovec.iov_len, io_kiocb_ppos(kiocb));
 		}
 
 		if (iov_iter_is_bvec(iter))
@@ -3139,7 +3144,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		goto copy_iov;
 
 	iov_count = iov_iter_count(iter);
-	ret = rw_verify_area(READ, req->file, &kiocb->ki_pos, iov_count);
+	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), iov_count);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -3262,7 +3267,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 		goto copy_iov;
 
 	iov_count = iov_iter_count(iter);
-	ret = rw_verify_area(WRITE, req->file, &kiocb->ki_pos, iov_count);
+	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), iov_count);
 	if (unlikely(ret))
 		goto out_free;
 

