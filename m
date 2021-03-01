Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA20A327BDD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhCAKUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:20:38 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:52229 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233351AbhCAKTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:19:48 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 004111940B9B;
        Mon,  1 Mar 2021 05:19:00 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 01 Mar 2021 05:18:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=A3f7NL
        Tqo9W0tCXQz0ikwrypznVwx3h5L/UswYADVRE=; b=s5Ci4Ot4QssCOhjauGatlE
        x2v6a7eaDaxH3S3L/dZjh0wvJjciiVBUbeMCW6bLKVXcTQSnEjLZpiMr+mcBZY9U
        G8o2KGJETQFKZqru9ZBL1rg3kOeZIHX6BoMbMuMkpdZjG5l3nW7vonHLZ0NN1jNV
        /y6k0H+oSys1srZ0zV2zBfKGRvH8h27jIIboTLiHIPY9CcePSNDiSJhT2cWnCll6
        NLQCK8VaK3BC3F5U2qJJK4WAUXU8Oj+KcHrf1Mcg4uXZuUlkeMSYbj9SP4xHv9Pl
        9eJjDKHyhOEL5YB1ptTguhZBUR6fkySYrLHJVNzA6x628gnrrReFt6diLlSEwWVQ
        ==
X-ME-Sender: <xms:k788YLofhrIGXANPVZLQ4SCsn6uMqZXc3m06hc2lXd_T3cwqHaQLYg>
    <xme:k788YFkfinctoOnHby09QuJHSGEGNtsopCKZi5N72UrPT7EY8_cH8HUBZARY3zUEM
    JueIgzysuthyQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:k788YFFEKrMtZkGsVIVT3ofOHHUsBRVCIl6STmfGVyADpAiDsUkRsA>
    <xmx:k788YGrJtjyhxY3sdBqlZLtykkU7OzB8ibq77ReBaPnYKAPs0Ktrfg>
    <xmx:k788YJ4HgLs4KzrjsfY35Sc_AorPJrqOqYlNxcBNBNeA07d2MKgZjQ>
    <xmx:k788YB5e-gDya_jpygyOo0eMVBK93g8M_-HZ299LP8KNpgaRe1zCUA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6D4B01080064;
        Mon,  1 Mar 2021 05:18:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: abort the transaction if we fail to inc ref in" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:18:57 +0100
Message-ID: <1614593937139140@kroah.com>
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

From 867ed321f90d06aaba84e2c91de51cd3038825ef Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 14 Jan 2021 14:02:46 -0500
Subject: [PATCH] btrfs: abort the transaction if we fail to inc ref in
 btrfs_copy_root

While testing my error handling patches, I added a error injection site
at btrfs_inc_extent_ref, to validate the error handling I added was
doing the correct thing.  However I hit a pretty ugly corruption while
doing this check, with the following error injection stack trace:

btrfs_inc_extent_ref
  btrfs_copy_root
    create_reloc_root
      btrfs_init_reloc_root
	btrfs_record_root_in_trans
	  btrfs_start_transaction
	    btrfs_update_inode
	      btrfs_update_time
		touch_atime
		  file_accessed
		    btrfs_file_mmap

This is because we do not catch the error from btrfs_inc_extent_ref,
which in practice would be ENOMEM, which means we lose the extent
references for a root that has already been allocated and inserted,
which is the problem.  Fix this by aborting the transaction if we fail
to do the reference modification.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 56e132d825a2..95d9bae764ab 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -221,9 +221,10 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 		ret = btrfs_inc_ref(trans, root, cow, 1);
 	else
 		ret = btrfs_inc_ref(trans, root, cow, 0);
-
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		return ret;
+	}
 
 	btrfs_mark_buffer_dirty(cow);
 	*cow_ret = cow;

