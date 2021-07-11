Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E7A3C3C3A
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhGKMYT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:24:19 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:38657 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232798AbhGKMYT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:24:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 4DA6B1AC04A7;
        Sun, 11 Jul 2021 08:21:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 11 Jul 2021 08:21:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1Q9iby
        hIF/9K7i9q0SK9yZAw0xGL0bFL/mocgK1XEBU=; b=IzhPFl0trZbYze6rwMBAZM
        oWn7Ffu19f+6mhZ88fS3vcXgiEIyPQO2cdtytdxGQRBtsJhcnERGErUPcM7wDmbv
        hSvl+YD/to+B3byLH9AH9yEtDiUU62dP2XIG1XXJXiae1Fw/aXXuM5KYTfI6vFAv
        ycOcTqZFL2maRxgJI/xmBrX1WK50PjNCivUgMnXDbhp6OmPLPepjIiHK7OKVyn+4
        +wGtyZKa2ZKrLYugrfbvqTwvcQZAOCgez83zDZnmVbwF3ObHwaV9zlb3JDfy0K6W
        Elm3JFlImsVbOwamJqtUh0TVj83OE5UJ2HEuMnHX8pyaymr3TLir7T7QzNzYgq7w
        ==
X-ME-Sender: <xms:S-LqYHJmfohqM2yN4N_XbMjWaT2NRDLikZdox9NYMkgdC5i6xzA1Zw>
    <xme:S-LqYLIm6kJKqEjcKR_BMBG9YjMBikgZHYuj7KhJ0Jp101BSui23iIjQMwvjqwGSq
    ZFaXVCKOMTKiQ>
X-ME-Received: <xmr:S-LqYPu97tux6yiVhUU6_EWAmQzuBNaxp79k3dwh3vjblj9cX1UzDo5qK4aGiWg8FlaKUrUEWtXb1-CZDQFdR9VqAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:S-LqYAbSnTVLIw8GyrHPetYY9fO_d7WQnj1dih6CR7DHGYCO9CdSVw>
    <xmx:S-LqYOaUr6zuAtngcmDVE76Y6edX_uL27fJ1qG-IB8TqEsAxdpA8OQ>
    <xmx:S-LqYECmd39i3hoxXPSCqaensbTtdxih7G1mIbzccveSIYNRGtzg6g>
    <xmx:S-LqYHB_WSSvfDgU4ltYaSLvMJijVruLfycn0mVmSE61wbAaUQ1Y-SWqykg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:21:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: compression: don't try to compress if we don't have" failed to apply to 4.14-stable tree
To:     dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:21:22 +0200
Message-ID: <162600608252180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

