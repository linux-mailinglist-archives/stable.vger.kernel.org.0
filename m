Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1D9C17E3
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730459AbfI2Rev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:34:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730450AbfI2Rev (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:34:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD3EB21925;
        Sun, 29 Sep 2019 17:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778490;
        bh=1F6bt5RpTUbDNunG2NjSi17pPf5izSSykKUzr/Z4S1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16mh7X8BDLhhT2SnfrpihSS4KE6YMu+g8KxxWyjQoB9T9OT1r5hpYgF9pXr372fVd
         HXw1vCwH2zbFZouq7hym/oLTVeVX0AHehtoolj6QAGgr5GkoPdVU28Q2ILA0ehOlAG
         YPyXORqAwEpZZejsNyxRlhj+UTAtpYHj12fRTzNU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org, john@phrozen.org, kishon@ti.com,
        ralf@linux-mips.org, robh+dt@kernel.org, hauke@hauke-m.de,
        mark.rutland@arm.com, ms@dev.tdt.de,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 12/33] MIPS: lantiq: update the clock alias' for the mainline PCIe PHY driver
Date:   Sun, 29 Sep 2019 13:34:00 -0400
Message-Id: <20190929173424.9361-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190929173424.9361-1-sashal@kernel.org>
References: <20190929173424.9361-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit ed90302be64a53d9031c8ce05428c358b16a5d96 ]

The mainline PCIe PHY driver has it's own devicetree node. Update the
clock alias so the mainline driver finds the clocks.

The first PCIe PHY is located at 0x1f106800 and exists on VRX200, ARX300
and GRX390.
The second PCIe PHY is located at 0x1f700400 and exists on ARX300 and
GRX390.
The third PCIe PHY is located at 0x1f106a00 and exists onl on GRX390.
Lantiq's board support package (called "UGW") names these registers
"PDI".

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: john@phrozen.org
Cc: kishon@ti.com
Cc: ralf@linux-mips.org
Cc: robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: hauke@hauke-m.de
Cc: mark.rutland@arm.com
Cc: ms@dev.tdt.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/xway/sysctrl.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/mips/lantiq/xway/sysctrl.c b/arch/mips/lantiq/xway/sysctrl.c
index e0af39b33e287..4334d83784dab 100644
--- a/arch/mips/lantiq/xway/sysctrl.c
+++ b/arch/mips/lantiq/xway/sysctrl.c
@@ -470,14 +470,14 @@ void __init ltq_soc_init(void)
 		clkdev_add_pmu("1f203018.usb2-phy", "phy", 1, 2, PMU_ANALOG_USB0_P);
 		clkdev_add_pmu("1f203034.usb2-phy", "phy", 1, 2, PMU_ANALOG_USB1_P);
 		/* rc 0 */
-		clkdev_add_pmu("1d900000.pcie", "phy", 1, 2, PMU_ANALOG_PCIE0_P);
+		clkdev_add_pmu("1f106800.phy", "phy", 1, 2, PMU_ANALOG_PCIE0_P);
 		clkdev_add_pmu("1d900000.pcie", "msi", 1, 1, PMU1_PCIE_MSI);
-		clkdev_add_pmu("1d900000.pcie", "pdi", 1, 1, PMU1_PCIE_PDI);
+		clkdev_add_pmu("1f106800.phy", "pdi", 1, 1, PMU1_PCIE_PDI);
 		clkdev_add_pmu("1d900000.pcie", "ctl", 1, 1, PMU1_PCIE_CTL);
 		/* rc 1 */
-		clkdev_add_pmu("19000000.pcie", "phy", 1, 2, PMU_ANALOG_PCIE1_P);
+		clkdev_add_pmu("1f700400.phy", "phy", 1, 2, PMU_ANALOG_PCIE1_P);
 		clkdev_add_pmu("19000000.pcie", "msi", 1, 1, PMU1_PCIE1_MSI);
-		clkdev_add_pmu("19000000.pcie", "pdi", 1, 1, PMU1_PCIE1_PDI);
+		clkdev_add_pmu("1f700400.phy", "pdi", 1, 1, PMU1_PCIE1_PDI);
 		clkdev_add_pmu("19000000.pcie", "ctl", 1, 1, PMU1_PCIE1_CTL);
 	}
 
@@ -501,9 +501,9 @@ void __init ltq_soc_init(void)
 		clkdev_add_pmu("1e101000.usb", "otg", 1, 0, PMU_USB0);
 		clkdev_add_pmu("1e106000.usb", "otg", 1, 0, PMU_USB1);
 		/* rc 2 */
-		clkdev_add_pmu("1a800000.pcie", "phy", 1, 2, PMU_ANALOG_PCIE2_P);
+		clkdev_add_pmu("1f106a00.pcie", "phy", 1, 2, PMU_ANALOG_PCIE2_P);
 		clkdev_add_pmu("1a800000.pcie", "msi", 1, 1, PMU1_PCIE2_MSI);
-		clkdev_add_pmu("1a800000.pcie", "pdi", 1, 1, PMU1_PCIE2_PDI);
+		clkdev_add_pmu("1f106a00.pcie", "pdi", 1, 1, PMU1_PCIE2_PDI);
 		clkdev_add_pmu("1a800000.pcie", "ctl", 1, 1, PMU1_PCIE2_CTL);
 		clkdev_add_pmu("1e108000.eth", NULL, 0, 0, PMU_SWITCH | PMU_PPE_DP);
 		clkdev_add_pmu("1da00000.usif", "NULL", 1, 0, PMU_USIF);
@@ -528,10 +528,10 @@ void __init ltq_soc_init(void)
 		clkdev_add_pmu("1e101000.usb", "otg", 1, 0, PMU_USB0 | PMU_AHBM);
 		clkdev_add_pmu("1f203034.usb2-phy", "phy", 1, 0, PMU_USB1_P);
 		clkdev_add_pmu("1e106000.usb", "otg", 1, 0, PMU_USB1 | PMU_AHBM);
-		clkdev_add_pmu("1d900000.pcie", "phy", 1, 1, PMU1_PCIE_PHY);
+		clkdev_add_pmu("1f106800.phy", "phy", 1, 1, PMU1_PCIE_PHY);
 		clkdev_add_pmu("1d900000.pcie", "bus", 1, 0, PMU_PCIE_CLK);
 		clkdev_add_pmu("1d900000.pcie", "msi", 1, 1, PMU1_PCIE_MSI);
-		clkdev_add_pmu("1d900000.pcie", "pdi", 1, 1, PMU1_PCIE_PDI);
+		clkdev_add_pmu("1f106800.phy", "pdi", 1, 1, PMU1_PCIE_PDI);
 		clkdev_add_pmu("1d900000.pcie", "ctl", 1, 1, PMU1_PCIE_CTL);
 		clkdev_add_pmu(NULL, "ahb", 1, 0, PMU_AHBM | PMU_AHBS);
 
-- 
2.20.1

