Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB579327FBC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235819AbhCANjt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:39:49 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:35921 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235676AbhCANjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:39:48 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7606019420AD;
        Mon,  1 Mar 2021 08:39:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:39:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=UTnC2F
        S6YfprqKB2Uj7WkeziO/MJgnvhlnX1hdGTmRs=; b=W1yHNuaaseOWHg1foewFxZ
        7DQhKeeX+1I3BVmI7/pjcWsQfkeWsDhrFc9LsEu+tWhrHsRxxtmBiJiqfdHZrNAf
        Drf37iJauEFSnsehjRA9Mi3ubrK9vMfvZ564Y2ao5Wcd9DG2KoiusgPDXX/2QAK9
        e+ZKaPnGeOoBb3NWTDTdTfCeJQOa+3NypXMBrVsMi+53hr8/B/yFNV6lLOYO0Mpp
        JNc5fkn2mI4biZrPbhmszSePCwxlrvk/JvW9lNalYVyH1tdjJHUGNcGx8lDS74x7
        TmGi5W+0senv2KEiNEF1hOldavU1qIPliWmEwFpXBo9F1RitPYZc0ts8EmsYs6Jg
        ==
X-ME-Sender: <xms:de48YOzov9kXYHb7yu9YnrVFfp80idohjsIaljHliESh36_XcZP5Og>
    <xme:de48YKRQgMuQNLTNFr6mz6hcKRZbKVLYq6-jQet-2sf9GD5kT4MMZYXs4obCsS3A2
    Hf_cOWPCWPObA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeelnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:de48YAUGpnRWUVuRd8QrbJAIJo246dCQXtimCytLY7ZArd3b25_FNw>
    <xmx:de48YEh6mPs-nbl2UzdBrOfrdEzPU1NW97DeZepkgunAWRd-T7x_Kg>
    <xmx:de48YACFbIQXQ3h2gtsBk3jbuk68EoOZ9F5g5lJiQAoKlJdofhrTyw>
    <xmx:de48YJ6GWaIdO3gShrbrN87LgbFkdvGlP7qSOwwym_AbWsOq2U92Sg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22DF01080057;
        Mon,  1 Mar 2021 08:39:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] f2fs: enforce the immutable flag on open files" failed to apply to 5.4-stable tree
To:     chao@kernel.org, jaegeuk@kernel.org, yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:38:59 +0100
Message-ID: <161460593922122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e0fcd01510ad025c9bbce704c5c2579294056141 Mon Sep 17 00:00:00 2001
From: Chao Yu <chao@kernel.org>
Date: Sat, 26 Dec 2020 18:07:01 +0800
Subject: [PATCH] f2fs: enforce the immutable flag on open files

This patch ports commit 02b016ca7f99 ("ext4: enforce the immutable
flag on open files") to f2fs.

According to the chattr man page, "a file with the 'i' attribute
cannot be modified..."  Historically, this was only enforced when the
file was opened, per the rest of the description, "... and the file
can not be opened in write mode".

There is general agreement that we should standardize all file systems
to prevent modifications even for files that were opened at the time
the immutable flag is set.  Eventually, a change to enforce this at
the VFS layer should be landing in mainline.

Cc: stable@kernel.org
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 2ddc4baaf173..d57b54643918 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -60,6 +60,9 @@ static vm_fault_t f2fs_vm_page_mkwrite(struct vm_fault *vmf)
 	bool need_alloc = true;
 	int err = 0;
 
+	if (unlikely(IS_IMMUTABLE(inode)))
+		return VM_FAULT_SIGBUS;
+
 	if (unlikely(f2fs_cp_error(sbi))) {
 		err = -EIO;
 		goto err;
@@ -865,6 +868,14 @@ int f2fs_setattr(struct dentry *dentry, struct iattr *attr)
 	if (unlikely(f2fs_cp_error(F2FS_I_SB(inode))))
 		return -EIO;
 
+	if (unlikely(IS_IMMUTABLE(inode)))
+		return -EPERM;
+
+	if (unlikely(IS_APPEND(inode) &&
+			(attr->ia_valid & (ATTR_MODE | ATTR_UID |
+				  ATTR_GID | ATTR_TIMES_SET))))
+		return -EPERM;
+
 	if ((attr->ia_valid & ATTR_SIZE) &&
 		!f2fs_is_compress_backend_ready(inode))
 		return -EOPNOTSUPP;
@@ -4351,6 +4362,11 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		inode_lock(inode);
 	}
 
+	if (unlikely(IS_IMMUTABLE(inode))) {
+		ret = -EPERM;
+		goto unlock;
+	}
+
 	ret = generic_write_checks(iocb, from);
 	if (ret > 0) {
 		bool preallocated = false;
@@ -4415,6 +4431,7 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		if (ret > 0)
 			f2fs_update_iostat(F2FS_I_SB(inode), APP_WRITE_IO, ret);
 	}
+unlock:
 	inode_unlock(inode);
 out:
 	trace_f2fs_file_write_iter(inode, iocb->ki_pos,

