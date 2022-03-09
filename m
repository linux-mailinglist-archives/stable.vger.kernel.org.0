Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FCC4D3815
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbiCIQey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235895AbiCIQ0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:26:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56CE155C1C;
        Wed,  9 Mar 2022 08:22:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62EC2615F1;
        Wed,  9 Mar 2022 16:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5544EC340E8;
        Wed,  9 Mar 2022 16:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842942;
        bh=f+/LjIyPWDuCwlVHkTax26XwIURY3UIYesjueyn5gTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pPbOVTW8OYEvqxPq0KDfS4x+8t6nEpRVJDL/YWZy4x5WB5Hj0D3ACOEg7yY1vViqu
         RiVEWfiTGStuHDUzGWTVCII1tx00eLJe1XLlBKxRuTiGcvzsP89fBI7JhArVpxH7Cy
         KZ40HJR81JRQ6ATXsmuzHtx1mJHwfBH1vPHx8t8N6R67dXfzWUOqUks0bR1aRKD108
         BZ3old2TMlCgJi/wW1QEm3BO/rCXauVwU338AfBVNaV9K6azGVAkVAJN2jr7byYK6+
         /ts7DT69yZ+TMmTqFlFUC3uqloxsEUz1hM9HRG4Bsh/J2jFmZugVIV96dH0+ecw1Dx
         UWAPi9yzJCctw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        jbx6244@gmail.com, helen.koike@collabora.com,
        thierry.reding@gmail.com, punitagrawal@gmail.com,
        knaerzche@gmail.com, briannorris@chromium.org,
        zhangqing@rock-chips.com, daniel.lezcano@linaro.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 04/20] arm64: dts: rockchip: reorder rk3399 hdmi clocks
Date:   Wed,  9 Mar 2022 11:21:42 -0500
Message-Id: <20220309162158.136467-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162158.136467-1-sashal@kernel.org>
References: <20220309162158.136467-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 2e8a8b5955a000cc655f7e368670518cbb77fe58 ]

The binding specifies the clock order to "cec", "grf", "vpll". Reorder
the clocks accordingly.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20220126145549.617165-19-s.hauer@pengutronix.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 4b6065dbba55..52ba4d07e771 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1770,10 +1770,10 @@ hdmi: hdmi@ff940000 {
 		interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH 0>;
 		clocks = <&cru PCLK_HDMI_CTRL>,
 			 <&cru SCLK_HDMI_SFR>,
-			 <&cru PLL_VPLL>,
+			 <&cru SCLK_HDMI_CEC>,
 			 <&cru PCLK_VIO_GRF>,
-			 <&cru SCLK_HDMI_CEC>;
-		clock-names = "iahb", "isfr", "vpll", "grf", "cec";
+			 <&cru PLL_VPLL>;
+		clock-names = "iahb", "isfr", "cec", "grf", "vpll";
 		power-domains = <&power RK3399_PD_HDCP>;
 		reg-io-width = <4>;
 		rockchip,grf = <&grf>;
-- 
2.34.1

