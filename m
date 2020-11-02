Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14112A31AC
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 18:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgKBRf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 12:35:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbgKBRf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Nov 2020 12:35:26 -0500
Received: from localhost.localdomain (cpe-70-114-140-30.austin.res.rr.com [70.114.140.30])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86C6F208A9;
        Mon,  2 Nov 2020 17:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604338526;
        bh=grigcmrEiodYgzlWfZJO1Bq5qiQJKGw/FYZ5fiKtMaM=;
        h=From:To:Cc:Subject:Date:From;
        b=FMU11bnF3y21FAQkSBN5RaT2+PnWguQzgQyaUg1r2JQsu9DSQ12v50q3wV/Cw/Cuw
         WycB9ndLQOWUDnK3zOZnhaZ2giDz7vxDv0UOCBPLN03KUHYfi7aebzVfvcwNifCWys
         k2D9fu85H0Q9k7NGFpPTSwEdfBY539nEAMUYlkB0=
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     devicetree@vger.kernel.org
Cc:     dinguyen@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        vigneshr@ti.com, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: [PATCH] arm64: dts: agilex/stratix10: Fix qspi node compatible
Date:   Mon,  2 Nov 2020 11:35:20 -0600
Message-Id: <20201102173520.13242-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The QSPI flash node needs to have the required "jedec,spi-nor"
in the compatible string.

Fixes: 0cb140d07fc7 ("arm64: dts: stratix10: Add QSPI support for Stratix10")
Cc: stable@vger.kernel.org
Suggested-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts      | 2 +-
 arch/arm64/boot/dts/altera/socfpga_stratix10_socdk_nand.dts | 2 +-
 arch/arm64/boot/dts/intel/socfpga_agilex_socdk.dts          | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
index feadd21bc0dc..46e558ab7729 100644
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10_socdk.dts
@@ -159,7 +159,7 @@
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
@@ -192,7 +192,7 @@
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
@@ -110,7 +110,7 @@
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "mt25qu02g";
+		compatible = "micron,mt25qu02g", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <100000000>;
 
-- 
2.17.1

