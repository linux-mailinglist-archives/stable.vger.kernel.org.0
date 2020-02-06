Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD8EA154C37
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgBFTZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:25:46 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58409 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727836AbgBFTZq (ORCPT
        <rfc822;Stable@vger.kernel.org>); Thu, 6 Feb 2020 14:25:46 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 05F1E21D28;
        Thu,  6 Feb 2020 14:25:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 06 Feb 2020 14:25:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=zNS2Gy
        S7I3wBgIihgBz/M8lzhOJ0JTBEQpBLVwH3ZVU=; b=E1QaPRGjvlb1BKeeyLhu4M
        S+TARSJXPoKznRiV5NloRpvWGRCh2h3uIir0+pbUsvQBmSIyjkkskFcbI9Im4V8q
        jIZie5lkJ7i9lZ1x7EYI5f08FBSZfCI2N+ynoM5uh8nxGkWQVKkwKFnfi2i/IRer
        AwWcr18GY9QmTgcIAbpeIu07DWZ7gknWH5d6opmTUDJEtvlj4whdLDZOYqdcPr7d
        ID9s0b52SWvMNlUHuTwkEOOMffGdbMy9oGXo4uN7AgrK4mjdVRJYKsXBQncKoB9w
        rqmuzSlNTl5DBimVdZEY6Tj4g5iQ8JfrysgCD7tq7FZT32Yh8uj6EDeKNkZMdJDw
        ==
X-ME-Sender: <xms:OGg8XqA-38wBSyyy1AhzZ2N2goblRIELR_8QTP8xLp9V9PwuO6pmxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheefgdduvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:OGg8Xi-GwRQD47inZZ3BIHRbFNcF9W-4w44XQLtbTGXrsiwASVYnxQ>
    <xmx:OGg8Xq_Pwmdl7Dg5wqN_sU8poUCzo18CwAj8LEbn-pmahb_8oQguzQ>
    <xmx:OGg8Xr8sfiFQuDzOtqHUtcjPqkAYX4FvOe-q2VEwru5Wxky2GL7XwA>
    <xmx:OWg8XpYEjz1Gbq7M_G_OSQIqaKshakILhqtOUF9IWEYKmxUklLwMrA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 99C173280059;
        Thu,  6 Feb 2020 14:25:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] ubifs: Fix deadlock in concurrent bulk-read and writepage" failed to apply to 4.4-stable tree
To:     chengzhihao1@huawei.com, Stable@vger.kernel.org, richard@nod.at,
        yi.zhang@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 06 Feb 2020 20:20:48 +0100
Message-ID: <158101684823573@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From f5de5b83303e61b1f3fb09bd77ce3ac2d7a475f2 Mon Sep 17 00:00:00 2001
From: Zhihao Cheng <chengzhihao1@huawei.com>
Date: Sat, 11 Jan 2020 17:50:36 +0800
Subject: [PATCH] ubifs: Fix deadlock in concurrent bulk-read and writepage
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In ubifs, concurrent execution of writepage and bulk read on the same file
may cause ABBA deadlock, for example (Reproduce method see Link):

Process A(Bulk-read starts from page4)         Process B(write page4 back)
  vfs_read                                       wb_workfn or fsync
  ...                                            ...
  generic_file_buffered_read                     write_cache_pages
    ubifs_readpage                                 LOCK(page4)

      ubifs_bulk_read                              ubifs_writepage
        LOCK(ui->ui_mutex)                           ubifs_write_inode

	  ubifs_do_bulk_read                           LOCK(ui->ui_mutex)
	    find_or_create_page(alloc page4)                  ↑
	      LOCK(page4)                   <--     ABBA deadlock occurs!

In order to ensure the serialization execution of bulk read, we can't
remove the big lock 'ui->ui_mutex' in ubifs_bulk_read(). Instead, we
allow ubifs_do_bulk_read() to lock page failed by replacing
find_or_create_page(FGP_LOCK) with
pagecache_get_page(FGP_LOCK | FGP_NOWAIT).

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Suggested-by: zhangyi (F) <yi.zhang@huawei.com>
Cc: <Stable@vger.kernel.org>
Fixes: 4793e7c5e1c ("UBIFS: add bulk-read facility")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206153
Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index cd52585c8f4f..c649048fcc81 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -786,7 +786,9 @@ static int ubifs_do_bulk_read(struct ubifs_info *c, struct bu_info *bu,
 
 		if (page_offset > end_index)
 			break;
-		page = find_or_create_page(mapping, page_offset, ra_gfp_mask);
+		page = pagecache_get_page(mapping, page_offset,
+				 FGP_LOCK|FGP_ACCESSED|FGP_CREAT|FGP_NOWAIT,
+				 ra_gfp_mask);
 		if (!page)
 			break;
 		if (!PageUptodate(page))

