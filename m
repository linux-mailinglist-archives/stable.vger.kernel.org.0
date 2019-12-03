Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9BFD111F59
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbfLCWru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:47:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:38128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728343AbfLCWrt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:47:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9F8320684;
        Tue,  3 Dec 2019 22:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413268;
        bh=HwrdliP4e2KnHoiiMFsQZ6eO7u3d7tT5XWKqlt9m2F4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uta/fiN69toY/rLb5rQbDpzA1cPVL6i+Cn+PWF5vBxqcygy7ZnYzDI7icWfSErKWN
         NsVx7V0yGKA4r7Yt5QBKFrxgXIsbKvN8+r4iacCjx+XhJII7OkrUMPAgqcsXkjEX6w
         2PrJSsV+3m5n3yuAQq5EBpo+GAZzww6x2zcxtfo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 063/321] ARM: dts: imx23: Fix memory node duplication
Date:   Tue,  3 Dec 2019 23:32:09 +0100
Message-Id: <20191203223430.448598495@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit b629e83520fafe6f4c2f3e8c88c78a496fc4987c ]

Boards based on imx23 have duplicate memory nodes:

- One coming from the board dts file: memory@

- One coming from the imx23.dtsi file.

Fix the duplication by removing the memory node from the dtsi file
and by adding 'device_type = "memory";' in the board dts.

Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx23-evk.dts           | 1 +
 arch/arm/boot/dts/imx23-olinuxino.dts     | 1 +
 arch/arm/boot/dts/imx23-sansa.dts         | 1 +
 arch/arm/boot/dts/imx23-stmp378x_devb.dts | 1 +
 arch/arm/boot/dts/imx23-xfi3.dts          | 1 +
 arch/arm/boot/dts/imx23.dtsi              | 2 --
 6 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx23-evk.dts b/arch/arm/boot/dts/imx23-evk.dts
index ad2ae25b7b4db..aca27aa2d44bd 100644
--- a/arch/arm/boot/dts/imx23-evk.dts
+++ b/arch/arm/boot/dts/imx23-evk.dts
@@ -10,6 +10,7 @@
 	compatible = "fsl,imx23-evk", "fsl,imx23";
 
 	memory@40000000 {
+		device_type = "memory";
 		reg = <0x40000000 0x08000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx23-olinuxino.dts b/arch/arm/boot/dts/imx23-olinuxino.dts
index e9351774c6199..109f51603d45e 100644
--- a/arch/arm/boot/dts/imx23-olinuxino.dts
+++ b/arch/arm/boot/dts/imx23-olinuxino.dts
@@ -20,6 +20,7 @@
 	compatible = "olimex,imx23-olinuxino", "fsl,imx23";
 
 	memory@40000000 {
+		device_type = "memory";
 		reg = <0x40000000 0x04000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx23-sansa.dts b/arch/arm/boot/dts/imx23-sansa.dts
index 67de7863ad795..fa22fd9b24129 100644
--- a/arch/arm/boot/dts/imx23-sansa.dts
+++ b/arch/arm/boot/dts/imx23-sansa.dts
@@ -50,6 +50,7 @@
 	compatible = "sandisk,sansa_fuze_plus", "fsl,imx23";
 
 	memory@40000000 {
+		device_type = "memory";
 		reg = <0x40000000 0x04000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx23-stmp378x_devb.dts b/arch/arm/boot/dts/imx23-stmp378x_devb.dts
index 95c7b918f6d60..aab029349420d 100644
--- a/arch/arm/boot/dts/imx23-stmp378x_devb.dts
+++ b/arch/arm/boot/dts/imx23-stmp378x_devb.dts
@@ -17,6 +17,7 @@
 	compatible = "fsl,stmp378x-devb", "fsl,imx23";
 
 	memory@40000000 {
+		device_type = "memory";
 		reg = <0x40000000 0x04000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx23-xfi3.dts b/arch/arm/boot/dts/imx23-xfi3.dts
index 9616e500b9961..2b5df8dfd3ff3 100644
--- a/arch/arm/boot/dts/imx23-xfi3.dts
+++ b/arch/arm/boot/dts/imx23-xfi3.dts
@@ -49,6 +49,7 @@
 	compatible = "creative,x-fi3", "fsl,imx23";
 
 	memory@40000000 {
+		device_type = "memory";
 		reg = <0x40000000 0x04000000>;
 	};
 
diff --git a/arch/arm/boot/dts/imx23.dtsi b/arch/arm/boot/dts/imx23.dtsi
index 71bfd2b15609a..aaaa987d8eff9 100644
--- a/arch/arm/boot/dts/imx23.dtsi
+++ b/arch/arm/boot/dts/imx23.dtsi
@@ -13,10 +13,8 @@
 	 * The decompressor and also some bootloaders rely on a
 	 * pre-existing /chosen node to be available to insert the
 	 * command line and merge other ATAGS info.
-	 * Also for U-Boot there must be a pre-existing /memory node.
 	 */
 	chosen {};
-	memory { device_type = "memory"; };
 
 	aliases {
 		gpio0 = &gpio0;
-- 
2.20.1



