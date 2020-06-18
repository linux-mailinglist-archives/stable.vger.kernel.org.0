Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1357D1FF533
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 16:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730954AbgFROpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 10:45:39 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:58329 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730970AbgFROpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 10:45:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 998F8613;
        Thu, 18 Jun 2020 10:45:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 18 Jun 2020 10:45:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=wH/QLD
        L9GIPIS9a4r8MfaT+aj4dhaOWNWVwe6GI02co=; b=PILQGwcip1wfIIhJkg/v6c
        oiE9l5C3gdOsafQEU6QkYh6Sgdr3qUC/zOSPQ3f0JS4Po+3+JqN+T2Vqn0oC4y3b
        C1ikKNVeOdTqH7aFUbEY9tXdXXFPWTX1p5GamH33TC+CsLSx+HQdK9GLy+LoViCf
        9hee7x8nzHi2kE35+ks5yz9i8lNJrkXzz7SxcT1ar6PJuWWK4ms6DJYwYU2pJPws
        KgTwdmtezZmQYCbBFld9ZLMfxDxMsorSP5A+tetTp46DourXP7HN8DC9jfirdhPW
        cuN7cbcimzf+DTmLtTzpVHvj4+4GgMrC/bzDM93VezdPFKWyQD6AWqW5mm3Woq5A
        ==
X-ME-Sender: <xms:DX7rXlszb4ZVyX5TjlXXKi9tS32ATbZKn0koIMHyrCEpeOFK9X9NlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejgedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepiedtffetffduvdfgkeevgfdtieekueduffehffeftd
    egvdejuedvudegudeltdeinecuffhomhgrihhnpehgihhthhhusgdrtghomhenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:DX7rXue7Vq9hrgKYNMrPJU_1gaFdT4svryDUNuCdlR8yv0Hd4c967A>
    <xmx:DX7rXozjExcXfKv3pUovVR3IZq7OkKQI2OVW66YydbTS4MAQY97MJw>
    <xmx:DX7rXsMW2yO9TzxDSb8XxgOggW8eIdR_9sll6U2H5kZInPwX6mJf2w>
    <xmx:DX7rXiFmbVOzjiVTlVKVD_-IQE9Yrb7771ILyHDMlS20oumER8Srbnm8hqE>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B529A328005E;
        Thu, 18 Jun 2020 10:45:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: send: emit file capabilities after chown" failed to apply to 4.4-stable tree
To:     mpdesouza@suse.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 18 Jun 2020 16:45:23 +0200
Message-ID: <1592491523186218@kroah.com>
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

From 89efda52e6b6930f80f5adda9c3c9edfb1397191 Mon Sep 17 00:00:00 2001
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Sun, 10 May 2020 23:15:07 -0300
Subject: [PATCH] btrfs: send: emit file capabilities after chown

Whenever a chown is executed, all capabilities of the file being touched
are lost.  When doing incremental send with a file with capabilities,
there is a situation where the capability can be lost on the receiving
side. The sequence of actions bellow shows the problem:

  $ mount /dev/sda fs1
  $ mount /dev/sdb fs2

  $ touch fs1/foo.bar
  $ setcap cap_sys_nice+ep fs1/foo.bar
  $ btrfs subvolume snapshot -r fs1 fs1/snap_init
  $ btrfs send fs1/snap_init | btrfs receive fs2

  $ chgrp adm fs1/foo.bar
  $ setcap cap_sys_nice+ep fs1/foo.bar

  $ btrfs subvolume snapshot -r fs1 fs1/snap_complete
  $ btrfs subvolume snapshot -r fs1 fs1/snap_incremental

  $ btrfs send fs1/snap_complete | btrfs receive fs2
  $ btrfs send -p fs1/snap_init fs1/snap_incremental | btrfs receive fs2

At this point, only a chown was emitted by "btrfs send" since only the
group was changed. This makes the cap_sys_nice capability to be dropped
from fs2/snap_incremental/foo.bar

To fix that, only emit capabilities after chown is emitted. The current
code first checks for xattrs that are new/changed, emits them, and later
emit the chown. Now, __process_new_xattr skips capabilities, letting
only finish_inode_if_needed to emit them, if they exist, for the inode
being processed.

This behavior was being worked around in "btrfs receive" side by caching
the capability and only applying it after chown. Now, xattrs are only
emmited _after_ chown, making that workaround not needed anymore.

Link: https://github.com/kdave/btrfs-progs/issues/202
CC: stable@vger.kernel.org # 4.4+
Suggested-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index c5f41bd86765..4f3b8d2bb56b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -23,6 +23,7 @@
 #include "btrfs_inode.h"
 #include "transaction.h"
 #include "compression.h"
+#include "xattr.h"
 
 /*
  * Maximum number of references an extent can have in order for us to attempt to
@@ -4545,6 +4546,10 @@ static int __process_new_xattr(int num, struct btrfs_key *di_key,
 	struct fs_path *p;
 	struct posix_acl_xattr_header dummy_acl;
 
+	/* Capabilities are emitted by finish_inode_if_needed */
+	if (!strncmp(name, XATTR_NAME_CAPS, name_len))
+		return 0;
+
 	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
@@ -5107,6 +5112,64 @@ static int send_extent_data(struct send_ctx *sctx,
 	return 0;
 }
 
+/*
+ * Search for a capability xattr related to sctx->cur_ino. If the capability is
+ * found, call send_set_xattr function to emit it.
+ *
+ * Return 0 if there isn't a capability, or when the capability was emitted
+ * successfully, or < 0 if an error occurred.
+ */
+static int send_capabilities(struct send_ctx *sctx)
+{
+	struct fs_path *fspath = NULL;
+	struct btrfs_path *path;
+	struct btrfs_dir_item *di;
+	struct extent_buffer *leaf;
+	unsigned long data_ptr;
+	char *buf = NULL;
+	int buf_len;
+	int ret = 0;
+
+	path = alloc_path_for_send();
+	if (!path)
+		return -ENOMEM;
+
+	di = btrfs_lookup_xattr(NULL, sctx->send_root, path, sctx->cur_ino,
+				XATTR_NAME_CAPS, strlen(XATTR_NAME_CAPS), 0);
+	if (!di) {
+		/* There is no xattr for this inode */
+		goto out;
+	} else if (IS_ERR(di)) {
+		ret = PTR_ERR(di);
+		goto out;
+	}
+
+	leaf = path->nodes[0];
+	buf_len = btrfs_dir_data_len(leaf, di);
+
+	fspath = fs_path_alloc();
+	buf = kmalloc(buf_len, GFP_KERNEL);
+	if (!fspath || !buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, fspath);
+	if (ret < 0)
+		goto out;
+
+	data_ptr = (unsigned long)(di + 1) + btrfs_dir_name_len(leaf, di);
+	read_extent_buffer(leaf, buf, data_ptr, buf_len);
+
+	ret = send_set_xattr(sctx, fspath, XATTR_NAME_CAPS,
+			strlen(XATTR_NAME_CAPS), buf, buf_len);
+out:
+	kfree(buf);
+	fs_path_free(fspath);
+	btrfs_free_path(path);
+	return ret;
+}
+
 static int clone_range(struct send_ctx *sctx,
 		       struct clone_root *clone_root,
 		       const u64 disk_byte,
@@ -5972,6 +6035,10 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
 			goto out;
 	}
 
+	ret = send_capabilities(sctx);
+	if (ret < 0)
+		goto out;
+
 	/*
 	 * If other directory inodes depended on our current directory
 	 * inode's move/rename, now do their move/rename operations.

