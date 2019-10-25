Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFFAE45E9
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 10:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408333AbfJYIlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 04:41:23 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:44650 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405057AbfJYIlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 04:41:22 -0400
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Ludovic.Desroches@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Ludovic.Desroches@microchip.com";
  x-sender="Ludovic.Desroches@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Ludovic.Desroches@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Ludovic.Desroches@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: SRZRZ0DKDT47obkNCrvEEvEWA9lxJz/n+4y8g1CvS6lC6iKUhdYJyCIxMDppQvIyWY9fWQLNGd
 oD63BNCCZr4cM8HSqEuN/OloqWFETGhtnFklHEzNsZPk00D9OmFxm+hZ9G77f6ghUlfsLjYOLy
 MH6dkXXsHFZzAqUuHB/xmEQgP7bzOZI9gmpny4lOekLsMt02UFWVu6+7vkSB9al1cT84W1Rkdb
 MWCzTInjefQprVsAkDVEhizo+laZBHe3JXOQieEUQlBT1z2I0nhq7p5Qy9Ej8Xq6ukYM2vbX0m
 RG0=
X-IronPort-AV: E=Sophos;i="5.68,228,1569308400"; 
   d="scan'208";a="52901142"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Oct 2019 01:41:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 25 Oct 2019 01:41:15 -0700
Received: from M43218.corp.atmel.com (10.10.85.251) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 25 Oct 2019 01:41:14 -0700
From:   Ludovic Desroches <ludovic.desroches@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] ARM: dts: at91: sama5d4: fix pinctrl muxing
Date:   Fri, 25 Oct 2019 10:42:10 +0200
Message-ID: <20191025084210.14726-1-ludovic.desroches@microchip.com>
X-Mailer: git-send-email 2.24.0.rc0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix pinctrl muxing, PD28, PD29 and PD31 can be muxed to peripheral A. It
allows to use SCK0, SCK1 and SPI0_NPCS2 signals.

Signed-off-by: Ludovic Desroches <ludovic.desroches@microchip.com>
Fixes: 679f8d92bb01 ("ARM: at91/dt: sama5d4: add pioD pin mux mask and enable pioD")
Cc: stable@vger.kernel.org
---
 arch/arm/boot/dts/sama5d4.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sama5d4.dtsi b/arch/arm/boot/dts/sama5d4.dtsi
index 6ab27a7b388d..a4cef07c38cb 100644
--- a/arch/arm/boot/dts/sama5d4.dtsi
+++ b/arch/arm/boot/dts/sama5d4.dtsi
@@ -914,7 +914,7 @@ /*   A          B          C  */
 					0xffffffff 0x3ffcfe7c 0x1c010101	/* pioA */
 					0x7fffffff 0xfffccc3a 0x3f00cc3a	/* pioB */
 					0xffffffff 0x3ff83fff 0xff00ffff	/* pioC */
-					0x0003ff00 0x8002a800 0x00000000	/* pioD */
+					0xb003ff00 0x8002a800 0x00000000	/* pioD */
 					0xffffffff 0x7fffffff 0x76fff1bf	/* pioE */
 					>;
 
-- 
2.24.0.rc0

