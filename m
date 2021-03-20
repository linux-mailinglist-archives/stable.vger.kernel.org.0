Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA97342C48
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 12:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbhCTLei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Mar 2021 07:34:38 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:41499 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229640AbhCTLeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Mar 2021 07:34:08 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B46AE1940B19;
        Sat, 20 Mar 2021 07:34:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 20 Mar 2021 07:34:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lMO0fy
        dvVNSNtI+JL456RXTa5kHr0RkFr/0xAeRBvOE=; b=ZjTEs3PrDCBeNqyN9mLcnY
        8IN8GTsve0ikJd/APXY9EdAlF1mo7V/RlsYTjKQ2MI8VVziewaTQuHrqgLZmGaiF
        fYIOGUMoW86wk69Uy1Ffnqg5HMTI9UCXEJspmXwgm0VXMlN7CpoLzG3ZANBrn9dK
        s3VjciaD90lvFtBkMqCVTZJpfzYEzQ7IuP2n//1FqCSk2yjondvPO8SDEzcXNaRI
        cEzMsBPPoBLI1j50DNnH+xQ5BIvgQCtf+iHE0QsUlgt0hxLzcY3bsi96QdXCeR2q
        mytJBjl3Qt4YhlPWpOBDa89HlbtEIQk5CKNNewPWLLnAkTd3NS2nvnQsxMua3T7w
        ==
X-ME-Sender: <xms:r91VYH9LSomsZXs4E70pDaB7gGKZXmb0E2lHdzFeZo0-IU83h81Z8w>
    <xme:r91VYDtbgDdEHbwZIY8PUBsyMA6I-GgADr9XyONldMWAvrJoOXLlCydKQo-0IaUxL
    Ev6rNIJW8_jKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegtddgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:r91VYFAyYi-YNy0vtGoIQze2_HPPvEXTGaVySfs-G0Ntb1UbSlepQw>
    <xmx:r91VYDe4pmwdKqbevKKti05p-gu-RTxgRCeWsTQmxSlbN734kw-VZg>
    <xmx:r91VYMOddc2L7I3zgvGrpttrgRL7CjjZV-XLFGFuHhsG76ZrUBYqLw>
    <xmx:r91VYGVJxTYrGQtvHk95df8yPPlk6ExI_sQy6kPLdHamz5vbcaZCGw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 625DA240113;
        Sat, 20 Mar 2021 07:34:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: always pin deleted leaves when there are active tree" failed to apply to 5.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 20 Mar 2021 12:34:03 +0100
Message-ID: <1616240043203158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

