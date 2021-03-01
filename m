Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D08328B5D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240099AbhCASdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:33:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239859AbhCAS0U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:26:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90DF4652EA;
        Mon,  1 Mar 2021 17:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620442;
        bh=q21wqGcKVLQxf7NsfwXZrs01TDvucU5bYi8SLKcX+kM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BF1LAaYsHCo8QmLr9AKhABgkthY//uATsk30/cSI6uYA7/lgQm3kPT3U6yvD7JbKv
         fXJNbb0LHWiapPOLCFt15BCWJDaF/swBT0wUgOUhH4ALlVFgv2M08CgTbmcI5v5CB7
         0crvHtAXv7D7kNFnpRoobYd/KooOZehViud/Rg8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 154/775] arm64: dts: mt8183: Add missing power-domain for pwm0 node
Date:   Mon,  1 Mar 2021 17:05:22 +0100
Message-Id: <20210301161209.264539618@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

[ Upstream commit 2f99fb6e46b0e982bb6ab18b24a08fa318f740ea ]

The MT8183 display PWM device will not work until the associated
power-domain is enabled. Add the power-domain reference to the node
allows the display PWM driver to operate and the backlight turn on.

Fixes: f15722c0fef0 ("arm64: dts: mt8183: Add pwm and backlight node")
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Reviewed-by: Hsin-Yi Wang <hsinyi@chromium.org>
Link: https://lore.kernel.org/r/20210113215723.71966-1-enric.balletbo@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index 9c0073cfad452..64fbba76597c8 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -661,6 +661,7 @@
 			compatible = "mediatek,mt8183-disp-pwm";
 			reg = <0 0x1100e000 0 0x1000>;
 			interrupts = <GIC_SPI 128 IRQ_TYPE_LEVEL_LOW>;
+			power-domains = <&spm MT8183_POWER_DOMAIN_DISP>;
 			#pwm-cells = <2>;
 			clocks = <&topckgen CLK_TOP_MUX_DISP_PWM>,
 					<&infracfg CLK_INFRA_DISP_PWM>;
-- 
2.27.0



