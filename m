Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31E2249B8C
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgHSLSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:18:46 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:51599 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727818AbgHSLSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:18:39 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1AD6E19426ED;
        Wed, 19 Aug 2020 07:18:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:18:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZE5zA1
        dDXW4w6jclLQzfosgOdvaxOa+I8XHMy2pG2Qg=; b=hkmUUiOKKzwVxRubKWI1/z
        TRoqKTpS76RbUp7IGMVxK50LfQrKXFzZnRhIZga+WSzf9Ns+E18cPIrDFZMIjaW2
        S2m0u3YTz6cY2YTrr2ZYDKOspKYV96MxY+yhlQEmlSpVTDdbt8RLjLRK/nuBlI27
        zuuxF517kdhWWZm3r9i/Oq/i7qOOl3QASM2v4ZXNsGMUl+1QRfsySl2LiBPqXKik
        oX6kqN4rDr6ZVW5dTR5uXSdY3TQiCiU8qxRxCZf+tsPT44Fs56CqNcjZ6yHuN+7j
        AEnsoX88NU+unlsoRI6Z67aveiOKoajwxnMpkF7o0nh8Uo+mnh6EpALxaZfLG+rg
        ==
X-ME-Sender: <xms:jAo9Xzq4GuESnEzCrYoWiPG05kzN5fuV8CxDzgU8bG0hA5EYHnOqGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:jQo9X9qoUkPw6RkX_yIENs0IDB5JTIoSIds_LlmiUPsy48SZAY2nrQ>
    <xmx:jQo9XwMZPpr74ZQZlw9YEzVPo0U5S1xpJ6Cm2IrNU-9rxoU8XE6iCw>
    <xmx:jQo9X27EkGQ477_Zrc-kKa9pSdOHcovhQ68-G-fP6W1_5I2xLcRWeA>
    <xmx:jQo9X0EwkM-YPlIC4SkO-COW_KC90Z7wrAUa1w44HYS-GlqjaL0MYg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B472E3280063;
        Wed, 19 Aug 2020 07:18:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: add missing check for nocow and compression inode" failed to apply to 4.14-stable tree
To:     dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:18:58 +0200
Message-ID: <159783593848109@kroah.com>
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

From f37c563bab4297024c300b05c8f48430e323809d Mon Sep 17 00:00:00 2001
From: David Sterba <dsterba@suse.com>
Date: Fri, 10 Jul 2020 09:49:56 +0200
Subject: [PATCH] btrfs: add missing check for nocow and compression inode
 flags

User Forza reported on IRC that some invalid combinations of file
attributes are accepted by chattr.

The NODATACOW and compression file flags/attributes are mutually
exclusive, but they could be set by 'chattr +c +C' on an empty file. The
nodatacow will be in effect because it's checked first in
btrfs_run_delalloc_range.

Extend the flag validation to catch the following cases:

  - input flags are conflicting
  - old and new flags are conflicting
  - initialize the local variable with inode flags after inode ls locked

Inode attributes take precedence over mount options and are an
independent setting.

Nocompress would be a no-op with nodatacow, but we don't want to mix
any compression-related options with nodatacow.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index b4ddf51ae377..bd3511c5ca81 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -164,8 +164,11 @@ static int btrfs_ioctl_getflags(struct file *file, void __user *arg)
 	return 0;
 }
 
-/* Check if @flags are a supported and valid set of FS_*_FL flags */
-static int check_fsflags(unsigned int flags)
+/*
+ * Check if @flags are a supported and valid set of FS_*_FL flags and that
+ * the old and new flags are not conflicting
+ */
+static int check_fsflags(unsigned int old_flags, unsigned int flags)
 {
 	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
@@ -174,9 +177,19 @@ static int check_fsflags(unsigned int flags)
 		      FS_NOCOW_FL))
 		return -EOPNOTSUPP;
 
+	/* COMPR and NOCOMP on new/old are valid */
 	if ((flags & FS_NOCOMP_FL) && (flags & FS_COMPR_FL))
 		return -EINVAL;
 
+	if ((flags & FS_COMPR_FL) && (flags & FS_NOCOW_FL))
+		return -EINVAL;
+
+	/* NOCOW and compression options are mutually exclusive */
+	if ((old_flags & FS_NOCOW_FL) && (flags & (FS_COMPR_FL | FS_NOCOMP_FL)))
+		return -EINVAL;
+	if ((flags & FS_NOCOW_FL) && (old_flags & (FS_COMPR_FL | FS_NOCOMP_FL)))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -190,7 +203,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	unsigned int fsflags, old_fsflags;
 	int ret;
 	const char *comp = NULL;
-	u32 binode_flags = binode->flags;
+	u32 binode_flags;
 
 	if (!inode_owner_or_capable(inode))
 		return -EPERM;
@@ -201,22 +214,23 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	if (copy_from_user(&fsflags, arg, sizeof(fsflags)))
 		return -EFAULT;
 
-	ret = check_fsflags(fsflags);
-	if (ret)
-		return ret;
-
 	ret = mnt_want_write_file(file);
 	if (ret)
 		return ret;
 
 	inode_lock(inode);
-
 	fsflags = btrfs_mask_fsflags_for_type(inode, fsflags);
 	old_fsflags = btrfs_inode_flags_to_fsflags(binode->flags);
+
 	ret = vfs_ioc_setflags_prepare(inode, old_fsflags, fsflags);
 	if (ret)
 		goto out_unlock;
 
+	ret = check_fsflags(old_fsflags, fsflags);
+	if (ret)
+		goto out_unlock;
+
+	binode_flags = binode->flags;
 	if (fsflags & FS_SYNC_FL)
 		binode_flags |= BTRFS_INODE_SYNC;
 	else

