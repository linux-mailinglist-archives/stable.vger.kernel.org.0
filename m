Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 836C617FCCF
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgCJNXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:23:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729755AbgCJM7W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:59:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1019A2468D;
        Tue, 10 Mar 2020 12:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845161;
        bh=cKYl5Bomn7OIOLCEqiFWbDvqbeoLZJjAkix424k6Qd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rvf59BZjVcKmOv/Xf1maJv8Z58uXf74slvbk84t2m/51lUcTaniA2ABT5fCy/tZn4
         KlTC/++WEU5ZCuBPbpbIAi/BYNb7ujMuSFmgj2CpSm8pdP/4Tfzk8h5mez+Qbd4Cak
         EnCb5RBsWJo8uoK96e+xClV+kX/OjA4IZvzilhy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ley Foon Tan <ley.foon.tan@intel.com>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 5.5 085/189] arm64: dts: socfpga: agilex: Fix gmac compatible
Date:   Tue, 10 Mar 2020 13:38:42 +0100
Message-Id: <20200310123648.275495203@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ley Foon Tan <ley.foon.tan@intel.com>

commit 8c867387160e89c9ffd12459f38e56844312a7a7 upstream.

Fix gmac compatible string to "altr,socfpga-stmmac-a10-s10". Gmac for
Agilex should use same compatible as Stratix 10.

Fixes: 4b36daf9ada3 ("arm64: dts: agilex: Add initial support for Intel's Agilex SoCFPGA")
Cc: stable@vger.kernel.org
Signed-off-by: Ley Foon Tan <ley.foon.tan@intel.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
@@ -117,7 +117,7 @@
 		};
 
 		gmac1: ethernet@ff802000 {
-			compatible = "altr,socfpga-stmmac", "snps,dwmac-3.74a", "snps,dwmac";
+			compatible = "altr,socfpga-stmmac-a10-s10", "snps,dwmac-3.74a", "snps,dwmac";
 			reg = <0xff802000 0x2000>;
 			interrupts = <0 91 4>;
 			interrupt-names = "macirq";
@@ -132,7 +132,7 @@
 		};
 
 		gmac2: ethernet@ff804000 {
-			compatible = "altr,socfpga-stmmac", "snps,dwmac-3.74a", "snps,dwmac";
+			compatible = "altr,socfpga-stmmac-a10-s10", "snps,dwmac-3.74a", "snps,dwmac";
 			reg = <0xff804000 0x2000>;
 			interrupts = <0 92 4>;
 			interrupt-names = "macirq";


