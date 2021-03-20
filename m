Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C740342C44
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhCTLei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:34:38 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:60063 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229510AbhCTLeH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 07:34:07 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 203B41940722;
        Sat, 20 Mar 2021 07:34:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sat, 20 Mar 2021 07:34:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nROOT8
        mLcrqbO0jgagNEz7dcNACORUcre1IDyUq+fQA=; b=aq3ioVTR6rkLcu8fAsK5NU
        F2AaTXf1brYR0grs/UJ+WBLoNZi6+6cT1tej8sXvl4x2Yy1w7nZuOu2agmzmLSz6
        yEMkWRKcuahreVxRRSRIee3IdjDBEhWHra5zfDuGfiVIrulgzJ1l/BK49w5ZjOEq
        Uj3Wn07RUQdPGbK7PQZVm+d5qJGbUMaqS+7CX4rvY8YyXaWBfeL4a/OwNRhRaHdt
        oDrfem0EWR5nMz56x2chX2h+eUd5ECnyXRvhdCozweFOup6WG0ObLC/gzeKS7Fdl
        OSdjcFinzIMwVAxiX9y+6ZA+hJlo6MyMgI1WGRtxCQbavWTfvJXIcdckPfuf75kA
        ==
X-ME-Sender: <xms:rd1VYKB3F7ZhSfTxGhTZOG_CkIHd-V9OG_Y25ZkIeLQlfeMA3wKCDg>
    <xme:rd1VYOJhjIDpDnuzi6bqEPPWGn95v8GffOyjl01Mb3BGaF4IhZqiuKyA1rZpm8hnw
    shP7Qbdk9NP4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegtddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:rd1VYNmw4MV7PTIBQXXUY_ePQh4jc-9NcgLgHcRqUJuQ_J4gYvc-Rg>
    <xmx:rd1VYMFKGIoQEiArxsHsmqlgJPk08Da4wlmH0qVL5MZo7fqzTHHQHw>
    <xmx:rd1VYNG9N9DP54Jd746JLnT_7Fh0rG0IsUJJvz4MA7pe7RsMqQodvg>
    <xmx:rt1VYHmE78ZpG2l9Yeg6UoflDgP3KtygqwSYiEHw0sJQaWBfY5C5Pw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id ACEA21080057;
        Sat, 20 Mar 2021 07:34:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: always pin deleted leaves when there are active tree" failed to apply to 5.10-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 20 Mar 2021 12:34:01 +0100
Message-ID: <161624004185120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 485df75554257e883d0ce39bb886e8212349748e Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Thu, 11 Mar 2021 14:31:06 +0000
Subject: [PATCH] btrfs: always pin deleted leaves when there are active tree
 mod log users

When freeing a tree block we may end up adding its extent back to the
free space cache/tree, as long as there are no more references for it,
it was created in the current transaction and writeback for it never
happened. This is generally fine, however when we have tree mod log
operations it can result in inconsistent versions of a btree after
unwinding extent buffers with the recorded tree mod log operations.

This is because:

* We only log operations for nodes (adding and removing key/pointers),
  for leaves we don't do anything;

* This means that we can log a MOD_LOG_KEY_REMOVE_WHILE_FREEING operation
  for a node that points to a leaf that was deleted;

* Before we apply the logged operation to unwind a node, we can have
  that leaf's extent allocated again, either as a node or as a leaf, and
  possibly for another btree. This is possible if the leaf was created in
  the current transaction and writeback for it never started, in which
  case btrfs_free_tree_block() returns its extent back to the free space
  cache/tree;

* Then, before applying the tree mod log operation, some task allocates
  the metadata extent just freed before, and uses it either as a leaf or
  as a node for some btree (can be the same or another one, it does not
  matter);

* After applying the MOD_LOG_KEY_REMOVE_WHILE_FREEING operation we now
  get the target node with an item pointing to the metadata extent that
  now has content different from what it had before the leaf was deleted.
  It might now belong to a different btree and be a node and not a leaf
  anymore.

  As a consequence, the results of searches after the unwinding can be
  unpredictable and produce unexpected results.

So make sure we pin extent buffers corresponding to leaves when there
are tree mod log users.

CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 78ad31a59e59..36a3c973fda1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3323,6 +3323,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 
 	if (last_ref && btrfs_header_generation(buf) == trans->transid) {
 		struct btrfs_block_group *cache;
+		bool must_pin = false;
 
 		if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
 			ret = check_ref_cleanup(trans, buf->start);
@@ -3340,7 +3341,27 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 			goto out;
 		}
 
-		if (btrfs_is_zoned(fs_info)) {
+		/*
+		 * If this is a leaf and there are tree mod log users, we may
+		 * have recorded mod log operations that point to this leaf.
+		 * So we must make sure no one reuses this leaf's extent before
+		 * mod log operations are applied to a node, otherwise after
+		 * rewinding a node using the mod log operations we get an
+		 * inconsistent btree, as the leaf's extent may now be used as
+		 * a node or leaf for another different btree.
+		 * We are safe from races here because at this point no other
+		 * node or root points to this extent buffer, so if after this
+		 * check a new tree mod log user joins, it will not be able to
+		 * find a node pointing to this leaf and record operations that
+		 * point to this leaf.
+		 */
+		if (btrfs_header_level(buf) == 0) {
+			read_lock(&fs_info->tree_mod_log_lock);
+			must_pin = !list_empty(&fs_info->tree_mod_seq_list);
+			read_unlock(&fs_info->tree_mod_log_lock);
+		}
+
+		if (must_pin || btrfs_is_zoned(fs_info)) {
 			btrfs_redirty_list_add(trans->transaction, buf);
 			pin_down_extent(trans, cache, buf->start, buf->len, 1);
 			btrfs_put_block_group(cache);

