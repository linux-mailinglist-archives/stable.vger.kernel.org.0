Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD432E3580
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgL1Jal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:30:41 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:55791 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1Jal (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:30:41 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 90D636F4;
        Mon, 28 Dec 2020 04:29:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:29:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/YJXlO
        TJKMgOhHo8oI6Kagb2APnWKlCmB/7T4J1JS4c=; b=TIbeOOyX1Ag9NFnUrGOjFU
        zi6j2L/bipnH6qcDdG16Ntq5gNEIqVDO4T0Rrm+PPmj+uMqXtkZrORWrUuiZF68Q
        3haZDBCMguKlBih7bX3eoDfjuCKdrf68D+wZB/9qZGAHTJmz46dPOso06omp3zNt
        2GkAiJ57S6rU1pdjq8nGSgQbH+Q0MXH8l9KDgMeJrfHTLK7zmF1ZfgQ+jozCqTca
        PfEQf1Nas7FN2hBGVOdeO4SEVH+rIqP6iz2N0B3hAJvd33+Xs089WEQ6EKKqbPxi
        KtW4RoawK3yG9VxK4C/NRMdO9RJhbr5jiwKX5TW0bra8HIvhLo6D6ye8BtXBhFsw
        ==
X-ME-Sender: <xms:f6XpXzH8HJ5ygcomFkJ66W7YG5_c7853T4tv1tqNo7IP0wAZXy8V7A>
    <xme:f6XpXwWDDaDIHBiWBG4us1cK2dKxkVmHU0CWw7IE0TyevTrQeUJXCZ3tAhYerzlLn
    DkVPtu_z0cLyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:f6XpX1Kfc18iBnlmh0aWIMRWQQOQvPQrYV_APHp_0mwLOXeeEfZieg>
    <xmx:f6XpXxHu2cWQSIIw312MMTgt2rONCjXWlSQQaOr5Q5nGJY11EJWPSQ>
    <xmx:f6XpX5VnnXtFpWz4iAX_m3MM5X2VTZkhMeDxYjJQqHRa8_e0P9bT8g>
    <xmx:f6XpX6eUAjt4Th-Jw-3-BL2uJkqswMJuYC5vUO0wY0m6Zn8RKM1UzUclRQU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id ED673240057;
        Mon, 28 Dec 2020 04:29:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] ubifs: wbuf: Don't leak kernel memory to flash" failed to apply to 4.14-stable tree
To:     richard@nod.at, chengzhihao1@huawei.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:30:49 +0100
Message-ID: <16091478492463@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

