Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3E36AF46E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbjCGTQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbjCGTQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:09 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E32CB78AD;
        Tue,  7 Mar 2023 10:59:33 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id oj5so14183078pjb.5;
        Tue, 07 Mar 2023 10:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678215572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cVIyveesaPzxyGs8rOLixVIRbiaAfjdret3wPvq45AM=;
        b=T/crhf63EH3KsazTeaA8eUh5UZGOYxE18ottJ2uCHRmycMIIU3YfplnUd744dwP+Fd
         OCOBqEY3DOuA+eTDsfq6KllSJnzZy/VUTj/I+Nch2Hgijtg91Yn46/IsRFedWGdDShmX
         djfb+s6XwHkHPyM9z4TWRB5EmktsAxYgohvJcNCi/kYBkOzZjcmnb575aOlC48MuI3lJ
         vxMUmxe/5nsamR7ZC0AxY9+YFoVfYl2VLAKdHyg5lk+35zbd0FjkIKTLLbsXrxtFbQmo
         OWhxozVFV9sKXY9sb1U2HZ4ifPSlt+PuL5CVlE1x2JDEuAEhBMI5SGVn3E63V75SAi+p
         Tu0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678215572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cVIyveesaPzxyGs8rOLixVIRbiaAfjdret3wPvq45AM=;
        b=L6D7NYAjq1KDutix0Cq/ikkCazCqtsrhO57EvTJ6UnimNvCe7s1QCmmS6D7k7JRB1J
         VVGqXNSMWu4VnTcPsgSbbwamtv5avZjz437e/WwR5abIPcliNK6x64Kaek3zKyjWS5sa
         1uyxg2llZw+kQ8GD15Piz6WRuH1jzYcLNO+tsfFxOoVz7pePCeNNrn1e9IU+/JBMaGl1
         UZ48XoSSN5mLPrV0GCqVPQ9oWnJr8tcrmwR1xcHKkfBD13HwReyGyR5KxaR807p9Ps4/
         c8sMEvTwsQIgWB7vUoSPfScd3FOkeonw5b6mx4HRCQnLz3nOsE6qYSdnrI+wG3jfkuLU
         DEgQ==
X-Gm-Message-State: AO0yUKU6nSX3OmUgsYOQoSYRXxSpujREJ85KTFFdGiH19SGm29aG5WaQ
        ALXa/6HgO1cvLH/vC2VYrQN1cLRivw0hOQ==
X-Google-Smtp-Source: AK7set/l9W+JtVlwgRTkld68TyA0wV+sDBJHL+IKlddH46B81hTsrAmZ8/TF6vFgZEpw9vHRmvPgeg==
X-Received: by 2002:a17:903:2347:b0:19a:9859:be26 with SMTP id c7-20020a170903234700b0019a9859be26mr21614273plh.22.1678215572639;
        Tue, 07 Mar 2023 10:59:32 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:6f2b:1857:847c:366c])
        by smtp.gmail.com with ESMTPSA id ku4-20020a170903288400b001943d58268csm8745658plb.55.2023.03.07.10.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 10:59:32 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Yang Xu <xuyang2018.jy@fujitsu.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 05/11] fs: add mode_strip_sgid() helper
Date:   Tue,  7 Mar 2023 10:59:16 -0800
Message-Id: <20230307185922.125907-6-leah.rumancik@gmail.com>
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

From: Yang Xu <xuyang2018.jy@fujitsu.com>

commit 2b3416ceff5e6bd4922f6d1c61fb68113dd82302 upsream.

Add a dedicated helper to handle the setgid bit when creating a new file
in a setgid directory. This is a preparatory patch for moving setgid
stripping into the vfs. The patch contains no functional changes.

Currently the setgid stripping logic is open-coded directly in
inode_init_owner() and the individual filesystems are responsible for
handling setgid inheritance. Since this has proven to be brittle as
evidenced by old issues we uncovered over the last months (see [1] to
[3] below) we will try to move this logic into the vfs.

Link: e014f37db1a2 ("xfs: use setattr_copy to set vfs inode attributes") [1]
Link: 01ea173e103e ("xfs: fix up non-directory creation in SGID directories") [2]
Link: fd84bfdddd16 ("ceph: fix up non-directory creation in SGID directories") [3]
Link: https://lore.kernel.org/r/1657779088-2242-1-git-send-email-xuyang2018.jy@fujitsu.com
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-and-Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/inode.c         | 36 ++++++++++++++++++++++++++++++++----
 include/linux/fs.h |  2 ++
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 8279c700a2b7..3740102c9bd5 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2165,10 +2165,8 @@ void inode_init_owner(struct user_namespace *mnt_userns, struct inode *inode,
 		/* Directories are special, and always inherit S_ISGID */
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-		else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
-			 !in_group_p(i_gid_into_mnt(mnt_userns, dir)) &&
-			 !capable_wrt_inode_uidgid(mnt_userns, dir, CAP_FSETID))
-			mode &= ~S_ISGID;
+		else
+			mode = mode_strip_sgid(mnt_userns, dir, mode);
 	} else
 		inode_fsgid_set(inode, mnt_userns);
 	inode->i_mode = mode;
@@ -2324,3 +2322,33 @@ struct timespec64 current_time(struct inode *inode)
 	return timestamp_truncate(now, inode);
 }
 EXPORT_SYMBOL(current_time);
+
+/**
+ * mode_strip_sgid - handle the sgid bit for non-directories
+ * @mnt_userns: User namespace of the mount the inode was created from
+ * @dir: parent directory inode
+ * @mode: mode of the file to be created in @dir
+ *
+ * If the @mode of the new file has both the S_ISGID and S_IXGRP bit
+ * raised and @dir has the S_ISGID bit raised ensure that the caller is
+ * either in the group of the parent directory or they have CAP_FSETID
+ * in their user namespace and are privileged over the parent directory.
+ * In all other cases, strip the S_ISGID bit from @mode.
+ *
+ * Return: the new mode to use for the file
+ */
+umode_t mode_strip_sgid(struct user_namespace *mnt_userns,
+			const struct inode *dir, umode_t mode)
+{
+	if ((mode & (S_ISGID | S_IXGRP)) != (S_ISGID | S_IXGRP))
+		return mode;
+	if (S_ISDIR(mode) || !dir || !(dir->i_mode & S_ISGID))
+		return mode;
+	if (in_group_p(i_gid_into_mnt(mnt_userns, dir)))
+		return mode;
+	if (capable_wrt_inode_uidgid(mnt_userns, dir, CAP_FSETID))
+		return mode;
+
+	return mode & ~S_ISGID;
+}
+EXPORT_SYMBOL(mode_strip_sgid);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1e1ac116dd13..be9be4a7216c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1941,6 +1941,8 @@ extern long compat_ptr_ioctl(struct file *file, unsigned int cmd,
 void inode_init_owner(struct user_namespace *mnt_userns, struct inode *inode,
 		      const struct inode *dir, umode_t mode);
 extern bool may_open_dev(const struct path *path);
+umode_t mode_strip_sgid(struct user_namespace *mnt_userns,
+			const struct inode *dir, umode_t mode);
 
 /*
  * This is the "filldir" function type, used by readdir() to let
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

