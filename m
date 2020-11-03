Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11002A4700
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 14:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgKCNyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 08:54:23 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:45965 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729414AbgKCNws (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 08:52:48 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6137AB12;
        Tue,  3 Nov 2020 08:52:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 08:52:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=YRz9o5
        y42F5ONkK/QdvvhPf+wtBJjV9VtT5JWgpFjxE=; b=nuAMdhsjVFX/Ov1lk6m1DT
        EF7JBchGGd3QdY370R7jJNDEHQxcK57ejf4Zd+pjzgr2oBPFyVlZtj2NGxTAVlWa
        8KcZ+0rPSkxrTBmu6LegVmUStYo1ohPzg8js0y/HX/qAdX/OEUqC+cYWI9LabM5i
        Du7dr4NOHT/4bR3cXuWJomR0dfjng5lN8KlnMN0lm4fjcu4B8/h7/uT2AO7a9k6b
        ZjOPPCM9Uj90YN/PLlMRCp183Qa4EZw/UiKmqdCJlFhH2k2dC7DF4qc8lzFeF7+l
        aRYIaKS8brYQG/m1CgG220nXAvHNH0Ym62ne2gta2tkj981cLU1OgrjarJV0rbWA
        ==
X-ME-Sender: <xms:rmChXxOuhexOR4tFlaIy-dKwM_HzfPSCYzF9bs0mQsM9S_ncGNsalQ>
    <xme:rmChXz9MygqRdHjg_HB5cEy438BgQVUSzm23I2Zh1ZDQzkAB2065iHZ1Vk8Y9wrsX
    dEcfPjTWjKGWg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepuddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:rmChXwRpFzweR7jRFk2XGcUaR7bGFY6sM-Klwf-xO7bCsfmE6n1FAA>
    <xmx:rmChX9u65CrD9hVUyuGXvtj-vTQAbT7O__0H5s6JbvCITHSewk088g>
    <xmx:rmChX5cVbCsWgwfUrj3r51o6L-kZnAD82J2tFzgyABlVHBFStfIwIQ>
    <xmx:rmChX5EmiLlmpfZvo22sTGPbPmdlhSUVPvkzRtZyrbmbjeldkBD_HIqCy-8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 542D13280066;
        Tue,  3 Nov 2020 08:52:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: tracepoints: output proper root owner for" failed to apply to 5.4-stable tree
To:     wqu@suse.com, dsterba@suse.com, hans@knorrie.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 14:53:40 +0100
Message-ID: <160441162020482@kroah.com>
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

From 437490fed3b0c9ae21af8f70e0f338d34560842b Mon Sep 17 00:00:00 2001
From: Qu Wenruo <wqu@suse.com>
Date: Tue, 28 Jul 2020 09:42:49 +0800
Subject: [PATCH] btrfs: tracepoints: output proper root owner for
 trace_find_free_extent()

The current trace event always output result like this:

 find_free_extent: root=2(EXTENT_TREE) len=16384 empty_size=0 flags=4(METADATA)
 find_free_extent: root=2(EXTENT_TREE) len=16384 empty_size=0 flags=4(METADATA)
 find_free_extent: root=2(EXTENT_TREE) len=8192 empty_size=0 flags=1(DATA)
 find_free_extent: root=2(EXTENT_TREE) len=8192 empty_size=0 flags=1(DATA)
 find_free_extent: root=2(EXTENT_TREE) len=4096 empty_size=0 flags=1(DATA)
 find_free_extent: root=2(EXTENT_TREE) len=4096 empty_size=0 flags=1(DATA)

T's saying we're allocating data extent for EXTENT tree, which is not
even possible.

It's because we always use EXTENT tree as the owner for
trace_find_free_extent() without using the @root from
btrfs_reserve_extent().

This patch will change the parameter to use proper @root for
trace_find_free_extent():

Now it looks much better:

 find_free_extent: root=5(FS_TREE) len=16384 empty_size=0 flags=36(METADATA|DUP)
 find_free_extent: root=5(FS_TREE) len=8192 empty_size=0 flags=1(DATA)
 find_free_extent: root=5(FS_TREE) len=16384 empty_size=0 flags=1(DATA)
 find_free_extent: root=5(FS_TREE) len=4096 empty_size=0 flags=1(DATA)
 find_free_extent: root=5(FS_TREE) len=8192 empty_size=0 flags=1(DATA)
 find_free_extent: root=5(FS_TREE) len=16384 empty_size=0 flags=36(METADATA|DUP)
 find_free_extent: root=7(CSUM_TREE) len=16384 empty_size=0 flags=36(METADATA|DUP)
 find_free_extent: root=2(EXTENT_TREE) len=16384 empty_size=0 flags=36(METADATA|DUP)
 find_free_extent: root=1(ROOT_TREE) len=16384 empty_size=0 flags=36(METADATA|DUP)

Reported-by: Hans van Kranenburg <hans@knorrie.org>
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 780b9c9a98fe..dbff61d36cab 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3918,11 +3918,12 @@ static int prepare_allocation(struct btrfs_fs_info *fs_info,
  * |- Push harder to find free extents
  *    |- If not found, re-iterate all block groups
  */
-static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
+static noinline int find_free_extent(struct btrfs_root *root,
 				u64 ram_bytes, u64 num_bytes, u64 empty_size,
 				u64 hint_byte_orig, struct btrfs_key *ins,
 				u64 flags, int delalloc)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret = 0;
 	int cache_block_group_error = 0;
 	struct btrfs_block_group *block_group = NULL;
@@ -3954,7 +3955,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	ins->objectid = 0;
 	ins->offset = 0;
 
-	trace_find_free_extent(fs_info, num_bytes, empty_size, flags);
+	trace_find_free_extent(root, num_bytes, empty_size, flags);
 
 	space_info = btrfs_find_space_info(fs_info, flags);
 	if (!space_info) {
@@ -4203,7 +4204,7 @@ int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes,
 	flags = get_alloc_profile_by_root(root, is_data);
 again:
 	WARN_ON(num_bytes < fs_info->sectorsize);
-	ret = find_free_extent(fs_info, ram_bytes, num_bytes, empty_size,
+	ret = find_free_extent(root, ram_bytes, num_bytes, empty_size,
 			       hint_byte, ins, flags, delalloc);
 	if (!ret && !is_data) {
 		btrfs_dec_block_group_reservations(fs_info, ins->objectid);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 863335ecb7e8..b9241836d4f7 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1176,25 +1176,27 @@ DEFINE_EVENT(btrfs__reserved_extent,  btrfs_reserved_extent_free,
 
 TRACE_EVENT(find_free_extent,
 
-	TP_PROTO(const struct btrfs_fs_info *fs_info, u64 num_bytes,
+	TP_PROTO(const struct btrfs_root *root, u64 num_bytes,
 		 u64 empty_size, u64 data),
 
-	TP_ARGS(fs_info, num_bytes, empty_size, data),
+	TP_ARGS(root, num_bytes, empty_size, data),
 
 	TP_STRUCT__entry_btrfs(
+		__field(	u64,	root_objectid		)
 		__field(	u64,	num_bytes		)
 		__field(	u64,	empty_size		)
 		__field(	u64,	data			)
 	),
 
-	TP_fast_assign_btrfs(fs_info,
+	TP_fast_assign_btrfs(root->fs_info,
+		__entry->root_objectid	= root->root_key.objectid;
 		__entry->num_bytes	= num_bytes;
 		__entry->empty_size	= empty_size;
 		__entry->data		= data;
 	),
 
 	TP_printk_btrfs("root=%llu(%s) len=%llu empty_size=%llu flags=%llu(%s)",
-		  show_root_type(BTRFS_EXTENT_TREE_OBJECTID),
+		  show_root_type(__entry->root_objectid),
 		  __entry->num_bytes, __entry->empty_size, __entry->data,
 		  __print_flags((unsigned long)__entry->data, "|",
 				 BTRFS_GROUP_FLAGS))

