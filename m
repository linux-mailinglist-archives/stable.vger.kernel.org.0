Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84AFA2E96AF
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 15:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbhADOEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 09:04:06 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:38539 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725840AbhADOEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 09:04:05 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailforward.west.internal (Postfix) with ESMTP id 74CA8FF3;
        Mon,  4 Jan 2021 09:03:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Mon, 04 Jan 2021 09:03:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=/YB9ek
        sdhDPkugQsMIjnRV3YfcZDeVJ2eXJ0IisRwT0=; b=INQALyODMqzY9DNdWOA0hf
        y2l13ByS2ccbcKV83ZXraLmicZS5TiAn47gPV6RtPyyBOKQ/u6lji84mc1GCDG7O
        bCHZcyNY6y/Xja0xIz2Jy4PX0VwdDwmU3nBxDWTdB03z8+1Wmvuh+evVyEm3e9Rs
        fcPNCjxi8yv1rjxtM8Dmnx1nlbDQmqc1sk1VNQGgerE0RSE2ikCAJxGhAKaa+qcM
        sfd9qGF1eJi4f1nH6JGHZyfSmHk6s1SdsKczyUA6h7FwGoBoyIlPlgiBW4XGcROa
        fxcxLViEHlEgfh4+KyHbOulDvEDvianxEWJEz7i3aNFyx10GRR7KB45zdYW6whPA
        ==
X-ME-Sender: <xms:JiDzXwBHTRhZsCUzjPbFWJNz0jKp4rSJcNBXS9lp6cXmnIOYf0pCSg>
    <xme:JiDzXye8JqO6E-AWuDFdPr4hvkXrZXJ4iPWnSpZ-iUlzechDCtU8WjQNVdFos0y8-
    9mdKx-ImJqfKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdeffedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:JiDzXwccoitg-dnISkf7Xzf9MqSqnE9IqltKEDFTzaujEYfZNETWmg>
    <xmx:JiDzX-glU-OJNTA-jkIgTP4akpYSosZoiH43rawHEyk3IMDXQ790AQ>
    <xmx:JiDzX0SdVK-zOgyOewgTmuybGEzJ9kP9CzzL1hzybLpIg79vUuzJSw>
    <xmx:JyDzX5Q2tS50S-6k3a3-WL-y1o0-0WxDdArQNtxCwl23qlZ_dyc9kidvBzE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D74AB240057;
        Mon,  4 Jan 2021 09:03:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] fuse: fix bad inode" failed to apply to 5.10-stable tree
To:     mszeredi@redhat.com, jack@suse.cz, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jan 2021 15:04:44 +0100
Message-ID: <160976908417168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5d069dbe8aaf2a197142558b6fb2978189ba3454 Mon Sep 17 00:00:00 2001
From: Miklos Szeredi <mszeredi@redhat.com>
Date: Thu, 10 Dec 2020 15:33:14 +0100
Subject: [PATCH] fuse: fix bad inode

Jan Kara's analysis of the syzbot report (edited):

  The reproducer opens a directory on FUSE filesystem, it then attaches
  dnotify mark to the open directory.  After that a fuse_do_getattr() call
  finds that attributes returned by the server are inconsistent, and calls
  make_bad_inode() which, among other things does:

          inode->i_mode = S_IFREG;

  This then confuses dnotify which doesn't tear down its structures
  properly and eventually crashes.

Avoid calling make_bad_inode() on a live inode: switch to a private flag on
the fuse inode.  Also add the test to ops which the bad_inode_ops would
have caught.

This bug goes back to the initial merge of fuse in 2.6.14...

Reported-by: syzbot+f427adf9324b92652ccc@syzkaller.appspotmail.com
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Tested-by: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>

diff --git a/fs/fuse/acl.c b/fs/fuse/acl.c
index 5a48cee6d7d3..f529075a2ce8 100644
--- a/fs/fuse/acl.c
+++ b/fs/fuse/acl.c
@@ -19,6 +19,9 @@ struct posix_acl *fuse_get_acl(struct inode *inode, int type)
 	void *value = NULL;
 	struct posix_acl *acl;
 
+	if (fuse_is_bad(inode))
+		return ERR_PTR(-EIO);
+
 	if (!fc->posix_acl || fc->no_getxattr)
 		return NULL;
 
@@ -53,6 +56,9 @@ int fuse_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	const char *name;
 	int ret;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fc->posix_acl || fc->no_setxattr)
 		return -EOPNOTSUPP;
 
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 5d43af1169b7..78f9f209078c 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -202,7 +202,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 	int ret;
 
 	inode = d_inode_rcu(entry);
-	if (inode && is_bad_inode(inode))
+	if (inode && fuse_is_bad(inode))
 		goto invalid;
 	else if (time_before64(fuse_dentry_time(entry), get_jiffies_64()) ||
 		 (flags & (LOOKUP_EXCL | LOOKUP_REVAL))) {
@@ -462,6 +462,9 @@ static struct dentry *fuse_lookup(struct inode *dir, struct dentry *entry,
 	bool outarg_valid = true;
 	bool locked;
 
+	if (fuse_is_bad(dir))
+		return ERR_PTR(-EIO);
+
 	locked = fuse_lock_inode(dir);
 	err = fuse_lookup_name(dir->i_sb, get_node_id(dir), &entry->d_name,
 			       &outarg, &inode);
@@ -611,6 +614,9 @@ static int fuse_atomic_open(struct inode *dir, struct dentry *entry,
 	struct fuse_conn *fc = get_fuse_conn(dir);
 	struct dentry *res = NULL;
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	if (d_in_lookup(entry)) {
 		res = fuse_lookup(dir, entry, 0);
 		if (IS_ERR(res))
@@ -659,6 +665,9 @@ static int create_new_entry(struct fuse_mount *fm, struct fuse_args *args,
 	int err;
 	struct fuse_forget_link *forget;
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	forget = fuse_alloc_forget();
 	if (!forget)
 		return -ENOMEM;
@@ -786,6 +795,9 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 	struct fuse_mount *fm = get_fuse_mount(dir);
 	FUSE_ARGS(args);
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	args.opcode = FUSE_UNLINK;
 	args.nodeid = get_node_id(dir);
 	args.in_numargs = 1;
@@ -822,6 +834,9 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 	struct fuse_mount *fm = get_fuse_mount(dir);
 	FUSE_ARGS(args);
 
+	if (fuse_is_bad(dir))
+		return -EIO;
+
 	args.opcode = FUSE_RMDIR;
 	args.nodeid = get_node_id(dir);
 	args.in_numargs = 1;
@@ -900,6 +915,9 @@ static int fuse_rename2(struct inode *olddir, struct dentry *oldent,
 	struct fuse_conn *fc = get_fuse_conn(olddir);
 	int err;
 
+	if (fuse_is_bad(olddir))
+		return -EIO;
+
 	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
 		return -EINVAL;
 
@@ -1035,7 +1053,7 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
 	if (!err) {
 		if (fuse_invalid_attr(&outarg.attr) ||
 		    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-			make_bad_inode(inode);
+			fuse_make_bad(inode);
 			err = -EIO;
 		} else {
 			fuse_change_attributes(inode, &outarg.attr,
@@ -1237,6 +1255,9 @@ static int fuse_permission(struct inode *inode, int mask)
 	bool refreshed = false;
 	int err = 0;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
@@ -1332,7 +1353,7 @@ static const char *fuse_get_link(struct dentry *dentry, struct inode *inode,
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out_err;
 
 	if (fc->cache_symlinks)
@@ -1380,7 +1401,7 @@ static int fuse_dir_fsync(struct file *file, loff_t start, loff_t end,
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	if (fc->no_fsyncdir)
@@ -1679,7 +1700,7 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 
 	if (fuse_invalid_attr(&outarg.attr) ||
 	    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
-		make_bad_inode(inode);
+		fuse_make_bad(inode);
 		err = -EIO;
 		goto error;
 	}
@@ -1742,6 +1763,9 @@ static int fuse_setattr(struct dentry *entry, struct iattr *attr)
 	struct file *file = (attr->ia_valid & ATTR_FILE) ? attr->ia_file : NULL;
 	int ret;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(get_fuse_conn(inode)))
 		return -EACCES;
 
@@ -1800,6 +1824,9 @@ static int fuse_getattr(const struct path *path, struct kstat *stat,
 	struct inode *inode = d_inode(path->dentry);
 	struct fuse_conn *fc = get_fuse_conn(inode);
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fc)) {
 		if (!request_mask) {
 			/*
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 349885353036..8cccecb55fb8 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -232,6 +232,9 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 	bool dax_truncate = (file->f_flags & O_TRUNC) &&
 			  fc->atomic_o_trunc && FUSE_IS_DAX(inode);
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	err = generic_file_open(inode, file);
 	if (err)
 		return err;
@@ -469,7 +472,7 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	FUSE_ARGS(args);
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	err = write_inode_now(inode, 1);
@@ -541,7 +544,7 @@ static int fuse_fsync(struct file *file, loff_t start, loff_t end,
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	inode_lock(inode);
@@ -865,7 +868,7 @@ static int fuse_readpage(struct file *file, struct page *page)
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	err = fuse_do_readpage(file, page);
@@ -958,7 +961,7 @@ static void fuse_readahead(struct readahead_control *rac)
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	unsigned int i, max_pages, nr_pages = 0;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return;
 
 	max_pages = min_t(unsigned int, fc->max_pages,
@@ -1570,7 +1573,7 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct fuse_file *ff = file->private_data;
 	struct inode *inode = file_inode(file);
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	if (FUSE_IS_DAX(inode))
@@ -1588,7 +1591,7 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	struct fuse_file *ff = file->private_data;
 	struct inode *inode = file_inode(file);
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	if (FUSE_IS_DAX(inode))
@@ -2187,7 +2190,7 @@ static int fuse_writepages(struct address_space *mapping,
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		goto out;
 
 	data.inode = inode;
@@ -2972,7 +2975,7 @@ long fuse_ioctl_common(struct file *file, unsigned int cmd,
 	if (!fuse_allow_current_process(fc))
 		return -EACCES;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	return fuse_do_ioctl(file, cmd, arg, flags);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index d414c787e362..7c4b8cb93f9f 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -172,6 +172,8 @@ enum {
 	FUSE_I_INIT_RDPLUS,
 	/** An operation changing file size is in progress  */
 	FUSE_I_SIZE_UNSTABLE,
+	/* Bad inode */
+	FUSE_I_BAD,
 };
 
 struct fuse_conn;
@@ -859,6 +861,16 @@ static inline u64 fuse_get_attr_version(struct fuse_conn *fc)
 	return atomic64_read(&fc->attr_version);
 }
 
+static inline void fuse_make_bad(struct inode *inode)
+{
+	set_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state);
+}
+
+static inline bool fuse_is_bad(struct inode *inode)
+{
+	return unlikely(test_bit(FUSE_I_BAD, &get_fuse_inode(inode)->state));
+}
+
 /** Device operations */
 extern const struct file_operations fuse_dev_operations;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 36ab05315828..b0e18b470e91 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -132,7 +132,7 @@ static void fuse_evict_inode(struct inode *inode)
 			fi->forget = NULL;
 		}
 	}
-	if (S_ISREG(inode->i_mode) && !is_bad_inode(inode)) {
+	if (S_ISREG(inode->i_mode) && !fuse_is_bad(inode)) {
 		WARN_ON(!list_empty(&fi->write_files));
 		WARN_ON(!list_empty(&fi->queued_writes));
 	}
@@ -352,7 +352,7 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 		unlock_new_inode(inode);
 	} else if ((inode->i_mode ^ attr->mode) & S_IFMT) {
 		/* Inode has changed type, any I/O on the old should fail */
-		make_bad_inode(inode);
+		fuse_make_bad(inode);
 		iput(inode);
 		goto retry;
 	}
diff --git a/fs/fuse/readdir.c b/fs/fuse/readdir.c
index 3b5e91045871..3441ffa740f3 100644
--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -207,7 +207,7 @@ static int fuse_direntplus_link(struct file *file,
 			dput(dentry);
 			goto retry;
 		}
-		if (is_bad_inode(inode)) {
+		if (fuse_is_bad(inode)) {
 			dput(dentry);
 			return -EIO;
 		}
@@ -568,7 +568,7 @@ int fuse_readdir(struct file *file, struct dir_context *ctx)
 	struct inode *inode = file_inode(file);
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_is_bad(inode))
 		return -EIO;
 
 	mutex_lock(&ff->readdir.lock);
diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
index 371bdcbc7233..cdea18de94f7 100644
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -113,6 +113,9 @@ ssize_t fuse_listxattr(struct dentry *entry, char *list, size_t size)
 	struct fuse_getxattr_out outarg;
 	ssize_t ret;
 
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!fuse_allow_current_process(fm->fc))
 		return -EACCES;
 
@@ -178,6 +181,9 @@ static int fuse_xattr_get(const struct xattr_handler *handler,
 			 struct dentry *dentry, struct inode *inode,
 			 const char *name, void *value, size_t size)
 {
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	return fuse_getxattr(inode, name, value, size);
 }
 
@@ -186,6 +192,9 @@ static int fuse_xattr_set(const struct xattr_handler *handler,
 			  const char *name, const void *value, size_t size,
 			  int flags)
 {
+	if (fuse_is_bad(inode))
+		return -EIO;
+
 	if (!value)
 		return fuse_removexattr(inode, name);
 

