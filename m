Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249D6301C2F
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbhAXNYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:24:36 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:41945 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726672AbhAXNYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:24:31 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 35849B0A;
        Sun, 24 Jan 2021 08:23:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:23:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZnG/BV
        rgrqDvrYSA1OB6XahX/ltRA+CNJnIV04qD06E=; b=nzmuHbIeyP4LcSeBhewTis
        v0vNzBNkCjF227S6SJhXKm7j26rldeNLehgOOuAEYSXsZc6X+6troRboebKr173D
        TeIcmQtlSWj959NO/5yNV+nHIz9PADzNufoeFl+Mda9zZqwEgl47MJnP7bgq6jsL
        lNhqNv/20Z1zniFXc4VtckugktdjGx3VOxq0ray2sYbAszlG0NqFJdNdBvQ4jKRU
        Uq8gDEw/o5YW9zTiQZbfeGMP52SSLKAehwH8pqBDYY5U87PGWfEg4YmVLzUm0nHC
        VV91Lw0G64LVvqIFLuOX/PVBPjGHAPHzQ8TCkzwapr726WTeFHSKvBIS9Mx0UMBw
        ==
X-ME-Sender: <xms:5XQNYJG9WvWU-C6_Ee3AuPlgDCtgWhYeFy_zS2UjD55ZntYvgNWkvw>
    <xme:5XQNYOUYlcVLVHLmskMVx2NL4HPdX547XpJkul9Gcvyr9zQQaQLN2zja66xlgb55w
    WNpKqnYLcC8Gg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeevkeelveeiteetfeehtddugeegffevgedtueegieeftd
    effeelueetteeihfdtjeenucffohhmrghinhepghhoohhglhgvshhouhhrtggvrdgtohhm
    pdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvg
    hrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:5XQNYLKvVZWVgqek_WOuR8MZdMavNG2_vJwvlQH6oO2W3BCfcQ7LhA>
    <xmx:5XQNYPEmUSqSmIV4v5mVUopvofhrRMEvU6Gnk_tT2It_9udjsZ5ZDg>
    <xmx:5XQNYPXe-Q1-Rs8EhLvnIOMux1mzHjaY5FTgYo_1hknmlB_nkfXekA>
    <xmx:5XQNYMj14x_CJlCQt0_px0SEIVzwnnz0qfdWj8qI0hGdDazd58bCzxKzzK8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7F8A9240057;
        Sun, 24 Jan 2021 08:23:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: core: don't initialize block size from ext_csd if not" failed to apply to 4.14-stable tree
To:     pcc@google.com, adrian.hunter@intel.com, damien.lemoal@wdc.com,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:23:39 +0100
Message-ID: <161149461967212@kroah.com>
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

From b503087445ce7e45fabdee87ca9e460d5b5b5168 Mon Sep 17 00:00:00 2001
From: Peter Collingbourne <pcc@google.com>
Date: Thu, 14 Jan 2021 12:14:05 -0800
Subject: [PATCH] mmc: core: don't initialize block size from ext_csd if not
 present

If extended CSD was not available, the eMMC driver would incorrectly
set the block size to 0, as the data_sector_size field of ext_csd
was never initialized. This issue was exposed by commit 817046ecddbc
("block: Align max_hw_sectors to logical blocksize") which caused
max_sectors and max_hw_sectors to be set to 0 after setting the block
size to 0, resulting in a kernel panic in bio_split when attempting
to read from the device. Fix it by only reading the block size from
ext_csd if it is available.

Fixes: a5075eb94837 ("mmc: block: Allow disabling 512B sector size emulation")
Signed-off-by: Peter Collingbourne <pcc@google.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Link: https://linux-review.googlesource.com/id/If244d178da4d86b52034459438fec295b02d6e60
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210114201405.2934886-1-pcc@google.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index de7cb0369c30..002426e3cf76 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -384,8 +384,10 @@ static void mmc_setup_queue(struct mmc_queue *mq, struct mmc_card *card)
 		     "merging was advertised but not possible");
 	blk_queue_max_segments(mq->queue, mmc_get_max_segments(host));
 
-	if (mmc_card_mmc(card))
+	if (mmc_card_mmc(card) && card->ext_csd.data_sector_size) {
 		block_size = card->ext_csd.data_sector_size;
+		WARN_ON(block_size != 512 && block_size != 4096);
+	}
 
 	blk_queue_logical_block_size(mq->queue, block_size);
 	/*

