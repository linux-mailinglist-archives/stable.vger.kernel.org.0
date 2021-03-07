Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF7833015E
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhCGNsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:48:42 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50417 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231445AbhCGNsd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:48:33 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 4EAAB1A13;
        Sun,  7 Mar 2021 08:48:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:48:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZhpzI1
        gxpc2yTiJAtAK9bzQH1TSzeL7R0N10nkFCQbo=; b=diO2IE0IZLUBluqMXCYKit
        6oDyg1y+taIPvAX9FdmOyFkjZCxsnmjRc1iUIk8Dy2tTCY+q6mweA+khpKkSKANQ
        v+k0SBTH66gskWkZ2HaIvfXeWTN22r10X/ujgoTSllQbO6p9vMbP2jQ/8uzwgExp
        bCoCq4+azUpBCWAIjqFNH9qDK1cHhPyUGaTLtlpPLU/16Dke+SFtzzYFtmSGrOmK
        KhFYyZY+SgkwW/6zazlaEeN4QKBr15sxZ6KKFfqrTsXAoqKgwjeMqLsCq17Cg5/s
        eUKlLZeu5hkE/sTIVliVWMOilQHVmWO/DKDoxewUugi0cA5yP6uzT8wQlELzv1IQ
        ==
X-ME-Sender: <xms:r9lEYGX9D4PL56QP8ZaA8QzgvoMniS18w5zy0T7TxaA5H01uiILhuA>
    <xme:r9lEYCm-iaLOUiAdPnhLYiYVbaP8ewkMxPE09_sTADwXRgNY8V-TfAc4hnp2lwrj7
    2FIPXsw6jOQng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:r9lEYKYlq8jrKe1FWIhwgu13VlHZNHqSisV3VMqLB-SbUvYbnj1gCg>
    <xmx:r9lEYNWXnSKJOx66gwmEKW7woMHpCEo_T-CnxfuLwtrBSXE8QzDOmA>
    <xmx:r9lEYAnIIj5qlic5D1CG8b9BQlDVYT-YTNaqOcpP40x67HZ_8zZEUQ>
    <xmx:r9lEYFxt0dmY7aHrnRoT3VqDF6LvEsPTCqVOm_fuRoEyeNPoYquRVG1K_FY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 84471240064;
        Sun,  7 Mar 2021 08:48:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: tree-checker: do not error out if extent ref hash" failed to apply to 5.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com,
        tuomas.lahdekorpi@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:48:30 +0100
Message-ID: <161512491022699@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

