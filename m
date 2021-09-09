Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53EFD405125
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351099AbhIIMdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354436AbhIIMa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:30:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ED0961B47;
        Thu,  9 Sep 2021 11:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188367;
        bh=aEmmNDItKKfIvYWiPzZzc9Ik6tR4WWo7PiWkhXxbDw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1pkAQa8U29FvI7G3+tNLO0Xjhhf8g9vDyaMjnAB+fbX9Lo/qevlp2Zq5nYlPXh67
         lZ95o98BfaM1BBAL9C7H8Di6bduJPtdHrcUurRbb57elSPAxdZsajxpEb0/Lou67Ts
         EZ3udN+IWZbGI/Fn2Ez8QtXXb0jeeWRS/762fFT0elEjXX+VeXWCqgt6IOJyHunaGL
         xRRkmXpWDcUSbqAwbTuEZd7IJP+oPGYWKenHKEH/e7X6jsB298AiFOt524Zt4BSBm2
         VNbkdsYGiGzu/Gy2lRht78R4CYzfzkJH690B39HpzMSABx5NolExfj0mvvqRDxUowN
         xyXRkA0KkUGmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vidya Sagar <vidyas@nvidia.com>, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 069/176] arm64: tegra: Fix Tegra194 PCIe EP compatible string
Date:   Thu,  9 Sep 2021 07:49:31 -0400
Message-Id: <20210909115118.146181-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index 6946fb210e48..9b5007e5f790 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -1976,7 +1976,7 @@ pcie@141a0000 {
 	};
 
 	pcie_ep@14160000 {
-		compatible = "nvidia,tegra194-pcie-ep", "snps,dw-pcie-ep";
+		compatible = "nvidia,tegra194-pcie-ep";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX4A>;
 		reg = <0x00 0x14160000 0x0 0x00020000>, /* appl registers (128K)      */
 		      <0x00 0x36040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
@@ -2008,7 +2008,7 @@ pcie_ep@14160000 {
 	};
 
 	pcie_ep@14180000 {
-		compatible = "nvidia,tegra194-pcie-ep", "snps,dw-pcie-ep";
+		compatible = "nvidia,tegra194-pcie-ep";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8B>;
 		reg = <0x00 0x14180000 0x0 0x00020000>, /* appl registers (128K)      */
 		      <0x00 0x38040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
@@ -2040,7 +2040,7 @@ pcie_ep@14180000 {
 	};
 
 	pcie_ep@141a0000 {
-		compatible = "nvidia,tegra194-pcie-ep", "snps,dw-pcie-ep";
+		compatible = "nvidia,tegra194-pcie-ep";
 		power-domains = <&bpmp TEGRA194_POWER_DOMAIN_PCIEX8A>;
 		reg = <0x00 0x141a0000 0x0 0x00020000>, /* appl registers (128K)      */
 		      <0x00 0x3a040000 0x0 0x00040000>, /* iATU_DMA reg space (256K)  */
-- 
2.30.2

