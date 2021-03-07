Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1623301CB
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhCGN7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:59:21 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:40871 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231910AbhCGN6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:58:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id D11C31A7B;
        Sun,  7 Mar 2021 08:58:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:58:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=R3bw9G
        IE2lS48EoPDMh7YfPsM3MCJnvyBbB6g/2I+yk=; b=k0razTRvcmgi3ymE6Njgoj
        05ci5AWoV5vU3VgGqQciGC9NxS4hoxj2dc5QUZCEdaBBrazPg3ensm/Dv4da8ukh
        kd2ex6YLGDhMlW+XrBo/wly/FzASQvr827rXsCRZWLBbHqS98uLgHjuA+ldOK5ri
        HtWwNzvPwZyrNEWnI+/12e+KD3myMLW3lZrlKGfHfH3ByaB3cJ4MTTU7YwKIHQAU
        t5l6ip8LUa1UzaGp/QkzWOTj9pY8nY2re9my5UtwGTtqr8piacNMsUsGoN6lYGha
        FKHeOi7/3NOXhIdG6Mqn9Ed5W6E3EUeYKKEPJOF+on3Uv5orMysRVsSjF0H50Q6w
        ==
X-ME-Sender: <xms:G9xEYFeZ_8nehqLO7RLFwb1vZkSUiVhVc3LfQ89MruHZJVraoqROYw>
    <xme:G9xEYDOQwrvNW0k9fIvh--M2ywRGsWz_5gOpeUKC2_cnzotMKaK0RfI7GFXnzuKLh
    tIebZmkpS-TSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:G9xEYOiPyd960HBup_98UVR28-sq5Vcx4miz5rsMLhAasHt61oDtvQ>
    <xmx:G9xEYO8h4H59M2HVacxIWx1fJnUsUF8hWiiZue3ravl6Zm0S3w2A8w>
    <xmx:G9xEYBvxgiqMZm5juqc3H4WJ1CPJzpHu4_QOol1fcNGUiwVV20L9Ng>
    <xmx:G9xEYCXc2QNLokTF3pdAFBFZw-_SiafunhNy8-lN_DSyg3vKPk3-BJRRV0U>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0890124005C;
        Sun,  7 Mar 2021 08:58:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: don't flush from btrfs_delayed_inode_reserve_metadata" failed to apply to 5.11-stable tree
To:     nborisov@suse.com, dsterba@suse.com, wqu@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:58:49 +0100
Message-ID: <161512552914112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4d14c5cde5c268a2bc26addecf09489cb953ef64 Mon Sep 17 00:00:00 2001
From: Nikolay Borisov <nborisov@suse.com>
Date: Mon, 22 Feb 2021 18:40:44 +0200
Subject: [PATCH] btrfs: don't flush from btrfs_delayed_inode_reserve_metadata

Calling btrfs_qgroup_reserve_meta_prealloc from
btrfs_delayed_inode_reserve_metadata can result in flushing delalloc
while holding a transaction and delayed node locks. This is deadlock
prone. In the past multiple commits:

 * ae5e070eaca9 ("btrfs: qgroup: don't try to wait flushing if we're
already holding a transaction")

 * 6f23277a49e6 ("btrfs: qgroup: don't commit transaction when we already
 hold the handle")

Tried to solve various aspects of this but this was always a
whack-a-mole game. Unfortunately those 2 fixes don't solve a deadlock
scenario involving btrfs_delayed_node::mutex. Namely, one thread
can call btrfs_dirty_inode as a result of reading a file and modifying
its atime:

  PID: 6963   TASK: ffff8c7f3f94c000  CPU: 2   COMMAND: "test"
  #0  __schedule at ffffffffa529e07d
  #1  schedule at ffffffffa529e4ff
  #2  schedule_timeout at ffffffffa52a1bdd
  #3  wait_for_completion at ffffffffa529eeea             <-- sleeps with delayed node mutex held
  #4  start_delalloc_inodes at ffffffffc0380db5
  #5  btrfs_start_delalloc_snapshot at ffffffffc0393836
  #6  try_flush_qgroup at ffffffffc03f04b2
  #7  __btrfs_qgroup_reserve_meta at ffffffffc03f5bb6     <-- tries to reserve space and starts delalloc inodes.
  #8  btrfs_delayed_update_inode at ffffffffc03e31aa      <-- acquires delayed node mutex
  #9  btrfs_update_inode at ffffffffc0385ba8
 #10  btrfs_dirty_inode at ffffffffc038627b               <-- TRANSACTIION OPENED
 #11  touch_atime at ffffffffa4cf0000
 #12  generic_file_read_iter at ffffffffa4c1f123
 #13  new_sync_read at ffffffffa4ccdc8a
 #14  vfs_read at ffffffffa4cd0849
 #15  ksys_read at ffffffffa4cd0bd1
 #16  do_syscall_64 at ffffffffa4a052eb
 #17  entry_SYSCALL_64_after_hwframe at ffffffffa540008c

This will cause an asynchronous work to flush the delalloc inodes to
happen which can try to acquire the same delayed_node mutex:

  PID: 455    TASK: ffff8c8085fa4000  CPU: 5   COMMAND: "kworker/u16:30"
  #0  __schedule at ffffffffa529e07d
  #1  schedule at ffffffffa529e4ff
  #2  schedule_preempt_disabled at ffffffffa529e80a
  #3  __mutex_lock at ffffffffa529fdcb                    <-- goes to sleep, never wakes up.
  #4  btrfs_delayed_update_inode at ffffffffc03e3143      <-- tries to acquire the mutex
  #5  btrfs_update_inode at ffffffffc0385ba8              <-- this is the same inode that pid 6963 is holding
  #6  cow_file_range_inline.constprop.78 at ffffffffc0386be7
  #7  cow_file_range at ffffffffc03879c1
  #8  btrfs_run_delalloc_range at ffffffffc038894c
  #9  writepage_delalloc at ffffffffc03a3c8f
 #10  __extent_writepage at ffffffffc03a4c01
 #11  extent_write_cache_pages at ffffffffc03a500b
 #12  extent_writepages at ffffffffc03a6de2
 #13  do_writepages at ffffffffa4c277eb
 #14  __filemap_fdatawrite_range at ffffffffa4c1e5bb
 #15  btrfs_run_delalloc_work at ffffffffc0380987         <-- starts running delayed nodes
 #16  normal_work_helper at ffffffffc03b706c
 #17  process_one_work at ffffffffa4aba4e4
 #18  worker_thread at ffffffffa4aba6fd
 #19  kthread at ffffffffa4ac0a3d
 #20  ret_from_fork at ffffffffa54001ff

To fully address those cases the complete fix is to never issue any
flushing while holding the transaction or the delayed node lock. This
patch achieves it by calling qgroup_reserve_meta directly which will
either succeed without flushing or will fail and return -EDQUOT. In the
latter case that return value is going to be propagated to
btrfs_dirty_inode which will fallback to start a new transaction. That's
fine as the majority of time we expect the inode will have
BTRFS_DELAYED_NODE_INODE_DIRTY flag set which will result in directly
copying the in-memory state.

Fixes: c53e9653605d ("btrfs: qgroup: try to flush qgroup space when we get -EDQUOT")
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index ac9966e76a2f..bf25401c9768 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -627,7 +627,8 @@ static int btrfs_delayed_inode_reserve_metadata(
 	 */
 	if (!src_rsv || (!trans->bytes_reserved &&
 			 src_rsv->type != BTRFS_BLOCK_RSV_DELALLOC)) {
-		ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true);
+		ret = btrfs_qgroup_reserve_meta(root, num_bytes,
+					  BTRFS_QGROUP_RSV_META_PREALLOC, true);
 		if (ret < 0)
 			return ret;
 		ret = btrfs_block_rsv_add(root, dst_rsv, num_bytes,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4f2f1e932751..c35b724a5611 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6081,7 +6081,7 @@ static int btrfs_dirty_inode(struct inode *inode)
 		return PTR_ERR(trans);
 
 	ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
-	if (ret && ret == -ENOSPC) {
+	if (ret && (ret == -ENOSPC || ret == -EDQUOT)) {
 		/* whoops, lets try again with the full transaction */
 		btrfs_end_transaction(trans);
 		trans = btrfs_start_transaction(root, 1);

