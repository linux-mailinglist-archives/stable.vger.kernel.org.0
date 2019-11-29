Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C89E10D52E
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 12:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbfK2LuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 06:50:13 -0500
Received: from olimex.com ([184.105.72.32]:57808 "EHLO olimex.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbfK2LuM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Nov 2019 06:50:12 -0500
Received: from localhost.localdomain ([94.155.250.134])
        by olimex.com with ESMTPSA (ECDHE-RSA-AES128-GCM-SHA256:TLSv1.2:Kx=ECDH:Au=RSA:Enc=AESGCM(128):Mac=AEAD) (SMTP-AUTH username stefan@olimex.com, mechanism PLAIN)
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 03:40:02 -0800
From:   Stefan Mavrodiev <stefan@olimex.com>
To:     Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Allwinner
        sunXi SoC support),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     linux-sunxi@googlegroups.com, Stefan Mavrodiev <stefan@olimex.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 3/3] arm64: dts: allwinner: a64: olinuxino: Fix SDIO supply regulator
Date:   Fri, 29 Nov 2019 13:39:41 +0200
Message-Id: <20191129113941.20170-4-stefan@olimex.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191129113941.20170-1-stefan@olimex.com>
References: <20191129113941.20170-1-stefan@olimex.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A64-OLinuXino uses DCDC1 (VCC-IO) for MMC1 supply. In commit 916b68cfe4b5
("arm64: dts: a64-olinuxino: Enable RTL8723BS WiFi") ALDO2 is set, which is
VCC-PL. Since DCDC1 is always present, the boards are working without a
problem.

This patch sets the correct regulator.

Fixes: 916b68cfe4b5 ("arm64: dts: a64-olinuxino: Enable RTL8723BS WiFi")
Cc: stable@vger.kernel.org # v4.16+
Signed-off-by: Stefan Mavrodiev <stefan@olimex.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts
index ad3559c576dd..869bb146a9ff 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-olinuxino.dts
@@ -140,7 +140,7 @@
 &mmc1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&mmc1_pins>;
-	vmmc-supply = <&reg_aldo2>;
+	vmmc-supply = <&reg_dcdc1>;
 	vqmmc-supply = <&reg_dldo4>;
 	mmc-pwrseq = <&wifi_pwrseq>;
 	bus-width = <4>;
-- 
2.17.1
