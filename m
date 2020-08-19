Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346EE249F82
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 15:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgHSNVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 09:21:53 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:40031 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728548AbgHSNVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 09:21:42 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 8DDCEC2B;
        Wed, 19 Aug 2020 09:21:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 09:21:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+OpZLh
        GmIlBLYfY7mgSd0d+YkB5oSJD5ud7d9RYUryU=; b=qTJCRdXoItbc9fu/vTyIzn
        OQa/uOlCEnOVIqN5x13VuO7lO4CUyb1UIcDyQzhvH4k4aONzEObYihthRPy7Ps10
        vUavbfY4XmvoElpC3EiCy6rlFxJKOIk/a1LkR3dMdBrNOWJNbLIe7tj2p+izu3uJ
        cqjY7RhxzE0SNotxzWhAyHJuEWp3DqoYuvloiNCacX18AHTXglCzZOWI3qOpegit
        vthPKewV2CgN0c4KDFfl2G1cqyQiD/BU/0iCPpQ/5K/oPtcOJ6cFqbNX5O//zpOP
        rkUzO82nXu7XtHER8CUnPylVdwEhdT1lcL24f4beTcLTHV3mdLWTtgJcC7ObKCbg
        ==
X-ME-Sender: <xms:Wic9X5MRwDQa-YGiw75zD3P7PXIYlIdP5WG_oUwBMiFI9d6td5GBNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:Wic9X7-pC_tLGVthJff7Q_Ik_RXUfBBbJuiveyj1L6SebODau8DEew>
    <xmx:Wic9X4Q47XP_jhFV5NrPlMRzBoDDRZLUT7hiAFNi4Lhmf-tsV0YDTw>
    <xmx:Wic9X1sUW1N94st5fIIgY_uUvVAi4NxqZTVbVwWLvrH5r-uQCKUKMA>
    <xmx:Wyc9X3q1TTR0mGOy2-up56jJlU7AFgYlwM0s8p566J-gnkiawr62CXfJGoM>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8F8A330600A9;
        Wed, 19 Aug 2020 09:21:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] gfs2: Never call gfs2_block_zero_range with an open" failed to apply to 5.4-stable tree
To:     rpeterso@redhat.com, agruenba@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 15:21:52 +0200
Message-ID: <1597843312243105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 70499cdfeb3625c87eebe4f7a7ea06fa7447e5df Mon Sep 17 00:00:00 2001
From: Bob Peterson <rpeterso@redhat.com>
Date: Fri, 24 Jul 2020 12:06:31 -0500
Subject: [PATCH] gfs2: Never call gfs2_block_zero_range with an open
 transaction

Before this patch, some functions started transactions then they called
gfs2_block_zero_range. However, gfs2_block_zero_range, like writes, can
start transactions, which results in a recursive transaction error.
For example:

do_shrink
   trunc_start
      gfs2_trans_begin <------------------------------------------------
         gfs2_block_zero_range
            iomap_zero_range(inode, from, length, NULL, &gfs2_iomap_ops);
               iomap_apply ... iomap_zero_range_actor
                  iomap_begin
                     gfs2_iomap_begin
                        gfs2_iomap_begin_write
                  actor (iomap_zero_range_actor)
		     iomap_zero
			iomap_write_begin
			   gfs2_iomap_page_prepare
			      gfs2_trans_begin <------------------------

This patch reorders the callers of gfs2_block_zero_range so that they
only start their transactions after the call. It also adds a BUG_ON to
ensure this doesn't happen again.

Fixes: 2257e468a63b ("gfs2: implement gfs2_block_zero_range using iomap_zero_range")
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 6306eaae378b..6d2ea788d0a1 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1351,9 +1351,15 @@ int gfs2_extent_map(struct inode *inode, u64 lblock, int *new, u64 *dblock, unsi
 	return ret;
 }
 
+/*
+ * NOTE: Never call gfs2_block_zero_range with an open transaction because it
+ * uses iomap write to perform its actions, which begin their own transactions
+ * (iomap_begin, page_prepare, etc.)
+ */
 static int gfs2_block_zero_range(struct inode *inode, loff_t from,
 				 unsigned int length)
 {
+	BUG_ON(current->journal_info);
 	return iomap_zero_range(inode, from, length, NULL, &gfs2_iomap_ops);
 }
 
@@ -1414,6 +1420,16 @@ static int trunc_start(struct inode *inode, u64 newsize)
 	u64 oldsize = inode->i_size;
 	int error;
 
+	if (!gfs2_is_stuffed(ip)) {
+		unsigned int blocksize = i_blocksize(inode);
+		unsigned int offs = newsize & (blocksize - 1);
+		if (offs) {
+			error = gfs2_block_zero_range(inode, newsize,
+						      blocksize - offs);
+			if (error)
+				return error;
+		}
+	}
 	if (journaled)
 		error = gfs2_trans_begin(sdp, RES_DINODE + RES_JDATA, GFS2_JTRUNC_REVOKES);
 	else
@@ -1427,19 +1443,10 @@ static int trunc_start(struct inode *inode, u64 newsize)
 
 	gfs2_trans_add_meta(ip->i_gl, dibh);
 
-	if (gfs2_is_stuffed(ip)) {
+	if (gfs2_is_stuffed(ip))
 		gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode) + newsize);
-	} else {
-		unsigned int blocksize = i_blocksize(inode);
-		unsigned int offs = newsize & (blocksize - 1);
-		if (offs) {
-			error = gfs2_block_zero_range(inode, newsize,
-						      blocksize - offs);
-			if (error)
-				goto out;
-		}
+	else
 		ip->i_diskflags |= GFS2_DIF_TRUNC_IN_PROG;
-	}
 
 	i_size_write(inode, newsize);
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = current_time(&ip->i_inode);
@@ -2448,25 +2455,7 @@ int __gfs2_punch_hole(struct file *file, loff_t offset, loff_t length)
 	loff_t start, end;
 	int error;
 
-	start = round_down(offset, blocksize);
-	end = round_up(offset + length, blocksize) - 1;
-	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (error)
-		return error;
-
-	if (gfs2_is_jdata(ip))
-		error = gfs2_trans_begin(sdp, RES_DINODE + 2 * RES_JDATA,
-					 GFS2_JTRUNC_REVOKES);
-	else
-		error = gfs2_trans_begin(sdp, RES_DINODE, 0);
-	if (error)
-		return error;
-
-	if (gfs2_is_stuffed(ip)) {
-		error = stuffed_zero_range(inode, offset, length);
-		if (error)
-			goto out;
-	} else {
+	if (!gfs2_is_stuffed(ip)) {
 		unsigned int start_off, end_len;
 
 		start_off = offset & (blocksize - 1);
@@ -2489,6 +2478,26 @@ int __gfs2_punch_hole(struct file *file, loff_t offset, loff_t length)
 		}
 	}
 
+	start = round_down(offset, blocksize);
+	end = round_up(offset + length, blocksize) - 1;
+	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (error)
+		return error;
+
+	if (gfs2_is_jdata(ip))
+		error = gfs2_trans_begin(sdp, RES_DINODE + 2 * RES_JDATA,
+					 GFS2_JTRUNC_REVOKES);
+	else
+		error = gfs2_trans_begin(sdp, RES_DINODE, 0);
+	if (error)
+		return error;
+
+	if (gfs2_is_stuffed(ip)) {
+		error = stuffed_zero_range(inode, offset, length);
+		if (error)
+			goto out;
+	}
+
 	if (gfs2_is_jdata(ip)) {
 		BUG_ON(!current->journal_info);
 		gfs2_journaled_truncate_range(inode, offset, length);

