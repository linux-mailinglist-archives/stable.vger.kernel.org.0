Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520AB2E3556
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgL1JOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:14:02 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:43757 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1JOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:14:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0B10A61D;
        Mon, 28 Dec 2020 04:13:15 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:13:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Vl5Dt/
        bjZt825MCq7jVefzthXG+W+Z8IGlAueKYJWck=; b=BwGlykpYvZI8wxMg2/4lLe
        dn/kHwvggrPyLO12xVDfRffAazFIG4yNSuo0FF0DG2yb0jLGU+ON1LVUzk0WnMXu
        E7jYG2NAbmA+4cgRoBs8HMhesDv/sx5loGW7s7niZ7uUzLpO44/9hzG4yU3JxqGB
        HdQlyF0ajBukFdm5rvvxFkD7SkGyJ78zSCPZGzX8yQ7qxWsYl5lfA6lPl/bs6t/L
        EPsnPa3UStiayRD0u4JPin+YfM0SmOF3qbM9TnQvpFN9/SlpZO2WYGCUSEekXvZW
        DK3rpCjVR+SJmlAJP+0PrF1ex6I9LUEAiihvITdiErrsvpn19meGoPNqXH60yZwg
        ==
X-ME-Sender: <xms:q6HpXzJegy2zvU87SdFyVJ4ao0cO07F25wf_CdhPpXJowz5t6Y0J9g>
    <xme:q6HpX3IjnuFhfF5vDtDH8nhPDHOY5bgiorZt1lJVBptrM7-AAO1izEN8T0i8L3ZXC
    iUIBWum2rsoZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:q6HpX7vbpaSBPsgHUS6qArGMEmbmnZWQ4ZxSCk4qiDAixUpuqjusYA>
    <xmx:q6HpX8b8Tx1OKCDtPLdfaK4YF0PnQMxkEAxq9ue8o8aZI9YZcmJlBA>
    <xmx:q6HpX6ZI9E7nf1-odPwAQ-gcTg8-zvTUIQxja_PfSVEtBexDA5N1cg>
    <xmx:q6HpX9yaQxP1ChKw4xDX4Gcx0k48PMkOwfYVmkfZrTaJI90K3Sl9bpiw-9Y>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E0303108005C;
        Mon, 28 Dec 2020 04:13:14 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix race when defragmenting leads to unnecessary IO" failed to apply to 5.4-stable tree
To:     fdmanana@suse.com, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:14:38 +0100
Message-ID: <1609146878228106@kroah.com>
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

From 7f458a3873ae94efe1f37c8b96c97e7298769e98 Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Wed, 4 Nov 2020 11:07:33 +0000
Subject: [PATCH] btrfs: fix race when defragmenting leads to unnecessary IO

When defragmenting we skip ranges that have holes or inline extents, so that
we don't do unnecessary IO and waste space. We do this check when calling
should_defrag_range() at btrfs_defrag_file(). However we do it without
holding the inode's lock. The reason we do it like this is to avoid
blocking other tasks for too long, that possibly want to operate on other
file ranges, since after the call to should_defrag_range() and before
locking the inode, we trigger a synchronous page cache readahead. However
before we were able to lock the inode, some other task might have punched
a hole in our range, or we may now have an inline extent there, in which
case we should not set the range for defrag anymore since that would cause
unnecessary IO and make us waste space (i.e. allocating extents to contain
zeros for a hole).

So after we locked the inode and the range in the iotree, check again if
we have holes or an inline extent, and if we do, just skip the range.

I hit this while testing my next patch that fixes races when updating an
inode's number of bytes (subject "btrfs: update the number of bytes used
by an inode atomically"), and it depends on this change in order to work
correctly. Alternatively I could rework that other patch to detect holes
and flag their range with the 'new delalloc' bit, but this itself fixes
an efficiency problem due a race that from a functional point of view is
not harmful (it could be triggered with btrfs/062 from fstests).

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ea40a19cc4cb..2904f92c3813 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1275,6 +1275,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	u64 page_end;
 	u64 page_cnt;
 	u64 start = (u64)start_index << PAGE_SHIFT;
+	u64 search_start;
 	int ret;
 	int i;
 	int i_done;
@@ -1371,6 +1372,40 @@ static int cluster_pages_for_defrag(struct inode *inode,
 
 	lock_extent_bits(&BTRFS_I(inode)->io_tree,
 			 page_start, page_end - 1, &cached_state);
+
+	/*
+	 * When defragmenting we skip ranges that have holes or inline extents,
+	 * (check should_defrag_range()), to avoid unnecessary IO and wasting
+	 * space. At btrfs_defrag_file(), we check if a range should be defragged
+	 * before locking the inode and then, if it should, we trigger a sync
+	 * page cache readahead - we lock the inode only after that to avoid
+	 * blocking for too long other tasks that possibly want to operate on
+	 * other file ranges. But before we were able to get the inode lock,
+	 * some other task may have punched a hole in the range, or we may have
+	 * now an inline extent, in which case we should not defrag. So check
+	 * for that here, where we have the inode and the range locked, and bail
+	 * out if that happened.
+	 */
+	search_start = page_start;
+	while (search_start < page_end) {
+		struct extent_map *em;
+
+		em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, search_start,
+				      page_end - search_start);
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
+			goto out_unlock_range;
+		}
+		if (em->block_start >= EXTENT_MAP_LAST_BYTE) {
+			free_extent_map(em);
+			/* Ok, 0 means we did not defrag anything */
+			ret = 0;
+			goto out_unlock_range;
+		}
+		search_start = extent_map_end(em);
+		free_extent_map(em);
+	}
+
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start,
 			  page_end - 1, EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
 			  EXTENT_DEFRAG, 0, 0, &cached_state);
@@ -1401,6 +1436,10 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT);
 	extent_changeset_free(data_reserved);
 	return i_done;
+
+out_unlock_range:
+	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
+			     page_start, page_end - 1, &cached_state);
 out:
 	for (i = 0; i < i_done; i++) {
 		unlock_page(pages[i]);

