Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41B7520C8C5
	for <lists+stable@lfdr.de>; Sun, 28 Jun 2020 17:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgF1Ptt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 11:49:49 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:41651 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbgF1Ptt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jun 2020 11:49:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id E9D751940709;
        Sun, 28 Jun 2020 11:49:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 28 Jun 2020 11:49:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QWvXXU
        NLntABvcU1Z0PtjPlyUN42fI/D35yQaUkbRuU=; b=eg4fnw0ym2D0qCWr7fc9RL
        mKXO370TAUomp3icG2on+8PjiQK9ML3EYRphGGI4mS6vfH9VvAmOcDVxjcQKrkCd
        CsiaXhDY5RIrGspEw/1Sirw6NB+dQQfuJ09x1mGBForYsPsKjN+hyCLOelRjbOxY
        +Uu533uzrs9+wLrXoIo5KhjSS9rcy0b1lqQqnHjFhTx5XRgmGaerGFFZREFbpSB8
        f+7jXw5Siq6Z8D6C0p3TbnbLHPGwcy8hXJiMaqHkoxKu/hJWXg/P/qGA3u3HC6pF
        oYDZbvI0GWXH66popYtof2mSSZTjx35rNPgDqnHe6SyBYGETw5QFsw7pqJa6S2rQ
        ==
X-ME-Sender: <xms:G7z4XkQzVR0xrN5ffNuN29yalPe_hmNGztYBAn9c0kc5mNXuhU1b7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeliedgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:G7z4XhwI_Ivvf8fuOPHgVdjbmblYPfJUH67R685WcgYv2bbo058bpA>
    <xmx:G7z4Xh30yMK6Nu_gQWxLSOXoJc-nxVSKXznQXTxkPH9zMOhbab6Lzw>
    <xmx:G7z4XoBqgfDXc9hyWx0YoWbLD9dAmwSEB5GU8tS_WJw9tJ607q6uLA>
    <xmx:G7z4XtKXA19ecXHIF6v0zq5R0iKDSJ97qK8j0YSjYKRyL5b8gcbPpw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B6CA3067B94;
        Sun, 28 Jun 2020 11:49:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] cifs/smb3: Fix data inconsistent when punch hole" failed to apply to 4.4-stable tree
To:     zhangxiaoxu5@huawei.com, pshilov@microsoft.com,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Jun 2020 17:49:36 +0200
Message-ID: <159335937686102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From acc91c2d8de4ef46ed751c5f9df99ed9a109b100 Mon Sep 17 00:00:00 2001
From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Date: Tue, 23 Jun 2020 07:31:53 -0400
Subject: [PATCH] cifs/smb3: Fix data inconsistent when punch hole

When punch hole success, we also can read old data from file:
  # strace -e trace=pread64,fallocate xfs_io -f -c "pread 20 40" \
           -c "fpunch 20 40" -c"pread 20 40" file
  pread64(3, " version 5.8.0-rc1+"..., 40, 20) = 40
  fallocate(3, FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE, 20, 40) = 0
  pread64(3, " version 5.8.0-rc1+"..., 40, 20) = 40

CIFS implements the fallocate(FALLOCATE_FL_PUNCH_HOLE) with send SMB
ioctl(FSCTL_SET_ZERO_DATA) to server. It just set the range of the
remote file to zero, but local page caches not updated, then the
local page caches inconsistent with server.

Also can be found by xfstests generic/316.

So, we need to remove the page caches before send the SMB
ioctl(FSCTL_SET_ZERO_DATA) to server.

Fixes: 31742c5a33176 ("enable fallocate punch hole ("fallocate -p") for SMB3")
Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc: stable@vger.kernel.org # v3.17
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 876a0d9e3d46..d9fdafa5eb60 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3259,6 +3259,12 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 		return rc;
 	}
 
+	/*
+	 * We implement the punch hole through ioctl, so we need remove the page
+	 * caches first, otherwise the data may be inconsistent with the server.
+	 */
+	truncate_pagecache_range(inode, offset, offset + len - 1);
+
 	cifs_dbg(FYI, "Offset %lld len %lld\n", offset, len);
 
 	fsctl_buf.FileOffset = cpu_to_le64(offset);

