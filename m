Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944C92B49E0
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 16:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730264AbgKPPsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 10:48:43 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:54041 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729057AbgKPPsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 10:48:42 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 895C1C55;
        Mon, 16 Nov 2020 10:48:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 16 Nov 2020 10:48:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=yyfD0j
        aMVvEBhAotNtQe9zCt5cjNiHoFf60elYv+fc4=; b=eO/6yDebJGiSSnPI/zRua6
        +NSIhAkyCCckdxhThFD8IaHqzPHq+eWU9fIP1sb6j0EY6dA1WGen0rMZDCvyhUFF
        R72fEhVY2B4rAPexVZCw9crDMMq0zo2ltgOucrGqJ8Eei5rhFeR/2fUXKUirNUAY
        wATATkdXFyU6KSSDRxGC0X7y02qbwsopxpXUwhU+AwbPZIEOAqsXI9kv8Zpcnm1b
        AbWNi9TBqKaDh+koV6k4Ff8oLmm9MwzHz4KbAjrwQO1VzrZq5uqOHwXBKltUNFCC
        t/bPbFMwhMoTszG6iOyf7wDAVopKskClG6n2tzFh1mfrDoIqKkZfeG6+U6ATu/fg
        ==
X-ME-Sender: <xms:WZ-yXxX_7lcXMlEKgeTj3BLn2TntnHz_7x2vJYlxdGpJDK8B3qZJNw>
    <xme:WZ-yXxmWQc8azWtQtvtgOyYH-TA5mF8Vy-K-5Hdf4EE1257HWR-vBaXkW7frJ4sQX
    L7nXbfVk6BrOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefuddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:WZ-yX9a2MzD_7b7D466RSmwchUIxQvcjis1W8IerVwN8k-mA22gxkQ>
    <xmx:WZ-yX0WJdGL3045zOV-dCO7AX9hORMIXgbw_hBAmJ_TZpzoZz_hFCA>
    <xmx:WZ-yX7k00jxdGkY8OgeuHifg0L3cHoIsBnBpBEZ-JfYSmmSPDuTAag>
    <xmx:WZ-yXzuYl9_E7XmidB93_MbzLa8B6dd9mKEe8HJZgdbwSrBtHokwlg0TqDQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B6397328005A;
        Mon, 16 Nov 2020 10:48:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: fix potential overflow in cluster_pages_for_defrag on" failed to apply to 4.19-stable tree
To:     willy@infradead.org, dsterba@suse.com, josef@toxicpanda.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Nov 2020 16:49:26 +0100
Message-ID: <160554176617964@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

