Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D9D44117A
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 00:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhJaXo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Oct 2021 19:44:27 -0400
Received: from aposti.net ([89.234.176.197]:36378 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230232AbhJaXo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 31 Oct 2021 19:44:27 -0400
From:   Paul Cercueil <paul@crapouillou.net>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] ARM: dts: exynos/i9100: Fix BCM4330 Bluetooth reset polarity
Date:   Sun, 31 Oct 2021 23:41:36 +0000
Message-Id: <20211031234137.87070-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The reset GPIO was marked active-high, which is against what's specified
in the documentation. Mark the reset GPIO as active-low. With this
change, Bluetooth can now be used on the i9100.

Fixes: 8620cc2f99b7 ("ARM: dts: exynos: Add devicetree file for the Galaxy S2")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
 arch/arm/boot/dts/exynos4210-i9100.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4210-i9100.dts b/arch/arm/boot/dts/exynos4210-i9100.dts
index 55922176807e..5f5d9b135736 100644
--- a/arch/arm/boot/dts/exynos4210-i9100.dts
+++ b/arch/arm/boot/dts/exynos4210-i9100.dts
@@ -827,7 +827,7 @@ bluetooth {
 		compatible = "brcm,bcm4330-bt";
 
 		shutdown-gpios = <&gpl0 4 GPIO_ACTIVE_HIGH>;
-		reset-gpios = <&gpl1 0 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpl1 0 GPIO_ACTIVE_LOW>;
 		device-wakeup-gpios = <&gpx3 1 GPIO_ACTIVE_HIGH>;
 		host-wakeup-gpios = <&gpx2 6 GPIO_ACTIVE_HIGH>;
 	};
-- 
2.33.0

