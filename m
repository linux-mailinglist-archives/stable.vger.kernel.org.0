Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1AAE256323
	for <lists+stable@lfdr.de>; Sat, 29 Aug 2020 00:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgH1WZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 18:25:57 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18087 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgH1WZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Aug 2020 18:25:51 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4984430001>; Fri, 28 Aug 2020 15:25:07 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 28 Aug 2020 15:25:51 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 28 Aug 2020 15:25:51 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 28 Aug
 2020 22:25:50 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 28 Aug 2020 22:25:50 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.174.186]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f49846d000b>; Fri, 28 Aug 2020 15:25:50 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH 4.19 3/7] dt-bindings: mmc: tegra: Add tmclk for Tegra210 and Tegra186
Date:   Fri, 28 Aug 2020 15:25:13 -0700
Message-ID: <1598653517-13658-4-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598653517-13658-1-git-send-email-skomatineni@nvidia.com>
References: <1598653517-13658-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598653507; bh=Z/tDa8PZb78FAhTYv8UBvqTqA2anupWim4jqs/y3vaI=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=QxXIBUnnhwjOeu6XZTouvgN7Y9nBKlp+mFIBasEHu9pjsJ+nsVeU3F1p94kJYEaQ0
         49pa9RRNTVoGhNpzuDuYxisTqYr1DMg/YhlDoc+P3zh+9lgGgnHIgnm2lsuAahwEhn
         qKKAW8m8SW4YAGK5UJbPtYTDuZnEYKzTxdyF+Dn/eJRkCrpfQyUsMBTDj+3EvwK1gz
         mCWkOLEzgHvyjCUYgpbs1QyNH4ZlDzQ0IIZCWigmtZvXJBiLeCximikav952Ew0lV5
         rMOCcz3pLSC1IAqqPsHF3EqvjvhO+9AagnfCNX2P81SgToZi6lGHtIaw5rH6q0HPZ3
         R3vSEpqaXtJAA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b5a84ecf025a ("mmc: tegra: Add Tegra210 support")

Tegra210 and later uses separate SDMMC_LEGACY_TM clock for data
timeout.

So, this patch adds "tmclk" to Tegra sdhci clock property in the
device tree binding.

Fixes: b5a84ecf025a ("mmc: tegra: Add Tegra210 support")
Cc: stable <stable@vger.kernel.org> # 4.19
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
---
 .../bindings/mmc/nvidia,tegra20-sdhci.txt          | 23 ++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt b/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt
index 9bce578..a5f1fae 100644
--- a/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt
+++ b/Documentation/devicetree/bindings/mmc/nvidia,tegra20-sdhci.txt
@@ -14,8 +14,15 @@ Required properties:
   - "nvidia,tegra124-sdhci": for Tegra124 and Tegra132
   - "nvidia,tegra210-sdhci": for Tegra210
   - "nvidia,tegra186-sdhci": for Tegra186
-- clocks : Must contain one entry, for the module clock.
-  See ../clocks/clock-bindings.txt for details.
+- clocks: For Tegra210 and Tegra186 must contain two entries.
+	  One for the module clock and one for the timeout clock.
+	  For all other Tegra devices, must contain a single entry for
+	  the module clock. See ../clocks/clock-bindings.txt for details.
+- clock-names: For Tegra210 and Tegra186 must contain the strings 'sdhci'
+	       and 'tmclk' to represent the module and the timeout clocks,
+	       respectively.
+	       For all other Tegra devices must contain the string 'sdhci'
+	       to represent the module clock.
 - resets : Must contain an entry for each entry in reset-names.
   See ../reset/reset.txt for details.
 - reset-names : Must include the following entries:
@@ -38,3 +45,15 @@ sdhci@c8000200 {
 	power-gpios = <&gpio 155 0>; /* gpio PT3 */
 	bus-width = <8>;
 };
+
+sdhci@700b0000 {
+	compatible = "nvidia,tegra210-sdhci";
+	reg = <0x0 0x700b0000 0x0 0x200>;
+	interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
+	clocks = <&tegra_car TEGRA210_CLK_SDMMC1>,
+		 <&tegra_car TEGRA210_CLK_SDMMC_LEGACY>;
+	clock-names = "sdhci", "tmclk";
+	resets = <&tegra_car 14>;
+	reset-names = "sdhci";
+	status = "disabled";
+};
-- 
2.7.4

