Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F0A301C34
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 14:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbhAXNZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 08:25:17 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:41101 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726672AbhAXNZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Jan 2021 08:25:16 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id AED8DE77;
        Sun, 24 Jan 2021 08:24:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 24 Jan 2021 08:24:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=WZ8ZBC
        sFRPXKk3XWVnDYLk0n7U15i8Ll7pqxxr34D6M=; b=dZwMjxPQWEAezm7XmwXj8w
        J9a5ddxBwBZIa1Tms56owQuLoDX1O0oiXnQXMaRtWqtT2wO8uh7Nbt5dMzHZBQhp
        V9PpUQcUVynE0bIjFNHFPoN08yl6gnSmDCeh8/CXOjID8Ew7zuB7ytfOVIMh4RMF
        w/hFlvcsV+rBNTDfRSezUFcXKYL8B3Tml0Lp+FffunnRv9OHPiP+og6gPKOyG+sM
        1KxzxJFyg1Nsd/lXr61C5z7ZQcDda9YgrKZLeE2VqL044okBrPhpFwddYzPwJusW
        tWYfy2OXYXsv1IkhHJnl0ShzhVPz1Gu2uyKFNHtcTTg+ocGAGGo/F7MQowNdFoGQ
        ==
X-ME-Sender: <xms:DHUNYLpB5Jdsh8Cu72yt16q_TwleviO4QpNwnuZMNc-Sy9NJsSsasQ>
    <xme:DHUNYFo0q-pKEx-zZ-osDzC29B-VPnWGGHj_InuDVoeTE158VAaToYHxBqjxQFRYa
    -qCa1Bszaa33w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:DHUNYIN-RgLGGPGE9D7hUBIfRKsf6xKOGg8r6w5m6Axj1oo4mfU38g>
    <xmx:DHUNYO77VM0pA3rKubfRFWakNxAOqk-eSPrusa2CfCucNbURY2z-zw>
    <xmx:DHUNYK7cMqcMu2atrtpLqMd7e1NKzCR3v5kOulfd_bQYNBRotxQ4rw>
    <xmx:DHUNYARXKpf0TsXojDZrNwdy-mHEOSgGKEtENlRmQsn1F8zmj8-pbg9FsEs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1D32108005C;
        Sun, 24 Jan 2021 08:24:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] mmc: sdhci-of-dwcmshc: fix rpmb access" failed to apply to 5.4-stable tree
To:     Jisheng.Zhang@synaptics.com, adrian.hunter@intel.com,
        ulf.hansson@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 24 Jan 2021 14:24:18 +0100
Message-ID: <16114946587033@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

