Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0005A330164
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhCGNtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:49:15 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50291 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231445AbhCGNsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:48:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 5AD9C19BE;
        Sun,  7 Mar 2021 08:48:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:48:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=OltiGe
        3bPvWkKawe5S2CEY+hEhXhbt0cJ/tUDgdUTUo=; b=MV2BZbvjmmvakm86GmGrdy
        vrQooxNz4f7iBQl9X12TBqnp4ZrLAw7+wR+o8oTeg7noMOyEgCdGMPoAAoGXlL+k
        wRdbW2s9fW6cEMRvXK7VNFObUdaGHe8GcyPZgE1sgvFqzEOFM04A74pGK+O/ehjC
        ch70wgrrMVtXK1K0SexmKmKrUOYEMLGyJx1xBxo0RQRsz4Q7bzOjNr3GY60fdNLS
        /r7Qk2GUguB4786k2e1QfPL8oyLRo3mKPsmSPszGUH47eV3RWjScq8AoaMhAZ5SY
        PMQUDd97yOsNK3VWzN4Fl4O7cX7HYBz/Z6YnwNplEcMwVU2R72DmMXoqVkCxHo7g
        ==
X-ME-Sender: <xms:udlEYPhQIG6nun0DtuaIU9oHOG4enuq97ttaj8FzVB3SFmHvNR13nQ>
    <xme:udlEYMBlF-kJ9H6LJlZ2IPsGUl4VGqFE3hZJQGer4IkYmrBzqnAyzE7f50FPHjTTS
    4N02h08NVJneQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:udlEYPEqwYib4dieheoruPIwR6bPiKvSfi0RpwXk5EeoTqUXPlz6kw>
    <xmx:udlEYMQ645_BvjLh5e3jTclC01MRzhoXQFZRlVggbam8qxVpRHTawg>
    <xmx:udlEYMzhf5vNY6TSGpqwlrMA3lO7cVn8V9jzmtFmWcZWK8Qofge9TQ>
    <xmx:utlEYH_cAIxRxU81Bw2LjFQEvdCSJY15F6lZH6Z8ZUhkSq-eBOoihdRaTRc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9AD8C1080057;
        Sun,  7 Mar 2021 08:48:41 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: tree-checker: do not error out if extent ref hash" failed to apply to 5.10-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com,
        tuomas.lahdekorpi@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:48:31 +0100
Message-ID: <161512491122890@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 1119a72e223f3073a604f8fccb3a470ccd8a4416 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 16 Feb 2021 15:43:22 -0500
Subject: [PATCH] btrfs: tree-checker: do not error out if extent ref hash
 doesn't match
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The tree checker checks the extent ref hash at read and write time to
make sure we do not corrupt the file system.  Generally extent
references go inline, but if we have enough of them we need to make an
item, which looks like

key.objectid	= <bytenr>
key.type	= <BTRFS_EXTENT_DATA_REF_KEY|BTRFS_TREE_BLOCK_REF_KEY>
key.offset	= hash(tree, owner, offset)

However if key.offset collide with an unrelated extent reference we'll
simply key.offset++ until we get something that doesn't collide.
Obviously this doesn't match at tree checker time, and thus we error
while writing out the transaction.  This is relatively easy to
reproduce, simply do something like the following

  xfs_io -f -c "pwrite 0 1M" file
  offset=2

  for i in {0..10000}
  do
	  xfs_io -c "reflink file 0 ${offset}M 1M" file
	  offset=$(( offset + 2 ))
  done

  xfs_io -c "reflink file 0 17999258914816 1M" file
  xfs_io -c "reflink file 0 35998517829632 1M" file
  xfs_io -c "reflink file 0 53752752058368 1M" file

  btrfs filesystem sync

And the sync will error out because we'll abort the transaction.  The
magic values above are used because they generate hash collisions with
the first file in the main subvol.

The fix for this is to remove the hash value check from tree checker, as
we have no idea which offset ours should belong to.

Reported-by: Tuomas Lähdekorpi <tuomas.lahdekorpi@gmail.com>
Fixes: 0785a9aacf9d ("btrfs: tree-checker: Add EXTENT_DATA_REF check")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add comment]
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 582061c7b547..f4ade821307d 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1453,22 +1453,14 @@ static int check_extent_data_ref(struct extent_buffer *leaf,
 		return -EUCLEAN;
 	}
 	for (; ptr < end; ptr += sizeof(*dref)) {
-		u64 root_objectid;
-		u64 owner;
 		u64 offset;
-		u64 hash;
 
+		/*
+		 * We cannot check the extent_data_ref hash due to possible
+		 * overflow from the leaf due to hash collisions.
+		 */
 		dref = (struct btrfs_extent_data_ref *)ptr;
-		root_objectid = btrfs_extent_data_ref_root(leaf, dref);
-		owner = btrfs_extent_data_ref_objectid(leaf, dref);
 		offset = btrfs_extent_data_ref_offset(leaf, dref);
-		hash = hash_extent_data_ref(root_objectid, owner, offset);
-		if (unlikely(hash != key->offset)) {
-			extent_err(leaf, slot,
-	"invalid extent data ref hash, item has 0x%016llx key has 0x%016llx",
-				   hash, key->offset);
-			return -EUCLEAN;
-		}
 		if (unlikely(!IS_ALIGNED(offset, leaf->fs_info->sectorsize))) {
 			extent_err(leaf, slot,
 	"invalid extent data backref offset, have %llu expect aligned to %u",

