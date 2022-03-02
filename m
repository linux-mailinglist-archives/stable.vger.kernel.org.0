Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBAC4CA9FC
	for <lists+stable@lfdr.de>; Wed,  2 Mar 2022 17:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240266AbiCBQTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Mar 2022 11:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238228AbiCBQTm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Mar 2022 11:19:42 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB79C2E0AB;
        Wed,  2 Mar 2022 08:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646237939; x=1677773939;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iJZ4w2BNAIhvjzcRUQCBu6P8PtdF5bDSwthjMcne50s=;
  b=fbwjA2G0jNFpJ8xrUz7MKCEgQBrHZy1gXPLZsSR81XYgmWQ4wqbF+++J
   LeJIsvF+6E2FlWqQ6qWNdwmf7qjsgK+Fjwd0iDYLI9vtW3+9M4ZJpCTE6
   YDNgUJ9fAOXPG7whlEwaQjnD/dP9KthtlpLcsiRKeO9WjMoVHkOr0gOmR
   PnFg55HVqRTyFUWm8vpQ2S0XGKnIFnpg+lTN6WEfR7Q3TNsbTFThdr3O2
   cq4xtuzn1DglVHg59pigePVuPkaL2/wrQZyfBNvujaSla/rey832C/I6P
   GLK+5fI3N+rFkJdelWdqnuum8IwSwIQLFPCD2OwxVk7VntKZeCllup1Z4
   w==;
X-IronPort-AV: E=Sophos;i="5.90,149,1643698800"; 
   d="scan'208";a="155442920"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Mar 2022 09:18:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 2 Mar 2022 09:18:59 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 2 Mar 2022 09:18:56 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <alexandre.belloni@bootlin.com>
CC:     <robh+dt@kernel.org>, <eugen.hristev@microchip.com>,
        <codrin.ciubotariu@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sergiu.moga@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] ARM: dts: at91: sama7g5: Remove unused properties in i2c nodes
Date:   Wed, 2 Mar 2022 18:18:54 +0200
Message-ID: <20220302161854.32177-1-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The "atmel,use-dma-rx", "atmel,use-dma-rx" dt properties are not used by
the i2c-at91 driver, nor they are defined in the bindings file, thus remove
them.

Cc: stable@vger.kernel.org
Fixes: 7540629e2fc7 ("ARM: dts: at91: add sama7g5 SoC DT and sama7g5-ek")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 arch/arm/boot/dts/sama7g5.dtsi | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/boot/dts/sama7g5.dtsi b/arch/arm/boot/dts/sama7g5.dtsi
index 1dc0631e9fd4..e626f6bd920a 100644
--- a/arch/arm/boot/dts/sama7g5.dtsi
+++ b/arch/arm/boot/dts/sama7g5.dtsi
@@ -591,8 +591,6 @@ i2c1: i2c@600 {
 				dmas = <&dma0 AT91_XDMAC_DT_PERID(7)>,
 					<&dma0 AT91_XDMAC_DT_PERID(8)>;
 				dma-names = "rx", "tx";
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				status = "disabled";
 			};
 		};
@@ -778,8 +776,6 @@ i2c8: i2c@600 {
 				dmas = <&dma0 AT91_XDMAC_DT_PERID(21)>,
 					<&dma0 AT91_XDMAC_DT_PERID(22)>;
 				dma-names = "rx", "tx";
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				status = "disabled";
 			};
 		};
@@ -804,8 +800,6 @@ i2c9: i2c@600 {
 				dmas = <&dma0 AT91_XDMAC_DT_PERID(23)>,
 					<&dma0 AT91_XDMAC_DT_PERID(24)>;
 				dma-names = "rx", "tx";
-				atmel,use-dma-rx;
-				atmel,use-dma-tx;
 				status = "disabled";
 			};
 		};
-- 
2.25.1

