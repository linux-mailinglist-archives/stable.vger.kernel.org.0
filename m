Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6C43C8F6E
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237481AbhGNTwe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239663AbhGNTtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 405B6613CA;
        Wed, 14 Jul 2021 19:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291868;
        bh=IoIL/uzOWF3lmwzwhyIGvg60jUkznyIlyRorCIlKBdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5TpJwcG7KrBGl5hZsaOOA58yodBveZ4MBsx8TCUQ7MoyLdCu5JNZ+S4cjyMeSXf8
         Q0ljN+KilpScPq5mwbZsymo7ux5ZLHcFf6KvavInO8/kb9IuFPlwf+WuJYOji7yJ0L
         9lOcOH+gaooYmmxQkVP7Z1J/OFLZCFtjPSQmPTc0aanpgakYtcB7/WrLj9FPk73Z+K
         ZutPyNwGtz/DSq4+9Iz1qXMmjfcphFVGuo2A/yk13lXAyr8GGOjdNO3rrRmj0KME96
         a318LHgDe4AsZGzbQ38VIfbBHXrhsomS93ZDbVpMYNO9/3Yv/QrrplXppX2/qzMOXr
         r2CwvO/pAuEBg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 56/88] ARM: dts: bcm283x: Fix up MMC node names
Date:   Wed, 14 Jul 2021 15:42:31 -0400
Message-Id: <20210714194303.54028-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 4847dd305317..3d040f6e2a20 100644
--- a/arch/arm/boot/dts/bcm2711.dtsi
+++ b/arch/arm/boot/dts/bcm2711.dtsi
@@ -395,7 +395,7 @@ emmc2bus: emmc2bus {
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
@@ -420,7 +420,7 @@ pwm: pwm@7e20c000 {
 			status = "disabled";
 		};
 
-		sdhci: sdhci@7e300000 {
+		sdhci: mmc@7e300000 {
 			compatible = "brcm,bcm2835-sdhci";
 			reg = <0x7e300000 0x100>;
 			interrupts = <2 30>;
-- 
2.30.2

