Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68DB3D282B
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbhGVPzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232784AbhGVPzJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:55:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 080F96135A;
        Thu, 22 Jul 2021 16:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971741;
        bh=bPysZGYoaAhE+qgCA+vuN2X4jnBLeVSu1WhAFD3upwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pE2HR7BO4eBHPJ5KkTsjjzEWqAfKYfMyR5zZtn5DwpCL0BpeEH6L8mMkaJgehc4P3
         XNm9pR4S8OAFecmL5Hw6WdjSye/jL7uOtPoYuYQsghbQN0sHigOk4LFA3uvD0APCkC
         pZHr+/wUNuEzBOGWuSweob19LaWn+H4A5EezO0I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/125] ARM: dts: gemini: rename mdio to the right name
Date:   Thu, 22 Jul 2021 18:29:52 +0200
Message-Id: <20210722155624.722645948@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c6f3d90e3e90..b8acc6eaaa6d 100644
--- a/arch/arm/boot/dts/gemini-dlink-dns-313.dts
+++ b/arch/arm/boot/dts/gemini-dlink-dns-313.dts
@@ -140,7 +140,7 @@
 		};
 	};
 
-	mdio0: ethernet-phy {
+	mdio0: mdio {
 		compatible = "virtual,mdio-gpio";
 		/* Uses MDC and MDIO */
 		gpios = <&gpio0 22 GPIO_ACTIVE_HIGH>, /* MDC */
diff --git a/arch/arm/boot/dts/gemini-nas4220b.dts b/arch/arm/boot/dts/gemini-nas4220b.dts
index 43c45f7e1e0a..13112a8a5dd8 100644
--- a/arch/arm/boot/dts/gemini-nas4220b.dts
+++ b/arch/arm/boot/dts/gemini-nas4220b.dts
@@ -62,7 +62,7 @@
 		};
 	};
 
-	mdio0: ethernet-phy {
+	mdio0: mdio {
 		compatible = "virtual,mdio-gpio";
 		gpios = <&gpio0 22 GPIO_ACTIVE_HIGH>, /* MDC */
 			<&gpio0 21 GPIO_ACTIVE_HIGH>; /* MDIO */
diff --git a/arch/arm/boot/dts/gemini-rut1xx.dts b/arch/arm/boot/dts/gemini-rut1xx.dts
index 08091d2a64e1..0ebda4efd9d0 100644
--- a/arch/arm/boot/dts/gemini-rut1xx.dts
+++ b/arch/arm/boot/dts/gemini-rut1xx.dts
@@ -56,7 +56,7 @@
 		};
 	};
 
-	mdio0: ethernet-phy {
+	mdio0: mdio {
 		compatible = "virtual,mdio-gpio";
 		gpios = <&gpio0 22 GPIO_ACTIVE_HIGH>, /* MDC */
 			<&gpio0 21 GPIO_ACTIVE_HIGH>; /* MDIO */
diff --git a/arch/arm/boot/dts/gemini-wbd111.dts b/arch/arm/boot/dts/gemini-wbd111.dts
index 3a2761dd460f..5602ba8f30f2 100644
--- a/arch/arm/boot/dts/gemini-wbd111.dts
+++ b/arch/arm/boot/dts/gemini-wbd111.dts
@@ -68,7 +68,7 @@
 		};
 	};
 
-	mdio0: ethernet-phy {
+	mdio0: mdio {
 		compatible = "virtual,mdio-gpio";
 		gpios = <&gpio0 22 GPIO_ACTIVE_HIGH>, /* MDC */
 			<&gpio0 21 GPIO_ACTIVE_HIGH>; /* MDIO */
diff --git a/arch/arm/boot/dts/gemini-wbd222.dts b/arch/arm/boot/dts/gemini-wbd222.dts
index 52b4dbc0c072..a4a260c36d75 100644
--- a/arch/arm/boot/dts/gemini-wbd222.dts
+++ b/arch/arm/boot/dts/gemini-wbd222.dts
@@ -67,7 +67,7 @@
 		};
 	};
 
-	mdio0: ethernet-phy {
+	mdio0: mdio {
 		compatible = "virtual,mdio-gpio";
 		gpios = <&gpio0 22 GPIO_ACTIVE_HIGH>, /* MDC */
 			<&gpio0 21 GPIO_ACTIVE_HIGH>; /* MDIO */
-- 
2.30.2



