Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557F9327BE5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhCAKWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:22:08 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:54277 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233351AbhCAKVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:21:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3D8101940B9A;
        Mon,  1 Mar 2021 05:19:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:19:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MsKOS4
        OS9VC4QXhliTyufy2sqiCuGgSW0HxLi39/Pj8=; b=FpjKO+JTC8cgLOvJXe51ax
        pocBjWcJaDD6du3Kfwed4REfp5m4/ocG/eY5YzK504714CrDwA1aTG1VNCMX2vzH
        H0MZ2AIz/Pfqq7EKK+cg+qIkcXSrhGLENePEn9ytTgQtKnI5NGP3WoFF0EzZw23Q
        aTRetE4ROePLiYvaiQrmnfkaysr0Jbkcs5Ec4l9rd6IqbywSMwoDpvqkWgILZjPq
        nqyqUpyhUyuarXvl5FuZ7Jsl9jQJZ+0pZ5n4gsOugbFcIuxpQLEzXjlx7D9CbC/G
        YcB5Wu4jh4hFoz2olwUtM2S1LsJE4woacSegP6IVRiqykxb65O3aED7N0e67jHGw
        ==
X-ME-Sender: <xms:ur88YMhObWFVLwMwCimYizcSeqyFVD_osHUMrM6tWwwNyMefUtjLxw>
    <xme:ur88YFBXqAgVX03dEBG8uNNS_a7DvURjYtDPvUUwYxop-rzz_Vrq4Y9sAd6CS3_kc
    kr4De1oDUzVkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:ur88YEFlP8N_9ChsMTxvItOFubHGsrQ0UrgdV8-N51fGYS0EgSbrXQ>
    <xmx:ur88YNTuxRH3bCJieGxidqNYVEKxfJUbOEYZ3GyKIAg-IyhNTSICMg>
    <xmx:ur88YJzsjKWyyn-7rWxYuj_kzIAwo-rLoGE_xDo92VPK8j7kWJN6AQ>
    <xmx:u788YHaJwbRUx8ciD9VoMnwQC2vEhoLBGBe22JJeReiwOTjff0atEQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 95FFC1080054;
        Mon,  1 Mar 2021 05:19:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix extent buffer leak on failure to copy root" failed to apply to 4.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:19:32 +0100
Message-ID: <16145939721728@kroah.com>
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

From 72c9925f87c8b74f36f8e75a4cd93d964538d3ca Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Thu, 4 Feb 2021 14:35:44 +0000
Subject: [PATCH] btrfs: fix extent buffer leak on failure to copy root

At btrfs_copy_root(), if the call to btrfs_inc_ref() fails we end up
returning without unlocking and releasing our reference on the extent
buffer named "cow" we previously allocated with btrfs_alloc_tree_block().

So fix that by unlocking the extent buffer and dropping our reference on
it before returning.

Fixes: be20aa9dbadc8c ("Btrfs: Add mount option to turn off data cow")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 95d9bae764ab..d56730a67885 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -222,6 +222,8 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	else
 		ret = btrfs_inc_ref(trans, root, cow, 0);
 	if (ret) {
+		btrfs_tree_unlock(cow);
+		free_extent_buffer(cow);
 		btrfs_abort_transaction(trans, ret);
 		return ret;
 	}

