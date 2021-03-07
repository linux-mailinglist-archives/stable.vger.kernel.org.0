Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2A633017A
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhCGNzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:55:31 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:59151 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231497AbhCGNzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:55:24 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 8666F1A78;
        Sun,  7 Mar 2021 08:55:23 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:55:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wdaj7C
        NPMIAWPl7qJPuWXIdLbe4qwmq+BX3ybnVpsc4=; b=QWoUxYZukgMDMTQrLOWGhW
        ueuBOISFsmyHTzIKFKM5ishdUCk7nZe+71b8ddp/oQ5+vY33i7ebEGcKwb9+qPf8
        /IHdA67pUXGplnTPqWZOl7XCiKvM2eAj5L9/n0k6vEPffMbhlm8GbvagwNOILQXD
        81eryYFepkVIP1mRH6zQeL+vkns8zw1ah/rQwCAcPl9aljXm8FBR1Xs0zUV78dgN
        YTrvoB29RQZ65QSz93vk2SKSvLxwj4eNWGcq1116aii0asnp2AovU74R36xZ2Ggm
        6jqe9/5sufK23uGE3z3bL4dt7uKW+QlbvPVcA7TrlwvDUeZ8J3RPfaBXZBuUICGg
        ==
X-ME-Sender: <xms:S9tEYLZlXlGpaigte1QUCN898x532NrZxhAztE1bJg4n8oe4un1KOg>
    <xme:S9tEYKbuUFTWFU5S1TqasGtTqBfDvfcmXNXUhyziJAr_O1WdIcbYvcM9WeNmFr2M2
    ajQrDF2Xa7oHg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:S9tEYN8YR4lgtQkcfJmza7qlMVbnC6utK4DEVi9-3X_sVL8CznctZg>
    <xmx:S9tEYBpdFeguDFjB_zJ0HMg79Nqj7Q8QTVrDtKvVdhLLJChVECIPrg>
    <xmx:S9tEYGrE-Z5rHTd3p_9Kb7T9XAVce2-kAifHejpecWmsRqRBSR5cvA>
    <xmx:S9tEYLAxreXBV93X9z48wkF3VZ5LM3FhzSWIi0nqh1QMLCt5mi7LkkI-6HY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C62FE24005B;
        Sun,  7 Mar 2021 08:55:22 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm bufio: subtract the number of initial sectors in" failed to apply to 4.14-stable tree
To:     mpatocka@redhat.com, gmazyland@gmail.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:55:20 +0100
Message-ID: <1615125320196229@kroah.com>
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

From a14e5ec66a7a66e57b24e2469f9212a78460207e Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Tue, 23 Feb 2021 21:21:20 +0100
Subject: [PATCH] dm bufio: subtract the number of initial sectors in
 dm_bufio_get_device_size

dm_bufio_get_device_size returns the device size in blocks. Before
returning the value, we must subtract the nubmer of starting
sectors. The number of starting sectors may not be divisible by block
size.

Note that currently, no target is using dm_bufio_set_sector_offset and
dm_bufio_get_device_size simultaneously, so this change has no effect.
However, an upcoming dm-verity-fec fix needs this change.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Milan Broz <gmazyland@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index fce4cbf9529d..50f3e673729c 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1526,6 +1526,10 @@ EXPORT_SYMBOL_GPL(dm_bufio_get_block_size);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c)
 {
 	sector_t s = i_size_read(c->bdev->bd_inode) >> SECTOR_SHIFT;
+	if (s >= c->start)
+		s -= c->start;
+	else
+		s = 0;
 	if (likely(c->sectors_per_block_bits >= 0))
 		s >>= c->sectors_per_block_bits;
 	else

