Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2DC2A473C
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729295AbgKCODH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:03:07 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:43231 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728817AbgKCOBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 09:01:51 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id AA764CC5;
        Tue,  3 Nov 2020 09:01:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:01:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5DMu6g
        O8vaE+U0nk2ulWZT+doOYl1YD3SGRdd5RuWAQ=; b=qejZ+sGNcARnXKmkxa+irk
        BlPT6JOomdoYfkt/9tPmOzspIM3NxcNbjWkt/j28eS8Ch78qYOftTGWtqeUAQHtZ
        rfhzRpQQhZoZgd/GxC7Q5CRmphiq/SpmrpumDSJL/a1owPXCLsvriOjY67d4JtDi
        lrT1PWQuHW/fDcYhvfTwyuKNqlejeJol2rLImMoOc6lffkMHBWyUYmW+UJdlFreE
        N2jORENohByP72PY+OHHmJ7fLs1SPsRK0az+Lec7YKLPbAKwBGand+oComaZMaR/
        7At5jyqr1PpeI6/YCbikQtVWDg3eCbAyOCj4SFnFxiqmqEwN3twnatsy9juTpbCw
        ==
X-ME-Sender: <xms:zWKhX8mq4F7_bx4dZoQ5h1A7gn3zR12GJYklRpD4qAhxC5fYalb1KQ>
    <xme:zWKhX71pW0ZejLCD8TONUPLDfe86Rqddc_yQRVU4hr2NI-4tTUKM_y7TafytFWlgq
    75VhtSwV3tODg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:zWKhX6oriG3zfSK2ZRyXMd2pjhfZ4gelfKUEJWkNCQVUmDVo8DSDoQ>
    <xmx:zWKhX4m_0OvVEx6vMhLr7ty1bRRJr7J92kiBnzZKnXb4dqO7_7munw>
    <xmx:zWKhX61nhpCM7OEgqjsCIYn5ip5LSsDPPIyRJciUGEyfXscgQ5K7cg>
    <xmx:zmKhX__SAu4fpCHFFz8oL92zPsDiA6EAYKAEAaEiNWDocEwlYoeLdErl38k>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 77D8B306467D;
        Tue,  3 Nov 2020 09:01:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm raid: fix discard limits for raid1 and raid10" failed to apply to 5.9-stable tree
To:     snitzer@redhat.com, mpatocka@redhat.com, zkabelac@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 15:02:43 +0100
Message-ID: <1604412163147170@kroah.com>
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

From e0910c8e4f87bb9f767e61a778b0d9271c4dc512 Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 24 Sep 2020 13:14:52 -0400
Subject: [PATCH] dm raid: fix discard limits for raid1 and raid10

Block core warned that discard_granularity was 0 for dm-raid with
personality of raid1.  Reason is that raid_io_hints() was incorrectly
special-casing raid1 rather than raid0.

But since commit 29efc390b9462 ("md/md0: optimize raid0 discard
handling") even raid0 properly handles large discards.

Fix raid_io_hints() by removing discard limits settings for raid1.
Also, fix limits for raid10 by properly stacking underlying limits as
done in blk_stack_limits().

Depends-on: 29efc390b9462 ("md/md0: optimize raid0 discard handling")
Fixes: 61697a6abd24a ("dm: eliminate 'split_discard_bios' flag from DM target interface")
Cc: stable@vger.kernel.org
Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 56b723d012ac..dc8568ab96f2 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3730,12 +3730,14 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	blk_limits_io_opt(limits, chunk_size_bytes * mddev_data_stripes(rs));
 
 	/*
-	 * RAID1 and RAID10 personalities require bio splitting,
-	 * RAID0/4/5/6 don't and process large discard bios properly.
+	 * RAID10 personality requires bio splitting,
+	 * RAID0/1/4/5/6 don't and process large discard bios properly.
 	 */
-	if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
-		limits->discard_granularity = chunk_size_bytes;
-		limits->max_discard_sectors = rs->md.chunk_sectors;
+	if (rs_is_raid10(rs)) {
+		limits->discard_granularity = max(chunk_size_bytes,
+						  limits->discard_granularity);
+		limits->max_discard_sectors = min_not_zero(rs->md.chunk_sectors,
+							   limits->max_discard_sectors);
 	}
 }
 

