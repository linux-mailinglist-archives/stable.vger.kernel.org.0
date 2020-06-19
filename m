Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F64200AE4
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgFSOGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:06:32 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:56789 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbgFSOGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 10:06:31 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8F946194586F;
        Fri, 19 Jun 2020 10:06:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 10:06:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=odGO7X
        ZbqToTIBwH7J0w+uy8z4j56XulKgGEipH4AoI=; b=gWq8e7cBjUriR1JF/H+LG2
        DHw02F15FjVq6FPbGGyxmLIiD/gqB6WR+7EhyX9PuloLpYVubQhyi3yYB2BPO3nG
        IIAQHa6+F2B+2t94OJWHSUrXWSp+X1mPzG/cukjpQiBysQhtMfl+Bn838FhBLTxq
        /gkNLou32/7o2Sa6Nuv48zTMmYgr0+hgl48yT+DcPbBdMfL2abkbzclda13WVPsr
        l38vgtEjUHAPt3fLOks0nA0TQuVnmXO3XmDPJX9Wv3v1dT4MI3VX2TdnESZwitJz
        3oebg/Gep8KySYZXg8PodLOQufB2SeM1kembfSu+miKjPyA6fY+DJ5mVUE5i2InQ
        ==
X-ME-Sender: <xms:YsbsXm1i6_c-vyJbtDczQ9PxnH0eqpuqHgk8n6lkrM8x2Dyk0inRmw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:YsbsXpHyGJRrk4RvYq5GaZQytM_CNpbyamH8IJ8zFn1SFeNQZC1N6g>
    <xmx:YsbsXu7lmcvSqZ2HGA_6DPI6aGWIaXaWGHJuYMATKYWvSJEUlQxu7A>
    <xmx:YsbsXn0mZpXB8x9CvXkhLbgkRUl4F0hJ5aqV7DjVnpfWeGJwv8EVdw>
    <xmx:ZsbsXpDJ-FuU4zBXvXCd0ym36ywPSlZtiwc3XQD6ijr4AX4Ey-fSHw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C9B103060FE7;
        Fri, 19 Jun 2020 10:06:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] f2fs: avoid utf8_strncasecmp() with unstable name" failed to apply to 5.7-stable tree
To:     ebiggers@google.com, drosen@google.com, jaegeuk@kernel.org,
        krisman@collabora.co.uk, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 16:06:23 +0200
Message-ID: <1592575583131183@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fc3bb095ab02b9e7d89a069ade2cead15c64c504 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Mon, 1 Jun 2020 13:08:05 -0700
Subject: [PATCH] f2fs: avoid utf8_strncasecmp() with unstable name

If the dentry name passed to ->d_compare() fits in dentry::d_iname, then
it may be concurrently modified by a rename.  This can cause undefined
behavior (possibly out-of-bounds memory accesses or crashes) in
utf8_strncasecmp(), since fs/unicode/ isn't written to handle strings
that may be concurrently modified.

Fix this by first copying the filename to a stack buffer if needed.
This way we get a stable snapshot of the filename.

Fixes: 2c2eb7a300cd ("f2fs: Support case-insensitive file name lookups")
Cc: <stable@vger.kernel.org> # v5.4+
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Daniel Rosenberg <drosen@google.com>
Cc: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 29f70f2295cc..d35976785e8c 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -1114,11 +1114,27 @@ static int f2fs_d_compare(const struct dentry *dentry, unsigned int len,
 	const struct inode *dir = READ_ONCE(parent->d_inode);
 	const struct f2fs_sb_info *sbi = F2FS_SB(dentry->d_sb);
 	struct qstr entry = QSTR_INIT(str, len);
+	char strbuf[DNAME_INLINE_LEN];
 	int res;
 
 	if (!dir || !IS_CASEFOLDED(dir))
 		goto fallback;
 
+	/*
+	 * If the dentry name is stored in-line, then it may be concurrently
+	 * modified by a rename.  If this happens, the VFS will eventually retry
+	 * the lookup, so it doesn't matter what ->d_compare() returns.
+	 * However, it's unsafe to call utf8_strncasecmp() with an unstable
+	 * string.  Therefore, we have to copy the name into a temporary buffer.
+	 */
+	if (len <= DNAME_INLINE_LEN - 1) {
+		memcpy(strbuf, str, len);
+		strbuf[len] = 0;
+		entry.name = strbuf;
+		/* prevent compiler from optimizing out the temporary buffer */
+		barrier();
+	}
+
 	res = utf8_strncasecmp(sbi->s_encoding, name, &entry);
 	if (res >= 0)
 		return res;

