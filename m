Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9FF2E3646
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbgL1LPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:15:14 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:48851 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727032AbgL1LPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:15:13 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0152A811;
        Mon, 28 Dec 2020 06:14:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:14:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=AX/Fgl
        WydL58dAxS04o2HPweEOuYMkTH7RcL9VkNGTc=; b=Tr63nExfGAeTNvSdLLCR8/
        j1J4GR3IT9JkVF2zFcUpbznuuVOBCP/xPWKxJKI2hkeMsHdxDD2WUKdNGng1PHu3
        mp2liCyJ+wEp/AVWTOvHuRGmDmBBgre9iir1PvcS2VjqnMNYVPF+BxsVtmI0qm8Q
        wA/MDV1R5V+LbAVPPKQiHp0uVM0qM7npraZAE/uP1TLLLLYHCxebKc9Oy1MF9D1M
        GJjTsppTQ2yvGEPp5iGquDzEtnWXTNtKsJ39awxlom3zXlFMA7RzlY/CjBknUAA0
        tskcjOnIRIXOMSU8y33Qk/91ct9jVw0cvSia+PmUqtuXJQbt9qtqDo5zA8OK1Piw
        ==
X-ME-Sender: <xms:_73pX-rbevYtpxx2xl7kfqSyhg4IVWvzRg-5YNpvgbaIpffjTJlMyw>
    <xme:_73pX8r6kUNh-Fayio7v2_rdm2FxgNDypK9BDLbaoDfVrbSmDsprMHXGTDSlIq3gr
    Kog-jLtZ1jf5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:_73pXzOcEUJL5E7ndruXaXncBPxuC6PCsJ9AOkAePHPjmESsFd6tZg>
    <xmx:_73pX96_vHFeg8yL7MKgqI3BGP3xPetIavNuO29jA23g5je9X5gCJA>
    <xmx:_73pX97pqqKC2M6cNDVZJISwXqExYcaVqAVpek9WRgGLkrAuEpV7Rg>
    <xmx:_73pX6js9Nw1h5lAuR0A_T9m7fYZyNJY77qSAU88eK2Xzm0j694Lm6pxkIY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2E7F2108005B;
        Mon, 28 Dec 2020 06:14:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] md/raid10: initialize r10_bio->read_slot before use." failed to apply to 4.19-stable tree
To:     kvigor@gmail.com, songliubraving@fb.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:15:21 +0100
Message-ID: <16091541217049@kroah.com>
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

From 93decc563637c4288380912eac0eb42fb246cc04 Mon Sep 17 00:00:00 2001
From: Kevin Vigor <kvigor@gmail.com>
Date: Fri, 6 Nov 2020 14:20:34 -0800
Subject: [PATCH] md/raid10: initialize r10_bio->read_slot before use.

In __make_request() a new r10bio is allocated and passed to
raid10_read_request(). The read_slot member of the bio is not
initialized, and the raid10_read_request() uses it to index an
array. This leads to occasional panics.

Fix by initializing the field to invalid value and checking for
valid value in raid10_read_request().

Cc: stable@vger.kernel.org
Signed-off-by: Kevin Vigor <kvigor@gmail.com>
Signed-off-by: Song Liu <songliubraving@fb.com>

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b7bca6703df8..3153183b7772 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1127,7 +1127,7 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	struct md_rdev *err_rdev = NULL;
 	gfp_t gfp = GFP_NOIO;
 
-	if (r10_bio->devs[slot].rdev) {
+	if (slot >= 0 && r10_bio->devs[slot].rdev) {
 		/*
 		 * This is an error retry, but we cannot
 		 * safely dereference the rdev in the r10_bio,
@@ -1508,6 +1508,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	r10_bio->mddev = mddev;
 	r10_bio->sector = bio->bi_iter.bi_sector;
 	r10_bio->state = 0;
+	r10_bio->read_slot = -1;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * conf->geo.raid_disks);
 
 	if (bio_data_dir(bio) == READ)

