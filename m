Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B83A2C01B0
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 09:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbgKWIvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 03:51:08 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:52195 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbgKWIvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 03:51:07 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 35A5958A;
        Mon, 23 Nov 2020 03:51:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 03:51:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=c2qMFF
        CZKpMsbMO4Y4uWsWNRW6ubYzbGJXd+ZMmZu6Y=; b=MrAY3OkAOpBomlgZxWX08D
        ozjy/H+/43FUBICupqOsKGLLAmH1iHEZc9pY1x72UeLuL/MHnZrRqC0pCR+HO8aw
        5vzVWyFEYsxoAm6wPb7vo/oI/vDITZfvKH4ol0UpuW1+jvxYLTAIpZl2g/+f/ypg
        PGttKD5FAsshPLzKJEuyuya6Mv8YdJq+1qWASyMDHfxDi9ShyK6T8Wn86Dh4Ih/L
        MSCAYHNuyv816luqkrxeSW4vkKbYhD9UQKaxNh6PZ6ms2hgs9ALb86qjAzI6o6TH
        d4GWTRieAkyxSrYCq726kI28uo//hudo8//FC+AK4yX2Sv60TwmrBTfX0bO97Blg
        ==
X-ME-Sender: <xms:-ne7X5ewqTaAqnQJ_QYoQsyXtkfOSNdd8v0jnVWqXuneoQ-p0X8k0Q>
    <xme:-ne7X3P2EcCrMrFjLiQfrLdOdplTg0u4yg69gOzS_NlEUPom7xXlzmfdVTav7yJIC
    xfU3cDPY7wyaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:-ne7XyiZdc58G1NxTH2sXgC_SoQX5YtGuCtOFUSZStiFuzFDh8IjgQ>
    <xmx:-ne7Xy-Sb7Wh7P-u16Ki978K1LBnPghCBcx5Kcl99nxDyVgf6wu06A>
    <xmx:-ne7X1s8bz9j84tNhoc_lfB0Wzzdp7us07Mgcjew-c3omLeydx8nzw>
    <xmx:-ne7Xz2zXcq83CvsfkdCsXvx1tYECu3wiZ-nTUWmlE4h1g_SnHxqNOzqppQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 271193064AAE;
        Mon, 23 Nov 2020 03:51:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: dts: agilex/stratix10: Fix qspi node compatible" failed to apply to 4.19-stable tree
To:     dinguyen@kernel.org, vigneshr@ti.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 09:52:16 +0100
Message-ID: <1606121536243112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f126b6702e7354d6247a36f20b9172457af5c15a Mon Sep 17 00:00:00 2001
From: Dinh Nguyen <dinguyen@kernel.org>
Date: Sun, 1 Nov 2020 14:02:56 -0600
Subject: [PATCH] arm64: dts: agilex/stratix10: Fix qspi node compatible

The QSPI flash node needs to have the required "jedec,spi-nor"
in the compatible string.

Fixes: 0cb140d07fc7 ("arm64: dts: stratix10: Add QSPI support for Stratix10")
Cc: stable@vger.kernel.org
Suggested-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>

diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
index feadd21bc0dc..46e558ab7729 100644
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
@@ -159,7 +159,7 @@ &qspi {
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q00a";
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 
diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
index c07966740e14..f9b4a39683cf 100644
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts
@@ -192,7 +192,7 @@ &qspi {
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "n25q00a";
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 
diff --git a/arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts b/arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts
index 96c50d48289d..a7a83f29f00b 100644
--- a/arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts
@@ -110,7 +110,7 @@ &qspi {
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "mt25qu02g";
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 

