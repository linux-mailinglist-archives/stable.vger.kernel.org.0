Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0E519B83A
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 00:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733101AbgDAWPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 18:15:14 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:59743 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732537AbgDAWPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 18:15:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1585779313; x=1617315313;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pNTIwQ1CqOZCjXOldRhyWpBfPZeO+eg3UOXWN3Y4ZhM=;
  b=f4HcLq1tbPKw/WWUeuHkZ9WubJXNSwLOpxqAuBtLzUwFDuQf4B0YLwE4
   30wsqLJb3T2tGDHgnkFM7fgrebm365mOKahY6Vggl4nvPR+lki8f/ZYiW
   leDJvH5IN47AmUGK4u+pwVExEMy/kNIB4SmBDED+4JI/X/lSAqkNthCtw
   fVDZOQi42g7UOUJNVJjztJyBqaJBz2QJUtttO+rJJhNkQQs+aPrm9Xfuf
   12ZJ6g0PcAcNxUQIwotuU9pEmrs0Tvh+4VGDS/dObu74/48LP5nE3RN6B
   z2aOHuxE/wJDFlRxp1JcbYhIcvy7h+rcQmFUediWzY5i5JJSScgo0R0aS
   w==;
IronPort-SDR: qqE3wNJ1NKBF4wpf0zWePNhEAnobjp7/iTV/I5QY/VUA3NjQLZAoAXsRNEV8MseWD6qlejj0Xi
 K3Dg1lQCWf6OyBJ26oZ9uq7AgzMEnDmJN9UcjN3LLKmmcOVgr3owYq395RoEVvrTKdgv9XeGYA
 ysKExkPDqAsLKitmjRYVuuE3zEFv47TsyAsC5kqRotNHT2nleIhE6L5eppUAPbKD82k/9eOhhq
 W0TyUMTOT2xn0x40LfyWjpqneTgz9cKPjhCwZex3lgCGHrtSPTjLkVTAl53KwpfcqumhQl4SGH
 XkQ=
X-IronPort-AV: E=Sophos;i="5.72,333,1580799600"; 
   d="scan'208";a="70956400"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2020 15:15:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 1 Apr 2020 15:15:12 -0700
Received: from sekiro.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 1 Apr 2020 15:15:15 -0700
From:   Ludovic Desroches <ludovic.desroches@microchip.com>
To:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <robh+dt@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Tudor.Ambarus@microchip.com>, <Cristian.Birsan@microchip.com>,
        <Codrin.Ciubotariu@microchip.com>,
        "Ludovic Desroches" <ludovic.desroches@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/5] ARM: dts: at91: sama5d2_ptc_ek: fix sdmmc0 node description
Date:   Thu, 2 Apr 2020 00:15:00 +0200
Message-ID: <20200401221504.41196-1-ludovic.desroches@microchip.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Remove non-removable and mmc-ddr-1_8v properties from the sdmmc0
node which come probably from an unchecked copy/paste.

Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Fixes:42ed535595ec "ARM: dts: at91: introduce the sama5d2 ptc ek board"
Cc: stable@vger.kernel.org # 4.19 and later
---
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
index 1c24ac8019ba7..772809c54c1f3 100644
--- a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
@@ -125,8 +125,6 @@ sdmmc0: sdio-host@a0000000 {
 			bus-width = <8>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_sdmmc0_default>;
-			non-removable;
-			mmc-ddr-1_8v;
 			status = "okay";
 		};
 
-- 
2.26.0

