Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C89A122704
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 09:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfLQIuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 03:50:20 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:47496 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfLQIuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 03:50:19 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xBH8oFZx072970;
        Tue, 17 Dec 2019 02:50:15 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1576572615;
        bh=Oyi7OikDDT1O2GSXSF0FaFnaghRdiLKuGoGiKhDYnMI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=xjE0nmClIxXmz5oMnWj+CG7ZNRXToQ4EECWYgPdQpWqhyT4pwa47M7DaWlDA+6nLT
         n9bhskdFCa+Vuyo+i6H1cfsKPE+2SaHSxrNRtfMFCmy/l2/YYiBT2PTwjN3CVOPM7c
         R1UkJ2YtVJn2NHzmOSoN+UCXfZv7gN3sOiwSZm6o=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xBH8oFBo006629
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Dec 2019 02:50:15 -0600
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 17
 Dec 2019 02:50:15 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 17 Dec 2019 02:50:15 -0600
Received: from a0393678ub.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBH8o6dX062966;
        Tue, 17 Dec 2019 02:50:13 -0600
From:   Kishon Vijay Abraham I <kishon@ti.com>
To:     =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
CC:     Rob Herring <robh+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: [PATCH 2/3] ARM: dts: am571x-idk: Fix gpios property to have the correct  gpio number
Date:   Tue, 17 Dec 2019 14:21:23 +0530
Message-ID: <20191217085124.22480-3-kishon@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191217085124.22480-1-kishon@ti.com>
References: <20191217085124.22480-1-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit d23f3839fe97d8dce03d ("ARM: dts: DRA7: Add pcie1 dt node for
EP mode") while adding the dt node for EP mode for DRA7 platform,
added rc node for am571x-idk and populated gpios property with
"gpio3 23". However the GPIO_PCIE_SWRST line is actually connected
to "gpio5 18". Fix it here. (The patch adding "gpio3 23" was tested
with another am57x board in EP mode which doesn't rely on reset from
host).

Fixes: d23f3839fe97d8dce03d ("ARM: dts: DRA7: Add pcie1 dt node for
EP mode")
Cc: stable <stable@vger.kernel.org> # 4.14+

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/am571x-idk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am571x-idk.dts b/arch/arm/boot/dts/am571x-idk.dts
index 67239f7c22b8..669559c9c95b 100644
--- a/arch/arm/boot/dts/am571x-idk.dts
+++ b/arch/arm/boot/dts/am571x-idk.dts
@@ -167,7 +167,7 @@
 
 &pcie1_rc {
 	status = "okay";
-	gpios = <&gpio3 23 GPIO_ACTIVE_HIGH>;
+	gpios = <&gpio5 18 GPIO_ACTIVE_HIGH>;
 };
 
 &mmc1 {
-- 
2.17.1

