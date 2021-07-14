Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA663C9024
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240125AbhGNTx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240957AbhGNTuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8974613DD;
        Wed, 14 Jul 2021 19:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291987;
        bh=ZcwUKOkhXKdWLeqDGC3PgNVbHduCINTJiLBaLTYNEuw=;
        h=From:To:Cc:Subject:Date:From;
        b=VFdi1F1qf+KoopzirWHqFCBIYIkBtciq9oc+W2+8Fc1Ko08w7ma+AWt10qn5lWu9c
         O01ubOQ3zREG0bI6Hm+kqshq3HYz8Y/SeGlaeBUxU4ljyayKA4zJVmS1QC4Gs4/XUb
         +uhXkUqnLd6GEd5OCFbfexUgp3XVIr4AvmX4KGDP429z9ErdYTdSj816abl+0k1Un9
         gns/xy5Nq+4CebSPRJUHGqX4ydSLjKmRQ1xraBfpvpkWxPrUc693UrztRPbkGwStJz
         9vgU1+0X/JeqRxQPkGPx0MugFJzpz5DM8CfsYgbdUhILOxSzCRGsCOlTsE5k/4HCJR
         TloTjYqfjU9EQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/39] ARM: dts: gemini: rename mdio to the right name
Date:   Wed, 14 Jul 2021 15:45:46 -0400
Message-Id: <20210714194625.55303-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit fc5b59b945b546e27977e99a5ca6fe61179ff0d2 ]

ethernet-phy is not the right name for mdio, fix it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/gemini-dlink-dns-313.dts | 2 +-
 arch/arm/boot/dts/gemini-nas4220b.dts      | 2 +-
 arch/arm/boot/dts/gemini-rut1xx.dts        | 2 +-
 arch/arm/boot/dts/gemini-wbd111.dts        | 2 +-
 arch/arm/boot/dts/gemini-wbd222.dts        | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/gemini-dlink-dns-313.dts b/arch/arm/boot/dts/gemini-dlink-dns-313.dts
index 361dccd6c7ee..431c705a7b90 100644
--- a/arch/arm/boot/dts/gemini-dlink-dns-313.dts
+++ b/arch/arm/boot/dts/gemini-dlink-dns-313.dts
@@ -140,7 +140,7 @@ map1 {
 		};
 	};
 
-	mdio0: ethernet-phy {
+	mdio0: mdio {
 		compatible = "virtual,mdio-gpio";
 		/* Uses MDC and MDIO */
 		gpios = <&gpio0 22 GPIO_ACTIVE_HIGH>, /* MDC */
diff --git a/arch/arm/boot/dts/gemini-nas4220b.dts b/arch/arm/boot/dts/gemini-nas4220b.dts
index 963ea890c87f..1c5f7f9e7be3 100644
--- a/arch/arm/boot/dts/gemini-nas4220b.dts
+++ b/arch/arm/boot/dts/gemini-nas4220b.dts
@@ -62,7 +62,7 @@ led-green-os {
 		};
 	};
 
-	mdio0: ethernet-phy {
+	mdio0: mdio {
 		compatible = "virtual,mdio-gpio";
 		gpios = <&gpio0 22 GPIO_ACTIVE_HIGH>, /* MDC */
 			<&gpio0 21 GPIO_ACTIVE_HIGH>; /* MDIO */
diff --git a/arch/arm/boot/dts/gemini-rut1xx.dts b/arch/arm/boot/dts/gemini-rut1xx.dts
index eb4f0bf074da..c067c3778f1d 100644
--- a/arch/arm/boot/dts/gemini-rut1xx.dts
+++ b/arch/arm/boot/dts/gemini-rut1xx.dts
@@ -56,7 +56,7 @@ led-power {
 		};
 	};
 
-	mdio0: ethernet-phy {
+	mdio0: mdio {
 		compatible = "virtual,mdio-gpio";
 		gpios = <&gpio0 22 GPIO_ACTIVE_HIGH>, /* MDC */
 			<&gpio0 21 GPIO_ACTIVE_HIGH>; /* MDIO */
diff --git a/arch/arm/boot/dts/gemini-wbd111.dts b/arch/arm/boot/dts/gemini-wbd111.dts
index 29af86cd10f7..52c10ec0dc72 100644
--- a/arch/arm/boot/dts/gemini-wbd111.dts
+++ b/arch/arm/boot/dts/gemini-wbd111.dts
@@ -68,7 +68,7 @@ led-greeb-l3 {
 		};
 	};
 
-	mdio0: ethernet-phy {
+	mdio0: mdio {
 		compatible = "virtual,mdio-gpio";
 		gpios = <&gpio0 22 GPIO_ACTIVE_HIGH>, /* MDC */
 			<&gpio0 21 GPIO_ACTIVE_HIGH>; /* MDIO */
diff --git a/arch/arm/boot/dts/gemini-wbd222.dts b/arch/arm/boot/dts/gemini-wbd222.dts
index 24e6ae3616f7..73de5cfa01f8 100644
--- a/arch/arm/boot/dts/gemini-wbd222.dts
+++ b/arch/arm/boot/dts/gemini-wbd222.dts
@@ -67,7 +67,7 @@ led-green-l3 {
 		};
 	};
 
-	mdio0: ethernet-phy {
+	mdio0: mdio {
 		compatible = "virtual,mdio-gpio";
 		gpios = <&gpio0 22 GPIO_ACTIVE_HIGH>, /* MDC */
 			<&gpio0 21 GPIO_ACTIVE_HIGH>; /* MDIO */
-- 
2.30.2

