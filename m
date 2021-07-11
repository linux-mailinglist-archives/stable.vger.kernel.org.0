Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4214C3C3C3D
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhGKMY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:24:26 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:58947 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232798AbhGKMY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:24:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 69E691AC04A7;
        Sun, 11 Jul 2021 08:21:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 11 Jul 2021 08:21:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Km/QBP
        IlfrOcqqg2GFpyECKTB3OKn1nOL+zsGo5uZq0=; b=fx4CpkPr2O/m3l8Hgb29Fo
        cdi6P6y1GTGy0rhlPcdcDouZOXI+MabLAsSzHJqYHngv/owLIVyxTATCiX1DsyMB
        JP6FyQoPn6ZgaOoFE/fQy9Kz+vKEp/fPHlTbsawQ47yUpTZZQ2XbVA9HNy6BqhJa
        RScunbsbLSNINyYokT3xOCerLIQrvvsoEtgbxEzf92Hjc65eeaLmzNAw/6f/H8Dd
        blzXE4uuLkAPwxdUNCVC1KJzV77zIspLD4yFkuw1vbyp1oP+UoAcfGs0sAzAJ4Hl
        KgooFdf5JWtXIfMF/r8ZPmpwVlNm1HOTBpLFm418tlaZShqa4t/T+n5FLfgUwNgg
        ==
X-ME-Sender: <xms:UuLqYEZwrFQVpMk-TbO_kZDmGcSiocGRtKHiG98sKi5zRO8yGZNgvg>
    <xme:UuLqYPbNyHZnzV2SdlQD7WmW4i4R9a4M5Bjv36RG02gxQe3-ruor5hlo_mdDFEGTV
    Ch1QEVC9pBEIQ>
X-ME-Received: <xmr:UuLqYO8Nsya17ZzKQ-4dhIh6k0bE-xgFrqhBruSPC75FBerWtGUIGMpSRS_zEJqkzfQqFjpaJxjFKjLgzPZyNYtBJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:UuLqYOoU-becW33D44J4QjAwcxrCkWDOZ7QW2qDfOPd8BwAr_bTC8w>
    <xmx:UuLqYPrn043x74kl_r28FvGvbcIOuV5aC1RxfZPcHXRmmm5ktEjZyg>
    <xmx:UuLqYMT9Au3gTVr6yA_mHAQ4gnUokV4KXAWD6jm12BaSwR74YB7RqA>
    <xmx:U-LqYORZlM9H8w9fwVWb2yuj9aZx1BhxYsjtKTGgObcrNqRTr5RP1LElD_Y>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:21:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: compression: don't try to compress if we don't have" failed to apply to 5.4-stable tree
To:     dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:21:24 +0200
Message-ID: <1626006084107128@kroah.com>
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

