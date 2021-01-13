Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3168C2F581F
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 04:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbhANCO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 21:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729127AbhAMV1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 16:27:34 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB314C061794
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 13:26:44 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id c5so3643537wrp.6
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 13:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D1S3P3wYxnauf8f9jx7zANHe34sHwRv+daV5YIyiXhI=;
        b=Hrx/TaCfkJxtFNQa87eSBcMRfQ2c11QFmYtwGQbkuAjYvfa1BqthfTmxUqddELSwjT
         QnIfCNNd1BqJVSubzsI/hTeOTFnP1fFsYp+Fri0PQ7XxV32I/zyPkXEec/XAs3el8RKs
         XblAiRS4xz0zN46dV5dPk5M3Q6gRcJPxi87i6iMLwdOqkRczF5EpX/uYCZo0WueV+FAZ
         Vr4GUhA5Vt2lmSMSBuzBFThT7/K7f0Fr8iHvINMSE5ePxrSjnQm9Oil+zXJzLoKIHXeF
         rMyTplysQKjeILSpLYplYKZrhCoNFsLxnvJGyMUHOXuB2xRky5vn4GgPMW71kg1CNwlH
         iRhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=D1S3P3wYxnauf8f9jx7zANHe34sHwRv+daV5YIyiXhI=;
        b=n7xb7gZ/jbka+ouZ9hPTWEiRDp5oSdalYm0e4ukGGAvtCPDEQZ87iz08lnhtEHMNny
         DEQFGcJx3TxpBZe0NXtq+hBVw+HhYdlI7wKFIqxxZQUxjaVr+W6lVx2JzKkPD4/MBiOz
         gN4Rm+uUJoHqQMAhyrG9MM4jwBvU/C+1SuS3b0Fg1HtyIqmIgjRxkOWrU9Peuc9J9rjp
         AGqMY4P7n7Vf/sJTbNv1hNC1w2fgY9BoI/Md0MpJPjs/UFKnnnIoLxOPn6p7yrDZIvuq
         Dk03/uya6HPF73iVkIAZiF3JrKTDSvMKAXoNBfGjOvUX+UIr5oaSUtv8KO/ZN/8K88HR
         fzMQ==
X-Gm-Message-State: AOAM530HFRTV8TEGNBjhxUuqZcpQ+e2e4yjBK4NSDmm8Lfe+pWH4aqj5
        3AHZUX4mUpA4Yx4zSx4dLzM=
X-Google-Smtp-Source: ABdhPJwP+ttaYYnSESefVT4LRs4iEzFaWvXs8Bl61dZVgrsF+Nar98FMXk8MnVoOKIqF7T3pLrfpmg==
X-Received: by 2002:a5d:6206:: with SMTP id y6mr4612633wru.413.1610573202520;
        Wed, 13 Jan 2021 13:26:42 -0800 (PST)
Received: from debian (host-92-5-250-55.as43234.net. [92.5.250.55])
        by smtp.gmail.com with ESMTPSA id m18sm5456190wrw.43.2021.01.13.13.26.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Jan 2021 13:26:41 -0800 (PST)
Date:   Wed, 13 Jan 2021 21:26:39 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     richard@nod.at, chengzhihao1@huawei.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ubifs: wbuf: Don't leak kernel memory to
 flash" failed to apply to 4.14-stable tree
Message-ID: <20210113212639.a5ltkvm3dj4zkhk2@debian>
References: <16091478492463@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sqfw2mnviq6us6eg"
Content-Disposition: inline
In-Reply-To: <16091478492463@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sqfw2mnviq6us6eg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Dec 28, 2020 at 10:30:49AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 4.9-stable and 4.4-stable.

--
Regards
Sudip

--sqfw2mnviq6us6eg
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-ubifs-wbuf-Don-t-leak-kernel-memory-to-flash.patch"

From b37cba57bea48fba2de82b9def75167730cefb3b Mon Sep 17 00:00:00 2001
From: Richard Weinberger <richard@nod.at>
Date: Mon, 16 Nov 2020 22:05:30 +0100
Subject: [PATCH] ubifs: wbuf: Don't leak kernel memory to flash

commit 20f1431160c6b590cdc269a846fc5a448abf5b98 upstream

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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/ubifs/io.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index 135e95950f51..5b4d4b1087c4 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -331,7 +331,7 @@ void ubifs_pad(const struct ubifs_info *c, void *buf, int pad)
 {
 	uint32_t crc;
 
-	ubifs_assert(pad >= 0 && !(pad & 7));
+	ubifs_assert(pad >= 0);
 
 	if (pad >= UBIFS_PAD_NODE_SZ) {
 		struct ubifs_ch *ch = buf;
@@ -727,6 +727,10 @@ int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf, void *buf, int len)
 		 * write-buffer.
 		 */
 		memcpy(wbuf->buf + wbuf->used, buf, len);
+		if (aligned_len > len) {
+			ubifs_assert(aligned_len - len < 8);
+			ubifs_pad(c, wbuf->buf + wbuf->used + len, aligned_len - len);
+		}
 
 		if (aligned_len == wbuf->avail) {
 			dbg_io("flush jhead %s wbuf to LEB %d:%d",
@@ -819,13 +823,18 @@ int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf, void *buf, int len)
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
+			ubifs_assert(aligned_len - len < 8);
+			ubifs_pad(c, wbuf->buf + len, aligned_len - len);
+		}
+	}
 
 	if (c->leb_size - wbuf->offs >= c->max_write_size)
 		wbuf->size = c->max_write_size;
-- 
2.11.0


--sqfw2mnviq6us6eg--
