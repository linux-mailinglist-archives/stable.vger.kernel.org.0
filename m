Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6E7261FB9
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 22:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730190AbgIHUGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 16:06:09 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:44489 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730236AbgIHPVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 11:21:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 2FA68ED0;
        Tue,  8 Sep 2020 08:26:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 08 Sep 2020 08:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8paECn
        KEOPSqVP+RKjswrIdGb1oOVq1xehRjNImSByE=; b=PjWeMksQln3dH+Ww49lY+a
        e693KidWKSivGPkriMrvv52TwW61QxuyJ/GwXF1e2imTJlbvwXW+Qj+2KLAIMYgN
        tZGUMVJfBBDuS0LTrrHjCjfGaABYY6qzruRjwoMb3o2bgpmn2TLUCFFjALaJy65b
        9FsGYsStIeRgIPu4LdwFl4DqJHQ6e1UHi2YGqSpKW+5JLjPFZxjY/Z/G/7iK6i2W
        dJpfWphQHitC0WBsX0aWDWwvK4qBxVfF5Ku0XUJ+d/zoAa3KoxCqssIP/h6ab3LB
        ZH7VEJPMN18H8rOqNu14yOstz69ROgL/JZj9iY8NtTU0brwgzfNNEH4NOVpw8BMQ
        ==
X-ME-Sender: <xms:hHhXX7aRvudTNW0stCVcS_kPu92cyE3uERL0Hg_0utNKGiX84jDxJw>
    <xme:hHhXX6aqy1K99V8a6v0PpWiX6P0kP19vI_kdD0syd38hxAyPZKP0jXdIzSloKbyvX
    _sSOSRv8KxL4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehfedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:hHhXX98kcXjxH0eb4Ij27YWQ_jL21jYxUu07TaEKb1qDBj6071H_eg>
    <xmx:hHhXXxp5xJO7reOvpMUgE2Pn8NmjFl-Wb7HgFrLd6UWAlbX0epoIPg>
    <xmx:hHhXX2qwsNtbJB88X39iRk1OSz3x9vX1G67BDGmQq6vsghQvZt2FxA>
    <xmx:hHhXX9ReBMpYKqLxjMAcyvMsSKdupwp2KbBXENFlO8dxSd47mzQQDsJozsY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 57BF23280059;
        Tue,  8 Sep 2020 08:26:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] affs: fix basic permission bits to actually work" failed to apply to 4.4-stable tree
To:     max@enpas.org, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Sep 2020 14:26:50 +0200
Message-ID: <159956801012764@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d3a84a8d0dde4e26bc084b36ffcbdc5932ac85e2 Mon Sep 17 00:00:00 2001
From: Max Staudt <max@enpas.org>
Date: Thu, 27 Aug 2020 17:49:00 +0200
Subject: [PATCH] affs: fix basic permission bits to actually work

The basic permission bits (protection bits in AmigaOS) have been broken
in Linux' AFFS - it would only set bits, but never delete them.
Also, contrary to the documentation, the Archived bit was not handled.

Let's fix this for good, and set the bits such that Linux and classic
AmigaOS can coexist in the most peaceful manner.

Also, update the documentation to represent the current state of things.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Max Staudt <max@enpas.org>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/Documentation/filesystems/affs.rst b/Documentation/filesystems/affs.rst
index 7f1a40dce6d3..5776cbd5fa53 100644
--- a/Documentation/filesystems/affs.rst
+++ b/Documentation/filesystems/affs.rst
@@ -110,13 +110,15 @@ The Amiga protection flags RWEDRWEDHSPARWED are handled as follows:
 
   - R maps to r for user, group and others. On directories, R implies x.
 
-  - If both W and D are allowed, w will be set.
+  - W maps to w.
 
   - E maps to x.
 
-  - H and P are always retained and ignored under Linux.
+  - D is ignored.
 
-  - A is always reset when a file is written to.
+  - H, S and P are always retained and ignored under Linux.
+
+  - A is cleared when a file is written to.
 
 User id and group id will be used unless set[gu]id are given as mount
 options. Since most of the Amiga file systems are single user systems
@@ -128,11 +130,13 @@ Linux -> Amiga:
 
 The Linux rwxrwxrwx file mode is handled as follows:
 
-  - r permission will set R for user, group and others.
+  - r permission will allow R for user, group and others.
+
+  - w permission will allow W for user, group and others.
 
-  - w permission will set W and D for user, group and others.
+  - x permission of the user will allow E for plain files.
 
-  - x permission of the user will set E for plain files.
+  - D will be allowed for user, group and others.
 
   - All other flags (suid, sgid, ...) are ignored and will
     not be retained.
diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index f708c45d5f66..29f11e10a7c7 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -420,24 +420,51 @@ affs_mode_to_prot(struct inode *inode)
 	u32 prot = AFFS_I(inode)->i_protect;
 	umode_t mode = inode->i_mode;
 
+	/*
+	 * First, clear all RWED bits for owner, group, other.
+	 * Then, recalculate them afresh.
+	 *
+	 * We'll always clear the delete-inhibit bit for the owner, as that is
+	 * the classic single-user mode AmigaOS protection bit and we need to
+	 * stay compatible with all scenarios.
+	 *
+	 * Since multi-user AmigaOS is an extension, we'll only set the
+	 * delete-allow bit if any of the other bits in the same user class
+	 * (group/other) are used.
+	 */
+	prot &= ~(FIBF_NOEXECUTE | FIBF_NOREAD
+		  | FIBF_NOWRITE | FIBF_NODELETE
+		  | FIBF_GRP_EXECUTE | FIBF_GRP_READ
+		  | FIBF_GRP_WRITE   | FIBF_GRP_DELETE
+		  | FIBF_OTR_EXECUTE | FIBF_OTR_READ
+		  | FIBF_OTR_WRITE   | FIBF_OTR_DELETE);
+
+	/* Classic single-user AmigaOS flags. These are inverted. */
 	if (!(mode & 0100))
 		prot |= FIBF_NOEXECUTE;
 	if (!(mode & 0400))
 		prot |= FIBF_NOREAD;
 	if (!(mode & 0200))
 		prot |= FIBF_NOWRITE;
+
+	/* Multi-user extended flags. Not inverted. */
 	if (mode & 0010)
 		prot |= FIBF_GRP_EXECUTE;
 	if (mode & 0040)
 		prot |= FIBF_GRP_READ;
 	if (mode & 0020)
 		prot |= FIBF_GRP_WRITE;
+	if (mode & 0070)
+		prot |= FIBF_GRP_DELETE;
+
 	if (mode & 0001)
 		prot |= FIBF_OTR_EXECUTE;
 	if (mode & 0004)
 		prot |= FIBF_OTR_READ;
 	if (mode & 0002)
 		prot |= FIBF_OTR_WRITE;
+	if (mode & 0007)
+		prot |= FIBF_OTR_DELETE;
 
 	AFFS_I(inode)->i_protect = prot;
 }
diff --git a/fs/affs/file.c b/fs/affs/file.c
index a26a0f96c119..d91b0133d95d 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -429,6 +429,24 @@ static int affs_write_begin(struct file *file, struct address_space *mapping,
 	return ret;
 }
 
+static int affs_write_end(struct file *file, struct address_space *mapping,
+			  loff_t pos, unsigned int len, unsigned int copied,
+			  struct page *page, void *fsdata)
+{
+	struct inode *inode = mapping->host;
+	int ret;
+
+	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
+
+	/* Clear Archived bit on file writes, as AmigaOS would do */
+	if (AFFS_I(inode)->i_protect & FIBF_ARCHIVED) {
+		AFFS_I(inode)->i_protect &= ~FIBF_ARCHIVED;
+		mark_inode_dirty(inode);
+	}
+
+	return ret;
+}
+
 static sector_t _affs_bmap(struct address_space *mapping, sector_t block)
 {
 	return generic_block_bmap(mapping,block,affs_get_block);
@@ -438,7 +456,7 @@ const struct address_space_operations affs_aops = {
 	.readpage = affs_readpage,
 	.writepage = affs_writepage,
 	.write_begin = affs_write_begin,
-	.write_end = generic_write_end,
+	.write_end = affs_write_end,
 	.direct_IO = affs_direct_IO,
 	.bmap = _affs_bmap
 };
@@ -795,6 +813,12 @@ static int affs_write_end_ofs(struct file *file, struct address_space *mapping,
 	if (tmp > inode->i_size)
 		inode->i_size = AFFS_I(inode)->mmu_private = tmp;
 
+	/* Clear Archived bit on file writes, as AmigaOS would do */
+	if (AFFS_I(inode)->i_protect & FIBF_ARCHIVED) {
+		AFFS_I(inode)->i_protect &= ~FIBF_ARCHIVED;
+		mark_inode_dirty(inode);
+	}
+
 err_first_bh:
 	unlock_page(page);
 	put_page(page);

