Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7B53C8D84
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhGNTo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235157AbhGNToP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:44:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC009613E2;
        Wed, 14 Jul 2021 19:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291668;
        bh=FUQogsC63AgKVtlZSZYe/r6K/jr3cURdFyPF41bpO5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kguxu+R7aBEt+FnZlEz60toSN2bm0/una4h86+t89WUWjTsbUZcxVKkiP0mPHXKr4
         qjFq1NoHDtwkzCG1gYanoWaMKFp6G+HwbD2N6NlyvZQTNMZzg4AQUOsFIW+GIftWdz
         OAmi69pEvER28Zx+eRb58D4qpnlF5MfGouNMx8tOOK+6Ezxvxedo8RcwjZtg0zcfMv
         xdWKDWAXHkLChiLPxdggfUuAmEVrfkQctQW0v7cGh7Fi6/JGjGQDo4YFq+mmnOTUQC
         PNsg2LuXOCikxIyN29LeElmvl/7Ugk8bztenIwDn4aknJDHbiYpHKNWwYdMAlNPhFy
         rE9Mfhj/i6Scw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 022/102] ARM: dts: BCM5301X: Fix pinmux subnodes names
Date:   Wed, 14 Jul 2021 15:39:15 -0400
Message-Id: <20210714194036.53141-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit bb95d7d440fefd104c593d9cb20da6d34a474e97 ]

This matches pinmux-node.yaml requirements.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm47094.dtsi | 2 +-
 arch/arm/boot/dts/bcm5301x.dtsi | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/bcm47094.dtsi b/arch/arm/boot/dts/bcm47094.dtsi
index 2a8f7312d1be..6282363313e1 100644
--- a/arch/arm/boot/dts/bcm47094.dtsi
+++ b/arch/arm/boot/dts/bcm47094.dtsi
@@ -11,7 +11,7 @@ / {
 &pinctrl {
 	compatible = "brcm,bcm4709-pinmux";
 
-	pinmux_mdio: mdio {
+	pinmux_mdio: mdio-pins {
 		groups = "mdio_grp";
 		function = "mdio";
 	};
diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index 092ec525c01c..5b9723a10bd6 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -458,18 +458,18 @@ spi-pins {
 					function = "spi";
 				};
 
-				pinmux_i2c: i2c {
+				pinmux_i2c: i2c-pins {
 					groups = "i2c_grp";
 					function = "i2c";
 				};
 
-				pinmux_pwm: pwm {
+				pinmux_pwm: pwm-pins {
 					groups = "pwm0_grp", "pwm1_grp",
 						 "pwm2_grp", "pwm3_grp";
 					function = "pwm";
 				};
 
-				pinmux_uart1: uart1 {
+				pinmux_uart1: uart1-pins {
 					groups = "uart1_grp";
 					function = "uart1";
 				};
-- 
2.30.2

