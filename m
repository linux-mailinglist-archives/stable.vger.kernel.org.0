Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F962B49DF
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 16:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730893AbgKPPsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 10:48:40 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:54659 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729057AbgKPPsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 10:48:40 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id AAB8FC6A;
        Mon, 16 Nov 2020 10:48:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 16 Nov 2020 10:48:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jHsf0W
        UfSRQzPBvCeL6s/Wtu/IlY3oeSVsRplXJ/MDE=; b=azOhwjtLBKle8rG0xOZ7rj
        nrxNbGSFYIlIiyF9msoCyB8iPhzWNzMTHKgKnPJrHQh0aoO9v9Fzgq/zBWXsCdHO
        3/8UNFwc980WnKnhmJtTPpuhbL6wNGOEftoURWG7AfkSTbjYBG6mrlMa6ozg0bY+
        PM3x2qheoAS+NYVqFSd5fV0P7apamtQxTlwrLk6FbdfqswhQE7nc3K+NkKD3NcrS
        Um9SU0iw96EE0h0H9kbq8ikWglX6zERPhFGWlbOG215uGX4muAnvBXjDRyAZ9FFq
        +Hv6Gu+3lb+MiRUKdyKT6M2mKRFGaT2+XjQIJmHzW0MUY5F2ItPxgbPPbp3Vglag
        ==
X-ME-Sender: <xms:V5-yX2-w5GfUxAtJSSwLIujDbAuywIh7xAT822WeJjyxSLDi-CbhWA>
    <xme:V5-yX2v1LON6qklD_l15r2LXONEMws2ayoTcaR3EOMCJXMxVHhkfnSWIxLsCq6BIo
    QXHU5lm7_w7BA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefuddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:V5-yX8D4ph7Hxvi3UvFgye4Y2IflI6UGlZ62P62uiA437e0-OLAEAw>
    <xmx:V5-yX-fVdybPBbzlGjVNl31uadlkj2X90cxM-dYp_oPUhRbtb0e1pw>
    <xmx:V5-yX7Nha8pThxRn9TirliF8tMm6Oi-O42FFFiTZIVM9e-sCVKLEjQ>
    <xmx:V5-yXx0XB-J2YqYimblvWrI3RLm5Orm_SKAj4DvRGxezQlB0nMjHd5BreVo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EAC5E3064AB2;
        Mon, 16 Nov 2020 10:48:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix potential overflow in cluster_pages_for_defrag on" failed to apply to 5.4-stable tree
To:     willy@infradead.org, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Nov 2020 16:49:26 +0100
Message-ID: <160554176663142@kroah.com>
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

From a1fbc6750e212c5675a4e48d7f51d44607eb8756 Mon Sep 17 00:00:00 2001
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Sun, 4 Oct 2020 19:04:26 +0100
Subject: [PATCH] btrfs: fix potential overflow in cluster_pages_for_defrag on
 32bit arch

On 32-bit systems, this shift will overflow for files larger than 4GB as
start_index is unsigned long while the calls to btrfs_delalloc_*_space
expect u64.

CC: stable@vger.kernel.org # 4.4+
Fixes: df480633b891 ("btrfs: extent-tree: Switch to new delalloc space reserve and release")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Sterba <dsterba@suse.com>
[ define the variable instead of repeating the shift ]
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ab408a23ba32..69a384145dc6 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1274,6 +1274,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	u64 page_start;
 	u64 page_end;
 	u64 page_cnt;
+	u64 start = (u64)start_index << PAGE_SHIFT;
 	int ret;
 	int i;
 	int i_done;
@@ -1290,8 +1291,7 @@ static int cluster_pages_for_defrag(struct inode *inode,
 	page_cnt = min_t(u64, (u64)num_pages, (u64)file_end - start_index + 1);
 
 	ret = btrfs_delalloc_reserve_space(BTRFS_I(inode), &data_reserved,
-			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT);
+			start, page_cnt << PAGE_SHIFT);
 	if (ret)
 		return ret;
 	i_done = 0;
@@ -1380,8 +1380,7 @@ again:
 		btrfs_mod_outstanding_extents(BTRFS_I(inode), 1);
 		spin_unlock(&BTRFS_I(inode)->lock);
 		btrfs_delalloc_release_space(BTRFS_I(inode), data_reserved,
-				start_index << PAGE_SHIFT,
-				(page_cnt - i_done) << PAGE_SHIFT, true);
+				start, (page_cnt - i_done) << PAGE_SHIFT, true);
 	}
 
 
@@ -1408,8 +1407,7 @@ out:
 		put_page(pages[i]);
 	}
 	btrfs_delalloc_release_space(BTRFS_I(inode), data_reserved,
-			start_index << PAGE_SHIFT,
-			page_cnt << PAGE_SHIFT, true);
+			start, page_cnt << PAGE_SHIFT, true);
 	btrfs_delalloc_release_extents(BTRFS_I(inode), page_cnt << PAGE_SHIFT);
 	extent_changeset_free(data_reserved);
 	return ret;

