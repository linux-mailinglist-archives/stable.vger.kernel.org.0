Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4223D29B3
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbhGVQF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:40488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234209AbhGVQE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:04:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9182561CBF;
        Thu, 22 Jul 2021 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972297;
        bh=5GbnxnRz/alVXZRk6E3oCgK2dZ1Z3wbNbQf9Z27cDn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z31BMH1W3il/xeQGm69M1+KHQ7Xf0ElnLK1pLhfe3Y3fyovro3ZKvKsFhGnArPvYh
         hVzcWFMKmE3ErUSa2xiPNqiCxAd2v0i6m24mhXgki1lOc/cJEczOJsa2ou2k4FoV4F
         tZwcxga2Nz25LQFexvxZgDc75vLXjK3EuifpRTsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 060/156] ARM: dts: bcm283x: Fix up MMC node names
Date:   Thu, 22 Jul 2021 18:30:35 +0200
Message-Id: <20210722155630.346271461@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit f230c32349eb0a43a012a81c08a7f13859b86cbb ]

Fix the node names for the MMC/SD card controller to conform
to the standard node name mmc@..

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/1622981777-5023-2-git-send-email-stefan.wahren@i2se.com
Signed-off-by: Nicolas Saenz Julienne <nsaenz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2711.dtsi | 2 +-
 arch/arm/boot/dts/bcm283x.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm2711.dtsi b/arch/arm/boot/dts/bcm2711.dtsi
index 720beec54d61..d872064db761 100644
--- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -413,7 +413,7 @@
 		ranges = <0x0 0x7e000000  0x0 0xfe000000  0x01800000>;
 		dma-ranges = <0x0 0xc0000000  0x0 0x00000000  0x40000000>;
 
-		emmc2: emmc2@7e340000 {
+		emmc2: mmc@7e340000 {
 			compatible = "brcm,bcm2711-emmc2";
 			reg = <0x0 0x7e340000 0x100>;
 			interrupts = <GIC_SPI 126 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm/boot/dts/bcm283x.dtsi b/arch/arm/boot/dts/bcm283x.dtsi
index b83a864e2e8b..0f3be55201a5 100644
--- a/arch/arm/boot/dts/bcm283x.dtsi
+++ b/arch/arm/boot/dts/bcm283x.dtsi
@@ -420,7 +420,7 @@
 			status = "disabled";
 		};
 
-		sdhci: sdhci@7e300000 {
+		sdhci: mmc@7e300000 {
 			compatible = "brcm,bcm2835-sdhci";
 			reg = <0x7e300000 0x100>;
 			interrupts = <2 30>;
-- 
2.30.2



