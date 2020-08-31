Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488EB257696
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 11:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgHaJgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 05:36:21 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51591 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726072AbgHaJgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 05:36:21 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 896FB773;
        Mon, 31 Aug 2020 05:36:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 05:36:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=PoLMKc
        1p79NwRobflHb0uxET4XVV3sqp34ueZ8DJesU=; b=mCf5p6NkuG2X0XM2uYfaWm
        JRZN/0JoZq7vJx8hIQ1rxCRYOWEnHZsiDvItFOfPehM/0e3T9Z/knK3VWpc/jv6S
        RHHqMpsK5JxLgyAwAIkgW5+BmGehXseUaFUh2VlmXLtStuGRJHys7cS6pX67SYfW
        E2xIeJQeAHnfYblsoAuN7F2ia7OOq42O/LJpR0tXbyrNVdyfJEHtaS1GUTvfmmKF
        goRC5TRH59O3SRQL1kcuCJ+H3XDnhw04kaa9CP68a6wqsKfNFiDgiwfMNEALyGGx
        f20nPVdVAE15RxPuP88L4CgH/DkAog3h6a4LpQ0DerGj3JZjcwXXkYripheVQgCg
        ==
X-ME-Sender: <xms:k8RMX1YGNwzv3NK2g-yMCndL-BrwfyoETZ7IdXqnbWEV4qBWYED28Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:k8RMX8YSXVa16zkI3YbQHyrmTHE1N3q-FRPyoUKYGc1XjcNn4U5Log>
    <xmx:k8RMX386Z15aEzjkrjX7aOjBIqNZo1X09IbjCdYYbOpgXjmKxCIkSg>
    <xmx:k8RMXzpueURDmt2XgBR9YV6tSxRGLyUWgJ3C6g1fiRImGiKiotvdBg>
    <xmx:k8RMX3SIS8butstfJIKyoFKdtCMBGFlC4FI_RLR_0pX3WQccqQRp0fEZ8fc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D37F930600A6;
        Mon, 31 Aug 2020 05:36:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: check the right error variable in" failed to apply to 4.9-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 11:36:27 +0200
Message-ID: <159886658721020@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fb2fecbad50964b9f27a3b182e74e437b40753ef Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 10 Aug 2020 17:31:16 -0400
Subject: [PATCH] btrfs: check the right error variable in
 btrfs_del_dir_entries_in_log

With my new locking code dbench is so much faster that I tripped over a
transaction abort from ENOSPC.  This turned out to be because
btrfs_del_dir_entries_in_log was checking for ret == -ENOSPC, but this
function sets err on error, and returns err.  So instead of properly
marking the inode as needing a full commit, we were returning -ENOSPC
and aborting in __btrfs_unlink_inode.  Fix this by checking the proper
variable so that we return the correct thing in the case of ENOSPC.

The ENOENT needs to be checked, because btrfs_lookup_dir_item_index()
can return -ENOENT if the dir item isn't in the tree log (which would
happen if we hadn't fsync'ed this guy).  We actually handle that case in
__btrfs_unlink_inode, so it's an expected error to get back.

Fixes: 4a500fd178c8 ("Btrfs: Metadata ENOSPC handling for tree log")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ add note and comment about ENOENT ]
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 696dd861cc3c..39da9db35278 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3449,11 +3449,13 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 	btrfs_free_path(path);
 out_unlock:
 	mutex_unlock(&dir->log_mutex);
-	if (ret == -ENOSPC) {
+	if (err == -ENOSPC) {
 		btrfs_set_log_full_commit(trans);
-		ret = 0;
-	} else if (ret < 0)
-		btrfs_abort_transaction(trans, ret);
+		err = 0;
+	} else if (err < 0 && err != -ENOENT) {
+		/* ENOENT can be returned if the entry hasn't been fsynced yet */
+		btrfs_abort_transaction(trans, err);
+	}
 
 	btrfs_end_log_trans(root);
 

