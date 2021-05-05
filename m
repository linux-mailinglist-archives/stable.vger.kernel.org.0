Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B6C374187
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbhEEQi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:38:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234764AbhEEQg6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:36:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D27C1613FE;
        Wed,  5 May 2021 16:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232402;
        bh=7lPYU2+h32CIcM9NYvFnxpmwJr7/yHwrz8ZZlc+O1is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/2MZocsAn2iXYQXnNlX1qsETvX15fgB+0AVpPX2I2usyDmDio2dJmw2vSBR81zu9
         X695XgvNWIBxGH9Y6fkcBIJbk8DNsits/UcpHwPIFXsoqikuG09VUbji8wHt82E54g
         FYRWj3R0PGeY2glMNluP2dXO7qWh3hT7XEypSKxVr8fC+ZupuhWtd7lYj5UO7Cv+9S
         PBpTcfKMSv83kWu6gglpsaS68Oa/a/qMyK+S6ZR8iFAAq0vTw/DPFuODVWh2Xltc1J
         dAQ5pY9W7f+97PxosRjZjXhncSidyOIUUODRqpvMiLoq3VehnMwj3TWxANUcQLueAa
         p0dAgMLwfrJyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 083/116] i2c: i801: Add support for Intel Alder Lake PCH-M
Date:   Wed,  5 May 2021 12:30:51 -0400
Message-Id: <20210505163125.3460440-83-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 8f51c1763ae98bb63fc04627ceae383aa0e8ff7b ]

Add PCI ID of SMBus controller on Intel Alder Lake PCH-M.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-i801.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 4acee6f9e5a3..99d446763530 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -73,6 +73,7 @@
  * Comet Lake-V (PCH)		0xa3a3	32	hard	yes	yes	yes
  * Alder Lake-S (PCH)		0x7aa3	32	hard	yes	yes	yes
  * Alder Lake-P (PCH)		0x51a3	32	hard	yes	yes	yes
+ * Alder Lake-M (PCH)		0x54a3	32	hard	yes	yes	yes
  *
  * Features supported by this driver:
  * Software PEC				no
@@ -230,6 +231,7 @@
 #define PCI_DEVICE_ID_INTEL_ELKHART_LAKE_SMBUS		0x4b23
 #define PCI_DEVICE_ID_INTEL_JASPER_LAKE_SMBUS		0x4da3
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_P_SMBUS		0x51a3
+#define PCI_DEVICE_ID_INTEL_ALDER_LAKE_M_SMBUS		0x54a3
 #define PCI_DEVICE_ID_INTEL_BROXTON_SMBUS		0x5ad4
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_S_SMBUS		0x7aa3
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS		0x8c22
@@ -1087,6 +1089,7 @@ static const struct pci_device_id i801_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_JASPER_LAKE_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ALDER_LAKE_S_SMBUS) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ALDER_LAKE_P_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ALDER_LAKE_M_SMBUS) },
 	{ 0, }
 };
 
@@ -1771,6 +1774,7 @@ static int i801_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	case PCI_DEVICE_ID_INTEL_EBG_SMBUS:
 	case PCI_DEVICE_ID_INTEL_ALDER_LAKE_S_SMBUS:
 	case PCI_DEVICE_ID_INTEL_ALDER_LAKE_P_SMBUS:
+	case PCI_DEVICE_ID_INTEL_ALDER_LAKE_M_SMBUS:
 		priv->features |= FEATURE_BLOCK_PROC;
 		priv->features |= FEATURE_I2C_BLOCK_READ;
 		priv->features |= FEATURE_IRQ;
-- 
2.30.2

