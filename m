Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411DB371C25
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbhECQvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:32786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233826AbhECQtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:49:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A39061625;
        Mon,  3 May 2021 16:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060025;
        bh=mXsDBeuUMPBFRFVJrs9IFZVcnbArBC21XvWEUdKywGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJ4Sp457wMfBgOa5zABk9MIBBIuvS2IVpPMuROFh2cIB7masPWSIT7EUMsrytWUpz
         zY0vesQ38hhMYm4oGmSzWveUa+YpoecoZP4yseUzpcyyOlFPQC6cnZP9r7NZOiGpW+
         W+qNZOuRRDf2gZrM1N1ceA4o6Zo/WubwX/fbruDqA3R+n/y9wHI1n7G35+mLznDIHl
         N9yCa8W4Y2hMSSxNfkWO7Fi4exflgujjgQ9EXXzl9CkrQzq7GPecpQr+MBeGXv2iYx
         wQ8F/x7rpBc/NxjXvVTd5LLjvQE/e7ilUXHN1PxsK9PCeNmYJj7Qocoo09kBO7fQce
         otUoCyUhqYGRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 28/57] mmc: sdhci-pci: Add PCI IDs for Intel LKF
Date:   Mon,  3 May 2021 12:39:12 -0400
Message-Id: <20210503163941.2853291-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit ee629112be8b4eff71d4d3d108a28bc7dc877e13 ]

Add PCI IDs for Intel LKF eMMC and SD card host controllers.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20210322055356.24923-1-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-pci-core.c | 2 ++
 drivers/mmc/host/sdhci-pci.h      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/mmc/host/sdhci-pci-core.c b/drivers/mmc/host/sdhci-pci-core.c
index afbccfceaaf8..3bfe5406a686 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -1907,6 +1907,8 @@ static const struct pci_device_id pci_ids[] = {
 	SDHCI_PCI_DEVICE(INTEL, CMLH_SD,   intel_byt_sd),
 	SDHCI_PCI_DEVICE(INTEL, JSL_EMMC,  intel_glk_emmc),
 	SDHCI_PCI_DEVICE(INTEL, JSL_SD,    intel_byt_sd),
+	SDHCI_PCI_DEVICE(INTEL, LKF_EMMC,  intel_glk_emmc),
+	SDHCI_PCI_DEVICE(INTEL, LKF_SD,    intel_byt_sd),
 	SDHCI_PCI_DEVICE(O2, 8120,     o2),
 	SDHCI_PCI_DEVICE(O2, 8220,     o2),
 	SDHCI_PCI_DEVICE(O2, 8221,     o2),
diff --git a/drivers/mmc/host/sdhci-pci.h b/drivers/mmc/host/sdhci-pci.h
index 981bbbe63aff..779156ce1ee1 100644
--- a/drivers/mmc/host/sdhci-pci.h
+++ b/drivers/mmc/host/sdhci-pci.h
@@ -57,6 +57,8 @@
 #define PCI_DEVICE_ID_INTEL_CMLH_SD	0x06f5
 #define PCI_DEVICE_ID_INTEL_JSL_EMMC	0x4dc4
 #define PCI_DEVICE_ID_INTEL_JSL_SD	0x4df8
+#define PCI_DEVICE_ID_INTEL_LKF_EMMC	0x98c4
+#define PCI_DEVICE_ID_INTEL_LKF_SD	0x98f8
 
 #define PCI_DEVICE_ID_SYSKONNECT_8000	0x8000
 #define PCI_DEVICE_ID_VIA_95D0		0x95d0
-- 
2.30.2

