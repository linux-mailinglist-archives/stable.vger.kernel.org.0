Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BDB20D187
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgF2SmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:42:06 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50185 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728069AbgF2Sl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:41:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B90AA8D4;
        Mon, 29 Jun 2020 07:38:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 29 Jun 2020 07:38:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yUM8WL
        sGCDw4vz4mnUHG8zQgFjD7hQ607GkHzC2hk+A=; b=u/DsJ9ljWmxqH96ysdxpA5
        rBjWbQwfdk8WPMyDU9D5aMEcWLwJWqjy7phFLTZYHF9VYqbTUYjE85sgx9jh5WVi
        iLfUtcTfh0dlP+jw9qH3Cydzwo1iwt7CaZG1b4JJ3vVm7E10y+sV+r3hGA/KQcjz
        7ZfuwrIJmZF4XE1NxQKxlrs/qziTUHmBHde+KbNcJhlMQpaUH9VMZdgZp0YcsJf0
        gFUeOwj/W9SlovYSqfpz4+CAhz/Dg8kZUeO7VW41LpdhK8KQsaW8MHpbsvI94b7N
        D45P1/WJ1rMV7Q0i54K09TftEtq/Wif4y4Un2LyA81aIVN12YKSYG/TT6a2HNsgw
        ==
X-ME-Sender: <xms:vNL5XhukmGJDsid4tIEZb54dHV10sCL33BjrRLPCTneMCfct0a58DA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelkedggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:vNL5Xqc9SBm1uYSDRG0PQZI8LqJ4J7Sda5L_m3Oyq6zc8ZheuvGtzA>
    <xmx:vNL5XkyiekryrgCp0Zqu5rVcWEvZW0AeMw-FEGr0dmLAtU3PJPzizQ>
    <xmx:vNL5XoPO-q6YykkqIiDunozimn4keN-oYWLkoT4smQyrjNi3BPyJ7A>
    <xmx:vdL5XuE85ZXy72CqOXE4wQZ8mrZGP2xlCtWhvE6tSF0nkkbndKox5DNgJsQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8D55F3067C46;
        Mon, 29 Jun 2020 07:38:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm zoned: assign max_io_len correctly" failed to apply to 4.14-stable tree
To:     houtao1@huawei.com, damien.lemoal@wdc.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jun 2020 13:38:28 +0200
Message-ID: <15934307083243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

