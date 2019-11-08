Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27571F498D
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389965AbfKHLmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:42:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389945AbfKHLmY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46E6F21D6C;
        Fri,  8 Nov 2019 11:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213344;
        bh=ZcfI9Io9gL+K+leh9xNl/+x3gDLhi0YCH+sL9MOr5HY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqe/slqFj3cpUc/f4ycWtoPu9zSXOAFwrg4zOelWrsUytw7i+9LLVyKKC9hYXnFh6
         rwiIileUgjIbLhV0eZfiaCrdFDWR/ond62warRAMubNNI+rTCWupgV0pVU4qrt1F4Y
         PGwd4a820U6aGumvp6pA7k1Et6hheVgKdcyITtw4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 180/205] ARM: dts: bcm: Fix SPI bus warnings
Date:   Fri,  8 Nov 2019 06:37:27 -0500
Message-Id: <20191108113752.12502-180-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit ab0b47d2eff413d60b0a1fc0c1f87f87f0d7f375 ]

dtc has new checks for SPI buses. Fix the warnings in node names.

arch/arm/boot/dts/bcm53340-ubnt-unifi-switch8.dtb: Warning (spi_bus_bridge): /axi@18000000/qspi@27200: node name for SPI buses should be 'spi'
arch/arm/boot/dts/bcm958525er.dtb: Warning (spi_bus_bridge): /axi/qspi@27200: node name for SPI buses should be 'spi'
arch/arm/boot/dts/bcm958525xmc.dtb: Warning (spi_bus_bridge): /axi/qspi@27200: node name for SPI buses should be 'spi'
arch/arm/boot/dts/bcm958622hr.dtb: Warning (spi_bus_bridge): /axi/qspi@27200: node name for SPI buses should be 'spi'
arch/arm/boot/dts/bcm958625hr.dtb: Warning (spi_bus_bridge): /axi/qspi@27200: node name for SPI buses should be 'spi'
arch/arm/boot/dts/bcm988312hr.dtb: Warning (spi_bus_bridge): /axi/qspi@27200: node name for SPI buses should be 'spi'

Cc: Ray Jui <rjui@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: Jon Mason <jonmason@broadcom.com>
Cc: bcm-kernel-feedback-list@broadcom.com
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm-hr2.dtsi | 2 +-
 arch/arm/boot/dts/bcm-nsp.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm-hr2.dtsi b/arch/arm/boot/dts/bcm-hr2.dtsi
index 3084a7c957339..e4d49731287f6 100644
--- a/arch/arm/boot/dts/bcm-hr2.dtsi
+++ b/arch/arm/boot/dts/bcm-hr2.dtsi
@@ -216,7 +216,7 @@
 			reg = <0x33000 0x14>;
 		};
 
-		qspi: qspi@27200 {
+		qspi: spi@27200 {
 			compatible = "brcm,spi-bcm-qspi", "brcm,spi-nsp-qspi";
 			reg = <0x027200 0x184>,
 			      <0x027000 0x124>,
diff --git a/arch/arm/boot/dts/bcm-nsp.dtsi b/arch/arm/boot/dts/bcm-nsp.dtsi
index 09ba850463228..2b219addeb449 100644
--- a/arch/arm/boot/dts/bcm-nsp.dtsi
+++ b/arch/arm/boot/dts/bcm-nsp.dtsi
@@ -273,7 +273,7 @@
 			brcm,nand-has-wp;
 		};
 
-		qspi: qspi@27200 {
+		qspi: spi@27200 {
 			compatible = "brcm,spi-bcm-qspi", "brcm,spi-nsp-qspi";
 			reg = <0x027200 0x184>,
 			      <0x027000 0x124>,
-- 
2.20.1

