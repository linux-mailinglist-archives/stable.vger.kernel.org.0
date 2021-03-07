Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0534330152
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhCGNns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:43:48 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:55005 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230244AbhCGNnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:43:47 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 47A41186F;
        Sun,  7 Mar 2021 08:43:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:43:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3yEHBb
        AkQ/8U//wb8SHJMhbmAhEoDbHpz4U3assf2cc=; b=iSpc6b33IJyTGRh6qC94gy
        AmkGPXRKazAfdsJYtX91jA2hxNBL+EWCLdSTj5o9H2CRz6Q1JdgQBM2Uy0KaUsUM
        NMRqyI7S57UVPI/dxOGp5FMxwhdHTo27Mjuirosf5jS4cu8QZYVnX2pxbpppP+Gy
        0c8ewAjHIQ2QgtI3kMns7epWkUfPB+/gGRuse3hBB3o1vsNItjrnWvFqixTLuTfn
        +7opq4qnrqBtahbUdUgpdypwvenL5MpHm4QX/+Czd4Fiz7K8Uz0PXlFulXXFxfKN
        NkMZ71JiuoG2VQf6K5PUrtLeZlWemK8yBeSK7lFLl9LciK9oaWI0OFcP5gFOnnKQ
        ==
X-ME-Sender: <xms:kthEYMDQvHHicZW6TC_XPu0scPnMWIEFvMdzLoCxcnMRipm8b3Ha6g>
    <xme:kthEYOh950mAyGx2inowc4QfAdA71Gt0gE9yUdL8QaRoHdKW017RFwiQ9Cgr_xPt_
    pzD4PhYsF1kqw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:kthEYPlj76vm8SiQneVgaK0bLxCzZ5gmT1d3COP08pvlYZZWowIV_g>
    <xmx:kthEYCyzLqVwy9e2XGc-wHTYR1RtqtUJKoKqyRlk-FV5S6f46KDAaw>
    <xmx:kthEYBSWr9roNBaYWIaWFmKkhyKLzf-Vd3o35cMikLVd_jZ7AvWubQ>
    <xmx:kthEYC6nPRuC0gUN0qyZ6ijVVwYAKSbkVSflMqKS9JrqsrbrkwRCLUYBJQg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4651C1080059;
        Sun,  7 Mar 2021 08:43:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: raid56: simplify tracking of Q stripe presence" failed to apply to 4.4-stable tree
To:     dsterba@suse.com, johannes.thumshirn@wdc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:43:44 +0100
Message-ID: <161512462421981@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From c17af96554a8a8777cbb0fd53b8497250e548b43 Mon Sep 17 00:00:00 2001
From: David Sterba <dsterba@suse.com>
Date: Wed, 19 Feb 2020 15:17:20 +0100
Subject: [PATCH] btrfs: raid56: simplify tracking of Q stripe presence
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

There are temporary variables tracking the index of P and Q stripes, but
none of them is really used as such, merely for determining if the Q
stripe is present. This leads to compiler warnings with
-Wunused-but-set-variable and has been reported several times.

fs/btrfs/raid56.c: In function ‘finish_rmw’:
fs/btrfs/raid56.c:1199:6: warning: variable ‘p_stripe’ set but not used [-Wunused-but-set-variable]
 1199 |  int p_stripe = -1;
      |      ^~~~~~~~
fs/btrfs/raid56.c: In function ‘finish_parity_scrub’:
fs/btrfs/raid56.c:2356:6: warning: variable ‘p_stripe’ set but not used [-Wunused-but-set-variable]
 2356 |  int p_stripe = -1;
      |      ^~~~~~~~

Replace the two variables with one that has a clear meaning and also get
rid of the warnings. The logic that verifies that there are only 2
valid cases is unchanged.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index a8e53c8e7b01..406b1efd3ba5 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1196,22 +1196,19 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 	int nr_data = rbio->nr_data;
 	int stripe;
 	int pagenr;
-	int p_stripe = -1;
-	int q_stripe = -1;
+	bool has_qstripe;
 	struct bio_list bio_list;
 	struct bio *bio;
 	int ret;
 
 	bio_list_init(&bio_list);
 
-	if (rbio->real_stripes - rbio->nr_data == 1) {
-		p_stripe = rbio->real_stripes - 1;
-	} else if (rbio->real_stripes - rbio->nr_data == 2) {
-		p_stripe = rbio->real_stripes - 2;
-		q_stripe = rbio->real_stripes - 1;
-	} else {
+	if (rbio->real_stripes - rbio->nr_data == 1)
+		has_qstripe = false;
+	else if (rbio->real_stripes - rbio->nr_data == 2)
+		has_qstripe = true;
+	else
 		BUG();
-	}
 
 	/* at this point we either have a full stripe,
 	 * or we've read the full stripe from the drive.
@@ -1255,7 +1252,7 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 		SetPageUptodate(p);
 		pointers[stripe++] = kmap(p);
 
-		if (q_stripe != -1) {
+		if (has_qstripe) {
 
 			/*
 			 * raid6, add the qstripe and call the
@@ -2353,8 +2350,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 	int nr_data = rbio->nr_data;
 	int stripe;
 	int pagenr;
-	int p_stripe = -1;
-	int q_stripe = -1;
+	bool has_qstripe;
 	struct page *p_page = NULL;
 	struct page *q_page = NULL;
 	struct bio_list bio_list;
@@ -2364,14 +2360,12 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 
 	bio_list_init(&bio_list);
 
-	if (rbio->real_stripes - rbio->nr_data == 1) {
-		p_stripe = rbio->real_stripes - 1;
-	} else if (rbio->real_stripes - rbio->nr_data == 2) {
-		p_stripe = rbio->real_stripes - 2;
-		q_stripe = rbio->real_stripes - 1;
-	} else {
+	if (rbio->real_stripes - rbio->nr_data == 1)
+		has_qstripe = false;
+	else if (rbio->real_stripes - rbio->nr_data == 2)
+		has_qstripe = true;
+	else
 		BUG();
-	}
 
 	if (bbio->num_tgtdevs && bbio->tgtdev_map[rbio->scrubp]) {
 		is_replace = 1;
@@ -2393,7 +2387,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 		goto cleanup;
 	SetPageUptodate(p_page);
 
-	if (q_stripe != -1) {
+	if (has_qstripe) {
 		q_page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
 		if (!q_page) {
 			__free_page(p_page);
@@ -2416,8 +2410,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 		/* then add the parity stripe */
 		pointers[stripe++] = kmap(p_page);
 
-		if (q_stripe != -1) {
-
+		if (has_qstripe) {
 			/*
 			 * raid6, add the qstripe and call the
 			 * library function to fill in our p/q

