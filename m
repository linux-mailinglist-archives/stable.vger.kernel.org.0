Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4442C01AE
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 09:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgKWIvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 03:51:15 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:36841 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725275AbgKWIvP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 03:51:15 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 904CDE20;
        Mon, 23 Nov 2020 03:51:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 03:51:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=FbCwb8
        hJb7jw/XXRL9trvEAqY5jpy0j7hDQw0nCX3YQ=; b=AmRSPuoWZ3QC0dG4WwY78E
        jJ3GWk4/o+0VElYed0tmctLyL39RbsfoCBCEjySnu64oneU4Mu6SffXsBJrHpOY6
        ahv92xPDNQNYO3mSmObuXx+39SqLAEhsLTuRAt9jBynDlWPq5q6nl/g9tSQ8PvJL
        Hfb4FIWegDfzA3RwvFmKyLK6Wjwvwq7nDicH9SGl5UyAVZTD2VNzacba07BfkGtx
        F/TuvgdfdcsGMEqE9kEL+dHokrCROQ2dvWY7935txF2rFjA/Xugh/X3JPKmLAmfW
        Wp6fqgwCkzMg5u6U2/ICQ/o1KMwRT+cWVsQDKPTAmXBj/BpUq6n0+gDn1DNVb3GQ
        ==
X-ME-Sender: <xms:Ani7Xx2Ins-JtY5vMNOmFvILczc3YDv8iIAoIRM3cUMjMWeQFa1XDw>
    <xme:Ani7X4EefL2-i0_SyPaPE9SKsXvCBh5zRmiSBPJk0NVxUTbFggx6vXhqof5TAy_lh
    2__Hn-NvurEBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeghedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:Ani7Xx47jSVUmy7BVSwHfp8e5zAqLbvu_Xra9_MjpBwzcfNjM14zow>
    <xmx:Ani7X-2LyqjS6J3f9LtRPaQvadxWheLLDZecbOv1AVRr8QSjpb-acw>
    <xmx:Ani7X0FGtJjx7ueOeB--0Zzz8NDPldeIN05ar5E1_Jf-DacviFGUNw>
    <xmx:Ani7X_Ndj-TICkzVDoBuwjEVQgjh043wyeM8MdWiqxPgXcGE2D3HSD-IFcY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CB5363280065;
        Mon, 23 Nov 2020 03:51:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: dts: agilex/stratix10: Fix qspi node compatible" failed to apply to 5.4-stable tree
To:     dinguyen@kernel.org, vigneshr@ti.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 09:52:16 +0100
Message-ID: <1606121536895@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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
 

