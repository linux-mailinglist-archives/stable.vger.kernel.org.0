Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9334A20C8C7
	for <lists+stable@lfdr.de>; Sun, 28 Jun 2020 17:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgF1Pt4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 11:49:56 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:34687 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbgF1Pt4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jun 2020 11:49:56 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 5F30D1940702;
        Sun, 28 Jun 2020 11:49:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 28 Jun 2020 11:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=v/ioPS
        PJgHKeRzVU59GyFYZr4l7LSHETNhZZLDQQKRM=; b=LOwpjHx4UuG346/PVm5h+B
        x/v7bCo7RdcQNWYhxeOxyWuM6GgctgTbZLoqRJ3/jAz6fVNA+D4wbGjXPbY7Kwer
        IQkXSl2UCZ+nqiyDVPwlpUsMifvf2ysEzb7IoYl5B3TkJMIuJr1B78JzOUDZHFEU
        Pb75KXwf171i9I5DD73aXBDbBh8yYNq0SGH6Koue7AUn0Ou5zRtZ0K8bR6u5Xv1U
        fXIQqs6qgxfuu9WrEvRGO5c4WqthitNk9H0hgrU4fSwD+IQrXHs5UlE8cxtUgX3A
        SCeCu2lKdOLMMH9/Xn8ZWafXPKZfxNpvYb7efnEyAzSU6oaqNi05BoVNT3Q88XFw
        ==
X-ME-Sender: <xms:I7z4Xmqc5VIWszv1TjADQEBokNp-t2BirFBgLSPWA2dMcrZHs855CA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeliedgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:I7z4Xkrx-PsfoULB6shulvvYdKGBVS7H-LlO2dOEK2pCZvahDlt3uQ>
    <xmx:I7z4XrOQX4XXDe0vHtDgkR7AX4pnAnA572dzK_31Ij4vFOEk-rWi7Q>
    <xmx:I7z4Xl7amIkH-d5NZGLc2oDuxeES8XKhdHWgI-R2dYIYYMw_PDf_9g>
    <xmx:I7z4XijxXMtfOStEPvZy5J8Bs0eaHBRrpqAhN3WQ_0mJjjVQpEKFKQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E2A45328005D;
        Sun, 28 Jun 2020 11:49:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] cifs/smb3: Fix data inconsistent when punch hole" failed to apply to 4.14-stable tree
To:     zhangxiaoxu5@huawei.com, pshilov@microsoft.com,
        stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Jun 2020 17:49:38 +0200
Message-ID: <1593359378221248@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

