Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEE0378842
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239097AbhEJLVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235414AbhEJLKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:10:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF86C6145F;
        Mon, 10 May 2021 11:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644729;
        bh=aoZGLU3h/i0WadM2DxxNm7/BB1+HyOgT5g3s4onk+jI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gYI48RRrGXI6+WhzH+34JFmbI01lvOgVdJ+mqEQA2lVAeJyy+u6HHC/Bx+hEX+hE6
         eBjLfbOd+F666eHD/SgB3sWu4O820rz8xQ1Yo5OvQv3799O++aqDu646fj13bhwpHC
         oqYAguMfBUDgSdtT5/r3JdJB+knfQv8CcIoIuCbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 201/384] mmc: sdhci-pci: Add PCI IDs for Intel LKF
Date:   Mon, 10 May 2021 12:19:50 +0200
Message-Id: <20210510102021.506006255@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 936e4db9060f..bf04a08eeba1 100644
--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -1930,6 +1930,8 @@ static const struct pci_device_id pci_ids[] = {
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



