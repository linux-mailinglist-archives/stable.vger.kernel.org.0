Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6327A3C3C39
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhGKMYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:24:11 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50485 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232792AbhGKMYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:24:10 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id EF23F1AC04A7;
        Sun, 11 Jul 2021 08:21:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 11 Jul 2021 08:21:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yYmHBr
        n2inInloi/7ogfnbKxaT6SkkzK8x7oA/IZU6I=; b=Wckj11u5Y+vWmsH+VFkkWV
        Dk60jaq60ekNyrbJAOczizOfZuWkjlW3MVoITkU0izghGPlrIH+/b9SEpXg4BbNn
        a6Q0G/l5Grn8zHj0mFw5WFbJowOG0LbVdmM1BgFTjjnOSXWIWX3c5pwAF2RPzODC
        mUtA/RJ0Goph89LOZI0EYn9Ky72+JIWGT7jFxQu/043bkqZwG7ULkeQ96sSRwxfp
        M/lYksnh1wrwISHAGSBre+KpPkyV1UMFgAwoLRCajEScbxJ25+DyeQ5lmN1VMc9N
        Da4Zqaigzodeq9kE82z1vJEpHxIdGSZcyxblazvr3vBevWeiyl+VCr2zbeX8EP5w
        ==
X-ME-Sender: <xms:Q-LqYCwIRWTG3LItk2Nuh69LF28G0QJjoTFmlLVbYloa8z9WgYBdwg>
    <xme:Q-LqYOQeQq97386mHMaybFO2TNb54Q6UxsPBPkKJ28zXXxU4t9FQaTvwlEqHcxhfZ
    7yEJ44kmxMkmQ>
X-ME-Received: <xmr:Q-LqYEVXeDASoQgyNWfdv4ota1vez2hodmMxjirfcYG6xUqA__dDpOV2iHrCmZ5WvbVOV2L8UhVXQd2O5aGr-HglDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Q-LqYIiSJFDM9hIyLeurLjnGE7NmGxmjktvB9HWRHh1srDBsCXnTRw>
    <xmx:Q-LqYEBY3Dxeq08p1huVzlfsHo8Zc-5nN5EdkvGyGsYKaD_eFCmLCQ>
    <xmx:Q-LqYJKvAT0LgsXZZ68NDRvpg5aRNS6hbHdpGraX6XSaofRP9vjOzQ>
    <xmx:Q-LqYPo3_Z2YJSOLGhUgqsGBT3htfFMia9bjPg9kOW7A-kLXcdSBKWcjnbY>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:21:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: compression: don't try to compress if we don't have" failed to apply to 4.4-stable tree
To:     dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:21:21 +0200
Message-ID: <1626006081229238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From f2165627319ffd33a6217275e5690b1ab5c45763 Mon Sep 17 00:00:00 2001
From: David Sterba <dsterba@suse.com>
Date: Mon, 14 Jun 2021 12:45:18 +0200
Subject: [PATCH] btrfs: compression: don't try to compress if we don't have
 enough pages

The early check if we should attempt compression does not take into
account the number of input pages. It can happen that there's only one
page, eg. a tail page after some ranges of the BTRFS_MAX_UNCOMPRESSED
have been processed, or an isolated page that won't be converted to an
inline extent.

The single page would be compressed but a later check would drop it
again because the result size must be at least one block shorter than
the input. That can never work with just one page.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a2494c645681..e6eb20987351 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -629,7 +629,7 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (inode_need_compress(BTRFS_I(inode), start, end)) {
+	if (nr_pages > 1 && inode_need_compress(BTRFS_I(inode), start, end)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {

