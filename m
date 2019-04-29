Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A72C2EBC5
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 22:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbfD2UnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 16:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:52734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728928AbfD2UnZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 16:43:25 -0400
Received: from localhost.localdomain (cpe-70-114-128-244.austin.res.rr.com [70.114.128.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 399A02075E;
        Mon, 29 Apr 2019 20:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556570604;
        bh=MJVXxdcOSTv5ZMbStCvi8fOK8k6kWrfC4eC2Nm/Mpd4=;
        h=From:To:Cc:Subject:Date:From;
        b=R0cyTOzvxYAKag91T/W+q2PfQCK+FLaNZgq2CiyQQnvCwPG2l1JIsFrNWD5LT/hcG
         vb8yB69sYarnQ4aGm1BHBHQY63nYeLSeE9eauCmnbwbSwnWs6Gh3ZfFgKI0w2Kfvsa
         bplkdeMhF8j+JnU28JAG9eCD1G+bR5OBKCB9Togw=
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     robh+dt@kernel.org, mark.rutland@arm.com
Cc:     dinguyen@kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] ARM: dts: arria10: Add EMAC OCP reset property
Date:   Mon, 29 Apr 2019 15:43:14 -0500
Message-Id: <20190429204314.21220-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add the EMAC's OCP reset property on Arria10. The OCP reset bits are
also needed to correctly bring the EMACs out of reset correctly.

Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 arch/arm/boot/dts/socfpga_arria10.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/socfpga_arria10.dtsi b/arch/arm/boot/dts/socfpga_arria10.dtsi
index ae24599d5829..a6206a0d5763 100644
--- a/arch/arm/boot/dts/socfpga_arria10.dtsi
+++ b/arch/arm/boot/dts/socfpga_arria10.dtsi
@@ -431,8 +431,8 @@
 			rx-fifo-depth = <16384>;
 			clocks = <&l4_mp_clk>;
 			clock-names = "stmmaceth";
-			resets = <&rst EMAC0_RESET>;
-			reset-names = "stmmaceth";
+			resets = <&rst EMAC0_RESET>, <&rst EMAC0_OCP_RESET>;
+			reset-names = "stmmaceth", "stmmaceth-ocp";
 			snps,axi-config = <&socfpga_axi_setup>;
 			status = "disabled";
 		};
@@ -451,8 +451,8 @@
 			rx-fifo-depth = <16384>;
 			clocks = <&l4_mp_clk>;
 			clock-names = "stmmaceth";
-			resets = <&rst EMAC1_RESET>;
-			reset-names = "stmmaceth";
+			resets = <&rst EMAC1_RESET>, <&rst EMAC1_OCP_RESET>;
+			reset-names = "stmmaceth", "stmmaceth-ocp";
 			snps,axi-config = <&socfpga_axi_setup>;
 			status = "disabled";
 		};
@@ -470,8 +470,8 @@
 			tx-fifo-depth = <4096>;
 			rx-fifo-depth = <16384>;
 			clocks = <&l4_mp_clk>;
-			resets = <&rst EMAC2_RESET>;
-			clock-names = "stmmaceth";
+			resets = <&rst EMAC2_RESET>, <&rst EMAC2_OCP_RESET>;
+			clock-names = "stmmaceth", "stmmaceth-ocp";
 			snps,axi-config = <&socfpga_axi_setup>;
 			status = "disabled";
 		};
-- 
2.20.0

