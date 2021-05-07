Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 992E13767EC
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 17:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbhEGP3B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 11:29:01 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:33811 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233167AbhEGP3A (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 11:29:00 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id A256F1941A19;
        Fri,  7 May 2021 11:27:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 07 May 2021 11:27:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BhYkiK
        oEOtQrG1KP9wSPfdOJpJ1vlzWuAlgc3DWdkvc=; b=M0I4vvTNuRgxwslSlwh0RF
        R4TFZBwKhXW3I5xoVB0+ANfppTcBDOb2BuI8FWtQUONaHZHupGjQP0kx86ughfIW
        A0SWUcSlqDJpONOxEzEGA1n8+yXZ2YMzLlaBmxBC66gFPrGxo/zmZX560k83fqgN
        CBX3yVyzGyq40NoWiorXltERiV3lagers6l4JHaK0zHDU3ihZzD69ImwVIOWgZEo
        qCLdKCpB8y94UWPsMg0LbazU9SqFNxdaeVOocCzZNvhzM3QVjRuBa1iwnDwBcuEk
        n4FgLFxaGt5TLgGmDWPNSNEhxKrXim46s6fWJyUfDhnOb6oK6hN0W+8zJDvGze3w
        ==
X-ME-Sender: <xms:f1yVYJrMe7ddtcmrnpPWzmXWanHm_vUVrk_XEbHANyaebRdH5OE9AA>
    <xme:f1yVYLqVdss1NkOp1NU8RPBcWIKpIjOQcHgDo1DJ5re5aDx_jeEj6dG3bx2Bnmscg
    VFHteoTeR5UFw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegvddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:f1yVYGM023Y79185U4ZiOgAsCahBiBAP7ToOyk7JlCrVTX7k_P6WOg>
    <xmx:f1yVYE6sjfawzClQUelGZrjxBLxwXtneQe73leZkOQoIrWvmtWzscQ>
    <xmx:f1yVYI41TPvVDPnWW5WUYSoe7mSyFqcFzT0GYye8GexhAFFStgq8iQ>
    <xmx:f1yVYNhaZ6_zQPi0Rr1b2PRpYWhtw_zh0Vm1jpJMCJ9JrMyc0hQCAQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri,  7 May 2021 11:27:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix metadata extent leak after failure to create" failed to apply to 4.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 May 2021 17:27:56 +0200
Message-ID: <1620401276119220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 67addf29004c5be9fa0383c82a364bb59afc7f84 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Tue, 20 Apr 2021 10:55:12 +0100
Subject: [PATCH] btrfs: fix metadata extent leak after failure to create
 subvolume

When creating a subvolume we allocate an extent buffer for its root node
after starting a transaction. We setup a root item for the subvolume that
points to that extent buffer and then attempt to insert the root item into
the root tree - however if that fails, due to ENOMEM for example, we do
not free the extent buffer previously allocated and we do not abort the
transaction (as at that point we did nothing that can not be undone).

This means that we effectively do not return the metadata extent back to
the free space cache/tree and we leave a delayed reference for it which
causes a metadata extent item to be added to the extent tree, in the next
transaction commit, without having backreferences. When this happens
'btrfs check' reports the following:

  $ btrfs check /dev/sdi
  Opening filesystem to check...
  Checking filesystem on /dev/sdi
  UUID: dce2cb9d-025f-4b05-a4bf-cee0ad3785eb
  [1/7] checking root items
  [2/7] checking extents
  ref mismatch on [30425088 16384] extent item 1, found 0
  backref 30425088 root 256 not referenced back 0x564a91c23d70
  incorrect global backref count on 30425088 found 1 wanted 0
  backpointer mismatch on [30425088 16384]
  owner ref check failed [30425088 16384]
  ERROR: errors found in extent allocation tree or chunk allocation
  [3/7] checking free space cache
  [4/7] checking fs roots
  [5/7] checking only csums items (without verifying data)
  [6/7] checking root refs
  [7/7] checking quota groups skipped (not enabled on this FS)
  found 212992 bytes used, error(s) found
  total csum bytes: 0
  total tree bytes: 131072
  total fs tree bytes: 32768
  total extent tree bytes: 16384
  btree space waste bytes: 124669
  file data blocks allocated: 65536
   referenced 65536

So fix this by freeing the metadata extent if btrfs_insert_root() returns
an error.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 37c92a9fa2e3..b1328f17607e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -697,8 +697,6 @@ static noinline int create_subvol(struct inode *dir,
 	btrfs_set_root_otransid(root_item, trans->transid);
 
 	btrfs_tree_unlock(leaf);
-	free_extent_buffer(leaf);
-	leaf = NULL;
 
 	btrfs_set_root_dirid(root_item, BTRFS_FIRST_FREE_OBJECTID);
 
@@ -707,8 +705,22 @@ static noinline int create_subvol(struct inode *dir,
 	key.type = BTRFS_ROOT_ITEM_KEY;
 	ret = btrfs_insert_root(trans, fs_info->tree_root, &key,
 				root_item);
-	if (ret)
+	if (ret) {
+		/*
+		 * Since we don't abort the transaction in this case, free the
+		 * tree block so that we don't leak space and leave the
+		 * filesystem in an inconsistent state (an extent item in the
+		 * extent tree without backreferences). Also no need to have
+		 * the tree block locked since it is not in any tree at this
+		 * point, so no other task can find it and use it.
+		 */
+		btrfs_free_tree_block(trans, root, leaf, 0, 1);
+		free_extent_buffer(leaf);
 		goto fail;
+	}
+
+	free_extent_buffer(leaf);
+	leaf = NULL;
 
 	key.offset = (u64)-1;
 	new_root = btrfs_get_new_fs_root(fs_info, objectid, anon_dev);

