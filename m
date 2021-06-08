Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A0839F667
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 14:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhFHMXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 08:23:42 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:43633 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232259AbhFHMXl (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 8 Jun 2021 08:23:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id 1C7B49BB;
        Tue,  8 Jun 2021 08:21:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Jun 2021 08:21:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=qcbn5e
        29EFk/q1fh7UOAzR+R3YnDjgzg9oq7rmvMwE0=; b=AqVCUFKmWW3d1JjHuI+lzT
        zbu6P9XX47hskwNhZfLx8rDBlZRd4BP9PzQexsiueyZmY3u+iBAALj4m8bP++nf3
        Kuz9TfolcnkZwKg7RtzL3Zy40GK92fnscCgdm684F83k1HATakv91GguAq+GU7Mm
        4FmIBUbkguVtQZudGtZ186QDg7aFsumfg1lvewuWamrhS08vslHA/aZHUw2WD4Qx
        45JuhlppsHZidFKyKgi0ypO6HM4jFMjD8Gyk5cX2in3p3ovMJrjQghUUVXQlq52d
        67E+y/jj1vsPzdFi9lExD52lm8pCZdbkKCbpFGiHB85kJfv6XoyDojMNHOmSPSfg
        ==
X-ME-Sender: <xms:22C_YLFchbnRCelnBu-1Ivbs-Nulo6_KRs8nY0qxn2pwlDGl29MXQw>
    <xme:22C_YIWZMQjWG4BFVcPIif3KyFGR91GCyABdxR42K07HRfanpAxzDh4MYugBaMWBS
    WqVESwa6N5Wrw>
X-ME-Received: <xmr:22C_YNIzCOGfqW61KsMgULK6sRxmAlxCumYpRQj8M29W49RIle1ttmRCw_O_mi18qxC2lyPe7W1m1i1c2GC27YnjImM65e8v>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgfeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:22C_YJEoiFXHNynhuYmFu--omjAMNRI3IUIuYWX25_4iMR4OQh32yw>
    <xmx:22C_YBVQWx-jHHObj7DCDt3cPlMJI4Vnk_GC0WYwg8dsNQA9iyWg_Q>
    <xmx:22C_YEOTFu5HMbokZSeyVBXhtclPGo9NPZFdgWYiPE5h4RZQlfEBXg>
    <xmx:22C_YHz6ntrz9X_brrN_CdZF08P85Ftca95LNFajJ29s6R1EGVdr0TLO16o>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 08:21:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] fanotify: fix permission model of unprivileged group" failed to apply to 5.12-stable tree
To:     amir73il@gmail.com, Stable@vger.kernel.org,
        christian.brauner@ubuntu.com, jack@suse.cz, repnop@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 14:21:44 +0200
Message-ID: <162315490411353@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a8b98c808eab3ec8f1b5a64be967b0f4af4cae43 Mon Sep 17 00:00:00 2001
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 24 May 2021 16:53:21 +0300
Subject: [PATCH] fanotify: fix permission model of unprivileged group

Reporting event->pid should depend on the privileges of the user that
initialized the group, not the privileges of the user reading the
events.

Use an internal group flag FANOTIFY_UNPRIV to record the fact that the
group was initialized by an unprivileged user.

To be on the safe side, the premissions to setup filesystem and mount
marks now require that both the user that initialized the group and
the user setting up the mark have CAP_SYS_ADMIN.

Link: https://lore.kernel.org/linux-fsdevel/CAOQ4uxiA77_P5vtv7e83g0+9d7B5W9ZTE4GfQEYbWmfT1rA=VA@mail.gmail.com/
Fixes: 7cea2a3c505e ("fanotify: support limited functionality for unprivileged users")
Cc: <Stable@vger.kernel.org> # v5.12+
Link: https://lore.kernel.org/r/20210524135321.2190062-1-amir73il@gmail.com
Reviewed-by: Matthew Bobrowski <repnop@google.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 71fefb30e015..be5b6d2c01e7 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -424,11 +424,18 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	 * events generated by the listener process itself, without disclosing
 	 * the pids of other processes.
 	 */
-	if (!capable(CAP_SYS_ADMIN) &&
+	if (FAN_GROUP_FLAG(group, FANOTIFY_UNPRIV) &&
 	    task_tgid(current) != event->pid)
 		metadata.pid = 0;
 
-	if (path && path->mnt && path->dentry) {
+	/*
+	 * For now, fid mode is required for an unprivileged listener and
+	 * fid mode does not report fd in events.  Keep this check anyway
+	 * for safety in case fid mode requirement is relaxed in the future
+	 * to allow unprivileged listener to get events with no fd and no fid.
+	 */
+	if (!FAN_GROUP_FLAG(group, FANOTIFY_UNPRIV) &&
+	    path && path->mnt && path->dentry) {
 		fd = create_fd(group, path, &f);
 		if (fd < 0)
 			return fd;
@@ -1040,6 +1047,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 	int f_flags, fd;
 	unsigned int fid_mode = flags & FANOTIFY_FID_BITS;
 	unsigned int class = flags & FANOTIFY_CLASS_BITS;
+	unsigned int internal_flags = 0;
 
 	pr_debug("%s: flags=%x event_f_flags=%x\n",
 		 __func__, flags, event_f_flags);
@@ -1053,6 +1061,13 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 		 */
 		if ((flags & FANOTIFY_ADMIN_INIT_FLAGS) || !fid_mode)
 			return -EPERM;
+
+		/*
+		 * Setting the internal flag FANOTIFY_UNPRIV on the group
+		 * prevents setting mount/filesystem marks on this group and
+		 * prevents reporting pid and open fd in events.
+		 */
+		internal_flags |= FANOTIFY_UNPRIV;
 	}
 
 #ifdef CONFIG_AUDITSYSCALL
@@ -1105,7 +1120,7 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
 		goto out_destroy_group;
 	}
 
-	group->fanotify_data.flags = flags;
+	group->fanotify_data.flags = flags | internal_flags;
 	group->memcg = get_mem_cgroup_from_mm(current->mm);
 
 	group->fanotify_data.merge_hash = fanotify_alloc_merge_hash();
@@ -1305,11 +1320,13 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 	group = f.file->private_data;
 
 	/*
-	 * An unprivileged user is not allowed to watch a mount point nor
-	 * a filesystem.
+	 * An unprivileged user is not allowed to setup mount nor filesystem
+	 * marks.  This also includes setting up such marks by a group that
+	 * was initialized by an unprivileged user.
 	 */
 	ret = -EPERM;
-	if (!capable(CAP_SYS_ADMIN) &&
+	if ((!capable(CAP_SYS_ADMIN) ||
+	     FAN_GROUP_FLAG(group, FANOTIFY_UNPRIV)) &&
 	    mark_type != FAN_MARK_INODE)
 		goto fput_and_out;
 
@@ -1460,6 +1477,7 @@ static int __init fanotify_user_setup(void)
 	max_marks = clamp(max_marks, FANOTIFY_OLD_DEFAULT_MAX_MARKS,
 				     FANOTIFY_DEFAULT_MAX_USER_MARKS);
 
+	BUILD_BUG_ON(FANOTIFY_INIT_FLAGS & FANOTIFY_INTERNAL_GROUP_FLAGS);
 	BUILD_BUG_ON(HWEIGHT32(FANOTIFY_INIT_FLAGS) != 10);
 	BUILD_BUG_ON(HWEIGHT32(FANOTIFY_MARK_FLAGS) != 9);
 
diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index a712b2aaa9ac..57f0d5d9f934 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -144,7 +144,7 @@ void fanotify_show_fdinfo(struct seq_file *m, struct file *f)
 	struct fsnotify_group *group = f->private_data;
 
 	seq_printf(m, "fanotify flags:%x event-flags:%x\n",
-		   group->fanotify_data.flags,
+		   group->fanotify_data.flags & FANOTIFY_INIT_FLAGS,
 		   group->fanotify_data.f_flags);
 
 	show_fdinfo(m, f, fanotify_fdinfo);
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index bad41bcb25df..a16dbeced152 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -51,6 +51,10 @@ extern struct ctl_table fanotify_table[]; /* for sysctl */
 #define FANOTIFY_INIT_FLAGS	(FANOTIFY_ADMIN_INIT_FLAGS | \
 				 FANOTIFY_USER_INIT_FLAGS)
 
+/* Internal group flags */
+#define FANOTIFY_UNPRIV		0x80000000
+#define FANOTIFY_INTERNAL_GROUP_FLAGS	(FANOTIFY_UNPRIV)
+
 #define FANOTIFY_MARK_TYPE_BITS	(FAN_MARK_INODE | FAN_MARK_MOUNT | \
 				 FAN_MARK_FILESYSTEM)
 

