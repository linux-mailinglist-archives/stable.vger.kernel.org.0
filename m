Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D97CFFE4
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 19:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfJHRa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 13:30:26 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38037 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbfJHRa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 13:30:26 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6AB4521EA7;
        Tue,  8 Oct 2019 13:30:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 13:30:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=dyfkOv
        Sk76MJ8ZKJI/M4zNW7AYmdHi27qyTQkNX0Z/o=; b=M68XuMJe9OJLvNupCEbaqe
        VxN0dSXiul71dozbd+V6BCW2jYuk67uiapRIB2ykPywxDpH8ZryOS/oLwdmmcVxr
        dKKew651u0hTmkjFvDERgmPi8w3vQD8HSRY6/5383PmnRCtq/pNOgh6fVmi9Yr99
        LHjRPMw3amzZZJBvd6bE8JGjIuwU53QVoKDO31f86tFrCP8ZtkjLT+kG7KbjZnS6
        XCtNmMbz/IwU8UeZjX3/KsFY4O1y0lIgsRDP4LJ2mJx9CHmCrxcXX7MXgN2zHlFy
        vQUT7BV3uo85YtLtkMVAOIf2rGFXE+1oLD3M62B5kro8a2GFQHSfRuD9KcCczX5A
        ==
X-ME-Sender: <xms:scecXXybtbjjyTJxxu1UvZoqloic3lkbvSskLFe08ahSBZLk1H6H0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:scecXaVCSRPgUda5Z5ojmkJ69Ppe4H3EulcWrNsYe7Lnr7J_Woj07g>
    <xmx:scecXZYtsmdQSO-0Js2nnY9DodRhOtIqtP6N5S3slZkOuGf-NKd2Gg>
    <xmx:scecXTxmggKTt7bq-Gj4dCz0hPs1rjHrqhdLYOQX_Nc2NmxY-AvxzA>
    <xmx:scecXeTQUa8213ZcXjl47mv8Ve6CyeoNFC5eTnIKvCsKdaRUIQLBcQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D4D58005C;
        Tue,  8 Oct 2019 13:30:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mmc: sdhci: Let drivers define their DMA mask" failed to apply to 4.19-stable tree
To:     adrian.hunter@intel.com, nicoleotsuka@gmail.com,
        treding@nvidia.com, ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 19:30:21 +0200
Message-ID: <1570555821228116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4ee7dde4c777f14cb0f98dd201491bf6cc15899b Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@intel.com>
Date: Mon, 23 Sep 2019 12:08:09 +0200
Subject: [PATCH] mmc: sdhci: Let drivers define their DMA mask

Add host operation ->set_dma_mask() so that drivers can define their own
DMA masks.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Nicolin Chen <nicoleotsuka@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: stable@vger.kernel.org # v4.15 +
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 922a5b594c5e..b056400e34b1 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -3781,18 +3781,14 @@ int sdhci_setup_host(struct sdhci_host *host)
 		host->flags &= ~SDHCI_USE_ADMA;
 	}
 
-	/*
-	 * It is assumed that a 64-bit capable device has set a 64-bit DMA mask
-	 * and *must* do 64-bit DMA.  A driver has the opportunity to change
-	 * that during the first call to ->enable_dma().  Similarly
-	 * SDHCI_QUIRK2_BROKEN_64_BIT_DMA must be left to the drivers to
-	 * implement.
-	 */
 	if (sdhci_can_64bit_dma(host))
 		host->flags |= SDHCI_USE_64_BIT_DMA;
 
 	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
-		ret = sdhci_set_dma_mask(host);
+		if (host->ops->set_dma_mask)
+			ret = host->ops->set_dma_mask(host);
+		else
+			ret = sdhci_set_dma_mask(host);
 
 		if (!ret && host->ops->enable_dma)
 			ret = host->ops->enable_dma(host);
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index a29c4cd2d92e..0ed3e0eaef5f 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -622,6 +622,7 @@ struct sdhci_ops {
 
 	u32		(*irq)(struct sdhci_host *host, u32 intmask);
 
+	int		(*set_dma_mask)(struct sdhci_host *host);
 	int		(*enable_dma)(struct sdhci_host *host);
 	unsigned int	(*get_max_clock)(struct sdhci_host *host);
 	unsigned int	(*get_min_clock)(struct sdhci_host *host);

