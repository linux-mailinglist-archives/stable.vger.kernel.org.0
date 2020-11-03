Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5EE12A4ABA
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgKCQEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:04:50 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:36763 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727812AbgKCQEu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 11:04:50 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 95708D70;
        Tue,  3 Nov 2020 11:04:49 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 11:04:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9pAOzk
        J80MAQvyHpGL8BDpXMAbH0U9/aJnblw2fuVXw=; b=U1NAQQJgGPZyEGi1CiUTR8
        gCr5HZX1QGY4YyjwO3Bgd+1GYsTkpqYzgSMXdtERvtbR+sDF257De29Lm5H/2ahv
        Cr3NXWY30ZAc9LsVNSeYL2os4pRbu07dImzgi+0GfXQ1SowWQ+AnILKgbXBZfa05
        tIHbmnaL7JTouvbu3AUSCpNR0sESW3DZunEmCN1yVO/K416LVGD8GmVwDjt5yRCg
        yTO3aEFL7nqbk4JAZwUqZ0aENiQUbx++eph8rhB8U2hA5HoAmxZcc+gQ6KzeA0po
        XIchRXcwc/wWuq1TWIwVSKXUQcfrTKSp5DMpjqGIbIBdol2cnD87Qxp1FqJWxcyQ
        ==
X-ME-Sender: <xms:oH-hX-4tw0zAdDIgHZXfc3-lj4XcUygbOL-KzFK1rhyewAIQPeyiuA>
    <xme:oH-hX35-vA26DlAwqIy_ghjkfwje7Kap3iaWDpQJp3Wew4c8f8zCzZvXz0JT7NheM
    tJAYveL6FiMgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmdenucfjughrpefuvf
    fhfffkgggtgfesthekredttddtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihf
    ohhunhgurghtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltd
    etgedugeffgffhudffuddukeegfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghr
    nhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:oH-hX9dnbwpXUJVekjgr8aVL7PdXB9Y47htkMjrbqCglZZoUDPF3oQ>
    <xmx:oH-hX7LM0fnY-O2r54DasPL104x_i4rBrVSjjloJa1OtyAn1j0aVYQ>
    <xmx:oH-hXyLYlyhPtH-CCN9EWX9BHpHpCVaX8flx2pbN-xPsDlfXAcZpww>
    <xmx:oX-hX0j8PsEiJLQ8OHWBNreS8VdO0a7UDdlp-61UH1TqqwzNCJ2LXOw2C4g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A25A43280065;
        Tue,  3 Nov 2020 11:04:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: sdhci-of-esdhc: set timeout to max before tuning" failed to apply to 4.14-stable tree
To:     michael@walle.cc, adrian.hunter@intel.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 17:05:30 +0100
Message-ID: <1604419530177152@kroah.com>
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

From 0add6e9b88d0632a25323aaf4987dbacb0e4ae64 Mon Sep 17 00:00:00 2001
From: Michael Walle <michael@walle.cc>
Date: Fri, 23 Oct 2020 00:23:37 +0200
Subject: [PATCH] mmc: sdhci-of-esdhc: set timeout to max before tuning

On rare occations there is the following error:

  mmc0: Tuning timeout, falling back to fixed sampling clock

There are SD cards which takes a significant longer time to reply to the
first CMD19 command. The eSDHC takes the data timeout value into account
during the tuning period. The SDHCI core doesn't explicitly set this
timeout for the tuning procedure. Thus on the slow cards, there might be
a spurious "Buffer Read Ready" interrupt, which in turn triggers a wrong
sequence of events. In the end this will lead to an unsuccessful tuning
procedure and to the above error.

To workaround this, set the timeout to the maximum value (which is the
best we can do) and the SDHCI core will take care of the proper timeout
handling.

Fixes: ba49cbd0936e ("mmc: sdhci-of-esdhc: add tuning support")
Signed-off-by: Michael Walle <michael@walle.cc>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201022222337.19857-1-michael@walle.cc
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index 0b45eff6fed4..baf7801a1804 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -1052,6 +1052,17 @@ static int esdhc_execute_tuning(struct mmc_host *mmc, u32 opcode)
 
 	esdhc_tuning_block_enable(host, true);
 
+	/*
+	 * The eSDHC controller takes the data timeout value into account
+	 * during tuning. If the SD card is too slow sending the response, the
+	 * timer will expire and a "Buffer Read Ready" interrupt without data
+	 * is triggered. This leads to tuning errors.
+	 *
+	 * Just set the timeout to the maximum value because the core will
+	 * already take care of it in sdhci_send_tuning().
+	 */
+	sdhci_writeb(host, 0xe, SDHCI_TIMEOUT_CONTROL);
+
 	hs400_tuning = host->flags & SDHCI_HS400_TUNING;
 
 	do {

