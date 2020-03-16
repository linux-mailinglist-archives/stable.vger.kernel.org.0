Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C942186A11
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 12:31:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730773AbgCPLbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 07:31:23 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:48945 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730698AbgCPLbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 07:31:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 179417FC;
        Mon, 16 Mar 2020 07:31:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 07:31:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8yTgdt
        HZxpqr7oz5H191kAi9PBvdEr+TykV9xHISiNM=; b=vAm98HPMhKesIZwLQwBCuc
        Y7uG9CPl4fsM1CGWiLJ/9629cId91O1njT/EarqslUs0kM/OKjTwj9aSzcHvurBx
        ZEv+eE5Ytuccxd0zGuAci01rPepWwIivcRjmC84Ey7YoB3/3xBg5D3W1BKqUhwBX
        9No168MXjeCO8vvdrBee148ewYJWPy8wXzwGUKhrE3KGEXWPFsPZdXlm3x83lQyy
        XAarf2wPv/851SfEBWxs67REmlDK75FlhlB41l3OdCGFcWjXiTmF7V3uQ/iOeUI2
        3+QBIV4tr8S5C79howKj/hB2A6Wl5bu/vvnUkzCpok/nMxB8oFKXrCvTfeO3N9kQ
        ==
X-ME-Sender: <xms:iWNvXtYMYT8F24Qobfjv3CfJA2PO4hEMjRkqT8phsg_0olG8lv7rxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:iWNvXk2Cj7KmiQp_VRAhO78V1y1oRrdV0PrWLbAXvNpkmCd3J76D7g>
    <xmx:iWNvXlbs5a-wbC7zcUwm17_z4MMGqlurcbzQaZ5wAQP5cvyvTisdMQ>
    <xmx:iWNvXpk7uwBmlDnKOOaiaUqnKfGSAA9ypk2o-Dm1Tq2aFgGQk6yw2g>
    <xmx:iWNvXmBIjlLFPKnUQYhQehx9-riQNtr21H8JBelvsNreNPYKwWkQrg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD9E0306218B;
        Mon, 16 Mar 2020 07:31:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: core: Allow host controllers to require R1B for CMD6" failed to apply to 5.5-stable tree
To:     ulf.hansson@linaro.org, anders.roxell@linaro.org,
        faiz_abbas@ti.com, pgwipeout@gmail.com, skomatineni@nvidia.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 12:31:18 +0100
Message-ID: <158435827821152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1292e3efb149ee21d8d33d725eeed4e6b1ade963 Mon Sep 17 00:00:00 2001
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 10 Mar 2020 12:49:43 +0100
Subject: [PATCH] mmc: core: Allow host controllers to require R1B for CMD6

It has turned out that some host controllers can't use R1B for CMD6 and
other commands that have R1B associated with them. Therefore invent a new
host cap, MMC_CAP_NEED_RSP_BUSY to let them specify this.

In __mmc_switch(), let's check the flag and use it to prevent R1B responses
from being converted into R1. Note that, this also means that the host are
on its own, when it comes to manage the busy timeout.

Suggested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Cc: <stable@vger.kernel.org>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Tested-by: Faiz Abbas <faiz_abbas@ti.com>
Tested-By: Peter Geis <pgwipeout@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index da425ee2d9bf..e025604e17d4 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -542,9 +542,11 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 	 * If the max_busy_timeout of the host is specified, make sure it's
 	 * enough to fit the used timeout_ms. In case it's not, let's instruct
 	 * the host to avoid HW busy detection, by converting to a R1 response
-	 * instead of a R1B.
+	 * instead of a R1B. Note, some hosts requires R1B, which also means
+	 * they are on their own when it comes to deal with the busy timeout.
 	 */
-	if (host->max_busy_timeout && (timeout_ms > host->max_busy_timeout))
+	if (!(host->caps & MMC_CAP_NEED_RSP_BUSY) && host->max_busy_timeout &&
+	    (timeout_ms > host->max_busy_timeout))
 		use_r1b_resp = false;
 
 	cmd.opcode = MMC_SWITCH;
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index ba703384bea0..4c5eb3aa8e72 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -333,6 +333,7 @@ struct mmc_host {
 				 MMC_CAP_UHS_SDR50 | MMC_CAP_UHS_SDR104 | \
 				 MMC_CAP_UHS_DDR50)
 #define MMC_CAP_SYNC_RUNTIME_PM	(1 << 21)	/* Synced runtime PM suspends. */
+#define MMC_CAP_NEED_RSP_BUSY	(1 << 22)	/* Commands with R1B can't use R1. */
 #define MMC_CAP_DRIVER_TYPE_A	(1 << 23)	/* Host supports Driver Type A */
 #define MMC_CAP_DRIVER_TYPE_C	(1 << 24)	/* Host supports Driver Type C */
 #define MMC_CAP_DRIVER_TYPE_D	(1 << 25)	/* Host supports Driver Type D */

