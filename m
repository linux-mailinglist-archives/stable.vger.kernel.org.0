Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B796ABD6A
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 11:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjCFKzJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 05:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjCFKzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 05:55:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AED10401
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 02:55:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B651A60D30
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 10:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5643C433D2;
        Mon,  6 Mar 2023 10:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678100104;
        bh=wApSvP4KfnNYK2ednnLzHRRzGzYSha1RjMYq8WxtysU=;
        h=Subject:To:Cc:From:Date:From;
        b=LKwxYt6+cfHs1S/M+MlWYbrUx5gI8Q8/IHsw4C3UvULRFl8TGl807u1rgLmtWaV1C
         j2TZ7CS4CQ35ConAJXq2UjlVxehrfFZbA/f2jFCpsUDsdGVE1w/uaFOs+3m/7jArUc
         RDth8VSuVqIG3ckmSVo6v7wj7AWrqNek4iEaQjHk=
Subject: FAILED: patch "[PATCH] cifs: Fix uninitialized memory reads for oparms.mode" failed to apply to 5.10-stable tree
To:     vl@samba.org, stfrench@microsoft.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 11:55:01 +0100
Message-ID: <167810010149177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x de036dcaca65cf94bf7ff09c571c077f02bc92b4
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167810010149177@kroah.com' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

de036dcaca65 ("cifs: Fix uninitialized memory reads for oparms.mode")
a152d05ae4a7 ("cifs: Fix uninitialized memory read for smb311 posix symlink create")
ba5d4c1596ca ("cifs: fix file info setting in cifs_open_file()")
29cf28235e3e ("cifs: fix file info setting in cifs_query_path_info()")
76894f3e2f71 ("cifs: improve symlink handling for smb2+")
a63ec83c462b ("cifs: Add constructor/destructors for tcon->cfid")
dcb45fd7f501 ("cifs: Do not use tcon->cfid directly, use the cfid we get from open_cached_dir")
05b98fd2da6b ("cifs: Move cached-dir functions into a separate file")
fb157ed226d2 ("cifs: when insecure legacy is disabled shrink amount of SMB1 code")
d7d7a66aacd6 ("cifs: avoid use of global locks for high contention data")
9543c8ab3016 ("cifs: list_for_each() -> list_for_each_entry()")
4da2cd0517e0 ("cifs: remove redundant initialization to variable mnt_sign_enabled")
af3a6d1018f0 ("cifs: update cifs_ses::ip_addr after failover")
b54034a73baf ("cifs: during reconnect, update interface if necessary")
387ba9bf4cb8 ("cifs: do not build smb1ops if legacy support is disabled")
cc391b694ff0 ("cifs: fix potential deadlock in direct reclaim")
44a48081fc03 ("smb3: remove unneeded null check in cifs_readdir")
d87c48ce4d89 ("cifs: cache the dirents for entries in a cached directory")
5752bf645f9d ("cifs: avoid parallel session setups on same channel")
dd3cd8709ed5 ("cifs: use new enum for ses_status")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From de036dcaca65cf94bf7ff09c571c077f02bc92b4 Mon Sep 17 00:00:00 2001
From: Volker Lendecke <vl@samba.org>
Date: Wed, 11 Jan 2023 12:37:58 +0100
Subject: [PATCH] cifs: Fix uninitialized memory reads for oparms.mode

Use a struct assignment with implicit member initialization

Signed-off-by: Volker Lendecke <vl@samba.org>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index 60399081046a..b36ae64034a3 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -181,12 +181,13 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
-	oparms.tcon = tcon;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE);
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.fid = pfid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE),
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.fid = pfid,
+	};
 
 	rc = SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index bbf58c2439da..3cc3471199f5 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -1428,14 +1428,15 @@ static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info *cifs_sb,
 	tcon = tlink_tcon(tlink);
 	xid = get_xid();
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = READ_CONTROL;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = READ_CONTROL,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.disposition = FILE_OPEN,
+		.path = path,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (!rc) {
@@ -1494,14 +1495,15 @@ int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 	else
 		access_flags = WRITE_DAC;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = access_flags;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = access_flags,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.disposition = FILE_OPEN,
+		.path = path,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc) {
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 23f10e0d6e7e..8c014a3ff9e0 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5372,14 +5372,15 @@ CIFSSMBSetPathInfoFB(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_fid fid;
 	int rc;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_WRITE;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = fileName;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_WRITE,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.disposition = FILE_OPEN,
+		.path = fileName,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc)
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index ad4208bf1e32..1bf61778f44c 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -304,15 +304,16 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	if (!tcon->unix_ext && (mode & S_IWUGO) == 0)
 		create_options |= CREATE_OPTION_READONLY;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = desired_access;
-	oparms.create_options = cifs_create_options(cifs_sb, create_options);
-	oparms.disposition = disposition;
-	oparms.path = full_path;
-	oparms.fid = fid;
-	oparms.reconnect = false;
-	oparms.mode = mode;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = desired_access,
+		.create_options = cifs_create_options(cifs_sb, create_options),
+		.disposition = disposition,
+		.path = full_path,
+		.fid = fid,
+		.mode = mode,
+	};
 	rc = server->ops->open(xid, &oparms, oplock, buf);
 	if (rc) {
 		cifs_dbg(FYI, "cifs_create returned 0x%x\n", rc);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 7eb476a23701..e216bc9b7abf 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -260,14 +260,15 @@ static int cifs_nt_open(const char *full_path, struct inode *inode, struct cifs_
 	if (f_flags & O_DIRECT)
 		create_options |= CREATE_NO_BUFFER;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = desired_access;
-	oparms.create_options = cifs_create_options(cifs_sb, create_options);
-	oparms.disposition = disposition;
-	oparms.path = full_path;
-	oparms.fid = fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = desired_access,
+		.create_options = cifs_create_options(cifs_sb, create_options),
+		.disposition = disposition,
+		.path = full_path,
+		.fid = fid,
+	};
 
 	rc = server->ops->open(xid, &oparms, oplock, buf);
 	if (rc)
@@ -848,14 +849,16 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 	if (server->ops->get_lease_key)
 		server->ops->get_lease_key(inode, &cfile->fid);
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = desired_access;
-	oparms.create_options = cifs_create_options(cifs_sb, create_options);
-	oparms.disposition = disposition;
-	oparms.path = full_path;
-	oparms.fid = &cfile->fid;
-	oparms.reconnect = true;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = desired_access,
+		.create_options = cifs_create_options(cifs_sb, create_options),
+		.disposition = disposition,
+		.path = full_path,
+		.fid = &cfile->fid,
+		.reconnect = true,
+	};
 
 	/*
 	 * Can not refresh inode by passing in file_info buf to be returned by
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index f145a59af89b..7d0cc39d2921 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -508,14 +508,15 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
 		return PTR_ERR(tlink);
 	tcon = tlink_tcon(tlink);
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_READ;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_READ,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_OPEN,
+		.path = path,
+		.fid = &fid,
+	};
 
 	if (tcon->ses->server->oplocks)
 		oplock = REQ_OPLOCK;
@@ -1518,14 +1519,15 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 		goto out;
 	}
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = DELETE | FILE_WRITE_ATTRIBUTES;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = full_path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = DELETE | FILE_WRITE_ATTRIBUTES,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_OPEN,
+		.path = full_path,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc != 0)
@@ -2112,15 +2114,16 @@ cifs_do_rename(const unsigned int xid, struct dentry *from_dentry,
 	if (to_dentry->d_parent != from_dentry->d_parent)
 		goto do_rename_exit;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	/* open the file to be renamed -- we need DELETE perms */
-	oparms.desired_access = DELETE;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = from_path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		/* open the file to be renamed -- we need DELETE perms */
+		.desired_access = DELETE,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_OPEN,
+		.path = from_path,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc == 0) {
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index a5a097a69983..d937eedd74fb 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -271,14 +271,15 @@ cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	int buf_type = CIFS_NO_BUFFER;
 	FILE_ALL_INFO file_info;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_READ;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_READ,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_OPEN,
+		.path = path,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, &file_info);
 	if (rc)
@@ -313,14 +314,15 @@ cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_io_parms io_parms = {0};
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_WRITE;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_CREATE;
-	oparms.path = path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_WRITE,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_CREATE,
+		.path = path,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc)
@@ -355,13 +357,14 @@ smb3_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
 	struct smb2_file_all_info *pfile_info = NULL;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_READ;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_OPEN;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_READ,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_OPEN,
+		.fid = &fid,
+	};
 
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (utf16_path == NULL)
@@ -421,14 +424,15 @@ smb3_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 	if (!utf16_path)
 		return -ENOMEM;
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_WRITE;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_CREATE;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
-	oparms.mode = 0644;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_WRITE,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_CREATE,
+		.fid = &fid,
+		.mode = 0644,
+	};
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       NULL, NULL);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 4cb364454e13..abda6148be10 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -576,14 +576,15 @@ static int cifs_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 		if (!(le32_to_cpu(fi.Attributes) & ATTR_REPARSE))
 			return 0;
 
-		oparms.tcon = tcon;
-		oparms.cifs_sb = cifs_sb;
-		oparms.desired_access = FILE_READ_ATTRIBUTES;
-		oparms.create_options = cifs_create_options(cifs_sb, 0);
-		oparms.disposition = FILE_OPEN;
-		oparms.path = full_path;
-		oparms.fid = &fid;
-		oparms.reconnect = false;
+		oparms = (struct cifs_open_parms) {
+			.tcon = tcon,
+			.cifs_sb = cifs_sb,
+			.desired_access = FILE_READ_ATTRIBUTES,
+			.create_options = cifs_create_options(cifs_sb, 0),
+			.disposition = FILE_OPEN,
+			.path = full_path,
+			.fid = &fid,
+		};
 
 		/* Need to check if this is a symbolic link or not */
 		tmprc = CIFS_open(xid, &oparms, &oplock, NULL);
@@ -823,14 +824,15 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 		goto out;
 	}
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = SYNCHRONIZE | FILE_WRITE_ATTRIBUTES;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = full_path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = SYNCHRONIZE | FILE_WRITE_ATTRIBUTES,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.disposition = FILE_OPEN,
+		.path = full_path,
+		.fid = &fid,
+	};
 
 	cifs_dbg(FYI, "calling SetFileInfo since SetPathInfo for times not supported by this server\n");
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
@@ -998,15 +1000,16 @@ cifs_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 		goto out;
 	}
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.create_options = cifs_create_options(cifs_sb,
-						    OPEN_REPARSE_POINT);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = full_path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.create_options = cifs_create_options(cifs_sb,
+						      OPEN_REPARSE_POINT),
+		.disposition = FILE_OPEN,
+		.path = full_path,
+		.fid = &fid,
+	};
 
 	rc = CIFS_open(xid, &oparms, &oplock, NULL);
 	if (rc)
@@ -1115,15 +1118,16 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 
 	cifs_dbg(FYI, "sfu compat create special file\n");
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_WRITE;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR |
-						    CREATE_OPTION_SPECIAL);
-	oparms.disposition = FILE_CREATE;
-	oparms.path = full_path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_WRITE,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR |
+						      CREATE_OPTION_SPECIAL),
+		.disposition = FILE_CREATE,
+		.path = full_path,
+		.fid = &fid,
+	};
 
 	if (tcon->ses->server->oplocks)
 		oplock = REQ_OPLOCK;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 8521adf9ce79..37b4cd59245d 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -105,14 +105,15 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		goto finished;
 	}
 
-	vars->oparms.tcon = tcon;
-	vars->oparms.desired_access = desired_access;
-	vars->oparms.disposition = create_disposition;
-	vars->oparms.create_options = cifs_create_options(cifs_sb, create_options);
-	vars->oparms.fid = &fid;
-	vars->oparms.reconnect = false;
-	vars->oparms.mode = mode;
-	vars->oparms.cifs_sb = cifs_sb;
+	vars->oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = desired_access,
+		.disposition = create_disposition,
+		.create_options = cifs_create_options(cifs_sb, create_options),
+		.fid = &fid,
+		.mode = mode,
+		.cifs_sb = cifs_sb,
+	};
 
 	rqst[num_rqst].rq_iov = &vars->open_iov[0];
 	rqst[num_rqst].rq_nvec = SMB2_CREATE_IOV_SIZE;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index f22d36019ff4..43beec54710f 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -772,12 +772,13 @@ smb2_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_open_parms oparms;
 	struct cifs_fid fid;
 
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
 		       NULL, NULL);
@@ -817,12 +818,13 @@ smb2_is_path_accessible(const unsigned int xid, struct cifs_tcon *tcon,
 	if (!utf16_path)
 		return -ENOMEM;
 
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       &err_iov, &err_buftype);
@@ -1098,13 +1100,13 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
-	memset(&oparms, 0, sizeof(oparms));
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_WRITE_EA;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_WRITE_EA,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
@@ -1454,12 +1456,12 @@ smb2_ioctl_query_info(const unsigned int xid,
 	rqst[0].rq_iov = &vars->open_iov[0];
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
-	memset(&oparms, 0, sizeof(oparms));
-	oparms.tcon = tcon;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, create_options);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, create_options),
+		.fid = &fid,
+	};
 
 	if (qi.flags & PASSTHRU_FSCTL) {
 		switch (qi.info_type & FSCTL_DEVICE_ACCESS_MASK) {
@@ -2089,12 +2091,13 @@ smb3_notify(const unsigned int xid, struct file *pfile,
 	}
 
 	tcon = cifs_sb_master_tcon(cifs_sb);
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL, NULL,
 		       NULL);
@@ -2160,12 +2163,13 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES | FILE_READ_DATA,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = fid,
+	};
 
 	rc = SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
@@ -2491,12 +2495,13 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
-	oparms.tcon = tcon;
-	oparms.desired_access = desired_access;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = desired_access,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
@@ -2624,12 +2629,13 @@ smb311_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
 	if (!tcon->posix_extensions)
 		return smb2_queryfs(xid, tcon, cifs_sb, buf);
 
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
 		       NULL, NULL);
@@ -2917,13 +2923,13 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
-	memset(&oparms, 0, sizeof(oparms));
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, create_options);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, create_options),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
@@ -3057,13 +3063,13 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
 
-	memset(&oparms, 0, sizeof(oparms));
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, OPEN_REPARSE_POINT);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, OPEN_REPARSE_POINT),
+		.fid = &fid,
+	};
 
 	rc = SMB2_open_init(tcon, server,
 			    &rqst[0], &oplock, &oparms, utf16_path);
@@ -3197,17 +3203,20 @@ get_smb2_acl_by_path(struct cifs_sb_info *cifs_sb,
 		return ERR_PTR(rc);
 	}
 
-	oparms.tcon = tcon;
-	oparms.desired_access = READ_CONTROL;
-	oparms.disposition = FILE_OPEN;
-	/*
-	 * When querying an ACL, even if the file is a symlink we want to open
-	 * the source not the target, and so the protocol requires that the
-	 * client specify this flag when opening a reparse point
-	 */
-	oparms.create_options = cifs_create_options(cifs_sb, 0) | OPEN_REPARSE_POINT;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = READ_CONTROL,
+		.disposition = FILE_OPEN,
+		/*
+		 * When querying an ACL, even if the file is a symlink
+		 * we want to open the source not the target, and so
+		 * the protocol requires that the client specify this
+		 * flag when opening a reparse point
+		 */
+		.create_options = cifs_create_options(cifs_sb, 0) |
+				  OPEN_REPARSE_POINT,
+		.fid = &fid,
+	};
 
 	if (info & SACL_SECINFO)
 		oparms.desired_access |= SYSTEM_SECURITY;
@@ -3266,13 +3275,14 @@ set_smb2_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
 		return rc;
 	}
 
-	oparms.tcon = tcon;
-	oparms.desired_access = access_flags;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.disposition = FILE_OPEN;
-	oparms.path = path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = access_flags,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.disposition = FILE_OPEN,
+		.path = path,
+		.fid = &fid,
+	};
 
 	rc = SMB2_open(xid, &oparms, utf16_path, &oplock, NULL, NULL,
 		       NULL, NULL);
@@ -5139,15 +5149,16 @@ smb2_make_node(unsigned int xid, struct inode *inode,
 
 	cifs_dbg(FYI, "sfu compat create special file\n");
 
-	oparms.tcon = tcon;
-	oparms.cifs_sb = cifs_sb;
-	oparms.desired_access = GENERIC_WRITE;
-	oparms.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR |
-						    CREATE_OPTION_SPECIAL);
-	oparms.disposition = FILE_CREATE;
-	oparms.path = full_path;
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.cifs_sb = cifs_sb,
+		.desired_access = GENERIC_WRITE,
+		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR |
+						      CREATE_OPTION_SPECIAL),
+		.disposition = FILE_CREATE,
+		.path = full_path,
+		.fid = &fid,
+	};
 
 	if (tcon->ses->server->oplocks)
 		oplock = REQ_OPLOCK;

