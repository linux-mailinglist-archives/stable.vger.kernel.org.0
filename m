Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0E6404EEF
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348310AbhIIMQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351810AbhIIMKN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:10:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C371761A03;
        Thu,  9 Sep 2021 11:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188105;
        bh=+kRatSDu+QHL9l0gSMIuZXKbGnuhLFqj9q5XOU/+i3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fMRlqWpAqf+4X3RTp/FmTYzEGRlq1oSP73AUrzrXNQb64xF34yleq5Etr/WysT/+j
         gLyvNRKhbiHaQlMfzwc3KaKqhGK38SSPFTKA7yt5Arn44djApLE0IgFYyTkZp22IBS
         NK0J0CmickRtTOBh4UU7rWAvLlS7X8CRgxTXjFcSNEalAZ/kL56NFphjM1dVi5wG/r
         t/fJR7l+BeXcCd2fa4QJgUvtt2RkNm/lG967AIFsBMCc9TMDNRYHw3mRWTr0PTp6J3
         wGZhR/zmB8GWNhhU4a6pqZ5EEM4JkRrhTVfXfzeO4ZLOBiruyccDscLNxIn+ubwCnt
         UR39gyX2pUFdA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vidya Sagar <vidyas@nvidia.com>, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 085/219] arm64: tegra: Fix Tegra194 PCIe EP compatible string
Date:   Thu,  9 Sep 2021 07:44:21 -0400
Message-Id: <20210909114635.143983-85-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 2e40b6047283..203318aa660f 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -2005,7 +2005,7 @@ pcie@141a0000 {
 	};
 
 	pcie_ep@14160000 {
-		compatible = "nvidia,tegra194-pcie-ep", "snps,dw-pcie-ep";
+		compatible = "nvidia,tegra194-pcie-ep";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX4A>;
 		reg = <0x00 0x14160000 0x0 0x00020000>, /* appl registers (128K)      */
 		      <0x00 0x36040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
@@ -2037,7 +2037,7 @@ pcie_ep@14160000 {
 	};
 
 	pcie_ep@14180000 {
-		compatible = "nvidia,tegra194-pcie-ep", "snps,dw-pcie-ep";
+		compatible = "nvidia,tegra194-pcie-ep";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8B>;
 		reg = <0x00 0x14180000 0x0 0x00020000>, /* appl registers (128K)      */
 		      <0x00 0x38040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
@@ -2069,7 +2069,7 @@ pcie_ep@14180000 {
 	};
 
 	pcie_ep@141a0000 {
-		compatible = "nvidia,tegra194-pcie-ep", "snps,dw-pcie-ep";
+		compatible = "nvidia,tegra194-pcie-ep";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8A>;
 		reg = <0x00 0x141a0000 0x0 0x00020000>, /* appl registers (128K)      */
 		      <0x00 0x3a040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-- 
2.30.2

