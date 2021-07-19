Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB683CE3A2
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346369AbhGSPir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:38:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348746AbhGSPf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A357D606A5;
        Mon, 19 Jul 2021 16:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711268;
        bh=qi+xt+vtEw3X9RBwNB1yuBefOGiT7RKxgKto8UtTLFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jac3vbNNM8TOjakufCGrY7aGHE9NEbLr/VxNe4R1//o3StJS/g7BloZyvnm18Qwus
         5ejdHEqRwWpre3VpflXPHdEKtxhAq1pRmnXOcrGtk88s9uEbw1u3Tjwbr6jaO42Fl9
         cfqJCA9e4px/V2Y8CBmQ3S/czh4X9MW9stZwF7AU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Nishanth Menon <nm@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 291/351] arm64: dts: ti: k3-am64-mcu: Fix the compatible string in GPIO DT node
Date:   Mon, 19 Jul 2021 16:53:57 +0200
Message-Id: <20210719144954.665976009@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aswath Govindraju <a-govindraju@ti.com>

[ Upstream commit ec2fb989d03e7f79f7cd901cf9abf40aebba7acf ]

Fix the compatible string in mcu domain GPIO device tree node.

Fixes: 01a91e01b8fd ("arm64: dts: ti: k3-am64: Add GPIO DT nodes")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Reviewed-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210423060133.16473-1-a-govindraju@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am64-mcu.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am64-mcu.dtsi b/arch/arm64/boot/dts/ti/k3-am64-mcu.dtsi
index deb19ae5e168..eaf7edb2ef4d 100644
--- a/arch/arm64/boot/dts/ti/k3-am64-mcu.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64-mcu.dtsi
@@ -87,7 +87,7 @@
 	};
 
 	mcu_gpio0: gpio@4201000 {
-		compatible = "ti,am64-gpio", "keystone-gpio";
+		compatible = "ti,am64-gpio", "ti,keystone-gpio";
 		reg = <0x0 0x4201000 0x0 0x100>;
 		gpio-controller;
 		#gpio-cells = <2>;
-- 
2.30.2



