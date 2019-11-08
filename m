Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1EAAF4A23
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389040AbfKHLkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:40:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:53878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389015AbfKHLkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7DC5222CD;
        Fri,  8 Nov 2019 11:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213251;
        bh=a8iXu8RnT4u8d3wUf+Xu8tDfl5Vhe4ENrPCED6Q5Btk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8+43vhvCSyTkqgzyBHReF05H+Ezkcwl4m4l5SG/PJ9sdi/WDDfcavTJTNJrYunYW
         1tXyH5Brrru/jMgg11VkZjN/xyqv+ZMeZJiphrtcP/Zv7dCs7sVTIRgnDtRAoBPvIQ
         c+gQstsel3rz4j9xRvJy5ZcW7Sux9Wgg4GhIyms8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vicente Bergas <vicencb@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 117/205] arm64: dts: rockchip: Fix VCC5V0_HOST_EN on rk3399-sapphire
Date:   Fri,  8 Nov 2019 06:36:24 -0500
Message-Id: <20191108113752.12502-117-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vicente Bergas <vicencb@gmail.com>

[ Upstream commit bcdb578a5f5b4aea79441606ab7f0a2e076b4474 ]

The pin is GPIO4-D1 not GPIO1-D1, see schematic, page 15 for reference.

Signed-off-by: Vicente Bergas <vicencb@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi
index 36b60791c156d..8b33ef3306820 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi
@@ -116,7 +116,7 @@
 	vcc5v0_host: vcc5v0-host-regulator {
 		compatible = "regulator-fixed";
 		enable-active-high;
-		gpio = <&gpio1 RK_PD1 GPIO_ACTIVE_HIGH>;
+		gpio = <&gpio4 RK_PD1 GPIO_ACTIVE_HIGH>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&vcc5v0_host_en>;
 		regulator-name = "vcc5v0_host";
-- 
2.20.1

