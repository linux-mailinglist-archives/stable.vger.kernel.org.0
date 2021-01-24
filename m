Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9660301C35
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbhAXNZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:25:27 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:44277 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726672AbhAXNZ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:25:26 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B5CBCEB1;
        Sun, 24 Jan 2021 08:24:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:24:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xV/4fZ
        sHtbHe0vMDgsId3eEShClwlsHU3zzCl5J6yCs=; b=bE/fFKzmi3Z43p22J16TxO
        5JKPlsIk6rnkUfXCjGapDz93Z97IalFDre1sbFOMiZPaqtlINHMKeNJ6Kq47BC47
        i+GqzKsmwKsfXkPP0ULC2JUmgL91Tm6Z5qhnZ7S45L5fCZks+4gyFY1DBy2+vaah
        /Ejbp6r6eJxy/QulTSu/gBKdLFgwLXzYRqni3xUQ/DuFKMBgQnHYVOcn4dmDEev8
        JvYcL7gF2FbZTPQRJKgnHib/AU/A2XzIK7//Kjhhd+/a/Sl/JUVuMmYfNrxBgmtI
        wWBCpIpxJ1QBjzHeFXuGWoJ8l63BCzl54rpN6WBYtzjbY96+TanHqOQEcQvcwZ6w
        ==
X-ME-Sender: <xms:A3UNYHDzt8VEml6DH1Li-mvbrnoJ39XMjjGAIB1myDmYRAoFNtx44w>
    <xme:A3UNYNhiP0cOo3tGKOIG9_MixLGDgaqFPMZpFtygAyJWWY6xawPvGXhrxMmc35KS9
    MZEZym0c07mNg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:A3UNYCl-S69aOnSbBfvVB1toqmCeQeoIpKQas380H6sINj2KKX-I4Q>
    <xmx:A3UNYJz5LJcG2PRSnWW4JxLh9Oeme115_3BsL21Fegh17jsaiAMBEA>
    <xmx:A3UNYMQzfGavCdYrwsMvqbHujLj63jfh8WyakAjs3Uno385dXN3u8g>
    <xmx:A3UNYHIct366Ldy9DRIKnnE6q33IQonzJX0GxJOXO3ZLa7Vks-WOZLeBRC8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DFF071080059;
        Sun, 24 Jan 2021 08:24:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: sdhci-of-dwcmshc: fix rpmb access" failed to apply to 4.19-stable tree
To:     Jisheng.Zhang@synaptics.com, adrian.hunter@intel.com,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:24:17 +0100
Message-ID: <1611494657113254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From ca1219c0a7432272324660fc9f61a9940f90c50b Mon Sep 17 00:00:00 2001
From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Date: Tue, 29 Dec 2020 16:16:25 +0800
Subject: [PATCH] mmc: sdhci-of-dwcmshc: fix rpmb access

Commit a44f7cb93732 ("mmc: core: use mrq->sbc when sending CMD23 for
RPMB") began to use ACMD23 for RPMB if the host supports ACMD23. In
RPMB ACM23 case, we need to set bit 31 to CMD23 argument, otherwise
RPMB write operation will return general fail.

However, no matter V4 is enabled or not, the dwcmshc's ARGUMENT2
register is 32-bit block count register which doesn't support stuff
bits of CMD23 argument. So let's handle this specific ACMD23 case.

From another side, this patch also prepare for future v4 enabling
for dwcmshc, because from the 4.10 spec, the ARGUMENT2 register is
redefined as 32bit block count which doesn't support stuff bits of
CMD23 argument.

Fixes: a44f7cb93732 ("mmc: core: use mrq->sbc when sending CMD23 for RPMB")
Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20201229161625.38255233@xhacker.debian
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

diff --git a/drivers/mmc/host/sdhci-of-dwcmshc.c b/drivers/mmc/host/sdhci-of-dwcmshc.c
index 4b673792b5a4..d90020ed3622 100644
--- a/drivers/mmc/host/sdhci-of-dwcmshc.c
+++ b/drivers/mmc/host/sdhci-of-dwcmshc.c
@@ -16,6 +16,8 @@
 
 #include "sdhci-pltfm.h"
 
+#define SDHCI_DWCMSHC_ARG2_STUFF	GENMASK(31, 16)
+
 /* DWCMSHC specific Mode Select value */
 #define DWCMSHC_CTRL_HS400		0x7
 
@@ -49,6 +51,29 @@ static void dwcmshc_adma_write_desc(struct sdhci_host *host, void **desc,
 	sdhci_adma_write_desc(host, desc, addr, len, cmd);
 }
 
+static void dwcmshc_check_auto_cmd23(struct mmc_host *mmc,
+				     struct mmc_request *mrq)
+{
+	struct sdhci_host *host = mmc_priv(mmc);
+
+	/*
+	 * No matter V4 is enabled or not, ARGUMENT2 register is 32-bit
+	 * block count register which doesn't support stuff bits of
+	 * CMD23 argument on dwcmsch host controller.
+	 */
+	if (mrq->sbc && (mrq->sbc->arg & SDHCI_DWCMSHC_ARG2_STUFF))
+		host->flags &= ~SDHCI_AUTO_CMD23;
+	else
+		host->flags |= SDHCI_AUTO_CMD23;
+}
+
+static void dwcmshc_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	dwcmshc_check_auto_cmd23(mmc, mrq);
+
+	sdhci_request(mmc, mrq);
+}
+
 static void dwcmshc_set_uhs_signaling(struct sdhci_host *host,
 				      unsigned int timing)
 {
@@ -133,6 +158,8 @@ static int dwcmshc_probe(struct platform_device *pdev)
 
 	sdhci_get_of_property(pdev);
 
+	host->mmc_host_ops.request = dwcmshc_request;
+
 	err = sdhci_add_host(host);
 	if (err)
 		goto err_clk;

