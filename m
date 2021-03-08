Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B909F331678
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 19:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbhCHSqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 13:46:08 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35841 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbhCHSpl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 13:45:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615229142; x=1646765142;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QlZkF/n+OFe4HMXAJQG4MFvDSH2sQBY/KgzRuDuLAfg=;
  b=q/A+ZmVi+t/NOj2WVfaQd1QqJY/VDc0+Hk676ZHetA+42mSUkW1QN9DQ
   ww20ysUiYa6pu90klOa2uTsySWeGtc9KG2Uqe8mr8bf8O9ocuq+O5DoVq
   LSo7jyzuJprhBQ3VD2I8csX7ECdPInkaMRf0N6z1qodYGamC50xcFmzkd
   xceedd0zzUB7i8G0lWNhLIsfBnVXHepTF7mi9IdmqN5oY77DoJk0c3OUr
   JQbHGnK5fUD7t+NtTTRE7Dx++yFODNRkUQQ2AkICrpcF1Y/VMYzXw7v2M
   Dx5/yXlplLoB1aaaCPhATUK7thHgdy28qFWggGJf1VE+FSX2i3yCU+lKY
   g==;
IronPort-SDR: Rp+BGoXaDahRqxX8xCPAlHbcB4bTR4j7Ej2EwdYYgGhKAGjEHIXvtDMs7bO27SySllDhE162Ic
 FiQVayUJUcCjX9fzgDRTGMUEmvOpv5GTnCwXuxLoRX9PCCygMNd83UNOGE7uKDZdahHPY1W85L
 LenNozH2KGn9Hc0c3cUjWJsN/rN8q8x6dcgm8+zG0KthwgqxRPAZnHmZajn0c/Qzap2qXqcgPb
 fC+bSa/iH9TD5dwgB/ibFFjFg+oHFmPXJ12C34z7DwiNUimXKfdfIuNr3fkdzwkzxgh6jS4m4C
 xFg=
X-IronPort-AV: E=Sophos;i="5.81,233,1610434800"; 
   d="scan'208";a="111918962"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Mar 2021 11:45:40 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 8 Mar 2021 11:45:37 -0700
Received: from ness.microchip.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Mon, 8 Mar 2021 11:45:36 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>
CC:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        <stable@vger.kernel.org>,
        "Sandeep Sheriker Mallikarjun" 
        <sandeepsheriker.mallikarjun@microchip.com>
Subject: [PATCH] ARM: dts: at91: sam9x60: fix mux-mask to match product's datasheet
Date:   Mon, 8 Mar 2021 19:45:27 +0100
Message-ID: <20210308184527.33036-1-nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

Fix the whole mux-mask table according to datasheet for the sam9x60
product.  Too much functions for pins were disabled leading to
misunderstandings when enabling more peripherals or taking this table
as an example for another board.

Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Fixes: 1e5f532c2737 ("ARM: dts: at91: sam9x60: add device tree for soc and board")
Cc: <stable@vger.kernel.org> # 5.6+
Cc: Sandeep Sheriker Mallikarjun <sandeepsheriker.mallikarjun@microchip.com>
---
 arch/arm/boot/dts/at91-sam9x60ek.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sam9x60ek.dts b/arch/arm/boot/dts/at91-sam9x60ek.dts
index 4c40ae571154..63207c952223 100644
--- a/arch/arm/boot/dts/at91-sam9x60ek.dts
+++ b/arch/arm/boot/dts/at91-sam9x60ek.dts
@@ -336,9 +336,9 @@ ethernet-phy@0 {
 &pinctrl {
 	atmel,mux-mask = <
 			 /*	A	B	C	*/
-			 0xFFFFFEFF 0xC0E039FF 0xEF00019D	/* pioA */
-			 0x03FFFFFF 0x02FC7E68 0x00780000	/* pioB */
-			 0xffffffff 0xF83FFFFF 0xB800F3FC	/* pioC */
+			 0xFFFFFFFF 0xFFE03FFF 0xEF00019D	/* pioA */
+			 0x03FFFFFF 0x02FC7E7F 0x00780000	/* pioB */
+			 0xffffffff 0xFFFFFFFF 0xF83FFFFF	/* pioC */
 			 0x003FFFFF 0x003F8000 0x00000000	/* pioD */
 			 >;
 
-- 
2.30.1

