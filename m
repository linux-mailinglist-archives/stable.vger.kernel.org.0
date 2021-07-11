Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32763C3C3B
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhGKMYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:24:21 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:57623 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232792AbhGKMYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:24:21 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id A64AB1AC04BD;
        Sun, 11 Jul 2021 08:21:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 11 Jul 2021 08:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+AJyyN
        snf/OOIHlUsQyLoQ0+7OzL4N2pDTrqCYOMKRA=; b=T4X13xxBwFX3/7EturE7DS
        /l4T7at2wm2EvYH1Snfi9aBrG/3yV32R1YJr7NUHKzVoGme0huo/dZc3ph/ub/iU
        kQTf9+pI9JSPx5PCPob36HMNkhnhcWs/cy83g4vPWerVT6XiCBauqnajt/s2S1pE
        2kocAlxtLB9Ppt38SwWuYTJl8C2uf4Y9ocVyhsgCjTUkDtsnYaQwozp1l8jKktwP
        aRi+aoEWfRMXDg99NJQ1h/cMeEuNUwG5S9yYezudtezLFGsONstg5lm7XL+EM2/1
        bJ/DmtHq77fBRqr/YIuwVhTZnaV7QA7ZP9oVw4ZzqSpggj193X/tvz2JwgsWqYgA
        ==
X-ME-Sender: <xms:TuLqYIXUzQ1ye7VTFZbmOjWNtiyiO0ZbqPMjnPxhlvS2hbP70uHOrQ>
    <xme:TuLqYMkWJVbwCGVNeP7RNw3sE-hSRUFi7vKQvUHOXHJ4S6HkPXcw_SEnkWi-BTjXC
    hPTuYExFKwoHw>
X-ME-Received: <xmr:TuLqYMah70ZLkuI4mdbruG9PRTVYMTYTAIcldmd5JToG-t69Ibs65BSJk8sLXE650FjdIvI_tkvfIoLZ6m0T_NVcqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:TuLqYHUxy5qGhCJ2Jj_JY_r90WY7l2MHGlAsetAG7urDT6cZmckR7Q>
    <xmx:TuLqYCnxEsEy11pC9fAcKWm39-jiOBPOeqK14WXGqF3K3d-irlawpw>
    <xmx:TuLqYMcgbprzOQP3CMGm9TJEcLGIOfhxVIuRdIRonEgdTreDEeJcPQ>
    <xmx:TuLqYJvxSH6ePerICSQ875TQOhyXNTpfXmEdO32agctE0faltMnhIGjW-hI>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:21:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: compression: don't try to compress if we don't have" failed to apply to 4.9-stable tree
To:     dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:21:22 +0200
Message-ID: <162600608216394@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

