Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5AEE6AF47B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbjCGTRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbjCGTQL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:11 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E59FD6E9A;
        Tue,  7 Mar 2023 10:59:36 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id x34so14247050pjj.0;
        Tue, 07 Mar 2023 10:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678215575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N3/89BQbS9qa9xZLhN3jaD5mzSRJ9y6W4zs9EOpt7UY=;
        b=JXiHmriJjObPH+BM11YW8sd7uRom08ap5qhj41FY+1EkXh0YiZpFlheNN5ue2dJZh5
         tm9CZ3RtHn+Jw6lZtx4fBdtdxaglDopjTUXJsVAlGszyP7EUbugL+eG+t4UW/uNe3D4Q
         Kp1mb76OeOAyFdJ8hI66zY+vvHFRlqSfmkiigDq3xNHcqE6Hl35SQIcLd3o0yU5Ak6hs
         9AX9ifgP7Q5as810jT7XVDrhCsmZUOe6gvX53Kf/cMK1bTLHUXlg7Cf58WssXGVvqZmk
         zJmejAJ4T21rPfxyrPa7AOmCPZdojePkKIgabWPLKIZKl/tjbLggW7IzLq592sCpH3zy
         5gyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678215575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N3/89BQbS9qa9xZLhN3jaD5mzSRJ9y6W4zs9EOpt7UY=;
        b=U0UZoVGOgWRQdDEaqKMa5gSQBrAP5NPGh5XhEQGtX6tPXxSpfRilLkARreGYqJOB3r
         EsFSs3VaAcQpr+/qLIBWV11nBRtXPZUO+Dl/lqFXPH7tOOeZnK+ktwrXrfbeR2OdLBu1
         ovkeAX4wRmNcR/sD5k9JzaPoG2/WxALkGwAOaQEHyIwxmSUSZo/DfHjf543saT5X6iPw
         Sdl0CUBvxFVlrdPLH0C3tILpTE0fxCGCPhtXE70WMKpKXSaTRGmwIKi1NzXHNQ7dTlc5
         M3ZjnQ6zRPGcaWBJ/0/YlnprVj2tM/qUZk8NufQa4XboyZhEFah7XeByf/XP4ySY4gcy
         brlA==
X-Gm-Message-State: AO0yUKVV964pL+vZu8vS+PjEH+2R0jF2qjGOchuv3b9rFwHTEei8l5gl
        Jw7x44DXTYmZ52weVj3zKVK/6BBu+wVBxw==
X-Google-Smtp-Source: AK7set91vwHADNEik3Z4zIxZwvYO4F5nnFkL7/+yFvK/3UWe68uJKVH3QzceACWTGLPkxjWU7Fshdg==
X-Received: by 2002:a17:903:18e:b0:19a:75b8:f4ff with SMTP id z14-20020a170903018e00b0019a75b8f4ffmr19823271plg.35.1678215575513;
        Tue, 07 Mar 2023 10:59:35 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:6f2b:1857:847c:366c])
        by smtp.gmail.com with ESMTPSA id ku4-20020a170903288400b001943d58268csm8745658plb.55.2023.03.07.10.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 10:59:35 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Christian Brauner <brauner@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 5.15 07/11] attr: add in_group_or_capable()
Date:   Tue,  7 Mar 2023 10:59:18 -0800
Message-Id: <20230307185922.125907-8-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230307185922.125907-1-leah.rumancik@gmail.com>
References: <20230307185922.125907-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit 11c2a8700cdcabf9b639b7204a1e38e2a0b6798e upstream.

[backport to 5.15.y, prior to vfsgid_t]

In setattr_{copy,prepare}() we need to perform the same permission
checks to determine whether we need to drop the setgid bit or not.
Instead of open-coding it twice add a simple helper the encapsulates the
logic. We will reuse this helpers to make dropping the setgid bit during
write operations more consistent in a follow up patch.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/attr.c     |  8 ++++----
 fs/inode.c    | 28 ++++++++++++++++++++++++----
 fs/internal.h |  2 ++
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/attr.c b/fs/attr.c
index f581c4d00897..686840aa91c8 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -18,6 +18,8 @@
 #include <linux/evm.h>
 #include <linux/ima.h>
 
+#include "internal.h"
+
 /**
  * chown_ok - verify permissions to chown inode
  * @mnt_userns:	user namespace of the mount @inode was found from
@@ -141,8 +143,7 @@ int setattr_prepare(struct user_namespace *mnt_userns, struct dentry *dentry,
 			mapped_gid = i_gid_into_mnt(mnt_userns, inode);
 
 		/* Also check the setgid bit! */
-		if (!in_group_p(mapped_gid) &&
-		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_or_capable(mnt_userns, inode, mapped_gid))
 			attr->ia_mode &= ~S_ISGID;
 	}
 
@@ -257,8 +258,7 @@ void setattr_copy(struct user_namespace *mnt_userns, struct inode *inode,
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
 		kgid_t kgid = i_gid_into_mnt(mnt_userns, inode);
-		if (!in_group_p(kgid) &&
-		    !capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		if (!in_group_or_capable(mnt_userns, inode, kgid))
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
 	}
diff --git a/fs/inode.c b/fs/inode.c
index 957b2d18ec29..a71fb82279bb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2321,6 +2321,28 @@ struct timespec64 current_time(struct inode *inode)
 }
 EXPORT_SYMBOL(current_time);
 
+/**
+ * in_group_or_capable - check whether caller is CAP_FSETID privileged
+ * @mnt_userns: user namespace of the mount @inode was found from
+ * @inode:	inode to check
+ * @gid:	the new/current gid of @inode
+ *
+ * Check wether @gid is in the caller's group list or if the caller is
+ * privileged with CAP_FSETID over @inode. This can be used to determine
+ * whether the setgid bit can be kept or must be dropped.
+ *
+ * Return: true if the caller is sufficiently privileged, false if not.
+ */
+bool in_group_or_capable(struct user_namespace *mnt_userns,
+			 const struct inode *inode, kgid_t gid)
+{
+	if (in_group_p(gid))
+		return true;
+	if (capable_wrt_inode_uidgid(mnt_userns, inode, CAP_FSETID))
+		return true;
+	return false;
+}
+
 /**
  * mode_strip_sgid - handle the sgid bit for non-directories
  * @mnt_userns: User namespace of the mount the inode was created from
@@ -2342,11 +2364,9 @@ umode_t mode_strip_sgid(struct user_namespace *mnt_userns,
 		return mode;
 	if (S_ISDIR(mode) || !dir || !(dir->i_mode & S_ISGID))
 		return mode;
-	if (in_group_p(i_gid_into_mnt(mnt_userns, dir)))
-		return mode;
-	if (capable_wrt_inode_uidgid(mnt_userns, dir, CAP_FSETID))
+	if (in_group_or_capable(mnt_userns, dir,
+				i_gid_into_mnt(mnt_userns, dir)))
 		return mode;
-
 	return mode & ~S_ISGID;
 }
 EXPORT_SYMBOL(mode_strip_sgid);
diff --git a/fs/internal.h b/fs/internal.h
index 9075490f21a6..c89814727281 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -150,6 +150,8 @@ extern int vfs_open(const struct path *, struct file *);
 extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
 extern void inode_add_lru(struct inode *inode);
 extern int dentry_needs_remove_privs(struct dentry *dentry);
+bool in_group_or_capable(struct user_namespace *mnt_userns,
+			 const struct inode *inode, kgid_t gid);
 
 /*
  * fs-writeback.c
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

