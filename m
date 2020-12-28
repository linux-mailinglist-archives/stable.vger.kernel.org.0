Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF542E3645
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgL1LPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:15:04 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:38617 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727032AbgL1LPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:15:03 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id BBBDD82B;
        Mon, 28 Dec 2020 06:13:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:13:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=doQR5X
        nftFLXRDW+hxNfgFN2b8kL0n9RACkjhQgYwPo=; b=N89X3OT5CDjQK+UA/zoCVB
        rOKw9VWGdnioMZlR9PqraYbxWqqU0GXlBYQspPJQOIVoYa1LtLS4W1GSXuwnN04a
        VAIttFE3dZbP72M3gyKQSDdwNzmIgzLUYrexBAOtmT2FvwcULrRxG8/HmBIyS8FN
        Tobb0rZfSiSxIp6MR8X8fS6v5PWuJRSNgQ7ne+bs0+MHgJgu7MehXK/JDk+ZoVEx
        uKsOpCfbADQJhdDGtxmRJFmbSIM9HHzX0r+HyE3SI1lHncihMOweHIhEZfU5U5FR
        p7Tk5fA+zyH4TwN+e2ULeF/rvHrrIBxHM6zJlRecMXNvpKo2FQBd8IH11V6wqDgQ
        ==
X-ME-Sender: <xms:9b3pXzf5w3VQxprXxUJISr2hohbNydfzp3ZmoyU9mneBURvqvJWtkg>
    <xme:9b3pX5OiAu98rGG_JYX6dZPJdake6KGrdB2q6Tm4hVAe9-u6JGemEVF6gU3mgV-zA
    jfMgauYiq1Rrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:9b3pX8iiE3MLjLWDOv5BbKaZQn6_wLBmVQ543m5MtwE5bUDX8OTNMg>
    <xmx:9b3pX09r32jQCTCUvjV5xSVk1ezFmwngNDq-TP4EbNh62GUl4RO29g>
    <xmx:9b3pX_tuoQxNB837NPmokJl0eStbna5ZOm4b3DaeoIOlkIT72kgTBA>
    <xmx:9b3pX91Q1-5dZBeMj17nAV-RO8dWXE8cqAb3ohFTlKEM1bMw6EgsvGCx5BI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EC973108005C;
        Mon, 28 Dec 2020 06:13:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] md/raid10: initialize r10_bio->read_slot before use." failed to apply to 5.10-stable tree
To:     kvigor@gmail.com, songliubraving@fb.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:15:20 +0100
Message-ID: <160915412025445@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

