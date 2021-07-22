Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591F63D296A
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbhGVQD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:03:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232940AbhGVQDF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:03:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F7C4619F1;
        Thu, 22 Jul 2021 16:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972198;
        bh=tNLZTfT1LkAls7UaOUt/0JMXBQw5hIx7MpNekUg8Aj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bOagp08UOPhKUkVu1WYYIq54+xcD+gqGYxT49+hPQjCZA+FegdGj2HRKBmqxg3cs9
         0ZNisBGOjogwzoDXfc3FAXMvs5WDLNAEL+t4PLkyTZ91ZBhEoHa0AmoMoHccyU04TT
         AXOWW8K8rnY0Q3fTf1GR2/RiBirD9AYra2cgauAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 022/156] ARM: dts: BCM5301X: Fix pinmux subnodes names
Date:   Thu, 22 Jul 2021 18:29:57 +0200
Message-Id: <20210722155629.126949506@linuxfoundation.org>
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
@@ -11,7 +11,7 @@
 &pinctrl {
 	compatible = "brcm,bcm4709-pinmux";
 
-	pinmux_mdio: mdio {
+	pinmux_mdio: mdio-pins {
 		groups = "mdio_grp";
 		function = "mdio";
 	};
diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index bf595269ed7f..f92089290ccd 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -458,18 +458,18 @@
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



