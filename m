Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03AEE10663E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbfKVFtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:49:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:53708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727112AbfKVFtf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB1CF2070E;
        Fri, 22 Nov 2019 05:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401774;
        bh=S/UYcjtquDy0CcPqAHpXYiJOsV3eqyYvXDEKlXM21iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQv7R4a3mZ406EO6pURFQa76WFYgyVbt2fVavv3rgT1EnT417IuWLDLaoKHs0w5GV
         NfaCm2tNhagPlsPr8XTjsi30XrTZwi86VmxxzNtjfqkatJacDmI8Hp+JtjDJgqugSi
         0YHK/6IiJ0E8+J78GqA6kHGS0Yj5+WhaOSdMLXmU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 024/219] ARM: dts: Fix hsi gdd range for omap4
Date:   Fri, 22 Nov 2019 00:45:56 -0500
Message-Id: <20191122054911.1750-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit e9e685480b74aef3f3d0967dadb52eea3ff625d2 ]

While reviewing the missing mcasp ranges I noticed omap4 hsi range
for gdd is wrong so let's fix it.

I'm not aware of any omap4 devices in mainline kernel though that use
hsi though.

Fixes: 84badc5ec5fc ("ARM: dts: omap4: Move l4 child devices to probe
them with ti-sysc")
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap4-l4.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-l4.dtsi b/arch/arm/boot/dts/omap4-l4.dtsi
index 6eb26b837446c..5059ecac44787 100644
--- a/arch/arm/boot/dts/omap4-l4.dtsi
+++ b/arch/arm/boot/dts/omap4-l4.dtsi
@@ -196,12 +196,12 @@
 			clock-names = "fck";
 			#address-cells = <1>;
 			#size-cells = <1>;
-			ranges = <0x0 0x58000 0x4000>;
+			ranges = <0x0 0x58000 0x5000>;
 
 			hsi: hsi@0 {
 				compatible = "ti,omap4-hsi";
 				reg = <0x0 0x4000>,
-				      <0x4a05c000 0x1000>;
+				      <0x5000 0x1000>;
 				reg-names = "sys", "gdd";
 
 				clocks = <&l3_init_clkctrl OMAP4_HSI_CLKCTRL 0>;
-- 
2.20.1

