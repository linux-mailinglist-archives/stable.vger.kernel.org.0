Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D085371BD3
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhECQsu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233018AbhECQqs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:46:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F222E616EA;
        Mon,  3 May 2021 16:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059975;
        bh=ZN2qy5cMyzSe9YDw617ZLhB/+iq6NUKQkvsHc1nt9ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jG5ID60LDm7abj/0Z67t5c+A4J33F1u5XSBbUqdO9gwwZTGaPw1m4tUAih/9fMGNE
         Zd1nQwkegG/ziEM6lGm4yWUtZeHA8i6dRXvOLO6hsRDBLjmxR6S6WEOThPtsxQvjYb
         BhD3XsFMIIE+RhpWxHTA46S8zWuADCM79VZ1khEdxXy6sV5xlCMX4PuZOL6fzHcR2y
         9MuW69N7loeYa9mTylzWgI/FPvNU1k58y5foJMuR5PkbNRMseYXFkVtIQEonQBP07K
         XWN7kfNWj3fVuA9LKeB7bZLXzzQVWqzUHpbFLOia4wOmcljBcHBQw0FjVaCc++4oUt
         ZEZIcOEgEZ42w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 043/100] mmc: sdhci-pci: Add PCI IDs for Intel LKF
Date:   Mon,  3 May 2021 12:37:32 -0400
Message-Id: <20210503163829.2852775-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
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
index 9552708846ca..393e6251b3c3 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -1903,6 +1903,8 @@ static const struct pci_device_id pci_ids[] = {
 	SDHCI_PCI_DEVICE(INTEL, CMLH_SD,   intel_byt_sd),
 	SDHCI_PCI_DEVICE(INTEL, JSL_EMMC,  intel_glk_emmc),
 	SDHCI_PCI_DEVICE(INTEL, JSL_SD,    intel_byt_sd),
+	SDHCI_PCI_DEVICE(INTEL, LKF_EMMC,  intel_glk_emmc),
+	SDHCI_PCI_DEVICE(INTEL, LKF_SD,    intel_byt_sd),
 	SDHCI_PCI_DEVICE(O2, 8120,     o2),
 	SDHCI_PCI_DEVICE(O2, 8220,     o2),
 	SDHCI_PCI_DEVICE(O2, 8221,     o2),
diff --git a/drivers/mmc/host/sdhci-pci.h b/drivers/mmc/host/sdhci-pci.h
index d0ed232af0eb..8f90c4163bb5 100644
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

