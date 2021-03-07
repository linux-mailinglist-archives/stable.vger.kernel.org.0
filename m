Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10D933017E
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhCGN4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:56:03 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51681 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230373AbhCGNzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:55:32 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id EB0C01A7C;
        Sun,  7 Mar 2021 08:55:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:55:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=GbE0jL
        XJkn+TCA7U60y/TTFgBz5zmlQxDvmXc67sKHI=; b=isSgYMSfgIEKyUIZp58c49
        kBxGW4j4q6t3MMKZ+1sI89+hrAz7ggHLS/XpnghbrX2hnkAQjgwLcRiUZeZOJKvK
        cWugZ8/LUxtUQQhElZcggl8/wU2qYXwNs1DdumodfcSkd+GrksL29gjbZbvxJS09
        HhfbSr1AmdJKHkLMFFID8nlRhg5Nj53sRiWV84j3dAn+41jPTd+zOjmlRoEIzA2V
        8pBkX0XjaDMCvtYvA24525i1hZxZSx8b5jR1GE58nlq1X0/nR5/d6tBZl2eK/7eC
        RQgFFnNqVO08Giibq34Dq6FA2rj6fLs9XD2qvv/zdlEUkW6Arq9c2k3LcgLQL9Kg
        ==
X-ME-Sender: <xms:U9tEYKwa9xOUsZFPjiIyO_QN9IzmVu7iBIUPzufNCnjcEph_CO8X1Q>
    <xme:U9tEYGNkMqmNK3tBntVnjNrbRElnBXOH-expw3YUf8Hoan1yqQEkbppb-1bciL3KK
    ib0YxeKxITQXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepieenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:U9tEYJOlDld9OZyrLbBsDlVLZpgIOHZRTKDj0AefONEHDqhJ5_2e3g>
    <xmx:U9tEYIR-LRmnejCW2i1A1cNqsff5VC9-n02qSaPHZDNBhjGl8TNzbg>
    <xmx:U9tEYLB_uMBQejt8ttXB0-w-ZHFp_Sb8Yb185jc7aHlST8zOVBpCaQ>
    <xmx:U9tEYL98LU0Zwj2km_oTz3v7vAnT6rIIHpErbpOpKkjXuO3kGOGVxTmDDlA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4984D1080057;
        Sun,  7 Mar 2021 08:55:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] dm bufio: subtract the number of initial sectors in" failed to apply to 4.9-stable tree
To:     mpatocka@redhat.com, gmazyland@gmail.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:55:21 +0100
Message-ID: <1615125321215161@kroah.com>
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

