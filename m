Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D931F9B48
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730912AbgFOPBs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:01:48 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:45871 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730701AbgFOPBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:01:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 8AB6F63D;
        Mon, 15 Jun 2020 11:01:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=jZxMRa
        zFVx2BpT4llIvB0SxDre0g16KHxV8to7nie0M=; b=crpk/75c8VyJxNwvnh3jvz
        1z/E+DN06+hxN5xYL9TSi9RRvVC1DVSoPEa7SgQd+yTyaAGy4jQe8gobRGFkAuKv
        AxUw5KTimKX+0Fj4Qs5ZeM1HXNf/K9hbKzHlLBQR02XNLxgKyGWDCsSCi4ke2GK4
        Og8JWCMm3duX87R0PRQbEhaQkIH2EYx9qjYQ5si4hdPWk/Ip5u/st0wDPvuMeP3G
        dvvhGpQvqNom2lirX+QY34ykM53Q7i/+RW+NEZvoG2JJ84/7L/DK+2fQMKqAmGlv
        FhQTwYZxM8HmpiQ+bMWHr8mRgD5YRtmuBo7OuoUgdivyXgopODukqTnYFLfdePrQ
        ==
X-ME-Sender: <xms:WY3nXtQbM6LwV3_6dFlGpNCwDXLBA8Ec0dEL8-rhm9KlFQ5IPWWUiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:WY3nXmxtKcILQzAKTgQJTOO6bg2HitG2DBYP_Tokj-RHkXcrnZ6pUg>
    <xmx:WY3nXi334mK_YHEE0PjYGkiBn-4DYc4pBZDRkSrFTa1ugs-sBLxajw>
    <xmx:WY3nXlAYFS2IfQUS9l--LLpOK-IYWKn1g4x4SQ9wH5jt8i0CWSyVHQ>
    <xmx:Wo3nXsdhrRY7k6D6Wt1p3UoO6cx43p3zWIvfG-gSUEcWqfTLA3FoDnrBuIY>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2516430618B7;
        Mon, 15 Jun 2020 11:01:45 -0400 (EDT)
Subject: WTF: patch "[PATCH] smb3: Add new parm "nodelete"" was seriously submitted to be applied to the 5.7-stable tree?
To:     stfrench@microsoft.com, pshilov@microsoft.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:01:33 +0200
Message-ID: <1592233293158227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 5.7-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 82e9367c43890cb6a870f700c9180c7eb2035684 Mon Sep 17 00:00:00 2001
From: Steve French <stfrench@microsoft.com>
Date: Tue, 19 May 2020 03:06:57 -0500
Subject: [PATCH] smb3: Add new parm "nodelete"

In order to handle workloads where it is important to make sure that
a buggy app did not delete content on the drive, the new mount option
"nodelete" allows standard permission checks on the server to work,
but prevents on the client any attempts to unlink a file or delete
a directory on that mount point.  This can be helpful when running
a little understood app on a network mount that contains important
content that should not be deleted.

Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index c31f362fa098..889f9c71049b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -534,6 +534,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_puts(s, ",signloosely");
 	if (tcon->nocase)
 		seq_puts(s, ",nocase");
+	if (tcon->nodelete)
+		seq_puts(s, ",nodelete");
 	if (tcon->local_lease)
 		seq_puts(s, ",locallease");
 	if (tcon->retry)
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 39b708d9d86d..4d261fd78fcb 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -562,6 +562,7 @@ struct smb_vol {
 	bool override_gid:1;
 	bool dynperm:1;
 	bool noperm:1;
+	bool nodelete:1;
 	bool mode_ace:1;
 	bool no_psx_acl:1; /* set if posix acl support should be disabled */
 	bool cifs_acl:1;
@@ -1136,6 +1137,7 @@ struct cifs_tcon {
 	bool retry:1;
 	bool nocase:1;
 	bool nohandlecache:1; /* if strange server resource prob can turn off */
+	bool nodelete:1;
 	bool seal:1;      /* transport encryption for this mounted share */
 	bool unix_ext:1;  /* if false disable Linux extensions to CIFS protocol
 				for this mount even if server would support */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 329babc6b18a..57d1cc6bf86f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -75,7 +75,7 @@ enum {
 	Opt_forceuid, Opt_noforceuid,
 	Opt_forcegid, Opt_noforcegid,
 	Opt_noblocksend, Opt_noautotune, Opt_nolease,
-	Opt_hard, Opt_soft, Opt_perm, Opt_noperm,
+	Opt_hard, Opt_soft, Opt_perm, Opt_noperm, Opt_nodelete,
 	Opt_mapposix, Opt_nomapposix,
 	Opt_mapchars, Opt_nomapchars, Opt_sfu,
 	Opt_nosfu, Opt_nodfs, Opt_posixpaths,
@@ -141,6 +141,7 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_soft, "soft" },
 	{ Opt_perm, "perm" },
 	{ Opt_noperm, "noperm" },
+	{ Opt_nodelete, "nodelete" },
 	{ Opt_mapchars, "mapchars" }, /* SFU style */
 	{ Opt_nomapchars, "nomapchars" },
 	{ Opt_mapposix, "mapposix" }, /* SFM style */
@@ -1760,6 +1761,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		case Opt_noperm:
 			vol->noperm = 1;
 			break;
+		case Opt_nodelete:
+			vol->nodelete = 1;
+			break;
 		case Opt_mapchars:
 			vol->sfu_remap = true;
 			vol->remap = false; /* disable SFM mapping */
@@ -3362,6 +3366,8 @@ static int match_tcon(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 		return 0;
 	if (tcon->no_lease != volume_info->no_lease)
 		return 0;
+	if (tcon->nodelete != volume_info->nodelete)
+		return 0;
 	return 1;
 }
 
@@ -3597,6 +3603,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 	tcon->retry = volume_info->retry;
 	tcon->nocase = volume_info->nocase;
 	tcon->nohandlecache = volume_info->nohandlecache;
+	tcon->nodelete = volume_info->nodelete;
 	tcon->local_lease = volume_info->local_lease;
 	INIT_LIST_HEAD(&tcon->pending_opens);
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 5d2965a23730..873b1effd412 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1418,6 +1418,11 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 
 	xid = get_xid();
 
+	if (tcon->nodelete) {
+		rc = -EACCES;
+		goto unlink_out;
+	}
+
 	/* Unlink can be called from rename so we can not take the
 	 * sb->s_vfs_rename_mutex here */
 	full_path = build_path_from_dentry(dentry);
@@ -1746,6 +1751,12 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 		goto rmdir_exit;
 	}
 
+	if (tcon->nodelete) {
+		rc = -EACCES;
+		cifs_put_tlink(tlink);
+		goto rmdir_exit;
+	}
+
 	rc = server->ops->rmdir(xid, tcon, full_path, cifs_sb);
 	cifs_put_tlink(tlink);
 

