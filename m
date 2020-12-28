Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD94B2E3574
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgL1J1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:27:20 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:39181 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1J1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:27:19 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C35AC63C;
        Mon, 28 Dec 2020 04:26:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:26:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DK7ChN
        aP4NBne4V616AD9rISAOzIUHSf5ipHMKbIBso=; b=RYKcyB8lX+Zp8E7U+QUj1p
        fwM1M2JSInGRCgR0OXbJh/stOA5hm+mgH3uMhYwce7rAfejcNeEs4KLi+LjJzdDC
        4t8IB79QMYx36CgLNJsrzIYzJXK7DIRlC8PlKNBM9Aqu+hIsHfSJbvXU45qEAX7P
        Qlq7CGu8OxUr8QnfXKguWplBGSnl45rYfg64NSxg1yDwUowZ3O7sbQQG+zHj/F0s
        LkU1U8zV1r3/9cnepMh+9EJqd9GgWQ111Bu7z/LSkefM8PzrQcNqhnHYSKeVFAFX
        iokm3gJfJPRGx/yl0DIFVqA8Zkjy90rvWN+41kZ2pbjKmkk82S4qMyukmWt+IiAw
        ==
X-ME-Sender: <xms:yaTpX7gMhs2iKVXWY6z9uXWXWzBg9wecqbBDp7ktjBzRfLf472vL2g>
    <xme:yaTpX4DWFoMvAZwz6x2mVDUvO3AimHBiunlPfm8_YYLWyR5krUOFTUGFn_V4aM-gM
    tqDno2wV5lc_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:yaTpX7Gs0AqzYsgy8In7uRWZQJkS3DQYdYjQyvgi_LfNrdjB-iv49w>
    <xmx:yaTpX4T5Dwy8IA8L2t5TcOHeqAE4QtZrqgmbEey6avPYDKuSgooMrg>
    <xmx:yaTpX4yZ7TZ7cp86Cf7mXsqGtvWS52Bo_uMtdUlT-pQsGLKUnE_Fxg>
    <xmx:yaTpX1oxc6Hl-rnkQFxzRMiTGnMPB8WjWaUE5Pg1myguo7uXOUp1oKz-LX0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 179C524005C;
        Mon, 28 Dec 2020 04:26:32 -0500 (EST)
Subject: FAILED: patch "[PATCH] ovl: make ioctl() safe" failed to apply to 4.19-stable tree
To:     mszeredi@redhat.com, amir73il@gmail.com, dvyukov@google.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:27:56 +0100
Message-ID: <16091476769227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 89bdfaf93d9157499c3a0d61f489df66f2dead7f Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Mon, 14 Dec 2020 15:26:14 +0100
Subject: [PATCH] ovl: make ioctl() safe

ovl_ioctl_set_flags() does a capability check using flags, but then the
real ioctl double-fetches flags and uses potentially different value.

The "Check the capability before cred override" comment misleading: user
can skip this check by presenting benign flags first and then overwriting
them to non-benign flags.

Just remove the cred override for now, hoping this doesn't cause a
regression.

The proper solution is to create a new setxflags i_op (patches are in the
works).

Xfstests don't show a regression.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Fixes: dab5ca8fd9dd ("ovl: add lsattr/chattr support")
Cc: <stable@vger.kernel.org> # v4.19

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index efccb7c1f9bc..a1f72ac053e5 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -541,46 +541,31 @@ static long ovl_real_ioctl(struct file *file, unsigned int cmd,
 			   unsigned long arg)
 {
 	struct fd real;
-	const struct cred *old_cred;
 	long ret;
 
 	ret = ovl_real_fdget(file, &real);
 	if (ret)
 		return ret;
 
-	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	ret = security_file_ioctl(real.file, cmd, arg);
-	if (!ret)
+	if (!ret) {
+		/*
+		 * Don't override creds, since we currently can't safely check
+		 * permissions before doing so.
+		 */
 		ret = vfs_ioctl(real.file, cmd, arg);
-	revert_creds(old_cred);
+	}
 
 	fdput(real);
 
 	return ret;
 }
 
-static unsigned int ovl_iflags_to_fsflags(unsigned int iflags)
-{
-	unsigned int flags = 0;
-
-	if (iflags & S_SYNC)
-		flags |= FS_SYNC_FL;
-	if (iflags & S_APPEND)
-		flags |= FS_APPEND_FL;
-	if (iflags & S_IMMUTABLE)
-		flags |= FS_IMMUTABLE_FL;
-	if (iflags & S_NOATIME)
-		flags |= FS_NOATIME_FL;
-
-	return flags;
-}
-
 static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
-				unsigned long arg, unsigned int flags)
+				unsigned long arg)
 {
 	long ret;
 	struct inode *inode = file_inode(file);
-	unsigned int oldflags;
 
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
@@ -591,10 +576,13 @@ static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
 
 	inode_lock(inode);
 
-	/* Check the capability before cred override */
-	oldflags = ovl_iflags_to_fsflags(READ_ONCE(inode->i_flags));
-	ret = vfs_ioc_setflags_prepare(inode, oldflags, flags);
-	if (ret)
+	/*
+	 * Prevent copy up if immutable and has no CAP_LINUX_IMMUTABLE
+	 * capability.
+	 */
+	ret = -EPERM;
+	if (!ovl_has_upperdata(inode) && IS_IMMUTABLE(inode) &&
+	    !capable(CAP_LINUX_IMMUTABLE))
 		goto unlock;
 
 	ret = ovl_maybe_copy_up(file_dentry(file), O_WRONLY);
@@ -613,46 +601,6 @@ static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
 
 }
 
-static long ovl_ioctl_set_fsflags(struct file *file, unsigned int cmd,
-				  unsigned long arg)
-{
-	unsigned int flags;
-
-	if (get_user(flags, (int __user *) arg))
-		return -EFAULT;
-
-	return ovl_ioctl_set_flags(file, cmd, arg, flags);
-}
-
-static unsigned int ovl_fsxflags_to_fsflags(unsigned int xflags)
-{
-	unsigned int flags = 0;
-
-	if (xflags & FS_XFLAG_SYNC)
-		flags |= FS_SYNC_FL;
-	if (xflags & FS_XFLAG_APPEND)
-		flags |= FS_APPEND_FL;
-	if (xflags & FS_XFLAG_IMMUTABLE)
-		flags |= FS_IMMUTABLE_FL;
-	if (xflags & FS_XFLAG_NOATIME)
-		flags |= FS_NOATIME_FL;
-
-	return flags;
-}
-
-static long ovl_ioctl_set_fsxflags(struct file *file, unsigned int cmd,
-				   unsigned long arg)
-{
-	struct fsxattr fa;
-
-	memset(&fa, 0, sizeof(fa));
-	if (copy_from_user(&fa, (void __user *) arg, sizeof(fa)))
-		return -EFAULT;
-
-	return ovl_ioctl_set_flags(file, cmd, arg,
-				   ovl_fsxflags_to_fsflags(fa.fsx_xflags));
-}
-
 long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
@@ -663,12 +611,9 @@ long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		ret = ovl_real_ioctl(file, cmd, arg);
 		break;
 
-	case FS_IOC_SETFLAGS:
-		ret = ovl_ioctl_set_fsflags(file, cmd, arg);
-		break;
-
 	case FS_IOC_FSSETXATTR:
-		ret = ovl_ioctl_set_fsxflags(file, cmd, arg);
+	case FS_IOC_SETFLAGS:
+		ret = ovl_ioctl_set_flags(file, cmd, arg);
 		break;
 
 	default:

