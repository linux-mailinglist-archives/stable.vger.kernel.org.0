Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF7A4D345B
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235769AbiCIQYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238059AbiCIQVP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:21:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAD23DA74;
        Wed,  9 Mar 2022 08:18:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9210DB821FD;
        Wed,  9 Mar 2022 16:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21E0C340E8;
        Wed,  9 Mar 2022 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842679;
        bh=EuN1wgyEf6vW1+LXczXhQttTmxDi9+dEzIba/lpCv9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBce9eVkqWjVyN00ORq1SG2a5k1A6FzJGTJgbstlDdS2iPau8sGJf5o8rN69y8JV2
         WFc8Rn0eJt32/styCONPypv7+M/D4rh7xsTxUu8FkPw774w3n/4yvDE8E3DWKJXANn
         lG1+UXBRJKUUHmWdwFD+pkCQpZQanvDRc/cvH3jvrn/aKG+WsUewbfpSuxbbT94Fo5
         zCQk3TqmJnTmtyZTlAKqAqJyrwtE1oPUERPGsdsR/qZs45qhh472MWIgMyn3S98p9/
         3ipJOAYlJZdW5/2SK+UEWbt9QRMGH1J793KPbJizwk9yoSDm4APgrfg+n7JFKj9t6H
         H3tKbSep2h0iw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        jbx6244@gmail.com, helen.koike@collabora.com,
        dianders@chromium.org, daniel.lezcano@linaro.org,
        zhangqing@rock-chips.com, briannorris@chromium.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 07/27] arm64: dts: rockchip: reorder rk3399 hdmi clocks
Date:   Wed,  9 Mar 2022 11:16:44 -0500
Message-Id: <20220309161711.135679-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161711.135679-1-sashal@kernel.org>
References: <20220309161711.135679-1-sashal@kernel.org>
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
index d3cdf6f42a30..080457a68e3c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1881,10 +1881,10 @@ hdmi: hdmi@ff940000 {
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

