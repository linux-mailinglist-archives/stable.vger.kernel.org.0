Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 956912E357D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgL1JaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:30:12 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:54925 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1JaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:30:12 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 629D1715;
        Mon, 28 Dec 2020 04:29:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:29:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=1foCcn
        bGFaoX5NKFS94SLhWhFR75KsnGzCjzFTvZilE=; b=SxZV1iEVyFvmqDpnTNfYoP
        MyzVuHKVzucSQbtaOWcxicQ5S40L1KYM7cqgcFVIXIIbzMrxc0ApJkLb5yIGQJlQ
        PDMLPtbY9z4ThX3ZM2OemdW7/p6x0FGUnbwhlU41QNTKbF+aVRZD1WHFLjvQ6f62
        GK9heKhGBQiEQsLKX5AhGjk5eOVPdDjzjytt0Fuo7a3/v8Pwjgc+hAJYDRWJ2gCD
        sAPHFq0yb0NlQBjctP99wRBA+nZTcKiAY9/myM4cMhqKsfJr9cdFhSd2FolkNfif
        dkuUJCtLd7Qkf1L4/fQhhk/fBgCKQznaoU8F/mUcolFnzEpYkGJUbdqaa+mE1qcw
        ==
X-ME-Sender: <xms:daXpXyV_gPnIuibuygRNA8mFJ_KpMShLKownrsOQyGz2sOiq9M8iuA>
    <xme:daXpX-l8A0InWqqLIKdg8xoaFbPzh0v0v4qySdpeNvn2aGprKv8eZb5FzcgzaO6q_
    QbBHMfGf7V_2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:daXpX2bd4WlWOaCuNrrDMNMyr458hDVUSxxzuxDUqKwnXaxCf9eHEA>
    <xmx:daXpX5VUANVVN9CQbrDXglPqAMvtw7qxpwCxwBKT9nZ3LaXPXolPpw>
    <xmx:daXpX8mlwWguyU3SVecQW1hmFUnIreRcZ4H9P6inzZX_9cdKVBihpg>
    <xmx:dqXpXzsBq3C563aPOCafESjT0CeALxy7CFsFZ_beMyKujFzt8hMtxwb5y4E>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 090E724005D;
        Mon, 28 Dec 2020 04:29:24 -0500 (EST)
Subject: FAILED: patch "[PATCH] ubifs: wbuf: Don't leak kernel memory to flash" failed to apply to 4.4-stable tree
To:     richard@nod.at, chengzhihao1@huawei.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:30:48 +0100
Message-ID: <1609147848125110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 20f1431160c6b590cdc269a846fc5a448abf5b98 Mon Sep 17 00:00:00 2001
From: Richard Weinberger <richard@nod.at>
Date: Mon, 16 Nov 2020 22:05:30 +0100
Subject: [PATCH] ubifs: wbuf: Don't leak kernel memory to flash

Write buffers use a kmalloc()'ed buffer, they can leak
up to seven bytes of kernel memory to flash if writes are not
aligned.
So use ubifs_pad() to fill these gaps with padding bytes.
This was never a problem while scanning because the scanner logic
manually aligns node lengths and skips over these gaps.

Cc: <stable@vger.kernel.org>
Fixes: 1e51764a3c2ac05a2 ("UBIFS: add new flash file system")
Signed-off-by: Richard Weinberger <richard@nod.at>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index 2dc933f73165..a9cabb3fa64c 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -319,7 +319,7 @@ void ubifs_pad(const struct ubifs_info *c, void *buf, int pad)
 {
 	uint32_t crc;
 
-	ubifs_assert(c, pad >= 0 && !(pad & 7));
+	ubifs_assert(c, pad >= 0);
 
 	if (pad >= UBIFS_PAD_NODE_SZ) {
 		struct ubifs_ch *ch = buf;
@@ -764,6 +764,10 @@ int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf, void *buf, int len)
 		 * write-buffer.
 		 */
 		memcpy(wbuf->buf + wbuf->used, buf, len);
+		if (aligned_len > len) {
+			ubifs_assert(c, aligned_len - len < 8);
+			ubifs_pad(c, wbuf->buf + wbuf->used + len, aligned_len - len);
+		}
 
 		if (aligned_len == wbuf->avail) {
 			dbg_io("flush jhead %s wbuf to LEB %d:%d",
@@ -856,13 +860,18 @@ int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf, void *buf, int len)
 	}
 
 	spin_lock(&wbuf->lock);
-	if (aligned_len)
+	if (aligned_len) {
 		/*
 		 * And now we have what's left and what does not take whole
 		 * max. write unit, so write it to the write-buffer and we are
 		 * done.
 		 */
 		memcpy(wbuf->buf, buf + written, len);
+		if (aligned_len > len) {
+			ubifs_assert(c, aligned_len - len < 8);
+			ubifs_pad(c, wbuf->buf + len, aligned_len - len);
+		}
+	}
 
 	if (c->leb_size - wbuf->offs >= c->max_write_size)
 		wbuf->size = c->max_write_size;

