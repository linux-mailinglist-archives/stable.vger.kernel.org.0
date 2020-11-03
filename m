Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4948F2A485F
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:37:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgKCOhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:37:51 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:44669 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727553AbgKCOh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 09:37:27 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id BE555C6A;
        Tue,  3 Nov 2020 09:37:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:37:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JHQxIC
        ikMaTwvIT4Ff1v+iOOkSmEi4ENMc4sZh4gnBg=; b=ofoMSpCkX2O/QKSTa1boMW
        nWO35L+IPr1od02u6Igi+/tpAVYjiwH1+9/fB8/xsLA/xU59mTp7XM3PXRmdBnwu
        DpvM2IoX6MiYDW4tpTR2azpUTzbRyW/i6jvGj+ETd/piUfuBlkoo/zEhS9YKwyjw
        pGoJcaUTTamM+GclbJd7L8g+SpXc8vSZ8Jl+S6bCzWwTNbdJIMOyn1HWNivjrxlv
        PUNKgoUmAjRZoRFHWx5/XOHJ7kvONaz8LIk/9dy955cFOkTcz+k022k1b0e/wK5w
        jVAW9dLh0UU9Q8bZyDRVTclNex4kXRtH5bgGv7xwA8504aKTpMD9HqEUX0Kt5CLA
        ==
X-ME-Sender: <xms:JmuhX7NYH8U0FRBHMJtGwntdDOqwDBeEJEudgVDk2pRqQefwQrBuNA>
    <xme:JmuhX1-yA1-F0oJ5X4289KA8CZGQaIlEg0TKeXF2W-WdqfZCVsh386H3SZt2Y6NKe
    3fPijDOJLT4hA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:JmuhX6SkyI-NRtwiog1sExvsvsfQNgQqUjH8xDFtjjYLQa0UN6HwTw>
    <xmx:JmuhX_vdbMDGlbzI9yinC2aIEvPhkGsrseA9rBBA4YDPn9J9jcpJsw>
    <xmx:JmuhXzfKcUc2V3VwuuyH5T5RyIW5uxCuw19mbnhorItqafzKq4hpLA>
    <xmx:JmuhXzkyIPd_xgngYLHVgS9T0NBspel5GEwQsXrG4s_4i5A4_-VXiF-PwnY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id F2F993064610;
        Tue,  3 Nov 2020 09:37:25 -0500 (EST)
Subject: FAILED: patch "[PATCH] ubifs: xattr: Fix some potential memory leaks while iterating" failed to apply to 4.14-stable tree
To:     chengzhihao1@huawei.com, richard@nod.at, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 15:38:12 +0100
Message-ID: <160441429218120@kroah.com>
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

From f2aae745b82c842221f4f233051f9ac641790959 Mon Sep 17 00:00:00 2001
From: Zhihao Cheng <chengzhihao1@huawei.com>
Date: Mon, 1 Jun 2020 17:10:36 +0800
Subject: [PATCH] ubifs: xattr: Fix some potential memory leaks while iterating
 entries

Fix some potential memory leaks in error handling branches while
iterating xattr entries. For example, function ubifs_tnc_remove_ino()
forgets to free pxent if it exists. Similar problems also exist in
ubifs_purge_xattrs(), ubifs_add_orphan() and ubifs_jnl_write_inode().

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: <stable@vger.kernel.org>
Fixes: 1e51764a3c2ac05a2 ("UBIFS: add new flash file system")
Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 4a5b06f8d812..ed935aefe3e0 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -894,6 +894,7 @@ int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode)
 				if (err == -ENOENT)
 					break;
 
+				kfree(pxent);
 				goto out_release;
 			}
 
@@ -906,6 +907,7 @@ int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode)
 				ubifs_err(c, "dead directory entry '%s', error %d",
 					  xent->name, err);
 				ubifs_ro_mode(c, err);
+				kfree(pxent);
 				kfree(xent);
 				goto out_release;
 			}
diff --git a/fs/ubifs/orphan.c b/fs/ubifs/orphan.c
index 2c294085ffed..0fb61956146d 100644
--- a/fs/ubifs/orphan.c
+++ b/fs/ubifs/orphan.c
@@ -173,6 +173,7 @@ int ubifs_add_orphan(struct ubifs_info *c, ino_t inum)
 			err = PTR_ERR(xent);
 			if (err == -ENOENT)
 				break;
+			kfree(pxent);
 			return err;
 		}
 
@@ -182,6 +183,7 @@ int ubifs_add_orphan(struct ubifs_info *c, ino_t inum)
 
 		xattr_orphan = orphan_add(c, xattr_inum, orphan);
 		if (IS_ERR(xattr_orphan)) {
+			kfree(pxent);
 			kfree(xent);
 			return PTR_ERR(xattr_orphan);
 		}
diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index f609f6cdde70..b120a00773f8 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -2885,6 +2885,7 @@ int ubifs_tnc_remove_ino(struct ubifs_info *c, ino_t inum)
 			err = PTR_ERR(xent);
 			if (err == -ENOENT)
 				break;
+			kfree(pxent);
 			return err;
 		}
 
@@ -2898,6 +2899,7 @@ int ubifs_tnc_remove_ino(struct ubifs_info *c, ino_t inum)
 		fname_len(&nm) = le16_to_cpu(xent->nlen);
 		err = ubifs_tnc_remove_nm(c, &key1, &nm);
 		if (err) {
+			kfree(pxent);
 			kfree(xent);
 			return err;
 		}
@@ -2906,6 +2908,7 @@ int ubifs_tnc_remove_ino(struct ubifs_info *c, ino_t inum)
 		highest_ino_key(c, &key2, xattr_inum);
 		err = ubifs_tnc_remove_range(c, &key1, &key2);
 		if (err) {
+			kfree(pxent);
 			kfree(xent);
 			return err;
 		}
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index 9aefbb60074f..a0b9b349efe6 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -522,6 +522,7 @@ int ubifs_purge_xattrs(struct inode *host)
 				  xent->name, err);
 			ubifs_ro_mode(c, err);
 			kfree(pxent);
+			kfree(xent);
 			return err;
 		}
 
@@ -531,6 +532,7 @@ int ubifs_purge_xattrs(struct inode *host)
 		err = remove_xattr(c, host, xino, &nm);
 		if (err) {
 			kfree(pxent);
+			kfree(xent);
 			iput(xino);
 			ubifs_err(c, "cannot remove xattr, error %d", err);
 			return err;

