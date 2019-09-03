Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD33A6F45
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbfICQbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:31:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:50238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731091AbfICQ2U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0147823431;
        Tue,  3 Sep 2019 16:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528099;
        bh=TuQ/ocUSCU4+kYRLcX0jTnAXGkVW1Igvlj9UAItxga0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdiO46jwFrcvwtToqfmHBsrjj8DgzhPlnJd8hV1EJWy6vTCxxAj+hhCd7PCFusTfq
         +NrbN31GE7dScYVGJeF+0VkVRcL4FdglqyTyhVZSKyx2H29JPW4UghphsfK9jKLr47
         Afv0T4yUxjFI7XDld2V/kU2BPxI+7bC8AC5cDAFQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 107/167] mmc: sdhci-pci: Add support for Intel CML
Date:   Tue,  3 Sep 2019 12:24:19 -0400
Message-Id: <20190903162519.7136-107-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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

