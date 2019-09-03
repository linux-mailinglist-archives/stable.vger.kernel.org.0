Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9111A72D8
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfICSxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:53:53 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52461 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726009AbfICSxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:53:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4A1A522212;
        Tue,  3 Sep 2019 14:53:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 14:53:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=PtEElV
        ZaZ4wOosRGXJD+cr/M3TPKI2xhO8gTUkSMHEg=; b=L4eIh4gofIG4oQmlk7C64d
        j411ceM+ibsa+sx7WRRP2PYDBSNTABaMlqo9LSjEeUJWdGrHmv1cSVDjdq5L0eFr
        0gXeNyib93NkZrQtj9HRqZ5RmH9s0ZZlSFdhaL/rUIC366guGW77fz0PzGlFJmVJ
        SESKlr12PSMNSrEViQVP/kB5OpAKSrjw8BKOLzSCxfz37TYEjszt9A0PsWpFtgGU
        /S6dMdG6F6dm0bY5/++yAx2YM7g32ADVpS/Vht19TXV0Ehll78pLNc6topL01tVv
        vOocqOnfJX/+bx+Ms2u0lG90aDAYB47NO5sDDdqGhqso/mNiNnag6DVRACoqa9rg
        ==
X-ME-Sender: <xms:wLZuXSfokoCv_wMhfCBc10jhW99Z7J1KJxKrEHMh4bW51inzNONX5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:wLZuXYQ3wnJWLtovEVp9CZ8-C9RfTTVjST_rq-12szkWQu_fLKYWpg>
    <xmx:wLZuXQOKgjMm4Aa8GIGU-4ItIpsKztqk2RncyWAco-F-35id1_CJDw>
    <xmx:wLZuXWSjgCwehiwi18fx5Y4d4w8dkQGQE6jXlx8XjhKo9JytJllIDQ>
    <xmx:wLZuXRXgIghvJD6MfkRq6onUoYSWbGoYnOwqUrAJnFvqW-GBzcpyUw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE057D60057;
        Tue,  3 Sep 2019 14:53:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: sdhci-sprd: add get_ro hook function" failed to apply to 5.2-stable tree
To:     chunyan.zhang@unisoc.com, baolin.wang@linaro.org,
        ulf.hansson@linaro.org, zhang.lyra@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 20:53:50 +0200
Message-ID: <1567536830154206@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4eae8cbdff942a423926486be4e781a77d619966 Mon Sep 17 00:00:00 2001
From: Chunyan Zhang <chunyan.zhang@unisoc.com>
Date: Wed, 28 Aug 2019 10:17:33 +0800
Subject: [PATCH] mmc: sdhci-sprd: add get_ro hook function

sprd's sd host controller doesn't support write protect to sd card.

Fixes: fb8bd90f83c4 ("mmc: sdhci-sprd: Add Spreadtrum's initial host controller")
Signed-off-by: Chunyan Zhang <chunyan.zhang@unisoc.com>
Signed-off-by: Chunyan Zhang <zhang.lyra@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linaro.org>
Tested-by: Baolin Wang <baolin.wang@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-sprd.c b/drivers/mmc/host/sdhci-sprd.c
index 25f2fc4ce08f..ddc048e72385 100644
--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -374,6 +374,11 @@ static unsigned int sdhci_sprd_get_max_timeout_count(struct sdhci_host *host)
 	return 1 << 31;
 }
 
+static unsigned int sdhci_sprd_get_ro(struct sdhci_host *host)
+{
+	return 0;
+}
+
 static struct sdhci_ops sdhci_sprd_ops = {
 	.read_l = sdhci_sprd_readl,
 	.write_l = sdhci_sprd_writel,
@@ -386,6 +391,7 @@ static struct sdhci_ops sdhci_sprd_ops = {
 	.set_uhs_signaling = sdhci_sprd_set_uhs_signaling,
 	.hw_reset = sdhci_sprd_hw_reset,
 	.get_max_timeout_count = sdhci_sprd_get_max_timeout_count,
+	.get_ro = sdhci_sprd_get_ro,
 };
 
 static void sdhci_sprd_request(struct mmc_host *mmc, struct mmc_request *mrq)

