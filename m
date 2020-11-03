Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BE42A485D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgKCOhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:37:52 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:57975 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727385AbgKCOhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 09:37:20 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 05C65CCF;
        Tue,  3 Nov 2020 09:37:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:37:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=OSlNHz
        ctN5j00S+jg0A49zwXZc3QBlODadRzp9BFMdQ=; b=NIzBLgja4d0HB9Q4LsNwoJ
        mDFNaSmRzZPxcKIHwIqTqiwI/c96qu+7aDJEJgfzasdr2/u6k2g6kWjCcSlArVuF
        JYf6t9wNFYv/LZTq0RlyVwbbWSMaujKUm0msU6/ZeBvwT5BYps60g8JA1aEcS7ef
        RJen1WSNO3Csj8+02LvUmGcGTcUB/DdFQ8W9GdtRrbAJzmsMBr5GhJcRnMcUmygN
        W09bYrNupSdLxtsZ+nEmzhm7CIUSYt+icA0lPMijI4iw3YrPhPQO56citlPEIiM7
        kcmXvSmhYVp5fGZtGUVFC2H8ysB1cNBRZrX+ROFKtiGAFZfTIvetecRnlyokQlcA
        ==
X-ME-Sender: <xms:HmuhXzWEHKPxZ6c1Hv0jLB3Gmq1TYThnhjAv-7MARK5CQY_PIWsOdg>
    <xme:HmuhX7kEvjAcZIf9d7-0-QmKPY0KFYR1B6U5nG3VTE29cyUPJY8yDUKv6I3SojDfU
    dXY-wcls6C6Mw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:HmuhX_aQEjmpnPL9Fi5ewgj-3XOfq5AI8jhvp5GoOfjXMipmGhMADQ>
    <xmx:HmuhX-Uo0DYiIaDYK6D9UMZSyXsdGbOimosKlcWXNThisysofcRWRg>
    <xmx:HmuhX9nrvuDNVrBda5_WV0YmLWAOQVa8T1l4zOStgGpebqhjgV6epQ>
    <xmx:HmuhX8uWSMkzxBdvw8oiX0Qs7neps7e-bJ3EAHJrAwiFxwY_ULPiZxrxt5Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A622D328005E;
        Tue,  3 Nov 2020 09:37:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] ubifs: xattr: Fix some potential memory leaks while iterating" failed to apply to 4.4-stable tree
To:     chengzhihao1@huawei.com, richard@nod.at, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 15:38:11 +0100
Message-ID: <1604414291189130@kroah.com>
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

