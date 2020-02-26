Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673CE172D91
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 01:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730233AbgB1An5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 19:43:57 -0500
Received: from mga04.intel.com ([192.55.52.120]:43768 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730120AbgB1An4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 19:43:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Feb 2020 16:43:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,493,1574150400"; 
   d="scan'208";a="232379541"
Received: from unknown (HELO lftan) ([10.226.248.77])
  by fmsmga008.fm.intel.com with SMTP; 27 Feb 2020 16:43:53 -0800
Received: by lftan (sSMTP sendmail emulation); Thu, 27 Feb 2020 04:20:15 +0800
From:   Ley Foon Tan <ley.foon.tan@intel.com>
To:     Dinh Nguyen <dinguyen@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Chin Liang See <chin.liang.see@intel.com>,
        lftan.linux@gmail.com, Ley Foon Tan <ley.foon.tan@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH RESEND] arm64: dts: socfpga: agilex: Fix gmac compatible
Date:   Thu, 27 Feb 2020 04:20:14 +0800
Message-Id: <20200226202014.66253-1-ley.foon.tan@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix gmac compatible string to "altr,socfpga-stmmac-a10-s10". Gmac for
Agilex should use same compatible as Stratix 10.

Fixes: 4b36daf9ada3 ("arm64: dts: agilex: Add initial support for Intel's
Agilex SoCFPGA")

Cc: stable@vger.kernel.org
Signed-off-by: Ley Foon Tan <ley.foon.tan@intel.com>
---
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi b/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
index e1d357eaad7c..d8c44d3ca15a 100644
--- a/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
@@ -102,7 +102,7 @@
 		};
 
 		gmac0: ethernet@ff800000 {
-			compatible = "altr,socfpga-stmmac", "snps,dwmac-3.74a", "snps,dwmac";
+			compatible = "altr,socfpga-stmmac-a10-s10", "snps,dwmac-3.74a", "snps,dwmac";
 			reg = <0xff800000 0x2000>;
 			interrupts = <0 90 4>;
 			interrupt-names = "macirq";
@@ -118,7 +118,7 @@
 		};
 
 		gmac1: ethernet@ff802000 {
-			compatible = "altr,socfpga-stmmac", "snps,dwmac-3.74a", "snps,dwmac";
+			compatible = "altr,socfpga-stmmac-a10-s10", "snps,dwmac-3.74a", "snps,dwmac";
 			reg = <0xff802000 0x2000>;
 			interrupts = <0 91 4>;
 			interrupt-names = "macirq";
@@ -134,7 +134,7 @@
 		};
 
 		gmac2: ethernet@ff804000 {
-			compatible = "altr,socfpga-stmmac", "snps,dwmac-3.74a", "snps,dwmac";
+			compatible = "altr,socfpga-stmmac-a10-s10", "snps,dwmac-3.74a", "snps,dwmac";
 			reg = <0xff804000 0x2000>;
 			interrupts = <0 92 4>;
 			interrupt-names = "macirq";
-- 
2.19.0

