Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C711E2D4602
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731376AbgLIPyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:54:51 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:46427 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727806AbgLIPyu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:54:50 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 137941943980;
        Wed,  9 Dec 2020 03:39:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 03:39:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=1dlQ1D
        U0C/1OaDnxUyhIxqq+3BBcHA68s0mRqtRC5j0=; b=TDDdoqhQDBacMotNjiA9y7
        wCIeYyPyEGZ9S891jkQ6alQXKgJwgzC04xVirYXUWylrA4KwToUrxfGlBEVGYI6T
        jgleHYA98cnMlGPMHLbkdFxb9fuPI39hNOrNXrNkL+IHYPT4pZOHlDipitxVWYBa
        hPtLYwDt8OM3KVCn8g0iThSVHvNi9T38zVEDubvtE5jNDDt4ixBsmCqvvGGNmUFp
        2LXl88lIjd2IyzdlXCV5utnH9JtBA/0HtsdGB6Bf3hlXGsEQipsS4EEPmylSAkm7
        GL4a40H5unKfHQ/NphBa5NJvjI8uqjmkSF6WR/cD+/Bbn3vF0WcN2vvzD9eF0iGQ
        ==
X-ME-Sender: <xms:OY3QX9U4l1vccGOENHP1sSMTraEgkgi1BKkxcfCrL1FHPldCxogF2w>
    <xme:OY3QX9msxD6O-cEDtTeqx7Wu_EjUfKtv-m8x437_wLtd0yigxMGZf0B7aWj-vzr0-
    q2seJ2qvrRTvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:OY3QX5bmdOpenDdC0mv14-YzNFniVh8mmt821FggBzKk9mSsVjN4sg>
    <xmx:OY3QXwVeHMa4OOWlpE-XTEAXQvoikGFzEje0Nj4IOd5wwM4bRst87w>
    <xmx:OY3QX3lKbBXNxLC8FcZrSBQX78uBWJOnJYWWmcndTso8b4G2KjrHlQ>
    <xmx:Oo3QX1jx8Q0iSYxzK_hTyfsGY9fK9iOuzMML_3NJNBByzQq5uvNHqw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3AF011080059;
        Wed,  9 Dec 2020 03:39:21 -0500 (EST)
Subject: FAILED: patch "[PATCH] block: use gcd() to fix chunk_sectors limit stacking" failed to apply to 5.9-stable tree
To:     snitzer@redhat.com, axboe@kernel.dk, bjohnsto@redhat.com,
        jdorminy@redhat.com, martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:40:39 +0100
Message-ID: <160750323938143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7e7986f9d3ba69a7375a41080a1f8c8012cb0923 Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Tue, 1 Dec 2020 11:07:09 -0500
Subject: [PATCH] block: use gcd() to fix chunk_sectors limit stacking

commit 22ada802ede8 ("block: use lcm_not_zero() when stacking
chunk_sectors") broke chunk_sectors limit stacking. chunk_sectors must
reflect the most limited of all devices in the IO stack.

Otherwise malformed IO may result. E.g.: prior to this fix,
->chunk_sectors = lcm_not_zero(8, 128) would result in
blk_max_size_offset() splitting IO at 128 sectors rather than the
required more restrictive 8 sectors.

And since commit 07d098e6bbad ("block: allow 'chunk_sectors' to be
non-power-of-2") care must be taken to properly stack chunk_sectors to
be compatible with the possibility that a non-power-of-2 chunk_sectors
may be stacked. This is why gcd() is used instead of reverting back
to using min_not_zero().

Fixes: 22ada802ede8 ("block: use lcm_not_zero() when stacking chunk_sectors")
Fixes: 07d098e6bbad ("block: allow 'chunk_sectors' to be non-power-of-2")
Reported-by: John Dorminy <jdorminy@redhat.com>
Reported-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: John Dorminy <jdorminy@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9741d1d83e98..659cdb8a07fe 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -547,7 +547,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 
 	t->io_min = max(t->io_min, b->io_min);
 	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
-	t->chunk_sectors = lcm_not_zero(t->chunk_sectors, b->chunk_sectors);
+
+	/* Set non-power-of-2 compatible chunk_sectors boundary */
+	if (b->chunk_sectors)
+		t->chunk_sectors = gcd(t->chunk_sectors, b->chunk_sectors);
 
 	/* Physical block size a multiple of the logical block size? */
 	if (t->physical_block_size & (t->logical_block_size - 1)) {

