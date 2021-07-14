Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715203C8C3F
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhGNTla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:41:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232900AbhGNTl0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D966613CF;
        Wed, 14 Jul 2021 19:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291514;
        bh=FUQogsC63AgKVtlZSZYe/r6K/jr3cURdFyPF41bpO5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u1tCC16X0Vdq97T1LruDTFysUOH06guiwwwwrIvpGiR8mQLHibRUJ075BOXYC1WlR
         b3ZQAqvORQAEIumVE51BswEJL3byGYs2RU4oFKZshe3LVW29BDvBhfixWj9Ji8LkaG
         /QUhocPi8ym9ODVLtTNND9sd2aPUwCePjKEF3UL9Z/Ma+kFJXY/SWSvvS7KOENWq6I
         IReczjKvYap6GLjyzy729nvzFVvAa3viUWZ8HHQ6Q3ZT9r9XxFCQEzPHWtL7+dxD+h
         5Wc4EJEwaSml+A7S+xrKFGe8ez3thNqMO7FxqVb+mo3QTafTZ7ulJCklZg2/P4w/Kw
         W3nqIkCtQAEHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 022/108] ARM: dts: BCM5301X: Fix pinmux subnodes names
Date:   Wed, 14 Jul 2021 15:36:34 -0400
Message-Id: <20210714193800.52097-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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

