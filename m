Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD03915ECB2
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387829AbgBNR3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:29:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:59814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390314AbgBNQIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:08:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 412E72187F;
        Fri, 14 Feb 2020 16:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696481;
        bh=wxI//oVLBA4AEXrM9q4sGKSYQOhNs7aqgQgAI+8cswo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+s/BKRGS1kOsAJ3Bkz4Q/IZ29eY+k8TqMsnYR1i88c/Knf3D3T2N7TR6lEekzhWo
         +pUJiI80BAPRu9joDacQB9TOTbm1DsdAhgL5hILicv5BEpWXi7Rd1Jyhz8swqmtwA0
         viHMY2KrhK8VWncPVqSL5oIUdfU0n1iBElCjCNoo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 288/459] arm64: dts: rockchip: fix dwmmc clock name for px30
Date:   Fri, 14 Feb 2020 10:58:58 -0500
Message-Id: <20200214160149.11681-288-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 7f2147350291569acd1df5a26dcdfc573916016f ]

An experimental test with the command below gives this error:
px30-evb.dt.yaml: dwmmc@ff390000: clock-names:2:
'ciu-drive' was expected

'ciu-drv' is not a valid dwmmc clock name,
so fix this by changing it to 'ciu-drive'.

make ARCH=arm64 dtbs_check
DT_SCHEMA_FILES=Documentation/devicetree/bindings/mmc/rockchip-dw-mshc.yaml

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20200110161200.22755-1-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/px30.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/px30.dtsi b/arch/arm64/boot/dts/rockchip/px30.dtsi
index eb992d60e6baf..9e09909a510a1 100644
--- a/arch/arm64/boot/dts/rockchip/px30.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30.dtsi
@@ -768,7 +768,7 @@
 		interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru HCLK_SDMMC>, <&cru SCLK_SDMMC>,
 			 <&cru SCLK_SDMMC_DRV>, <&cru SCLK_SDMMC_SAMPLE>;
-		clock-names = "biu", "ciu", "ciu-drv", "ciu-sample";
+		clock-names = "biu", "ciu", "ciu-drive", "ciu-sample";
 		fifo-depth = <0x100>;
 		max-frequency = <150000000>;
 		pinctrl-names = "default";
@@ -783,7 +783,7 @@
 		interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru HCLK_SDIO>, <&cru SCLK_SDIO>,
 			 <&cru SCLK_SDIO_DRV>, <&cru SCLK_SDIO_SAMPLE>;
-		clock-names = "biu", "ciu", "ciu-drv", "ciu-sample";
+		clock-names = "biu", "ciu", "ciu-drive", "ciu-sample";
 		fifo-depth = <0x100>;
 		max-frequency = <150000000>;
 		pinctrl-names = "default";
@@ -798,7 +798,7 @@
 		interrupts = <GIC_SPI 53 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru HCLK_EMMC>, <&cru SCLK_EMMC>,
 			 <&cru SCLK_EMMC_DRV>, <&cru SCLK_EMMC_SAMPLE>;
-		clock-names = "biu", "ciu", "ciu-drv", "ciu-sample";
+		clock-names = "biu", "ciu", "ciu-drive", "ciu-sample";
 		fifo-depth = <0x100>;
 		max-frequency = <150000000>;
 		power-domains = <&power PX30_PD_MMC_NAND>;
-- 
2.20.1

