Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2063431EB45
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 16:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhBRPHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 10:07:18 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36670 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbhBRNiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 08:38:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1613655484; x=1645191484;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=m1IiLwGqbiTHG8Ajf+1tTZZIHKAEPqSOeQlap/U9wfs=;
  b=DA0plEHd00kiD66XBOtJ9JXzrm+vNhG5gxEVUOMVvxZPMQi6AY79b5aV
   YwoxtSNPuQ5MzhO5dup/gXN4iGPJDL4liNq3wPRJKG9Rr1Im6ujmBp8mm
   2ivqUApwioyytGduPvZIngDJMmufregcD4/Ct//CiwRqAqRxsct4oBkOM
   9bj49Sqx3agNOcidxl6CwD95sKmEZpkF5tzvs6lvPJ/6EtkfejOBsiAr/
   eWeFFF4Sv+8a1gZhwf49IiHxauRwrW7jrj9sAwclkERT1Jnk3B4Z+PsmW
   H1DGsBO6Z0gCTHpwOxTac8rS5SA8/8adMlpr53c87qcl9NdvP/GAPidnT
   A==;
IronPort-SDR: VHS7JS4ssbMIydEB/lcuoyoO2s0ERg9FuB68OmE56QZKFn6F3WJfG65+eh8mLAFCwnIuQQ0OYg
 ia7JzEOgxIxuTTWBToTeQhtPGDDH/3fyBSxNsNeGp15l6z3nvV2LrJlhRf6jKPkG/VunHYOviM
 Fx/vkiy/3McKdDZCHe29tKfPggGbd9b15eGNYhRPoHismHbmTOGufzR82/yKLlxglFejKiJvY6
 uYlXO3nf7oVo401k8m7YRiAaOv4xf47TgBEjX3Fp2DOTb6+TZOfM2FZN005/4R3clkCqoNB1MR
 /SU=
X-IronPort-AV: E=Sophos;i="5.81,187,1610434800"; 
   d="scan'208";a="109746287"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Feb 2021 06:35:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Feb 2021 06:35:56 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 18 Feb 2021 06:35:54 -0700
From:   <nicolas.ferre@microchip.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Federico Pellegrin <fede@evolware.org>,
        <stable@vger.kernel.org>,
        "Sandeep Sheriker Mallikarjun" 
        <sandeepsheriker.mallikarjun@microchip.com>
Subject: [PATCH] ARM: dts: at91: sam9x60: fix mux-mask for PA7 so it can be set to A, B and C
Date:   Thu, 18 Feb 2021 14:31:38 +0100
Message-ID: <20210218133138.21494-1-nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Federico Pellegrin <fede@evolware.org>

According to the datasheet PA7 can be set to either function A, B or
C (see table 6-2 of DS60001579D). The previous value would permit just
configuring with function C.

Signed-off-by: Federico Pellegrin <fede@evolware.org>
Fixes: 1e5f532c2737 ("ARM: dts: at91: sam9x60: add device tree for soc and board")
Cc: <stable@vger.kernel.org> # 5.6+
Cc: Sandeep Sheriker Mallikarjun <sandeepsheriker.mallikarjun@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
---
 arch/arm/boot/dts/at91-sam9x60ek.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91-sam9x60ek.dts b/arch/arm/boot/dts/at91-sam9x60ek.dts
index 73b6b1f89de9..4c40ae571154 100644
--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -336,7 +336,7 @@ ethernet-phy@0 {
 &pinctrl {
 	atmel,mux-mask = <
 			 /*	A	B	C	*/
-			 0xFFFFFE7F 0xC0E0397F 0xEF00019D	/* pioA */
+			 0xFFFFFEFF 0xC0E039FF 0xEF00019D	/* pioA */
 			 0x03FFFFFF 0x02FC7E68 0x00780000	/* pioB */
 			 0xffffffff 0xF83FFFFF 0xB800F3FC	/* pioC */
 			 0x003FFFFF 0x003F8000 0x00000000	/* pioD */
-- 
2.30.0

