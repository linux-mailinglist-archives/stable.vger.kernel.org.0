Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D569219B840
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 00:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733211AbgDAWPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 18:15:17 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:10810 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732537AbgDAWPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 18:15:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1585779316; x=1617315316;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K3miLFKrYLPIkEbM2MSg4gmUTaLvb4ricn3OFJzRkdI=;
  b=DJxNhL+zFfwJZjqHE2CEM0SDOG0GqLt+XuVIimkKPNnM0vj+5GviffZd
   DTnqlMkBj8zTlGw2mOTkhIdEO+JsVPbkq8JnLwDbNLqZkJxeM/zytvAxA
   PmxIHu3V0ilONkIrJOxHL3bKneRvImhk7PZAJGBX5Uvc+uC2iPoykfq1C
   lpSA1h7JPefWwO5ahTaNdc0asVoSLmzxnKOsOPhC0m0OGa8XTthC166/L
   mKnyx3uOO2EFl6AQz21VWy3t+EVRO10acGvxBQ95tQKNI8F8/wZltJvYW
   tL/jhGJXkl/gw4qK8qCLRbIFKi+f6HuQ31zq3SRLjBWvLcykNuPycCoBz
   Q==;
IronPort-SDR: 6zap22IBfi4TcnWYCqrLeBZPMSliWsCclyeMk4EPI0Hnwd2GCsMKryQyH08EXoTeiwIV1UO8fD
 EjFWzIxhjYo3YQRw8cUe7PPTLc8QWGDXT+CCqX/PkmxwU/WYjDKfiM777jq7BKgaG3ggmTsP7M
 kCB2S5vI1oww5F9EisU14REzmtRhkI0N9s6k729OdamqQt2CddMx8C97AaUCgZabTv+0W/d/VP
 NOXpA8vhLIsDbJzt8IKs8nlwnZijNBjOZIPNDE/kFyySYG+GPGymATZ6PgkNUzxhi7Nc281/O8
 r2s=
X-IronPort-AV: E=Sophos;i="5.72,333,1580799600"; 
   d="scan'208";a="72005448"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Apr 2020 15:15:16 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 1 Apr 2020 15:15:22 -0700
Received: from sekiro.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 1 Apr 2020 15:15:19 -0700
From:   Ludovic Desroches <ludovic.desroches@microchip.com>
To:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <robh+dt@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Tudor.Ambarus@microchip.com>, <Cristian.Birsan@microchip.com>,
        <Codrin.Ciubotariu@microchip.com>,
        "Ludovic Desroches" <ludovic.desroches@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/5] ARM: dts: at91: sama5d2_ptc_ek: fix vbus pin
Date:   Thu, 2 Apr 2020 00:15:01 +0200
Message-ID: <20200401221504.41196-2-ludovic.desroches@microchip.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401221504.41196-1-ludovic.desroches@microchip.com>
References: <20200401221504.41196-1-ludovic.desroches@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The gpio property for the vbus pin doesn't watch the pinctrl and is
not correct.

Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Fixes: 42ed535595ec "ARM: dts: at91: introduce the sama5d2 ptc ek board"
Cc: stable@vger.kernel.org # 4.19 and later
---
 arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
index 772809c54c1f3..b803fa1f20391 100644
--- a/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_ptc_ek.dts
@@ -40,7 +40,7 @@ main_xtal {
 
 	ahb {
 		usb0: gadget@300000 {
-			atmel,vbus-gpio = <&pioA PIN_PA27 GPIO_ACTIVE_HIGH>;
+			atmel,vbus-gpio = <&pioA PIN_PB11 GPIO_ACTIVE_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&pinctrl_usba_vbus>;
 			status = "okay";
-- 
2.26.0

