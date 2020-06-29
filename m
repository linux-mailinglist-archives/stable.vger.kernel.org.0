Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A81420D195
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgF2SmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:42:19 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:57017 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729011AbgF2Slw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:41:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id D04BD7DA;
        Mon, 29 Jun 2020 07:38:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 29 Jun 2020 07:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=MZn0sh
        2Sgoy6JyW/6IuDmoX4jyo0sWjZk497ycYthK4=; b=pqGsJFPw3GOjY2GDop4sbR
        5YRD+aJ7C0EjSKOWQJI8eBLDOiNqyIPbQAcsVCu1Hp/pZGmk/+bqvvPHGidf09qC
        G1amI0nNTND/6atw7paIKstafRfizXDZFtUwVp3BY5+h3XYrbVMM9kGH2taDJfcb
        9pQbMI0xGTk7ucw414istiiKwUVm43bxajUgpTxcdQSkU9dqp0c2BNXq1Fh2vSnA
        zuQBzbnmleH8DJn+zGS8flAEREWcI3g+s5BiM5U3zxwmLgdSmY56zUyTc0QxQi8G
        qJGkj8I4VHCqK7Tguq2xMA3nya0evstEzEjp5wM+VYMNkho3GiQqiFAw6lnnrgSg
        ==
X-ME-Sender: <xms:xtL5XmiSBrF-C-ashmsH10tqdt2g1q8Hq0t-POzrI4wGW9ABZ5A5pQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelkedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:xtL5XnDiK7fd-aaUZ1jVCR7JOGgQWH6v2GiXpYEMfzyhBHtRQFW_OA>
    <xmx:xtL5XuFhwEENk4PJ_qkvmkEJA9CG3Zhe5TaEoQaxXx_2Ak_jprrEWw>
    <xmx:xtL5XvQ-KXWHMnk9n57Ola63bsm_g-Zrsv8Psy74D1XzxomIFcdEjQ>
    <xmx:xtL5XhZ6aQORHOMal8Chy428mLYhPjyzOG0dAdKOFcSXeItgN8YJXqZw7dg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1AB273067C81;
        Mon, 29 Jun 2020 07:38:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm zoned: assign max_io_len correctly" failed to apply to 5.7-stable tree
To:     houtao1@huawei.com, damien.lemoal@wdc.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jun 2020 13:38:29 +0200
Message-ID: <1593430709148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7b2377486767503d47265e4d487a63c651f6b55d Mon Sep 17 00:00:00 2001
From: Hou Tao <houtao1@huawei.com>
Date: Mon, 15 Jun 2020 11:33:23 +0800
Subject: [PATCH] dm zoned: assign max_io_len correctly

The unit of max_io_len is sector instead of byte (spotted through
code review), so fix it.

Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
Cc: stable@vger.kernel.org
Signed-off-by: Hou Tao <houtao1@huawei.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index a907a9446c0b..cf915009c306 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -890,7 +890,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	/* Set target (no write same support) */
-	ti->max_io_len = dmz_zone_nr_sectors(dmz->metadata) << 9;
+	ti->max_io_len = dmz_zone_nr_sectors(dmz->metadata);
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_zeroes_bios = 1;

