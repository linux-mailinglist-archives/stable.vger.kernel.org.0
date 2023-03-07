Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046206AF478
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbjCGTRC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233754AbjCGTQL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:11 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B12FD6E96;
        Tue,  7 Mar 2023 10:59:35 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so17496831pjb.3;
        Tue, 07 Mar 2023 10:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678215574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UA/1q1zeM0W/AAfs1drjXbgERI9tLchrPVDjuQMIeT0=;
        b=o+SfxPhd45FJxG4fYY/UrXDhDHmH5SJEDl4yN6IAmEJ/WPDg5HKHliwrD2dqGVZEz0
         +RYAsqLKmGSfGGgAiE1kgauwSXkgXUhHdng8/coDh5wtTwgmNZYZEJz+ZXDx7b7ncPQp
         8mUyAjP7oLK+8iyTfQHZHJ8YkZolcy+sc0OWwxP7yzH3x3kzd4Ux1kt5aWMGYNLrUJRQ
         0ChgPIRUF4VT8OVXBdxrOfwNOATIQwcpI9jJkJGeJBpzDzazphqqaECANYoM61cP2WPg
         fgqABX3JaXZvVH404LZZqDp1AA3l68cHtOaTrq6zO7syh+IuEELzEtm0hXbijr+lpfMc
         ylag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678215574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UA/1q1zeM0W/AAfs1drjXbgERI9tLchrPVDjuQMIeT0=;
        b=peQ0Nm0AI+inT4/a3n1UJ+dLm/DMmFRC1iFsrsb8UwthK6zhUYW4OSEJ7FMczjbWgI
         GaUF+dqkhFvnTQWpyK9+VC1yFbrJXKbzQkuuHLnLC44F9QP7Jxsc6iMt3RUYX+A602wW
         jStvFkxCwHlGw4RwCF6PeOglGY2TjV4FRQqU/FPpe8oD2K4OhBOWdxg0rk2qlHdQ9gt0
         HdJiDbp4rZ4K1n+/+Pp1m03lQd9Y7Fnwlr/GBN8s1V38KfQAU4whH4ttHKyN4bnxCR6M
         WmJcayb6rKt+2/35qlxfs3wHssfAnClLHlz97cZIVBerkZe8dPnnR9Oj4nbEs8b4DaK0
         h0Kw==
X-Gm-Message-State: AO0yUKWGZe9KSznsrZ3JnCoOo8D+BKF93kACNQX5yR2KnZfejk7eT6Vv
        RVTFggwkQDi/O/Z8fa7S+tqK1VTRXyG0Fw==
X-Google-Smtp-Source: AK7set81hclzsR6WhV1vHXm3YESvfflPVwg5ow1EV/cyNqEsCu4cQx4rzvFkqHXX75roPRSloX7PVg==
X-Received: by 2002:a17:902:bf42:b0:19a:ad2f:2df9 with SMTP id u2-20020a170902bf4200b0019aad2f2df9mr14410132pls.55.1678215574198;
        Tue, 07 Mar 2023 10:59:34 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:6f2b:1857:847c:366c])
        by smtp.gmail.com with ESMTPSA id ku4-20020a170903288400b001943d58268csm8745658plb.55.2023.03.07.10.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 10:59:33 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Yang Xu <xuyang2018.jy@fujitsu.com>,
        Dave Chinner <david@fromorbit.com>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 06/11] fs: move S_ISGID stripping into the vfs_*() helpers
Date:   Tue,  7 Mar 2023 10:59:17 -0800
Message-Id: <20230307185922.125907-7-leah.rumancik@gmail.com>
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

commit 1639a49ccdce58ea248841ed9b23babcce6dbb0b upsream.

Move setgid handling out of individual filesystems and into the VFS
itself to stop the proliferation of setgid inheritance bugs.

Creating files that have both the S_IXGRP and S_ISGID bit raised in
directories that themselves have the S_ISGID bit set requires additional
privileges to avoid security issues.

When a filesystem creates a new inode it needs to take care that the
caller is either in the group of the newly created inode or they have
CAP_FSETID in their current user namespace and are privileged over the
parent directory of the new inode. If any of these two conditions is
true then the S_ISGID bit can be raised for an S_IXGRP file and if not
it needs to be stripped.

However, there are several key issues with the current implementation:

* S_ISGID stripping logic is entangled with umask stripping.

  If a filesystem doesn't support or enable POSIX ACLs then umask
  stripping is done directly in the vfs before calling into the
  filesystem.
  If the filesystem does support POSIX ACLs then unmask stripping may be
  done in the filesystem itself when calling posix_acl_create().

  Since umask stripping has an effect on S_ISGID inheritance, e.g., by
  stripping the S_IXGRP bit from the file to be created and all relevant
  filesystems have to call posix_acl_create() before inode_init_owner()
  where we currently take care of S_ISGID handling S_ISGID handling is
  order dependent. IOW, whether or not you get a setgid bit depends on
  POSIX ACLs and umask and in what order they are called.

  Note that technically filesystems are free to impose their own
  ordering between posix_acl_create() and inode_init_owner() meaning
  that there's additional ordering issues that influence S_SIGID
  inheritance.

* Filesystems that don't rely on inode_init_owner() don't get S_ISGID
  stripping logic.

  While that may be intentional (e.g. network filesystems might just
  defer setgid stripping to a server) it is often just a security issue.

This is not just ugly it's unsustainably messy especially since we do
still have bugs in this area years after the initial round of setgid
bugfixes.

So the current state is quite messy and while we won't be able to make
it completely clean as posix_acl_create() is still a filesystem specific
call we can improve the S_SIGD stripping situation quite a bit by
hoisting it out of inode_init_owner() and into the vfs creation
operations. This means we alleviate the burden for filesystems to handle
S_ISGID stripping correctly and can standardize the ordering between
S_ISGID and umask stripping in the vfs.

We add a new helper vfs_prepare_mode() so S_ISGID handling is now done
in the VFS before umask handling. This has S_ISGID handling is
unaffected unaffected by whether umask stripping is done by the VFS
itself (if no POSIX ACLs are supported or enabled) or in the filesystem
in posix_acl_create() (if POSIX ACLs are supported).

The vfs_prepare_mode() helper is called directly in vfs_*() helpers that
create new filesystem objects. We need to move them into there to make
sure that filesystems like overlayfs hat have callchains like:

sys_mknod()
-> do_mknodat(mode)
   -> .mknod = ovl_mknod(mode)
      -> ovl_create(mode)
         -> vfs_mknod(mode)

get S_ISGID stripping done when calling into lower filesystems via
vfs_*() creation helpers. Moving vfs_prepare_mode() into e.g.
vfs_mknod() takes care of that. This is in any case semantically cleaner
because S_ISGID stripping is VFS security requirement.

Security hooks so far have seen the mode with the umask applied but
without S_ISGID handling done. The relevant hooks are called outside of
vfs_*() creation helpers so by calling vfs_prepare_mode() from vfs_*()
helpers the security hooks would now see the mode without umask
stripping applied. For now we fix this by passing the mode with umask
settings applied to not risk any regressions for LSM hooks. IOW, nothing
changes for LSM hooks. It is worth pointing out that security hooks
never saw the mode that is seen by the filesystem when actually creating
the file. They have always been completely misplaced for that to work.

The following filesystems use inode_init_owner() and thus relied on
S_ISGID stripping: spufs, 9p, bfs, btrfs, ext2, ext4, f2fs, hfsplus,
hugetlbfs, jfs, minix, nilfs2, ntfs3, ocfs2, omfs, overlayfs, ramfs,
reiserfs, sysv, ubifs, udf, ufs, xfs, zonefs, bpf, tmpfs.

All of the above filesystems end up calling inode_init_owner() when new
filesystem objects are created through the ->mkdir(), ->mknod(),
->create(), ->tmpfile(), ->rename() inode operations.

Since directories always inherit the S_ISGID bit with the exception of
xfs when irix_sgid_inherit mode is turned on S_ISGID stripping doesn't
apply. The ->symlink() and ->link() inode operations trivially inherit
the mode from the target and the ->rename() inode operation inherits the
mode from the source inode. All other creation inode operations will get
S_ISGID handling via vfs_prepare_mode() when called from their relevant
vfs_*() helpers.

In addition to this there are filesystems which allow the creation of
filesystem objects through ioctl()s or - in the case of spufs -
circumventing the vfs in other ways. If filesystem objects are created
through ioctl()s the vfs doesn't know about it and can't apply regular
permission checking including S_ISGID logic. Therfore, a filesystem
relying on S_ISGID stripping in inode_init_owner() in their ioctl()
callpath will be affected by moving this logic into the vfs. We audited
those filesystems:

* btrfs allows the creation of filesystem objects through various
  ioctls(). Snapshot creation literally takes a snapshot and so the mode
  is fully preserved and S_ISGID stripping doesn't apply.

  Creating a new subvolum relies on inode_init_owner() in
  btrfs_new_subvol_inode() but only creates directories and doesn't
  raise S_ISGID.

* ocfs2 has a peculiar implementation of reflinks. In contrast to e.g.
  xfs and btrfs FICLONE/FICLONERANGE ioctl() that is only concerned with
  the actual extents ocfs2 uses a separate ioctl() that also creates the
  target file.

  Iow, ocfs2 circumvents the vfs entirely here and did indeed rely on
  inode_init_owner() to strip the S_ISGID bit. This is the only place
  where a filesystem needs to call mode_strip_sgid() directly but this
  is self-inflicted pain.

* spufs doesn't go through the vfs at all and doesn't use ioctl()s
  either. Instead it has a dedicated system call spufs_create() which
  allows the creation of filesystem objects. But spufs only creates
  directories and doesn't allo S_SIGID bits, i.e. it specifically only
  allows 0777 bits.

* bpf uses vfs_mkobj() but also doesn't allow S_ISGID bits to be created.

The patch will have an effect on ext2 when the EXT2_MOUNT_GRPID mount
option is used, on ext4 when the EXT4_MOUNT_GRPID mount option is used,
and on xfs when the XFS_FEAT_GRPID mount option is used. When any of
these filesystems are mounted with their respective GRPID option then
newly created files inherit the parent directories group
unconditionally. In these cases non of the filesystems call
inode_init_owner() and thus did never strip the S_ISGID bit for newly
created files. Moving this logic into the VFS means that they now get
the S_ISGID bit stripped. This is a user visible change. If this leads
to regressions we will either need to figure out a better way or we need
to revert. However, given the various setgid bugs that we found just in
the last two years this is a regression risk we should take.

Associated with this change is a new set of fstests to enforce the
semantics for all new filesystems.

Link: https://lore.kernel.org/ceph-devel/20220427092201.wvsdjbnc7b4dttaw@wittgenstein [1]
Link: e014f37db1a2 ("xfs: use setattr_copy to set vfs inode attributes") [2]
Link: 01ea173e103e ("xfs: fix up non-directory creation in SGID directories") [3]
Link: fd84bfdddd16 ("ceph: fix up non-directory creation in SGID directories") [4]
Link: https://lore.kernel.org/r/1657779088-2242-3-git-send-email-xuyang2018.jy@fujitsu.com
Suggested-by: Dave Chinner <david@fromorbit.com>
Suggested-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-and-Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
[<brauner@kernel.org>: rewrote commit message]
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Tested-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/inode.c       |  2 --
 fs/namei.c       | 82 ++++++++++++++++++++++++++++++++++++++++--------
 fs/ocfs2/namei.c |  1 +
 3 files changed, 70 insertions(+), 15 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 3740102c9bd5..957b2d18ec29 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2165,8 +2165,6 @@ void inode_init_owner(struct user_namespace *mnt_userns, struct inode *inode,
 		/* Directories are special, and always inherit S_ISGID */
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-		else
-			mode = mode_strip_sgid(mnt_userns, dir, mode);
 	} else
 		inode_fsgid_set(inode, mnt_userns);
 	inode->i_mode = mode;
diff --git a/fs/namei.c b/fs/namei.c
index 81b31d9a063f..02e99606c65b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3000,6 +3000,65 @@ void unlock_rename(struct dentry *p1, struct dentry *p2)
 }
 EXPORT_SYMBOL(unlock_rename);
 
+/**
+ * mode_strip_umask - handle vfs umask stripping
+ * @dir:	parent directory of the new inode
+ * @mode:	mode of the new inode to be created in @dir
+ *
+ * Umask stripping depends on whether or not the filesystem supports POSIX
+ * ACLs. If the filesystem doesn't support it umask stripping is done directly
+ * in here. If the filesystem does support POSIX ACLs umask stripping is
+ * deferred until the filesystem calls posix_acl_create().
+ *
+ * Returns: mode
+ */
+static inline umode_t mode_strip_umask(const struct inode *dir, umode_t mode)
+{
+	if (!IS_POSIXACL(dir))
+		mode &= ~current_umask();
+	return mode;
+}
+
+/**
+ * vfs_prepare_mode - prepare the mode to be used for a new inode
+ * @mnt_userns:		user namespace of the mount the inode was found from
+ * @dir:	parent directory of the new inode
+ * @mode:	mode of the new inode
+ * @mask_perms:	allowed permission by the vfs
+ * @type:	type of file to be created
+ *
+ * This helper consolidates and enforces vfs restrictions on the @mode of a new
+ * object to be created.
+ *
+ * Umask stripping depends on whether the filesystem supports POSIX ACLs (see
+ * the kernel documentation for mode_strip_umask()). Moving umask stripping
+ * after setgid stripping allows the same ordering for both non-POSIX ACL and
+ * POSIX ACL supporting filesystems.
+ *
+ * Note that it's currently valid for @type to be 0 if a directory is created.
+ * Filesystems raise that flag individually and we need to check whether each
+ * filesystem can deal with receiving S_IFDIR from the vfs before we enforce a
+ * non-zero type.
+ *
+ * Returns: mode to be passed to the filesystem
+ */
+static inline umode_t vfs_prepare_mode(struct user_namespace *mnt_userns,
+				       const struct inode *dir, umode_t mode,
+				       umode_t mask_perms, umode_t type)
+{
+	mode = mode_strip_sgid(mnt_userns, dir, mode);
+	mode = mode_strip_umask(dir, mode);
+
+	/*
+	 * Apply the vfs mandated allowed permission mask and set the type of
+	 * file to be created before we call into the filesystem.
+	 */
+	mode &= (mask_perms & ~S_IFMT);
+	mode |= (type & S_IFMT);
+
+	return mode;
+}
+
 /**
  * vfs_create - create new file
  * @mnt_userns:	user namespace of the mount the inode was found from
@@ -3025,8 +3084,8 @@ int vfs_create(struct user_namespace *mnt_userns, struct inode *dir,
 
 	if (!dir->i_op->create)
 		return -EACCES;	/* shouldn't it be ENOSYS? */
-	mode &= S_IALLUGO;
-	mode |= S_IFREG;
+
+	mode = vfs_prepare_mode(mnt_userns, dir, mode, S_IALLUGO, S_IFREG);
 	error = security_inode_create(dir, dentry, mode);
 	if (error)
 		return error;
@@ -3291,8 +3350,7 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 	if (open_flag & O_CREAT) {
 		if (open_flag & O_EXCL)
 			open_flag &= ~O_TRUNC;
-		if (!IS_POSIXACL(dir->d_inode))
-			mode &= ~current_umask();
+		mode = vfs_prepare_mode(mnt_userns, dir->d_inode, mode, mode, mode);
 		if (likely(got_write))
 			create_error = may_o_create(mnt_userns, &nd->path,
 						    dentry, mode);
@@ -3525,8 +3583,7 @@ struct dentry *vfs_tmpfile(struct user_namespace *mnt_userns,
 	child = d_alloc(dentry, &slash_name);
 	if (unlikely(!child))
 		goto out_err;
-	if (!IS_POSIXACL(dir))
-		mode &= ~current_umask();
+	mode = vfs_prepare_mode(mnt_userns, dir, mode, mode, mode);
 	error = dir->i_op->tmpfile(mnt_userns, dir, child, mode);
 	if (error)
 		goto out_err;
@@ -3804,6 +3861,7 @@ int vfs_mknod(struct user_namespace *mnt_userns, struct inode *dir,
 	if (!dir->i_op->mknod)
 		return -EPERM;
 
+	mode = vfs_prepare_mode(mnt_userns, dir, mode, mode, mode);
 	error = devcgroup_inode_mknod(mode, dev);
 	if (error)
 		return error;
@@ -3854,9 +3912,8 @@ static int do_mknodat(int dfd, struct filename *name, umode_t mode,
 	if (IS_ERR(dentry))
 		goto out1;
 
-	if (!IS_POSIXACL(path.dentry->d_inode))
-		mode &= ~current_umask();
-	error = security_path_mknod(&path, dentry, mode, dev);
+	error = security_path_mknod(&path, dentry,
+			mode_strip_umask(path.dentry->d_inode, mode), dev);
 	if (error)
 		goto out2;
 
@@ -3926,7 +3983,7 @@ int vfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 	if (!dir->i_op->mkdir)
 		return -EPERM;
 
-	mode &= (S_IRWXUGO|S_ISVTX);
+	mode = vfs_prepare_mode(mnt_userns, dir, mode, S_IRWXUGO | S_ISVTX, 0);
 	error = security_inode_mkdir(dir, dentry, mode);
 	if (error)
 		return error;
@@ -3954,9 +4011,8 @@ int do_mkdirat(int dfd, struct filename *name, umode_t mode)
 	if (IS_ERR(dentry))
 		goto out_putname;
 
-	if (!IS_POSIXACL(path.dentry->d_inode))
-		mode &= ~current_umask();
-	error = security_path_mkdir(&path, dentry, mode);
+	error = security_path_mkdir(&path, dentry,
+			mode_strip_umask(path.dentry->d_inode, mode));
 	if (!error) {
 		struct user_namespace *mnt_userns;
 		mnt_userns = mnt_user_ns(path.mnt);
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 11807034dd48..5b8237ceb8cc 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -197,6 +197,7 @@ static struct inode *ocfs2_get_init_inode(struct inode *dir, umode_t mode)
 	 * callers. */
 	if (S_ISDIR(mode))
 		set_nlink(inode, 2);
+	mode = mode_strip_sgid(&init_user_ns, dir, mode);
 	inode_init_owner(&init_user_ns, inode, dir, mode);
 	status = dquot_initialize(inode);
 	if (status)
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

