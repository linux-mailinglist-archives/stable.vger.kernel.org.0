Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2000D40533B
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355897AbhIIMuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355435AbhIIMpo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:45:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90D94630EB;
        Thu,  9 Sep 2021 11:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188565;
        bh=6THc55M9H+piYc7a5/b5tKa38hBPIcjtanzULpo3bgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MK1TN08my4z7izPDSVOnYcL9qloOK1wmDI4f+2/BTfMlLJrbtGZlBSqXfOSXUMSa3
         pruMBIK2vzxEceLR0l0JsOVqtgu6ntmkvdiOMxr6TgNOCis7G1PHegYMJZjHyod5dl
         32Z3QlRtEnz1npVHm1cvy/zDFNPb3u18u9NUk92Mq1b94noRt+CnQaKS6xv5AsH26j
         /J3X9PB0IuqPQvYNvGLQZNvJDBQiIy814ClOrpnlwNE0+/d10H+6/q0+tENNqj6lYQ
         b/gO65VzFgDaLCWWxBRz3KAgtRzzvc0rX4YuI+rRB+wvH1UWUHqLuoas9/y4vaKBie
         ZexOah+gkVxUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vidya Sagar <vidyas@nvidia.com>, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 046/109] arm64: tegra: Fix Tegra194 PCIe EP compatible string
Date:   Thu,  9 Sep 2021 07:54:03 -0400
Message-Id: <20210909115507.147917-46-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit bf2942a8b7c38e8cc2d5157b4f0323d7f4e5ec71 ]

The initialization sequence performed by the generic platform driver
pcie-designware-plat.c for a DWC based implementation doesn't work for
Tegra194. Tegra194 has a different initialization sequence requirement
which can only be satisfied by the Tegra194 specific platform driver
pcie-tegra194.c. So, remove the generic compatible string "snps,dw-pcie-ep"
from Tegra194's endpoint controller nodes.

Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 0821754f0fd6..90adff8aa9ba 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -1434,7 +1434,7 @@ pcie@141a0000 {
 	};
 
 	pcie_ep@14160000 {
-		compatible = "nvidia,tegra194-pcie-ep", "snps,dw-pcie-ep";
+		compatible = "nvidia,tegra194-pcie-ep";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX4A>;
 		reg = <0x00 0x14160000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x36040000 0x0 0x00040000   /* iATU_DMA reg space (256K)  */
@@ -1466,7 +1466,7 @@ pcie_ep@14160000 {
 	};
 
 	pcie_ep@14180000 {
-		compatible = "nvidia,tegra194-pcie-ep", "snps,dw-pcie-ep";
+		compatible = "nvidia,tegra194-pcie-ep";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8B>;
 		reg = <0x00 0x14180000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x38040000 0x0 0x00040000   /* iATU_DMA reg space (256K)  */
@@ -1498,7 +1498,7 @@ pcie_ep@14180000 {
 	};
 
 	pcie_ep@141a0000 {
-		compatible = "nvidia,tegra194-pcie-ep", "snps,dw-pcie-ep";
+		compatible = "nvidia,tegra194-pcie-ep";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8A>;
 		reg = <0x00 0x141a0000 0x0 0x00020000   /* appl registers (128K)      */
 		       0x00 0x3a040000 0x0 0x00040000   /* iATU_DMA reg space (256K)  */
-- 
2.30.2

