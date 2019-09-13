Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09849B1F3B
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390022AbfIMNRN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:17:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390017AbfIMNRM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:17:12 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F321206BB;
        Fri, 13 Sep 2019 13:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380631;
        bh=Wg7z6mgIuceYzpBt4Wy510oq3yofwdeGfUZjLVoc2Hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fXmfCUNU/mi7ueQiRgYQ6yo4+S4Tt3luJWhc291AyyDOx01GFnlh9rO7rY0mlnhg
         Z7hLKMUiZ7TzbZuMIVn5RairskfRyA850oqpqnrIFYRnwheQ+hdZzk5j3gMrXpSisS
         CE6G63V+sTKX2rTWAQKnIa4r7dmP6sQJ6CbQFKwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 128/190] mmc: sdhci-pci: Add support for Intel CML
Date:   Fri, 13 Sep 2019 14:06:23 +0100
Message-Id: <20190913130610.137457843@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 765c59675ab571caf7ada456bbfd23a73136b535 ]

Add PCI Ids for Intel CML.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-pci-core.c | 2 ++
 drivers/mmc/host/sdhci-pci.h      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index c4115bae5db18..71794391f48fa 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -1577,6 +1577,8 @@ static const struct pci_device_id pci_ids[] = {
 	SDHCI_PCI_DEVICE(INTEL, CNPH_SD,   intel_byt_sd),
 	SDHCI_PCI_DEVICE(INTEL, ICP_EMMC,  intel_glk_emmc),
 	SDHCI_PCI_DEVICE(INTEL, ICP_SD,    intel_byt_sd),
+	SDHCI_PCI_DEVICE(INTEL, CML_EMMC,  intel_glk_emmc),
+	SDHCI_PCI_DEVICE(INTEL, CML_SD,    intel_byt_sd),
 	SDHCI_PCI_DEVICE(O2, 8120,     o2),
 	SDHCI_PCI_DEVICE(O2, 8220,     o2),
 	SDHCI_PCI_DEVICE(O2, 8221,     o2),
diff --git a/drivers/mmc/host/sdhci-pci.h b/drivers/mmc/host/sdhci-pci.h
index 2ef0bdca91974..6f04a62b2998e 100644
--- a/drivers/mmc/host/sdhci-pci.h
+++ b/drivers/mmc/host/sdhci-pci.h
@@ -50,6 +50,8 @@
 #define PCI_DEVICE_ID_INTEL_CNPH_SD	0xa375
 #define PCI_DEVICE_ID_INTEL_ICP_EMMC	0x34c4
 #define PCI_DEVICE_ID_INTEL_ICP_SD	0x34f8
+#define PCI_DEVICE_ID_INTEL_CML_EMMC	0x02c4
+#define PCI_DEVICE_ID_INTEL_CML_SD	0x02f5
 
 #define PCI_DEVICE_ID_SYSKONNECT_8000	0x8000
 #define PCI_DEVICE_ID_VIA_95D0		0x95d0
-- 
2.20.1



