Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3062E357F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgL1Jak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:30:40 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:43897 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1Jak (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:30:40 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 1388D752;
        Mon, 28 Dec 2020 04:29:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:29:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=pgG0iN
        siWyfKq+9ThCrVvlLj0oMxWmg+K84qKPSfxlw=; b=ko8blE1eMK0fLLH6N6Gpis
        1MF1shppE+pOYWDo+QF/SZTaqHl9Ulx6zVmoa75kOjYXnSJzKR77lqEjlyDrWXnl
        2zAHH3ztEmijm+ivuC09xenslsH7fsQfndQrn3lrdlEGIcim03WiNQENrwjcKsC6
        v4bcHXW+oFjBx5LvfV6PbZb0fdwZykuPB/R7UPVzTKBVoZihfKrkLyrniq2mqO0K
        NIB39I3fTlbPdgmLxBLBHp3doLHjVA07bN3dAbSY9J1wTJpcG+XKPmZlgLUB/KaX
        qCg8VrvmOYgA1tEbecqImPGlE6MbHAMvZ2eOS3XG4LlvARhb9dBE6F3mLFXhuKrA
        ==
X-ME-Sender: <xms:faXpXwgAPn8aPuktUrQLxzJ2d8rACRK0-bOaS3UMsey53Kw3cgUCbw>
    <xme:faXpX5BPwyAYHk-kihASnYcJj-NQ_SvGSecELjPbvFBmGJepETkXM0HFToRsV8RFW
    JAG0I6vV1Thfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:faXpX4GYxJzxAzNPz0wjBRTtOAhn53zI51inEDW7rRKr_BKTATDWGg>
    <xmx:faXpXxRBiBoJkHiyrtYmeARZNK181ndVgxyfnOn1hbZUgrbi2QzxXA>
    <xmx:faXpX9xxL0nrTfNKZNifTKuah24PAxwiQZbZEW-ne0RFA8syoYvw_g>
    <xmx:faXpX7bkAaIQ_X83d3X1K1dwffD3jVnCuRzkaTXbGUvy0Tn-n0DeutaQlsg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 38E8C1080063;
        Mon, 28 Dec 2020 04:29:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] ubifs: wbuf: Don't leak kernel memory to flash" failed to apply to 4.9-stable tree
To:     richard@nod.at, chengzhihao1@huawei.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:30:48 +0100
Message-ID: <160914784816172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

