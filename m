Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F295301C31
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbhAXNY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:24:56 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:56511 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726993AbhAXNYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:24:55 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id A5CC7EAA;
        Sun, 24 Jan 2021 08:23:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:23:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PZiYNV
        ITTxQDCYsXCRDlmV8IKpJIV/AyuWN4b+POgw4=; b=QH+Jl3eweTUGRkRzVjG7zK
        GfHt/XxAiN8VzNpEGIlAKO4v9H3C9cfZM5geu0Y0ruDQ4bpWpf6u1MN4PAJtgV5Q
        0U2Tj/DY0a/mT1M4dT+3g4/SL1rlNq4daQzqgKFNcEtAxQwCTMj79BN539VmHahG
        DE8QxlTmQaN9/jwjO+poTDoUQFfv8ggHJaWWX5fjKQF8LWCyRnHk2Gar6KaJQBF2
        7W1E2LjtoDgLp9ZTSnIo1xcotCxm2tF+xmVYSWVkd5e4irA9K7CMbe1HygOkrOXZ
        HMvC4eNQ5dM6xx7vIlIyHUXfRMdaeNBS43yhWEfv8cgOoqA858WYxyEESi6D2Bow
        ==
X-ME-Sender: <xms:5HQNYF5cjXX2oqFA3CyrcFINah-fwSyCCPOmfr63icVVHVog4nw04Q>
    <xme:5HQNYC7kygDY1WD-NpLeyn6x5Ykpl3QZVmnX3dbDR9AvTpIwbrrAh3j6yhQHdxLam
    nq58CE7IJjzIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeevkeelveeiteetfeehtddugeegffevgedtueegieeftd
    effeelueetteeihfdtjeenucffohhmrghinhepghhoohhglhgvshhouhhrtggvrdgtohhm
    pdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvg
    hrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:5HQNYMfTLNX4jbQbHBdLnUlhcR1AXxJYoqo4N5ODaFIX_K3_JoTUzA>
    <xmx:5HQNYOJhshzHPcPry7qxqCASH9jO1HjYp3vmkKsocJAzMDPHFrK5vQ>
    <xmx:5HQNYJJ9gPB7HjD7ZSAoRxKN3BTepYNqknOSy86NPkugd7eNaMTYYw>
    <xmx:5HQNYAXrcl_LFISZ1kaiPiJc5_xmX0_aNyoReiPOAmxhq5coXgIpD8_PCAA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EF4C5108005C;
        Sun, 24 Jan 2021 08:23:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: core: don't initialize block size from ext_csd if not" failed to apply to 4.9-stable tree
To:     pcc@google.com, adrian.hunter@intel.com, damien.lemoal@wdc.com,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:23:38 +0100
Message-ID: <1611494618175232@kroah.com>
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

