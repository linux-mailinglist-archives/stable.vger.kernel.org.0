Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C13A257695
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 11:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgHaJgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 05:36:20 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:38703 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725915AbgHaJgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 05:36:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 50121858;
        Mon, 31 Aug 2020 05:36:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 05:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=a2bEfb
        2hC0/9mzBu+t1BXqr0eq6Q4HgFeACUDzmbgJM=; b=FVrb1ofIHWrRscLhO4VLC3
        1LDla9K/v89XVo83VIDeW7JTj9zD1k6bO/fNZGagCiDt3LzK05bgOknBdCT+l3o9
        bv+1qjN+8UiCUJ6ePZK/lstfR4iqYlKfGNSToiaVxCwoIAFovPUMsLjh2GFPbAF2
        tsMfMLH5o8HAOwwRuq0qDqGl1M+Qs057cFZDVB8XyWpYUabrFYEClBRwEc5VlBAX
        ifhDRue/X4YZx/EeKmfwj7YuiO2ZHG3hlXiredb79SAr6xdgv9o8BZo1Noh6/oVk
        wjwqmsMEp3H5I9eyhhAPu6WCU6OdryI9qPtMn+Fj4FCiagZuGsCopB6uYuMcobVQ
        ==
X-ME-Sender: <xms:kcRMXyx3qkJojwFBm5bo7hkn3E4iD-Kz5aT8-P2iE052pQd0C54YJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedgudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:kcRMX-RhLNaN4qNqKQCOMhgiVZWRR-8__4x2eEPgA65NJEYH3fGHpA>
    <xmx:kcRMX0XeaP71K__ZZ4BGR1T8LdpIrLh6CQFa0HnHOkqR_QiIfJib_A>
    <xmx:kcRMX4gN2IxV2JuQ7K1Y8EqkyQ7rvsFTZxtwojJtDJJ7Ltv_AylTZQ>
    <xmx:kcRMX_qe1xC4WEYEpuKcac0UnJPXLm8V7xTmRoy2PaVemwa8OgWYs83BUJ0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5135B328005A;
        Mon, 31 Aug 2020 05:36:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: check the right error variable in" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 11:36:26 +0200
Message-ID: <15988665864130@kroah.com>
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
 

