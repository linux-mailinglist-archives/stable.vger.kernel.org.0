Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F62F593A39
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244648AbiHOTcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344394AbiHOTbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:31:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FC32B633;
        Mon, 15 Aug 2022 11:44:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C427EB8105C;
        Mon, 15 Aug 2022 18:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F1AC433C1;
        Mon, 15 Aug 2022 18:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589070;
        bh=tWN5yU3HtCGh/ww69p/tfqc6Xnx4l+6311RSPwAUIXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4nFkkFlJeOerphifDtLxh8OIaMxWe+zeL2n4+v39qF+iSmnkM8GtQEhjhYXZQZWX
         itDLcNWNdbj6mPOzQ35eRevJ2fmRg2DcRpeopvm+5bibo8YEEh2khO1hUut3OZIF92
         mJ2jfOIufR33JNlwJMMRR4HfPEh8pcakO1hT6sNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 604/779] 9p: fix a bunch of checkpatch warnings
Date:   Mon, 15 Aug 2022 20:04:08 +0200
Message-Id: <20220815180403.175113584@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

[ Upstream commit 6e195b0f7c8e50927fa31946369c22a0534ec7e2 ]

Sohaib Mohamed started a serie of tiny and incomplete checkpatch fixes but
seemingly stopped halfway -- take over and do most of it.
This is still missing net/9p/trans* and net/9p/protocol.c for a later
time...

Link: http://lkml.kernel.org/r/20211102134608.1588018-3-dominique.martinet@atmark-techno.com
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/acl.c                |   1 +
 fs/9p/acl.h                |  17 +-
 fs/9p/cache.c              |   4 +-
 fs/9p/v9fs.c               |   4 +
 fs/9p/v9fs_vfs.h           |  11 +-
 fs/9p/vfs_addr.c           |   6 +-
 fs/9p/vfs_dentry.c         |   2 +
 fs/9p/vfs_file.c           |   1 +
 fs/9p/vfs_inode.c          |  14 +-
 fs/9p/vfs_inode_dotl.c     |   9 +-
 fs/9p/vfs_super.c          |   7 +-
 fs/9p/xattr.h              |  19 +-
 include/net/9p/9p.h        |  10 +-
 include/net/9p/client.h    |  22 +-
 include/net/9p/transport.h |  18 +-
 net/9p/client.c            | 432 ++++++++++++++++++-------------------
 net/9p/error.c             |   2 +-
 net/9p/mod.c               |   9 +-
 net/9p/protocol.c          |  36 ++--
 net/9p/protocol.h          |   2 +-
 net/9p/trans_common.h      |   2 +-
 21 files changed, 323 insertions(+), 305 deletions(-)

diff --git a/fs/9p/acl.c b/fs/9p/acl.c
index c381499f5416..da22415ed036 100644
--- a/fs/9p/acl.c
+++ b/fs/9p/acl.c
@@ -123,6 +123,7 @@ static int v9fs_set_acl(struct p9_fid *fid, int type, struct posix_acl *acl)
 	char *name;
 	size_t size;
 	void *buffer;
+
 	if (!acl)
 		return 0;
 
diff --git a/fs/9p/acl.h b/fs/9p/acl.h
index d43c8949e807..bc87b36f529e 100644
--- a/fs/9p/acl.h
+++ b/fs/9p/acl.h
@@ -15,14 +15,15 @@
 #define FS_9P_ACL_H
 
 #ifdef CONFIG_9P_FS_POSIX_ACL
-extern int v9fs_get_acl(struct inode *, struct p9_fid *);
-extern struct posix_acl *v9fs_iop_get_acl(struct inode *inode, int type, bool rcu);
-extern int v9fs_acl_chmod(struct inode *, struct p9_fid *);
-extern int v9fs_set_create_acl(struct inode *, struct p9_fid *,
-			       struct posix_acl *, struct posix_acl *);
-extern int v9fs_acl_mode(struct inode *dir, umode_t *modep,
-			 struct posix_acl **dpacl, struct posix_acl **pacl);
-extern void v9fs_put_acl(struct posix_acl *dacl, struct posix_acl *acl);
+int v9fs_get_acl(struct inode *inode, struct p9_fid *fid);
+struct posix_acl *v9fs_iop_get_acl(struct inode *inode, int type,
+				   bool rcu);
+int v9fs_acl_chmod(struct inode *inode, struct p9_fid *fid);
+int v9fs_set_create_acl(struct inode *inode, struct p9_fid *fid,
+			struct posix_acl *dacl, struct posix_acl *acl);
+int v9fs_acl_mode(struct inode *dir, umode_t *modep,
+		  struct posix_acl **dpacl, struct posix_acl **pacl);
+void v9fs_put_acl(struct posix_acl *dacl, struct posix_acl *acl);
 #else
 #define v9fs_iop_get_acl NULL
 static inline int v9fs_get_acl(struct inode *inode, struct p9_fid *fid)
diff --git a/fs/9p/cache.c b/fs/9p/cache.c
index 1769a44f4819..41da71320482 100644
--- a/fs/9p/cache.c
+++ b/fs/9p/cache.c
@@ -19,8 +19,8 @@
 #define CACHETAG_LEN  11
 
 struct fscache_netfs v9fs_cache_netfs = {
-	.name 		= "9p",
-	.version 	= 0,
+	.name		= "9p",
+	.version	= 0,
 };
 
 /*
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 2e0fa7c932db..141067379f5e 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -190,8 +190,10 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token, r;
+
 		if (!*p)
 			continue;
+
 		token = match_token(p, tokens, args);
 		switch (token) {
 		case Opt_debug:
@@ -659,6 +661,7 @@ static void v9fs_destroy_inode_cache(void)
 static int v9fs_cache_register(void)
 {
 	int ret;
+
 	ret = v9fs_init_inode_cache();
 	if (ret < 0)
 		return ret;
@@ -686,6 +689,7 @@ static void v9fs_cache_unregister(void)
 static int __init init_v9fs(void)
 {
 	int err;
+
 	pr_info("Installing v9fs 9p2000 file system support\n");
 	/* TODO: Setup list of registered trasnport modules */
 
diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index d44ade76966a..bc417da7e9c1 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -44,9 +44,10 @@ extern struct kmem_cache *v9fs_inode_cache;
 
 struct inode *v9fs_alloc_inode(struct super_block *sb);
 void v9fs_free_inode(struct inode *inode);
-struct inode *v9fs_get_inode(struct super_block *sb, umode_t mode, dev_t);
+struct inode *v9fs_get_inode(struct super_block *sb, umode_t mode,
+			     dev_t rdev);
 int v9fs_init_inode(struct v9fs_session_info *v9ses,
-		    struct inode *inode, umode_t mode, dev_t);
+		    struct inode *inode, umode_t mode, dev_t rdev);
 void v9fs_evict_inode(struct inode *inode);
 ino_t v9fs_qid2ino(struct p9_qid *qid);
 void v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
@@ -59,8 +60,8 @@ void v9fs_inode2stat(struct inode *inode, struct p9_wstat *stat);
 int v9fs_uflags2omode(int uflags, int extended);
 
 void v9fs_blank_wstat(struct p9_wstat *wstat);
-int v9fs_vfs_setattr_dotl(struct user_namespace *, struct dentry *,
-			  struct iattr *);
+int v9fs_vfs_setattr_dotl(struct user_namespace *mnt_userns,
+			  struct dentry *dentry, struct iattr *iattr);
 int v9fs_file_fsync_dotl(struct file *filp, loff_t start, loff_t end,
 			 int datasync);
 int v9fs_refresh_inode(struct p9_fid *fid, struct inode *inode);
@@ -68,9 +69,9 @@ int v9fs_refresh_inode_dotl(struct p9_fid *fid, struct inode *inode);
 static inline void v9fs_invalidate_inode_attr(struct inode *inode)
 {
 	struct v9fs_inode *v9inode;
+
 	v9inode = V9FS_I(inode);
 	v9inode->cache_validity |= V9FS_INO_INVALID_ATTR;
-	return;
 }
 
 int v9fs_open_to_dotl_flags(int flags);
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 1c4f1b39cc95..606d33ef35c6 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -242,11 +242,13 @@ v9fs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	loff_t pos = iocb->ki_pos;
 	ssize_t n;
 	int err = 0;
+
 	if (iov_iter_rw(iter) == WRITE) {
 		n = p9_client_write(file->private_data, pos, iter, &err);
 		if (n) {
 			struct inode *inode = file_inode(file);
 			loff_t i_size = i_size_read(inode);
+
 			if (pos + n > i_size)
 				inode_add_bytes(inode, pos + n - i_size);
 		}
@@ -257,7 +259,7 @@ v9fs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 }
 
 static int v9fs_write_begin(struct file *filp, struct address_space *mapping,
-			    loff_t pos, unsigned len, unsigned flags,
+			    loff_t pos, unsigned int len, unsigned int flags,
 			    struct page **pagep, void **fsdata)
 {
 	int retval = 0;
@@ -293,7 +295,7 @@ static int v9fs_write_begin(struct file *filp, struct address_space *mapping,
 }
 
 static int v9fs_write_end(struct file *filp, struct address_space *mapping,
-			  loff_t pos, unsigned len, unsigned copied,
+			  loff_t pos, unsigned int len, unsigned int copied,
 			  struct page *page, void *fsdata)
 {
 	loff_t last_pos = pos + copied;
diff --git a/fs/9p/vfs_dentry.c b/fs/9p/vfs_dentry.c
index 4b4292123b3d..c2736af97884 100644
--- a/fs/9p/vfs_dentry.c
+++ b/fs/9p/vfs_dentry.c
@@ -52,6 +52,7 @@ static int v9fs_cached_dentry_delete(const struct dentry *dentry)
 static void v9fs_dentry_release(struct dentry *dentry)
 {
 	struct hlist_node *p, *n;
+
 	p9_debug(P9_DEBUG_VFS, " dentry: %pd (%p)\n",
 		 dentry, dentry);
 	hlist_for_each_safe(p, n, (struct hlist_head *)&dentry->d_fsdata)
@@ -76,6 +77,7 @@ static int v9fs_lookup_revalidate(struct dentry *dentry, unsigned int flags)
 	if (v9inode->cache_validity & V9FS_INO_INVALID_ATTR) {
 		int retval;
 		struct v9fs_session_info *v9ses;
+
 		fid = v9fs_fid_lookup(dentry);
 		if (IS_ERR(fid))
 			return PTR_ERR(fid);
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 246235ebdb70..7437b185fa8e 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -408,6 +408,7 @@ v9fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		struct inode *inode = file_inode(file);
 		loff_t i_size;
 		unsigned long pg_start, pg_end;
+
 		pg_start = origin >> PAGE_SHIFT;
 		pg_end = (origin + retval - 1) >> PAGE_SHIFT;
 		if (inode->i_mapping && inode->i_mapping->nrpages)
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 15d9492536cf..0d9b7d453a87 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -49,6 +49,7 @@ static const struct inode_operations v9fs_symlink_inode_operations;
 static u32 unixmode2p9mode(struct v9fs_session_info *v9ses, umode_t mode)
 {
 	int res;
+
 	res = mode & 0777;
 	if (S_ISDIR(mode))
 		res |= P9_DMDIR;
@@ -223,6 +224,7 @@ v9fs_blank_wstat(struct p9_wstat *wstat)
 struct inode *v9fs_alloc_inode(struct super_block *sb)
 {
 	struct v9fs_inode *v9inode;
+
 	v9inode = kmem_cache_alloc(v9fs_inode_cache, GFP_KERNEL);
 	if (!v9inode)
 		return NULL;
@@ -251,7 +253,7 @@ int v9fs_init_inode(struct v9fs_session_info *v9ses,
 {
 	int err = 0;
 
-	inode_init_owner(&init_user_ns,inode,  NULL, mode);
+	inode_init_owner(&init_user_ns, inode, NULL, mode);
 	inode->i_blocks = 0;
 	inode->i_rdev = rdev;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = current_time(inode);
@@ -440,7 +442,7 @@ static struct inode *v9fs_qid_iget(struct super_block *sb,
 	unsigned long i_ino;
 	struct inode *inode;
 	struct v9fs_session_info *v9ses = sb->s_fs_info;
-	int (*test)(struct inode *, void *);
+	int (*test)(struct inode *inode, void *data);
 
 	if (new)
 		test = v9fs_test_new_inode;
@@ -499,8 +501,10 @@ v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 static int v9fs_at_to_dotl_flags(int flags)
 {
 	int rflags = 0;
+
 	if (flags & AT_REMOVEDIR)
 		rflags |= P9_DOTL_AT_REMOVEDIR;
+
 	return rflags;
 }
 
@@ -797,7 +801,7 @@ struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 
 static int
 v9fs_vfs_atomic_open(struct inode *dir, struct dentry *dentry,
-		     struct file *file, unsigned flags, umode_t mode)
+		     struct file *file, unsigned int flags, umode_t mode)
 {
 	int err;
 	u32 perm;
@@ -1084,7 +1088,7 @@ static int v9fs_vfs_setattr(struct user_namespace *mnt_userns,
 		fid = v9fs_fid_lookup(dentry);
 		use_dentry = 1;
 	}
-	if(IS_ERR(fid))
+	if (IS_ERR(fid))
 		return PTR_ERR(fid);
 
 	v9fs_blank_wstat(&wstat);
@@ -1364,7 +1368,7 @@ v9fs_vfs_mknod(struct user_namespace *mnt_userns, struct inode *dir,
 	char name[2 + U32_MAX_DIGITS + 1 + U32_MAX_DIGITS + 1];
 	u32 perm;
 
-	p9_debug(P9_DEBUG_VFS, " %lu,%pd mode: %hx MAJOR: %u MINOR: %u\n",
+	p9_debug(P9_DEBUG_VFS, " %lu,%pd mode: %x MAJOR: %u MINOR: %u\n",
 		 dir->i_ino, dentry, mode,
 		 MAJOR(rdev), MINOR(rdev));
 
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 833c638437a7..0f73aa26ddf4 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -107,7 +107,7 @@ static struct inode *v9fs_qid_iget_dotl(struct super_block *sb,
 	unsigned long i_ino;
 	struct inode *inode;
 	struct v9fs_session_info *v9ses = sb->s_fs_info;
-	int (*test)(struct inode *, void *);
+	int (*test)(struct inode *inode, void *data);
 
 	if (new)
 		test = v9fs_test_new_inode_dotl;
@@ -230,7 +230,7 @@ v9fs_vfs_create_dotl(struct user_namespace *mnt_userns, struct inode *dir,
 
 static int
 v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
-			  struct file *file, unsigned flags, umode_t omode)
+			  struct file *file, unsigned int flags, umode_t omode)
 {
 	int err = 0;
 	kgid_t gid;
@@ -261,7 +261,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	v9ses = v9fs_inode2v9ses(dir);
 
 	name = dentry->d_name.name;
-	p9_debug(P9_DEBUG_VFS, "name:%s flags:0x%x mode:0x%hx\n",
+	p9_debug(P9_DEBUG_VFS, "name:%s flags:0x%x mode:0x%x\n",
 		 name, flags, omode);
 
 	dfid = v9fs_parent_fid(dentry);
@@ -821,6 +821,7 @@ v9fs_vfs_link_dotl(struct dentry *old_dentry, struct inode *dir,
 	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) {
 		/* Get the latest stat info from server. */
 		struct p9_fid *fid;
+
 		fid = v9fs_fid_lookup(old_dentry);
 		if (IS_ERR(fid))
 			return PTR_ERR(fid);
@@ -857,7 +858,7 @@ v9fs_vfs_mknod_dotl(struct user_namespace *mnt_userns, struct inode *dir,
 	struct p9_qid qid;
 	struct posix_acl *dacl = NULL, *pacl = NULL;
 
-	p9_debug(P9_DEBUG_VFS, " %lu,%pd mode: %hx MAJOR: %u MINOR: %u\n",
+	p9_debug(P9_DEBUG_VFS, " %lu,%pd mode: %x MAJOR: %u MINOR: %u\n",
 		 dir->i_ino, dentry, omode,
 		 MAJOR(rdev), MINOR(rdev));
 
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 5fce6e30bc5a..7449f7fd47d2 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -113,7 +113,7 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 	struct inode *inode = NULL;
 	struct dentry *root = NULL;
 	struct v9fs_session_info *v9ses = NULL;
-	umode_t mode = S_IRWXUGO | S_ISVTX;
+	umode_t mode = 0777 | S_ISVTX;
 	struct p9_fid *fid;
 	int retval = 0;
 
@@ -157,6 +157,7 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 	sb->s_root = root;
 	if (v9fs_proto_dotl(v9ses)) {
 		struct p9_stat_dotl *st = NULL;
+
 		st = p9_client_getattr_dotl(fid, P9_STATS_BASIC);
 		if (IS_ERR(st)) {
 			retval = PTR_ERR(st);
@@ -167,6 +168,7 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 		kfree(st);
 	} else {
 		struct p9_wstat *st = NULL;
+
 		st = p9_client_stat(fid);
 		if (IS_ERR(st)) {
 			retval = PTR_ERR(st);
@@ -275,12 +277,13 @@ static int v9fs_statfs(struct dentry *dentry, struct kstatfs *buf)
 static int v9fs_drop_inode(struct inode *inode)
 {
 	struct v9fs_session_info *v9ses;
+
 	v9ses = v9fs_inode2v9ses(inode);
 	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE)
 		return generic_drop_inode(inode);
 	/*
 	 * in case of non cached mode always drop the
-	 * the inode because we want the inode attribute
+	 * inode because we want the inode attribute
 	 * to always match that on the server.
 	 */
 	return 1;
diff --git a/fs/9p/xattr.h b/fs/9p/xattr.h
index c63c3bea5de5..9b28842c6363 100644
--- a/fs/9p/xattr.h
+++ b/fs/9p/xattr.h
@@ -22,13 +22,14 @@ extern const struct xattr_handler *v9fs_xattr_handlers[];
 extern const struct xattr_handler v9fs_xattr_acl_access_handler;
 extern const struct xattr_handler v9fs_xattr_acl_default_handler;
 
-extern ssize_t v9fs_fid_xattr_get(struct p9_fid *, const char *,
-				  void *, size_t);
-extern ssize_t v9fs_xattr_get(struct dentry *, const char *,
-			      void *, size_t);
-extern int v9fs_fid_xattr_set(struct p9_fid *, const char *,
-			  const void *, size_t, int);
-extern int v9fs_xattr_set(struct dentry *, const char *,
-			  const void *, size_t, int);
-extern ssize_t v9fs_listxattr(struct dentry *, char *, size_t);
+ssize_t v9fs_fid_xattr_get(struct p9_fid *fid, const char *name,
+			   void *buffer, size_t buffer_size);
+ssize_t v9fs_xattr_get(struct dentry *dentry, const char *name,
+		       void *buffer, size_t buffer_size);
+int v9fs_fid_xattr_set(struct p9_fid *fid, const char *name,
+		       const void *value, size_t value_len, int flags);
+int v9fs_xattr_set(struct dentry *dentry, const char *name,
+		   const void *value, size_t value_len, int flags);
+ssize_t v9fs_listxattr(struct dentry *dentry, char *buffer,
+		       size_t buffer_size);
 #endif /* FS_9P_XATTR_H */
diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 03614de86942..6d0615140dbc 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -32,13 +32,13 @@
  */
 
 enum p9_debug_flags {
-	P9_DEBUG_ERROR = 	(1<<0),
-	P9_DEBUG_9P = 		(1<<2),
+	P9_DEBUG_ERROR =	(1<<0),
+	P9_DEBUG_9P =		(1<<2),
 	P9_DEBUG_VFS =		(1<<3),
 	P9_DEBUG_CONV =		(1<<4),
 	P9_DEBUG_MUX =		(1<<5),
 	P9_DEBUG_TRANS =	(1<<6),
-	P9_DEBUG_SLABS =      	(1<<7),
+	P9_DEBUG_SLABS =	(1<<7),
 	P9_DEBUG_FCALL =	(1<<8),
 	P9_DEBUG_FID =		(1<<9),
 	P9_DEBUG_PKT =		(1<<10),
@@ -317,8 +317,8 @@ enum p9_qid_t {
 };
 
 /* 9P Magic Numbers */
-#define P9_NOTAG	(u16)(~0)
-#define P9_NOFID	(u32)(~0)
+#define P9_NOTAG	((u16)(~0))
+#define P9_NOFID	((u32)(~0))
 #define P9_MAXWELEM	16
 
 /* Minimal header size: size[4] type[1] tag[2] */
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index e1c308d8d288..334dc748fb3f 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -23,7 +23,7 @@
  * @p9_proto_2000L: 9P2000.L extension
  */
 
-enum p9_proto_versions{
+enum p9_proto_versions {
 	p9_proto_legacy,
 	p9_proto_2000u,
 	p9_proto_2000L,
@@ -219,13 +219,13 @@ struct p9_stat_dotl *p9_client_getattr_dotl(struct p9_fid *fid,
 							u64 request_mask);
 
 int p9_client_mknod_dotl(struct p9_fid *oldfid, const char *name, int mode,
-			dev_t rdev, kgid_t gid, struct p9_qid *);
+			dev_t rdev, kgid_t gid, struct p9_qid *qid);
 int p9_client_mkdir_dotl(struct p9_fid *fid, const char *name, int mode,
-				kgid_t gid, struct p9_qid *);
+				kgid_t gid, struct p9_qid *qid);
 int p9_client_lock_dotl(struct p9_fid *fid, struct p9_flock *flock, u8 *status);
 int p9_client_getlock_dotl(struct p9_fid *fid, struct p9_getlock *fl);
 void p9_fcall_fini(struct p9_fcall *fc);
-struct p9_req_t *p9_tag_lookup(struct p9_client *, u16);
+struct p9_req_t *p9_tag_lookup(struct p9_client *c, u16 tag);
 
 static inline void p9_req_get(struct p9_req_t *r)
 {
@@ -241,14 +241,18 @@ int p9_req_put(struct p9_req_t *r);
 
 void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status);
 
-int p9_parse_header(struct p9_fcall *, int32_t *, int8_t *, int16_t *, int);
-int p9stat_read(struct p9_client *, char *, int, struct p9_wstat *);
-void p9stat_free(struct p9_wstat *);
+int p9_parse_header(struct p9_fcall *pdu, int32_t *size, int8_t *type,
+		    int16_t *tag, int rewind);
+int p9stat_read(struct p9_client *clnt, char *buf, int len,
+		struct p9_wstat *st);
+void p9stat_free(struct p9_wstat *stbuf);
 
 int p9_is_proto_dotu(struct p9_client *clnt);
 int p9_is_proto_dotl(struct p9_client *clnt);
-struct p9_fid *p9_client_xattrwalk(struct p9_fid *, const char *, u64 *);
-int p9_client_xattrcreate(struct p9_fid *, const char *, u64, int);
+struct p9_fid *p9_client_xattrwalk(struct p9_fid *file_fid,
+				   const char *attr_name, u64 *attr_size);
+int p9_client_xattrcreate(struct p9_fid *fid, const char *name,
+			  u64 attr_size, int flags);
 int p9_client_readlink(struct p9_fid *fid, char **target);
 
 int p9_client_init(void);
diff --git a/include/net/9p/transport.h b/include/net/9p/transport.h
index 3eb4261b2958..721597611625 100644
--- a/include/net/9p/transport.h
+++ b/include/net/9p/transport.h
@@ -40,14 +40,16 @@ struct p9_trans_module {
 	int maxsize;		/* max message size of transport */
 	int def;		/* this transport should be default */
 	struct module *owner;
-	int (*create)(struct p9_client *, const char *, char *);
-	void (*close) (struct p9_client *);
-	int (*request) (struct p9_client *, struct p9_req_t *req);
-	int (*cancel) (struct p9_client *, struct p9_req_t *req);
-	int (*cancelled)(struct p9_client *, struct p9_req_t *req);
-	int (*zc_request)(struct p9_client *, struct p9_req_t *,
-			  struct iov_iter *, struct iov_iter *, int , int, int);
-	int (*show_options)(struct seq_file *, struct p9_client *);
+	int (*create)(struct p9_client *client,
+		      const char *devname, char *args);
+	void (*close)(struct p9_client *client);
+	int (*request)(struct p9_client *client, struct p9_req_t *req);
+	int (*cancel)(struct p9_client *client, struct p9_req_t *req);
+	int (*cancelled)(struct p9_client *client, struct p9_req_t *req);
+	int (*zc_request)(struct p9_client *client, struct p9_req_t *req,
+			  struct iov_iter *uidata, struct iov_iter *uodata,
+			  int inlen, int outlen, int in_hdr_len);
+	int (*show_options)(struct seq_file *m, struct p9_client *client);
 };
 
 void v9fs_register_trans(struct p9_trans_module *m);
diff --git a/net/9p/client.c b/net/9p/client.c
index 7973267ec846..33a53f016e73 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -32,10 +32,9 @@
 
 #define DEFAULT_MSIZE (128 * 1024)
 
-/*
-  * Client Option Parsing (code inspired by NFS code)
-  *  - a little lazy - parse all client options
-  */
+/* Client Option Parsing (code inspired by NFS code)
+ *  - a little lazy - parse all client options
+ */
 
 enum {
 	Opt_msize,
@@ -89,20 +88,18 @@ int p9_show_client_options(struct seq_file *m, struct p9_client *clnt)
 }
 EXPORT_SYMBOL(p9_show_client_options);
 
-/*
- * Some error codes are taken directly from the server replies,
+/* Some error codes are taken directly from the server replies,
  * make sure they are valid.
  */
 static int safe_errno(int err)
 {
-	if ((err > 0) || (err < -MAX_ERRNO)) {
+	if (err > 0 || err < -MAX_ERRNO) {
 		p9_debug(P9_DEBUG_ERROR, "Invalid error code %d\n", err);
 		return -EPROTO;
 	}
 	return err;
 }
 
-
 /* Interpret mount option for protocol version */
 static int get_protocol_version(char *s)
 {
@@ -117,8 +114,9 @@ static int get_protocol_version(char *s)
 	} else if (!strcmp(s, "9p2000.L")) {
 		version = p9_proto_2000L;
 		p9_debug(P9_DEBUG_9P, "Protocol version: 9P2000.L\n");
-	} else
+	} else {
 		pr_info("Unknown protocol version %s\n", s);
+	}
 
 	return version;
 }
@@ -147,15 +145,13 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 		return 0;
 
 	tmp_options = kstrdup(opts, GFP_KERNEL);
-	if (!tmp_options) {
-		p9_debug(P9_DEBUG_ERROR,
-			 "failed to allocate copy of option string\n");
+	if (!tmp_options)
 		return -ENOMEM;
-	}
 	options = tmp_options;
 
 	while ((p = strsep(&options, ",")) != NULL) {
 		int token, r;
+
 		if (!*p)
 			continue;
 		token = match_token(p, tokens, args);
@@ -187,7 +183,7 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 
 			v9fs_put_trans(clnt->trans_mod);
 			clnt->trans_mod = v9fs_get_trans_by_name(s);
-			if (clnt->trans_mod == NULL) {
+			if (!clnt->trans_mod) {
 				pr_info("Could not find request transport: %s\n",
 					s);
 				ret = -EINVAL;
@@ -379,6 +375,7 @@ static int p9_tag_remove(struct p9_client *c, struct p9_req_t *r)
 static void p9_req_free(struct kref *ref)
 {
 	struct p9_req_t *r = container_of(ref, struct p9_req_t, refcount);
+
 	p9_fcall_fini(&r->tc);
 	p9_fcall_fini(&r->rc);
 	kmem_cache_free(p9_req_cache, r);
@@ -423,8 +420,7 @@ void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status)
 {
 	p9_debug(P9_DEBUG_MUX, " tag %d\n", req->tc.tag);
 
-	/*
-	 * This barrier is needed to make sure any change made to req before
+	/* This barrier is needed to make sure any change made to req before
 	 * the status change is visible to another thread
 	 */
 	smp_wmb();
@@ -446,12 +442,12 @@ EXPORT_SYMBOL(p9_client_cb);
  */
 
 int
-p9_parse_header(struct p9_fcall *pdu, int32_t *size, int8_t *type, int16_t *tag,
-								int rewind)
+p9_parse_header(struct p9_fcall *pdu, int32_t *size, int8_t *type,
+		int16_t *tag, int rewind)
 {
-	int8_t r_type;
-	int16_t r_tag;
-	int32_t r_size;
+	s8 r_type;
+	s16 r_tag;
+	s32 r_size;
 	int offset = pdu->offset;
 	int err;
 
@@ -499,7 +495,7 @@ EXPORT_SYMBOL(p9_parse_header);
 
 static int p9_check_errors(struct p9_client *c, struct p9_req_t *req)
 {
-	int8_t type;
+	s8 type;
 	int err;
 	int ecode;
 
@@ -510,8 +506,7 @@ static int p9_check_errors(struct p9_client *c, struct p9_req_t *req)
 			 req->rc.size);
 		return -EIO;
 	}
-	/*
-	 * dump the response from server
+	/* dump the response from server
 	 * This should be after check errors which poplulate pdu_fcall.
 	 */
 	trace_9p_protocol_dump(c, &req->rc);
@@ -524,6 +519,7 @@ static int p9_check_errors(struct p9_client *c, struct p9_req_t *req)
 
 	if (!p9_is_proto_dotl(c)) {
 		char *ename;
+
 		err = p9pdu_readf(&req->rc, c->proto_version, "s?d",
 				  &ename, &ecode);
 		if (err)
@@ -574,12 +570,11 @@ static int p9_check_zc_errors(struct p9_client *c, struct p9_req_t *req,
 {
 	int err;
 	int ecode;
-	int8_t type;
+	s8 type;
 	char *ename = NULL;
 
 	err = p9_parse_header(&req->rc, NULL, &type, NULL, 0);
-	/*
-	 * dump the response from server
+	/* dump the response from server
 	 * This should be after parse_header which poplulate pdu_fcall.
 	 */
 	trace_9p_protocol_dump(c, &req->rc);
@@ -607,7 +602,7 @@ static int p9_check_zc_errors(struct p9_client *c, struct p9_req_t *req,
 		if (len > inline_len) {
 			/* We have error in external buffer */
 			if (!copy_from_iter_full(ename + inline_len,
-					     len - inline_len, uidata)) {
+						 len - inline_len, uidata)) {
 				err = -EFAULT;
 				goto out_err;
 			}
@@ -659,7 +654,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...);
 static int p9_client_flush(struct p9_client *c, struct p9_req_t *oldreq)
 {
 	struct p9_req_t *req;
-	int16_t oldtag;
+	s16 oldtag;
 	int err;
 
 	err = p9_parse_header(&oldreq->tc, NULL, NULL, &oldtag, 1);
@@ -672,8 +667,7 @@ static int p9_client_flush(struct p9_client *c, struct p9_req_t *oldreq)
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	/*
-	 * if we haven't received a response for oldreq,
+	/* if we haven't received a response for oldreq,
 	 * remove it from the list
 	 */
 	if (oldreq->status == REQ_STATUS_SENT) {
@@ -699,7 +693,7 @@ static struct p9_req_t *p9_client_prepare_req(struct p9_client *c,
 		return ERR_PTR(-EIO);
 
 	/* if status is begin_disconnected we allow only clunk request */
-	if ((c->status == BeginDisconnect) && (type != P9_TCLUNK))
+	if (c->status == BeginDisconnect && type != P9_TCLUNK)
 		return ERR_PTR(-EIO);
 
 	req = p9_tag_alloc(c, type, req_size);
@@ -747,8 +741,9 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	if (signal_pending(current)) {
 		sigpending = 1;
 		clear_thread_flag(TIF_SIGPENDING);
-	} else
+	} else {
 		sigpending = 0;
+	}
 
 	err = c->trans_mod->request(c, req);
 	if (err < 0) {
@@ -762,14 +757,13 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	/* Wait for the response */
 	err = wait_event_killable(req->wq, req->status >= REQ_STATUS_RCVD);
 
-	/*
-	 * Make sure our req is coherent with regard to updates in other
+	/* Make sure our req is coherent with regard to updates in other
 	 * threads - echoes to wmb() in the callback
 	 */
 	smp_rmb();
 
-	if ((err == -ERESTARTSYS) && (c->status == Connected)
-				  && (type == P9_TFLUSH)) {
+	if (err == -ERESTARTSYS && c->status == Connected &&
+	    type == P9_TFLUSH) {
 		sigpending = 1;
 		clear_thread_flag(TIF_SIGPENDING);
 		goto again;
@@ -779,7 +773,7 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 		p9_debug(P9_DEBUG_ERROR, "req_status error %d\n", req->t_err);
 		err = req->t_err;
 	}
-	if ((err == -ERESTARTSYS) && (c->status == Connected)) {
+	if (err == -ERESTARTSYS && c->status == Connected) {
 		p9_debug(P9_DEBUG_MUX, "flushing\n");
 		sigpending = 1;
 		clear_thread_flag(TIF_SIGPENDING);
@@ -834,8 +828,7 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 	struct p9_req_t *req;
 
 	va_start(ap, fmt);
-	/*
-	 * We allocate a inline protocol data of only 4k bytes.
+	/* We allocate a inline protocol data of only 4k bytes.
 	 * The actual content is passed in zero-copy fashion.
 	 */
 	req = p9_client_prepare_req(c, type, P9_ZC_HDR_SZ, fmt, ap);
@@ -846,8 +839,9 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 	if (signal_pending(current)) {
 		sigpending = 1;
 		clear_thread_flag(TIF_SIGPENDING);
-	} else
+	} else {
 		sigpending = 0;
+	}
 
 	err = c->trans_mod->zc_request(c, req, uidata, uodata,
 				       inlen, olen, in_hdrlen);
@@ -861,7 +855,7 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 		p9_debug(P9_DEBUG_ERROR, "req_status error %d\n", req->t_err);
 		err = req->t_err;
 	}
-	if ((err == -ERESTARTSYS) && (c->status == Connected)) {
+	if (err == -ERESTARTSYS && c->status == Connected) {
 		p9_debug(P9_DEBUG_MUX, "flushing\n");
 		sigpending = 1;
 		clear_thread_flag(TIF_SIGPENDING);
@@ -897,11 +891,11 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
 	struct p9_fid *fid;
 
 	p9_debug(P9_DEBUG_FID, "clnt %p\n", clnt);
-	fid = kmalloc(sizeof(struct p9_fid), GFP_KERNEL);
+	fid = kmalloc(sizeof(*fid), GFP_KERNEL);
 	if (!fid)
 		return NULL;
 
-	memset(&fid->qid, 0, sizeof(struct p9_qid));
+	memset(&fid->qid, 0, sizeof(fid->qid));
 	fid->mode = -1;
 	fid->uid = current_fsuid();
 	fid->clnt = clnt;
@@ -949,15 +943,15 @@ static int p9_client_version(struct p9_client *c)
 	switch (c->proto_version) {
 	case p9_proto_2000L:
 		req = p9_client_rpc(c, P9_TVERSION, "ds",
-					c->msize, "9P2000.L");
+				    c->msize, "9P2000.L");
 		break;
 	case p9_proto_2000u:
 		req = p9_client_rpc(c, P9_TVERSION, "ds",
-					c->msize, "9P2000.u");
+				    c->msize, "9P2000.u");
 		break;
 	case p9_proto_legacy:
 		req = p9_client_rpc(c, P9_TVERSION, "ds",
-					c->msize, "9P2000");
+				    c->msize, "9P2000");
 		break;
 	default:
 		return -EINVAL;
@@ -974,13 +968,13 @@ static int p9_client_version(struct p9_client *c)
 	}
 
 	p9_debug(P9_DEBUG_9P, "<<< RVERSION msize %d %s\n", msize, version);
-	if (!strncmp(version, "9P2000.L", 8))
+	if (!strncmp(version, "9P2000.L", 8)) {
 		c->proto_version = p9_proto_2000L;
-	else if (!strncmp(version, "9P2000.u", 8))
+	} else if (!strncmp(version, "9P2000.u", 8)) {
 		c->proto_version = p9_proto_2000u;
-	else if (!strncmp(version, "9P2000", 6))
+	} else if (!strncmp(version, "9P2000", 6)) {
 		c->proto_version = p9_proto_legacy;
-	else {
+	} else {
 		p9_debug(P9_DEBUG_ERROR,
 			 "server returned an unknown version: %s\n", version);
 		err = -EREMOTEIO;
@@ -1010,7 +1004,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	char *client_id;
 
 	err = 0;
-	clnt = kmalloc(sizeof(struct p9_client), GFP_KERNEL);
+	clnt = kmalloc(sizeof(*clnt), GFP_KERNEL);
 	if (!clnt)
 		return ERR_PTR(-ENOMEM);
 
@@ -1032,7 +1026,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 	if (!clnt->trans_mod)
 		clnt->trans_mod = v9fs_get_default_trans();
 
-	if (clnt->trans_mod == NULL) {
+	if (!clnt->trans_mod) {
 		err = -EPROTONOSUPPORT;
 		p9_debug(P9_DEBUG_ERROR,
 			 "No transport defined or default transport\n");
@@ -1120,14 +1114,14 @@ void p9_client_begin_disconnect(struct p9_client *clnt)
 EXPORT_SYMBOL(p9_client_begin_disconnect);
 
 struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
-	const char *uname, kuid_t n_uname, const char *aname)
+				const char *uname, kuid_t n_uname,
+				const char *aname)
 {
 	int err = 0;
 	struct p9_req_t *req;
 	struct p9_fid *fid;
 	struct p9_qid qid;
 
-
 	p9_debug(P9_DEBUG_9P, ">>> TATTACH afid %d uname %s aname %s\n",
 		 afid ? afid->fid : -1, uname, aname);
 	fid = p9_fid_create(clnt);
@@ -1138,7 +1132,7 @@ struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
 	fid->uid = n_uname;
 
 	req = p9_client_rpc(clnt, P9_TATTACH, "ddss?u", fid->fid,
-			afid ? afid->fid : P9_NOFID, uname, aname, n_uname);
+			    afid ? afid->fid : P9_NOFID, uname, aname, n_uname);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto error;
@@ -1152,7 +1146,7 @@ struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
 	}
 
 	p9_debug(P9_DEBUG_9P, "<<< RATTACH qid %x.%llx.%x\n",
-		 qid.type, (unsigned long long)qid.path, qid.version);
+		 qid.type, qid.path, qid.version);
 
 	memmove(&fid->qid, &qid, sizeof(struct p9_qid));
 
@@ -1167,14 +1161,14 @@ struct p9_fid *p9_client_attach(struct p9_client *clnt, struct p9_fid *afid,
 EXPORT_SYMBOL(p9_client_attach);
 
 struct p9_fid *p9_client_walk(struct p9_fid *oldfid, uint16_t nwname,
-		const unsigned char * const *wnames, int clone)
+			      const unsigned char * const *wnames, int clone)
 {
 	int err;
 	struct p9_client *clnt;
 	struct p9_fid *fid;
 	struct p9_qid *wqids;
 	struct p9_req_t *req;
-	uint16_t nwqids, count;
+	u16 nwqids, count;
 
 	err = 0;
 	wqids = NULL;
@@ -1187,14 +1181,14 @@ struct p9_fid *p9_client_walk(struct p9_fid *oldfid, uint16_t nwname,
 		}
 
 		fid->uid = oldfid->uid;
-	} else
+	} else {
 		fid = oldfid;
-
+	}
 
 	p9_debug(P9_DEBUG_9P, ">>> TWALK fids %d,%d nwname %ud wname[0] %s\n",
 		 oldfid->fid, fid->fid, nwname, wnames ? wnames[0] : NULL);
 	req = p9_client_rpc(clnt, P9_TWALK, "ddT", oldfid->fid, fid->fid,
-								nwname, wnames);
+			    nwname, wnames);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto error;
@@ -1217,9 +1211,9 @@ struct p9_fid *p9_client_walk(struct p9_fid *oldfid, uint16_t nwname,
 
 	for (count = 0; count < nwqids; count++)
 		p9_debug(P9_DEBUG_9P, "<<<     [%d] %x.%llx.%x\n",
-			count, wqids[count].type,
-			(unsigned long long)wqids[count].path,
-			wqids[count].version);
+			 count, wqids[count].type,
+			 wqids[count].path,
+			 wqids[count].version);
 
 	if (nwname)
 		memmove(&fid->qid, &wqids[nwqids - 1], sizeof(struct p9_qid));
@@ -1235,7 +1229,7 @@ struct p9_fid *p9_client_walk(struct p9_fid *oldfid, uint16_t nwname,
 	fid = NULL;
 
 error:
-	if (fid && (fid != oldfid))
+	if (fid && fid != oldfid)
 		p9_fid_destroy(fid);
 
 	return ERR_PTR(err);
@@ -1252,7 +1246,7 @@ int p9_client_open(struct p9_fid *fid, int mode)
 
 	clnt = fid->clnt;
 	p9_debug(P9_DEBUG_9P, ">>> %s fid %d mode %d\n",
-		p9_is_proto_dotl(clnt) ? "TLOPEN" : "TOPEN", fid->fid, mode);
+		 p9_is_proto_dotl(clnt) ? "TLOPEN" : "TOPEN", fid->fid, mode);
 	err = 0;
 
 	if (fid->mode != -1)
@@ -1274,8 +1268,8 @@ int p9_client_open(struct p9_fid *fid, int mode)
 	}
 
 	p9_debug(P9_DEBUG_9P, "<<< %s qid %x.%llx.%x iounit %x\n",
-		p9_is_proto_dotl(clnt) ? "RLOPEN" : "ROPEN",  qid.type,
-		(unsigned long long)qid.path, qid.version, iounit);
+		 p9_is_proto_dotl(clnt) ? "RLOPEN" : "ROPEN",  qid.type,
+		 qid.path, qid.version, iounit);
 
 	memmove(&fid->qid, &qid, sizeof(struct p9_qid));
 	fid->mode = mode;
@@ -1288,8 +1282,8 @@ int p9_client_open(struct p9_fid *fid, int mode)
 }
 EXPORT_SYMBOL(p9_client_open);
 
-int p9_client_create_dotl(struct p9_fid *ofid, const char *name, u32 flags, u32 mode,
-		kgid_t gid, struct p9_qid *qid)
+int p9_client_create_dotl(struct p9_fid *ofid, const char *name, u32 flags,
+			  u32 mode, kgid_t gid, struct p9_qid *qid)
 {
 	int err = 0;
 	struct p9_client *clnt;
@@ -1297,16 +1291,16 @@ int p9_client_create_dotl(struct p9_fid *ofid, const char *name, u32 flags, u32
 	int iounit;
 
 	p9_debug(P9_DEBUG_9P,
-			">>> TLCREATE fid %d name %s flags %d mode %d gid %d\n",
-			ofid->fid, name, flags, mode,
-		 	from_kgid(&init_user_ns, gid));
+		 ">>> TLCREATE fid %d name %s flags %d mode %d gid %d\n",
+		 ofid->fid, name, flags, mode,
+		 from_kgid(&init_user_ns, gid));
 	clnt = ofid->clnt;
 
 	if (ofid->mode != -1)
 		return -EINVAL;
 
 	req = p9_client_rpc(clnt, P9_TLCREATE, "dsddg", ofid->fid, name, flags,
-			mode, gid);
+			    mode, gid);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto error;
@@ -1319,9 +1313,7 @@ int p9_client_create_dotl(struct p9_fid *ofid, const char *name, u32 flags, u32
 	}
 
 	p9_debug(P9_DEBUG_9P, "<<< RLCREATE qid %x.%llx.%x iounit %x\n",
-			qid->type,
-			(unsigned long long)qid->path,
-			qid->version, iounit);
+		 qid->type, qid->path, qid->version, iounit);
 
 	memmove(&ofid->qid, qid, sizeof(struct p9_qid));
 	ofid->mode = mode;
@@ -1344,7 +1336,7 @@ int p9_client_fcreate(struct p9_fid *fid, const char *name, u32 perm, int mode,
 	int iounit;
 
 	p9_debug(P9_DEBUG_9P, ">>> TCREATE fid %d name %s perm %d mode %d\n",
-						fid->fid, name, perm, mode);
+		 fid->fid, name, perm, mode);
 	err = 0;
 	clnt = fid->clnt;
 
@@ -1352,7 +1344,7 @@ int p9_client_fcreate(struct p9_fid *fid, const char *name, u32 perm, int mode,
 		return -EINVAL;
 
 	req = p9_client_rpc(clnt, P9_TCREATE, "dsdb?s", fid->fid, name, perm,
-				mode, extension);
+			    mode, extension);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto error;
@@ -1365,9 +1357,7 @@ int p9_client_fcreate(struct p9_fid *fid, const char *name, u32 perm, int mode,
 	}
 
 	p9_debug(P9_DEBUG_9P, "<<< RCREATE qid %x.%llx.%x iounit %x\n",
-				qid.type,
-				(unsigned long long)qid.path,
-				qid.version, iounit);
+		 qid.type, qid.path, qid.version, iounit);
 
 	memmove(&fid->qid, &qid, sizeof(struct p9_qid));
 	fid->mode = mode;
@@ -1381,18 +1371,18 @@ int p9_client_fcreate(struct p9_fid *fid, const char *name, u32 perm, int mode,
 EXPORT_SYMBOL(p9_client_fcreate);
 
 int p9_client_symlink(struct p9_fid *dfid, const char *name,
-		const char *symtgt, kgid_t gid, struct p9_qid *qid)
+		      const char *symtgt, kgid_t gid, struct p9_qid *qid)
 {
 	int err = 0;
 	struct p9_client *clnt;
 	struct p9_req_t *req;
 
 	p9_debug(P9_DEBUG_9P, ">>> TSYMLINK dfid %d name %s  symtgt %s\n",
-			dfid->fid, name, symtgt);
+		 dfid->fid, name, symtgt);
 	clnt = dfid->clnt;
 
 	req = p9_client_rpc(clnt, P9_TSYMLINK, "dssg", dfid->fid, name, symtgt,
-			gid);
+			    gid);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto error;
@@ -1405,7 +1395,7 @@ int p9_client_symlink(struct p9_fid *dfid, const char *name,
 	}
 
 	p9_debug(P9_DEBUG_9P, "<<< RSYMLINK qid %x.%llx.%x\n",
-			qid->type, (unsigned long long)qid->path, qid->version);
+		 qid->type, qid->path, qid->version);
 
 free_and_error:
 	p9_tag_remove(clnt, req);
@@ -1420,10 +1410,10 @@ int p9_client_link(struct p9_fid *dfid, struct p9_fid *oldfid, const char *newna
 	struct p9_req_t *req;
 
 	p9_debug(P9_DEBUG_9P, ">>> TLINK dfid %d oldfid %d newname %s\n",
-			dfid->fid, oldfid->fid, newname);
+		 dfid->fid, oldfid->fid, newname);
 	clnt = dfid->clnt;
 	req = p9_client_rpc(clnt, P9_TLINK, "dds", dfid->fid, oldfid->fid,
-			newname);
+			    newname);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -1440,7 +1430,7 @@ int p9_client_fsync(struct p9_fid *fid, int datasync)
 	struct p9_req_t *req;
 
 	p9_debug(P9_DEBUG_9P, ">>> TFSYNC fid %d datasync:%d\n",
-			fid->fid, datasync);
+		 fid->fid, datasync);
 	err = 0;
 	clnt = fid->clnt;
 
@@ -1476,8 +1466,8 @@ int p9_client_clunk(struct p9_fid *fid)
 		return 0;
 
 again:
-	p9_debug(P9_DEBUG_9P, ">>> TCLUNK fid %d (try %d)\n", fid->fid,
-								retries);
+	p9_debug(P9_DEBUG_9P, ">>> TCLUNK fid %d (try %d)\n",
+		 fid->fid, retries);
 	err = 0;
 	clnt = fid->clnt;
 
@@ -1491,16 +1481,16 @@ int p9_client_clunk(struct p9_fid *fid)
 
 	p9_tag_remove(clnt, req);
 error:
-	/*
-	 * Fid is not valid even after a failed clunk
+	/* Fid is not valid even after a failed clunk
 	 * If interrupted, retry once then give up and
 	 * leak fid until umount.
 	 */
 	if (err == -ERESTARTSYS) {
 		if (retries++ == 0)
 			goto again;
-	} else
+	} else {
 		p9_fid_destroy(fid);
+	}
 	return err;
 }
 EXPORT_SYMBOL(p9_client_clunk);
@@ -1540,7 +1530,7 @@ int p9_client_unlinkat(struct p9_fid *dfid, const char *name, int flags)
 	struct p9_client *clnt;
 
 	p9_debug(P9_DEBUG_9P, ">>> TUNLINKAT fid %d %s %d\n",
-		   dfid->fid, name, flags);
+		 dfid->fid, name, flags);
 
 	clnt = dfid->clnt;
 	req = p9_client_rpc(clnt, P9_TUNLINKAT, "dsd", dfid->fid, name, flags);
@@ -1586,8 +1576,8 @@ p9_client_read_once(struct p9_fid *fid, u64 offset, struct iov_iter *to,
 	char *dataptr;
 
 	*err = 0;
-	p9_debug(P9_DEBUG_9P, ">>> TREAD fid %d offset %llu %d\n",
-		   fid->fid, (unsigned long long) offset, (int)iov_iter_count(to));
+	p9_debug(P9_DEBUG_9P, ">>> TREAD fid %d offset %llu %zu\n",
+		 fid->fid, offset, iov_iter_count(to));
 
 	rsize = fid->iounit;
 	if (!rsize || rsize > clnt->msize - P9_IOHDRSZ)
@@ -1653,13 +1643,13 @@ p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
 	*err = 0;
 
 	p9_debug(P9_DEBUG_9P, ">>> TWRITE fid %d offset %llu count %zd\n",
-				fid->fid, (unsigned long long) offset,
-				iov_iter_count(from));
+		 fid->fid, offset, iov_iter_count(from));
 
 	while (iov_iter_count(from)) {
 		int count = iov_iter_count(from);
 		int rsize = fid->iounit;
-		if (!rsize || rsize > clnt->msize-P9_IOHDRSZ)
+
+		if (!rsize || rsize > clnt->msize - P9_IOHDRSZ)
 			rsize = clnt->msize - P9_IOHDRSZ;
 
 		if (count < rsize)
@@ -1672,7 +1662,7 @@ p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
 					       fid->fid, offset, rsize);
 		} else {
 			req = p9_client_rpc(clnt, P9_TWRITE, "dqV", fid->fid,
-						    offset, rsize, from);
+					    offset, rsize, from);
 		}
 		if (IS_ERR(req)) {
 			*err = PTR_ERR(req);
@@ -1705,12 +1695,13 @@ struct p9_wstat *p9_client_stat(struct p9_fid *fid)
 {
 	int err;
 	struct p9_client *clnt;
-	struct p9_wstat *ret = kmalloc(sizeof(struct p9_wstat), GFP_KERNEL);
+	struct p9_wstat *ret;
 	struct p9_req_t *req;
 	u16 ignored;
 
 	p9_debug(P9_DEBUG_9P, ">>> TSTAT fid %d\n", fid->fid);
 
+	ret = kmalloc(sizeof(*ret), GFP_KERNEL);
 	if (!ret)
 		return ERR_PTR(-ENOMEM);
 
@@ -1731,17 +1722,17 @@ struct p9_wstat *p9_client_stat(struct p9_fid *fid)
 	}
 
 	p9_debug(P9_DEBUG_9P,
-		"<<< RSTAT sz=%x type=%x dev=%x qid=%x.%llx.%x\n"
-		"<<<    mode=%8.8x atime=%8.8x mtime=%8.8x length=%llx\n"
-		"<<<    name=%s uid=%s gid=%s muid=%s extension=(%s)\n"
-		"<<<    uid=%d gid=%d n_muid=%d\n",
-		ret->size, ret->type, ret->dev, ret->qid.type,
-		(unsigned long long)ret->qid.path, ret->qid.version, ret->mode,
-		ret->atime, ret->mtime, (unsigned long long)ret->length,
-		ret->name, ret->uid, ret->gid, ret->muid, ret->extension,
-		from_kuid(&init_user_ns, ret->n_uid),
-		from_kgid(&init_user_ns, ret->n_gid),
-		from_kuid(&init_user_ns, ret->n_muid));
+		 "<<< RSTAT sz=%x type=%x dev=%x qid=%x.%llx.%x\n"
+		 "<<<    mode=%8.8x atime=%8.8x mtime=%8.8x length=%llx\n"
+		 "<<<    name=%s uid=%s gid=%s muid=%s extension=(%s)\n"
+		 "<<<    uid=%d gid=%d n_muid=%d\n",
+		 ret->size, ret->type, ret->dev, ret->qid.type, ret->qid.path,
+		 ret->qid.version, ret->mode,
+		 ret->atime, ret->mtime, ret->length,
+		 ret->name, ret->uid, ret->gid, ret->muid, ret->extension,
+		 from_kuid(&init_user_ns, ret->n_uid),
+		 from_kgid(&init_user_ns, ret->n_gid),
+		 from_kuid(&init_user_ns, ret->n_muid));
 
 	p9_tag_remove(clnt, req);
 	return ret;
@@ -1753,17 +1744,17 @@ struct p9_wstat *p9_client_stat(struct p9_fid *fid)
 EXPORT_SYMBOL(p9_client_stat);
 
 struct p9_stat_dotl *p9_client_getattr_dotl(struct p9_fid *fid,
-							u64 request_mask)
+					    u64 request_mask)
 {
 	int err;
 	struct p9_client *clnt;
-	struct p9_stat_dotl *ret = kmalloc(sizeof(struct p9_stat_dotl),
-								GFP_KERNEL);
+	struct p9_stat_dotl *ret;
 	struct p9_req_t *req;
 
 	p9_debug(P9_DEBUG_9P, ">>> TGETATTR fid %d, request_mask %lld\n",
-							fid->fid, request_mask);
+		 fid->fid, request_mask);
 
+	ret = kmalloc(sizeof(*ret), GFP_KERNEL);
 	if (!ret)
 		return ERR_PTR(-ENOMEM);
 
@@ -1783,26 +1774,27 @@ struct p9_stat_dotl *p9_client_getattr_dotl(struct p9_fid *fid,
 		goto error;
 	}
 
-	p9_debug(P9_DEBUG_9P,
-		"<<< RGETATTR st_result_mask=%lld\n"
-		"<<< qid=%x.%llx.%x\n"
-		"<<< st_mode=%8.8x st_nlink=%llu\n"
-		"<<< st_uid=%d st_gid=%d\n"
-		"<<< st_rdev=%llx st_size=%llx st_blksize=%llu st_blocks=%llu\n"
-		"<<< st_atime_sec=%lld st_atime_nsec=%lld\n"
-		"<<< st_mtime_sec=%lld st_mtime_nsec=%lld\n"
-		"<<< st_ctime_sec=%lld st_ctime_nsec=%lld\n"
-		"<<< st_btime_sec=%lld st_btime_nsec=%lld\n"
-		"<<< st_gen=%lld st_data_version=%lld\n",
-		ret->st_result_mask, ret->qid.type, ret->qid.path,
-		ret->qid.version, ret->st_mode, ret->st_nlink,
-		from_kuid(&init_user_ns, ret->st_uid),
-		from_kgid(&init_user_ns, ret->st_gid),
-		ret->st_rdev, ret->st_size, ret->st_blksize,
-		ret->st_blocks, ret->st_atime_sec, ret->st_atime_nsec,
-		ret->st_mtime_sec, ret->st_mtime_nsec, ret->st_ctime_sec,
-		ret->st_ctime_nsec, ret->st_btime_sec, ret->st_btime_nsec,
-		ret->st_gen, ret->st_data_version);
+	p9_debug(P9_DEBUG_9P, "<<< RGETATTR st_result_mask=%lld\n"
+		 "<<< qid=%x.%llx.%x\n"
+		 "<<< st_mode=%8.8x st_nlink=%llu\n"
+		 "<<< st_uid=%d st_gid=%d\n"
+		 "<<< st_rdev=%llx st_size=%llx st_blksize=%llu st_blocks=%llu\n"
+		 "<<< st_atime_sec=%lld st_atime_nsec=%lld\n"
+		 "<<< st_mtime_sec=%lld st_mtime_nsec=%lld\n"
+		 "<<< st_ctime_sec=%lld st_ctime_nsec=%lld\n"
+		 "<<< st_btime_sec=%lld st_btime_nsec=%lld\n"
+		 "<<< st_gen=%lld st_data_version=%lld\n",
+		 ret->st_result_mask,
+		 ret->qid.type, ret->qid.path, ret->qid.version,
+		 ret->st_mode, ret->st_nlink,
+		 from_kuid(&init_user_ns, ret->st_uid),
+		 from_kgid(&init_user_ns, ret->st_gid),
+		 ret->st_rdev, ret->st_size, ret->st_blksize, ret->st_blocks,
+		 ret->st_atime_sec, ret->st_atime_nsec,
+		 ret->st_mtime_sec, ret->st_mtime_nsec,
+		 ret->st_ctime_sec, ret->st_ctime_nsec,
+		 ret->st_btime_sec, ret->st_btime_nsec,
+		 ret->st_gen, ret->st_data_version);
 
 	p9_tag_remove(clnt, req);
 	return ret;
@@ -1821,7 +1813,7 @@ static int p9_client_statsize(struct p9_wstat *wst, int proto_version)
 	/* size[2] type[2] dev[4] qid[13] */
 	/* mode[4] atime[4] mtime[4] length[8]*/
 	/* name[s] uid[s] gid[s] muid[s] */
-	ret = 2+4+13+4+4+4+8+2+2+2+2;
+	ret = 2 + 4 + 13 + 4 + 4 + 4 + 8 + 2 + 2 + 2 + 2;
 
 	if (wst->name)
 		ret += strlen(wst->name);
@@ -1832,9 +1824,10 @@ static int p9_client_statsize(struct p9_wstat *wst, int proto_version)
 	if (wst->muid)
 		ret += strlen(wst->muid);
 
-	if ((proto_version == p9_proto_2000u) ||
-		(proto_version == p9_proto_2000L)) {
-		ret += 2+4+4+4;	/* extension[s] n_uid[4] n_gid[4] n_muid[4] */
+	if (proto_version == p9_proto_2000u ||
+	    proto_version == p9_proto_2000L) {
+		/* extension[s] n_uid[4] n_gid[4] n_muid[4] */
+		ret += 2 + 4 + 4 + 4;
 		if (wst->extension)
 			ret += strlen(wst->extension);
 	}
@@ -1851,21 +1844,23 @@ int p9_client_wstat(struct p9_fid *fid, struct p9_wstat *wst)
 	err = 0;
 	clnt = fid->clnt;
 	wst->size = p9_client_statsize(wst, clnt->proto_version);
-	p9_debug(P9_DEBUG_9P, ">>> TWSTAT fid %d\n", fid->fid);
+	p9_debug(P9_DEBUG_9P, ">>> TWSTAT fid %d\n",
+		 fid->fid);
 	p9_debug(P9_DEBUG_9P,
-		"     sz=%x type=%x dev=%x qid=%x.%llx.%x\n"
-		"     mode=%8.8x atime=%8.8x mtime=%8.8x length=%llx\n"
-		"     name=%s uid=%s gid=%s muid=%s extension=(%s)\n"
-		"     uid=%d gid=%d n_muid=%d\n",
-		wst->size, wst->type, wst->dev, wst->qid.type,
-		(unsigned long long)wst->qid.path, wst->qid.version, wst->mode,
-		wst->atime, wst->mtime, (unsigned long long)wst->length,
-		wst->name, wst->uid, wst->gid, wst->muid, wst->extension,
-		from_kuid(&init_user_ns, wst->n_uid),
-		from_kgid(&init_user_ns, wst->n_gid),
-		from_kuid(&init_user_ns, wst->n_muid));
-
-	req = p9_client_rpc(clnt, P9_TWSTAT, "dwS", fid->fid, wst->size+2, wst);
+		 "     sz=%x type=%x dev=%x qid=%x.%llx.%x\n"
+		 "     mode=%8.8x atime=%8.8x mtime=%8.8x length=%llx\n"
+		 "     name=%s uid=%s gid=%s muid=%s extension=(%s)\n"
+		 "     uid=%d gid=%d n_muid=%d\n",
+		 wst->size, wst->type, wst->dev, wst->qid.type,
+		 wst->qid.path, wst->qid.version,
+		 wst->mode, wst->atime, wst->mtime, wst->length,
+		 wst->name, wst->uid, wst->gid, wst->muid, wst->extension,
+		 from_kuid(&init_user_ns, wst->n_uid),
+		 from_kgid(&init_user_ns, wst->n_gid),
+		 from_kuid(&init_user_ns, wst->n_muid));
+
+	req = p9_client_rpc(clnt, P9_TWSTAT, "dwS",
+			    fid->fid, wst->size + 2, wst);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto error;
@@ -1888,15 +1883,15 @@ int p9_client_setattr(struct p9_fid *fid, struct p9_iattr_dotl *p9attr)
 	err = 0;
 	clnt = fid->clnt;
 	p9_debug(P9_DEBUG_9P, ">>> TSETATTR fid %d\n", fid->fid);
-	p9_debug(P9_DEBUG_9P,
-		"    valid=%x mode=%x uid=%d gid=%d size=%lld\n"
-		"    atime_sec=%lld atime_nsec=%lld\n"
-		"    mtime_sec=%lld mtime_nsec=%lld\n",
-		p9attr->valid, p9attr->mode,
-		from_kuid(&init_user_ns, p9attr->uid),
-		from_kgid(&init_user_ns, p9attr->gid),
-		p9attr->size, p9attr->atime_sec, p9attr->atime_nsec,
-		p9attr->mtime_sec, p9attr->mtime_nsec);
+	p9_debug(P9_DEBUG_9P, "    valid=%x mode=%x uid=%d gid=%d size=%lld\n",
+		 p9attr->valid, p9attr->mode,
+		 from_kuid(&init_user_ns, p9attr->uid),
+		 from_kgid(&init_user_ns, p9attr->gid),
+		 p9attr->size);
+	p9_debug(P9_DEBUG_9P, "    atime_sec=%lld atime_nsec=%lld\n",
+		 p9attr->atime_sec, p9attr->atime_nsec);
+	p9_debug(P9_DEBUG_9P, "    mtime_sec=%lld mtime_nsec=%lld\n",
+		 p9attr->mtime_sec, p9attr->mtime_nsec);
 
 	req = p9_client_rpc(clnt, P9_TSETATTR, "dI", fid->fid, p9attr);
 
@@ -1937,12 +1932,10 @@ int p9_client_statfs(struct p9_fid *fid, struct p9_rstatfs *sb)
 		goto error;
 	}
 
-	p9_debug(P9_DEBUG_9P, "<<< RSTATFS fid %d type 0x%lx bsize %ld "
-		"blocks %llu bfree %llu bavail %llu files %llu ffree %llu "
-		"fsid %llu namelen %ld\n",
-		fid->fid, (long unsigned int)sb->type, (long int)sb->bsize,
-		sb->blocks, sb->bfree, sb->bavail, sb->files,  sb->ffree,
-		sb->fsid, (long int)sb->namelen);
+	p9_debug(P9_DEBUG_9P,
+		 "<<< RSTATFS fid %d type 0x%x bsize %u blocks %llu bfree %llu bavail %llu files %llu ffree %llu fsid %llu namelen %u\n",
+		 fid->fid, sb->type, sb->bsize, sb->blocks, sb->bfree,
+		 sb->bavail, sb->files, sb->ffree, sb->fsid, sb->namelen);
 
 	p9_tag_remove(clnt, req);
 error:
@@ -1961,10 +1954,10 @@ int p9_client_rename(struct p9_fid *fid,
 	clnt = fid->clnt;
 
 	p9_debug(P9_DEBUG_9P, ">>> TRENAME fid %d newdirfid %d name %s\n",
-			fid->fid, newdirfid->fid, name);
+		 fid->fid, newdirfid->fid, name);
 
 	req = p9_client_rpc(clnt, P9_TRENAME, "dds", fid->fid,
-			newdirfid->fid, name);
+			    newdirfid->fid, name);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto error;
@@ -1988,9 +1981,9 @@ int p9_client_renameat(struct p9_fid *olddirfid, const char *old_name,
 	err = 0;
 	clnt = olddirfid->clnt;
 
-	p9_debug(P9_DEBUG_9P, ">>> TRENAMEAT olddirfid %d old name %s"
-		   " newdirfid %d new name %s\n", olddirfid->fid, old_name,
-		   newdirfid->fid, new_name);
+	p9_debug(P9_DEBUG_9P,
+		 ">>> TRENAMEAT olddirfid %d old name %s newdirfid %d new name %s\n",
+		 olddirfid->fid, old_name, newdirfid->fid, new_name);
 
 	req = p9_client_rpc(clnt, P9_TRENAMEAT, "dsds", olddirfid->fid,
 			    old_name, newdirfid->fid, new_name);
@@ -2000,7 +1993,7 @@ int p9_client_renameat(struct p9_fid *olddirfid, const char *old_name,
 	}
 
 	p9_debug(P9_DEBUG_9P, "<<< RRENAMEAT newdirfid %d new name %s\n",
-		   newdirfid->fid, new_name);
+		 newdirfid->fid, new_name);
 
 	p9_tag_remove(clnt, req);
 error:
@@ -2008,11 +2001,10 @@ int p9_client_renameat(struct p9_fid *olddirfid, const char *old_name,
 }
 EXPORT_SYMBOL(p9_client_renameat);
 
-/*
- * An xattrwalk without @attr_name gives the fid for the lisxattr namespace
+/* An xattrwalk without @attr_name gives the fid for the lisxattr namespace
  */
 struct p9_fid *p9_client_xattrwalk(struct p9_fid *file_fid,
-				const char *attr_name, u64 *attr_size)
+				   const char *attr_name, u64 *attr_size)
 {
 	int err;
 	struct p9_req_t *req;
@@ -2027,11 +2019,11 @@ struct p9_fid *p9_client_xattrwalk(struct p9_fid *file_fid,
 		goto error;
 	}
 	p9_debug(P9_DEBUG_9P,
-		">>> TXATTRWALK file_fid %d, attr_fid %d name %s\n",
-		file_fid->fid, attr_fid->fid, attr_name);
+		 ">>> TXATTRWALK file_fid %d, attr_fid %d name %s\n",
+		 file_fid->fid, attr_fid->fid, attr_name);
 
 	req = p9_client_rpc(clnt, P9_TXATTRWALK, "dds",
-			file_fid->fid, attr_fid->fid, attr_name);
+			    file_fid->fid, attr_fid->fid, attr_name);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto error;
@@ -2044,13 +2036,13 @@ struct p9_fid *p9_client_xattrwalk(struct p9_fid *file_fid,
 	}
 	p9_tag_remove(clnt, req);
 	p9_debug(P9_DEBUG_9P, "<<<  RXATTRWALK fid %d size %llu\n",
-		attr_fid->fid, *attr_size);
+		 attr_fid->fid, *attr_size);
 	return attr_fid;
 clunk_fid:
 	p9_client_clunk(attr_fid);
 	attr_fid = NULL;
 error:
-	if (attr_fid && (attr_fid != file_fid))
+	if (attr_fid && attr_fid != file_fid)
 		p9_fid_destroy(attr_fid);
 
 	return ERR_PTR(err);
@@ -2058,19 +2050,19 @@ struct p9_fid *p9_client_xattrwalk(struct p9_fid *file_fid,
 EXPORT_SYMBOL_GPL(p9_client_xattrwalk);
 
 int p9_client_xattrcreate(struct p9_fid *fid, const char *name,
-			u64 attr_size, int flags)
+			  u64 attr_size, int flags)
 {
 	int err;
 	struct p9_req_t *req;
 	struct p9_client *clnt;
 
 	p9_debug(P9_DEBUG_9P,
-		">>> TXATTRCREATE fid %d name  %s size %lld flag %d\n",
-		fid->fid, name, (long long)attr_size, flags);
+		 ">>> TXATTRCREATE fid %d name  %s size %llu flag %d\n",
+		 fid->fid, name, attr_size, flags);
 	err = 0;
 	clnt = fid->clnt;
 	req = p9_client_rpc(clnt, P9_TXATTRCREATE, "dsqd",
-			fid->fid, name, attr_size, flags);
+			    fid->fid, name, attr_size, flags);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto error;
@@ -2094,13 +2086,13 @@ int p9_client_readdir(struct p9_fid *fid, char *data, u32 count, u64 offset)
 	iov_iter_kvec(&to, READ, &kv, 1, count);
 
 	p9_debug(P9_DEBUG_9P, ">>> TREADDIR fid %d offset %llu count %d\n",
-				fid->fid, (unsigned long long) offset, count);
+		 fid->fid, offset, count);
 
 	err = 0;
 	clnt = fid->clnt;
 
 	rsize = fid->iounit;
-	if (!rsize || rsize > clnt->msize-P9_READDIRHDRSZ)
+	if (!rsize || rsize > clnt->msize - P9_READDIRHDRSZ)
 		rsize = clnt->msize - P9_READDIRHDRSZ;
 
 	if (count < rsize)
@@ -2108,8 +2100,7 @@ int p9_client_readdir(struct p9_fid *fid, char *data, u32 count, u64 offset)
 
 	/* Don't bother zerocopy for small IO (< 1024) */
 	if (clnt->trans_mod->zc_request && rsize > 1024) {
-		/*
-		 * response header len is 11
+		/* response header len is 11
 		 * PDU Header(7) + IO Size (4)
 		 */
 		req = p9_client_zc_rpc(clnt, P9_TREADDIR, &to, NULL, rsize, 0,
@@ -2150,7 +2141,7 @@ int p9_client_readdir(struct p9_fid *fid, char *data, u32 count, u64 offset)
 EXPORT_SYMBOL(p9_client_readdir);
 
 int p9_client_mknod_dotl(struct p9_fid *fid, const char *name, int mode,
-			dev_t rdev, kgid_t gid, struct p9_qid *qid)
+			 dev_t rdev, kgid_t gid, struct p9_qid *qid)
 {
 	int err;
 	struct p9_client *clnt;
@@ -2158,10 +2149,11 @@ int p9_client_mknod_dotl(struct p9_fid *fid, const char *name, int mode,
 
 	err = 0;
 	clnt = fid->clnt;
-	p9_debug(P9_DEBUG_9P, ">>> TMKNOD fid %d name %s mode %d major %d "
-		"minor %d\n", fid->fid, name, mode, MAJOR(rdev), MINOR(rdev));
+	p9_debug(P9_DEBUG_9P,
+		 ">>> TMKNOD fid %d name %s mode %d major %d minor %d\n",
+		 fid->fid, name, mode, MAJOR(rdev), MINOR(rdev));
 	req = p9_client_rpc(clnt, P9_TMKNOD, "dsdddg", fid->fid, name, mode,
-		MAJOR(rdev), MINOR(rdev), gid);
+			    MAJOR(rdev), MINOR(rdev), gid);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -2170,18 +2162,17 @@ int p9_client_mknod_dotl(struct p9_fid *fid, const char *name, int mode,
 		trace_9p_protocol_dump(clnt, &req->rc);
 		goto error;
 	}
-	p9_debug(P9_DEBUG_9P, "<<< RMKNOD qid %x.%llx.%x\n", qid->type,
-				(unsigned long long)qid->path, qid->version);
+	p9_debug(P9_DEBUG_9P, "<<< RMKNOD qid %x.%llx.%x\n",
+		 qid->type, qid->path, qid->version);
 
 error:
 	p9_tag_remove(clnt, req);
 	return err;
-
 }
 EXPORT_SYMBOL(p9_client_mknod_dotl);
 
 int p9_client_mkdir_dotl(struct p9_fid *fid, const char *name, int mode,
-				kgid_t gid, struct p9_qid *qid)
+			 kgid_t gid, struct p9_qid *qid)
 {
 	int err;
 	struct p9_client *clnt;
@@ -2191,8 +2182,8 @@ int p9_client_mkdir_dotl(struct p9_fid *fid, const char *name, int mode,
 	clnt = fid->clnt;
 	p9_debug(P9_DEBUG_9P, ">>> TMKDIR fid %d name %s mode %d gid %d\n",
 		 fid->fid, name, mode, from_kgid(&init_user_ns, gid));
-	req = p9_client_rpc(clnt, P9_TMKDIR, "dsdg", fid->fid, name, mode,
-		gid);
+	req = p9_client_rpc(clnt, P9_TMKDIR, "dsdg",
+			    fid->fid, name, mode, gid);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -2202,12 +2193,11 @@ int p9_client_mkdir_dotl(struct p9_fid *fid, const char *name, int mode,
 		goto error;
 	}
 	p9_debug(P9_DEBUG_9P, "<<< RMKDIR qid %x.%llx.%x\n", qid->type,
-				(unsigned long long)qid->path, qid->version);
+		 qid->path, qid->version);
 
 error:
 	p9_tag_remove(clnt, req);
 	return err;
-
 }
 EXPORT_SYMBOL(p9_client_mkdir_dotl);
 
@@ -2219,14 +2209,14 @@ int p9_client_lock_dotl(struct p9_fid *fid, struct p9_flock *flock, u8 *status)
 
 	err = 0;
 	clnt = fid->clnt;
-	p9_debug(P9_DEBUG_9P, ">>> TLOCK fid %d type %i flags %d "
-			"start %lld length %lld proc_id %d client_id %s\n",
-			fid->fid, flock->type, flock->flags, flock->start,
-			flock->length, flock->proc_id, flock->client_id);
+	p9_debug(P9_DEBUG_9P,
+		 ">>> TLOCK fid %d type %i flags %d start %lld length %lld proc_id %d client_id %s\n",
+		 fid->fid, flock->type, flock->flags, flock->start,
+		 flock->length, flock->proc_id, flock->client_id);
 
 	req = p9_client_rpc(clnt, P9_TLOCK, "dbdqqds", fid->fid, flock->type,
-				flock->flags, flock->start, flock->length,
-					flock->proc_id, flock->client_id);
+			    flock->flags, flock->start, flock->length,
+			    flock->proc_id, flock->client_id);
 
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -2240,7 +2230,6 @@ int p9_client_lock_dotl(struct p9_fid *fid, struct p9_flock *flock, u8 *status)
 error:
 	p9_tag_remove(clnt, req);
 	return err;
-
 }
 EXPORT_SYMBOL(p9_client_lock_dotl);
 
@@ -2252,12 +2241,14 @@ int p9_client_getlock_dotl(struct p9_fid *fid, struct p9_getlock *glock)
 
 	err = 0;
 	clnt = fid->clnt;
-	p9_debug(P9_DEBUG_9P, ">>> TGETLOCK fid %d, type %i start %lld "
-		"length %lld proc_id %d client_id %s\n", fid->fid, glock->type,
-		glock->start, glock->length, glock->proc_id, glock->client_id);
+	p9_debug(P9_DEBUG_9P,
+		 ">>> TGETLOCK fid %d, type %i start %lld length %lld proc_id %d client_id %s\n",
+		 fid->fid, glock->type, glock->start, glock->length,
+		 glock->proc_id, glock->client_id);
 
-	req = p9_client_rpc(clnt, P9_TGETLOCK, "dbqqds", fid->fid,  glock->type,
-		glock->start, glock->length, glock->proc_id, glock->client_id);
+	req = p9_client_rpc(clnt, P9_TGETLOCK, "dbqqds", fid->fid,
+			    glock->type, glock->start, glock->length,
+			    glock->proc_id, glock->client_id);
 
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -2269,9 +2260,10 @@ int p9_client_getlock_dotl(struct p9_fid *fid, struct p9_getlock *glock)
 		trace_9p_protocol_dump(clnt, &req->rc);
 		goto error;
 	}
-	p9_debug(P9_DEBUG_9P, "<<< RGETLOCK type %i start %lld length %lld "
-		"proc_id %d client_id %s\n", glock->type, glock->start,
-		glock->length, glock->proc_id, glock->client_id);
+	p9_debug(P9_DEBUG_9P,
+		 "<<< RGETLOCK type %i start %lld length %lld proc_id %d client_id %s\n",
+		 glock->type, glock->start, glock->length,
+		 glock->proc_id, glock->client_id);
 error:
 	p9_tag_remove(clnt, req);
 	return err;
diff --git a/net/9p/error.c b/net/9p/error.c
index 61c18daf3050..ff935746754e 100644
--- a/net/9p/error.c
+++ b/net/9p/error.c
@@ -185,7 +185,7 @@ int p9_error_init(void)
 		INIT_HLIST_HEAD(&hash_errmap[bucket]);
 
 	/* load initial error map into hash table */
-	for (c = errmap; c->name != NULL; c++) {
+	for (c = errmap; c->name; c++) {
 		c->namelen = strlen(c->name);
 		bucket = jhash(c->name, c->namelen, 0) % ERRHASHSZ;
 		INIT_HLIST_NODE(&c->list);
diff --git a/net/9p/mod.c b/net/9p/mod.c
index 5126566850bd..535cf016633c 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -24,13 +24,13 @@
 #include <linux/spinlock.h>
 
 #ifdef CONFIG_NET_9P_DEBUG
-unsigned int p9_debug_level = 0;	/* feature-rific global debug level  */
+unsigned int p9_debug_level;	/* feature-rific global debug level  */
 EXPORT_SYMBOL(p9_debug_level);
 module_param_named(debug, p9_debug_level, uint, 0);
 MODULE_PARM_DESC(debug, "9P debugging level");
 
 void _p9_debug(enum p9_debug_flags level, const char *func,
-		const char *fmt, ...)
+	       const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
@@ -53,10 +53,7 @@ void _p9_debug(enum p9_debug_flags level, const char *func,
 EXPORT_SYMBOL(_p9_debug);
 #endif
 
-/*
- * Dynamic Transport Registration Routines
- *
- */
+/* Dynamic Transport Registration Routines */
 
 static DEFINE_SPINLOCK(v9fs_trans_lock);
 static LIST_HEAD(v9fs_trans_list);
diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 03593eb240d8..59eb71f357fa 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -46,6 +46,7 @@ EXPORT_SYMBOL(p9stat_free);
 size_t pdu_read(struct p9_fcall *pdu, void *data, size_t size)
 {
 	size_t len = min(pdu->size - pdu->offset, size);
+
 	memcpy(data, &pdu->sdata[pdu->offset], len);
 	pdu->offset += len;
 	return size - len;
@@ -54,6 +55,7 @@ size_t pdu_read(struct p9_fcall *pdu, void *data, size_t size)
 static size_t pdu_write(struct p9_fcall *pdu, const void *data, size_t size)
 {
 	size_t len = min(pdu->capacity - pdu->size, size);
+
 	memcpy(&pdu->sdata[pdu->size], data, len);
 	pdu->size += len;
 	return size - len;
@@ -64,6 +66,7 @@ pdu_write_u(struct p9_fcall *pdu, struct iov_iter *from, size_t size)
 {
 	size_t len = min(pdu->capacity - pdu->size, size);
 	struct iov_iter i = *from;
+
 	if (!copy_from_iter_full(&pdu->sdata[pdu->size], len, &i))
 		len = 0;
 
@@ -71,26 +74,25 @@ pdu_write_u(struct p9_fcall *pdu, struct iov_iter *from, size_t size)
 	return size - len;
 }
 
-/*
-	b - int8_t
-	w - int16_t
-	d - int32_t
-	q - int64_t
-	s - string
-	u - numeric uid
-	g - numeric gid
-	S - stat
-	Q - qid
-	D - data blob (int32_t size followed by void *, results are not freed)
-	T - array of strings (int16_t count, followed by strings)
-	R - array of qids (int16_t count, followed by qids)
-	A - stat for 9p2000.L (p9_stat_dotl)
-	? - if optional = 1, continue parsing
-*/
+/*	b - int8_t
+ *	w - int16_t
+ *	d - int32_t
+ *	q - int64_t
+ *	s - string
+ *	u - numeric uid
+ *	g - numeric gid
+ *	S - stat
+ *	Q - qid
+ *	D - data blob (int32_t size followed by void *, results are not freed)
+ *	T - array of strings (int16_t count, followed by strings)
+ *	R - array of qids (int16_t count, followed by qids)
+ *	A - stat for 9p2000.L (p9_stat_dotl)
+ *	? - if optional = 1, continue parsing
+ */
 
 static int
 p9pdu_vreadf(struct p9_fcall *pdu, int proto_version, const char *fmt,
-	va_list ap)
+	     va_list ap)
 {
 	const char *ptr;
 	int errcode = 0;
diff --git a/net/9p/protocol.h b/net/9p/protocol.h
index 6835f91cfda5..4a2f68651037 100644
--- a/net/9p/protocol.h
+++ b/net/9p/protocol.h
@@ -11,7 +11,7 @@
  */
 
 int p9pdu_vwritef(struct p9_fcall *pdu, int proto_version, const char *fmt,
-								va_list ap);
+		  va_list ap);
 int p9pdu_readf(struct p9_fcall *pdu, int proto_version, const char *fmt, ...);
 int p9pdu_prepare(struct p9_fcall *pdu, int16_t tag, int8_t type);
 int p9pdu_finalize(struct p9_client *clnt, struct p9_fcall *pdu);
diff --git a/net/9p/trans_common.h b/net/9p/trans_common.h
index c43babb3f635..65c094c321a2 100644
--- a/net/9p/trans_common.h
+++ b/net/9p/trans_common.h
@@ -12,4 +12,4 @@
  *
  */
 
-void p9_release_pages(struct page **, int);
+void p9_release_pages(struct page **pages, int nr_pages);
-- 
2.35.1



