Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 246B5259879
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731504AbgIAQ0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:26:14 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17418 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730027AbgIAQZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 12:25:20 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4e75e20000>; Tue, 01 Sep 2020 09:25:06 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 01 Sep 2020 09:25:19 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 01 Sep 2020 09:25:19 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Sep
 2020 16:25:17 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 1 Sep 2020 16:25:17 +0000
Received: from skomatineni-linux.nvidia.com (Not Verified[10.2.173.243]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5f4e75ec0001>; Tue, 01 Sep 2020 09:25:17 -0700
From:   Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh+dt@kernel.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v2 4.19 3/7] dt-bindings: mmc: tegra: Add tmclk for Tegra210 and Tegra186
Date:   Tue, 1 Sep 2020 09:24:46 -0700
Message-ID: <1598977490-1826-4-git-send-email-skomatineni@nvidia.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598977490-1826-1-git-send-email-skomatineni@nvidia.com>
References: <1598977490-1826-1-git-send-email-skomatineni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598977506; bh=91lpNkKdgEoPrfUshzx2bxO8w2NQjCapWrsEaT/jp7s=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:X-NVConfidentiality:MIME-Version:
         Content-Type;
        b=LXYWaF0FZWO0RkCl9xIIyGGdXDXStOqPJju3bjklL+mE0ZIhJ6ig6EDsHUHBOn8XJ
         Y4AdwN/OSPFDPdraIst4tVzkYaZj4HI72wD9VlSnY1sJ3EJfUr3FI7p8E2D8py2+7S
         Ohg1/GvhoelgrUIMZSFi3dU660R3e9RT6fXUsn3sHVYbvBEwnFI0fvEffI1Fuw7Jgk
         ChA9SxcNsm/v9h0seAUhlF1w1Pd7qjb1g9xusLdXAwcJ0fD4YEIdsETOp2S6fz+hJu
         Y3YaOzsRfWwvkb+stgfkoP6nAMkOlV01jyDwi2h2uOtl5VgiUXHH4IjPWlLimB7k2q
         vMclH3rxZuq6g==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

