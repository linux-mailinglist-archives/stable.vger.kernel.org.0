Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B9B4D3475
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbiCIQZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238076AbiCIQVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:21:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C44514F2AE;
        Wed,  9 Mar 2022 08:18:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBA4F6195C;
        Wed,  9 Mar 2022 16:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9E0C340E8;
        Wed,  9 Mar 2022 16:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842687;
        bh=fclHap2gJdXZadfVVEDM3T0GfFqI1+iohUkcE0Z6Tsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sm6gi0J/Qo2G2KlGePU+0u+/45r0Kj0FxtJT+eFBW6VOh0moxKpXAVvPSBFJSW3UU
         LZqDqYL0goh1ztkHtnFbdbjUT/A9x54N9vvmzWh4R+cyH/iAr32pA0aCC51Als7R4X
         bE59kN72fqYcS+USKKtH1OJbZ+FroG6RItu/48tYQCcAoa5om/wdwrm5aT67BwZTQa
         GqQ0JhORHqVycONzxfmhagHhgryjjETGUjQwQimZ5yNH9AxmVV57GVHPbtZswIU2sF
         LM7GNuHKB7ZCgF0CnICY3JVs2hyCGcJmxQssFL2ZUQ2KoKFXapp0eZZkY3AtTLxxMO
         hkClaomfeGp6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 09/27] ARM: dts: rockchip: reorder rk322x hmdi clocks
Date:   Wed,  9 Mar 2022 11:16:46 -0500
Message-Id: <20220309161711.135679-9-sashal@kernel.org>
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

[ Upstream commit be4e65bdffab5f588044325117df77dad7e9c45a ]

The binding specifies the clock order to "iahb", "isfr", "cec". Reorder
the clocks accordingly.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20220210142353.3420859-1-s.hauer@pengutronix.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk322x.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/rk322x.dtsi b/arch/arm/boot/dts/rk322x.dtsi
index 8eed9e3a92e9..5868eb512f69 100644
--- a/arch/arm/boot/dts/rk322x.dtsi
+++ b/arch/arm/boot/dts/rk322x.dtsi
@@ -718,8 +718,8 @@ hdmi: hdmi@200a0000 {
 		interrupts = <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
 		assigned-clocks = <&cru SCLK_HDMI_PHY>;
 		assigned-clock-parents = <&hdmi_phy>;
-		clocks = <&cru SCLK_HDMI_HDCP>, <&cru PCLK_HDMI_CTRL>, <&cru SCLK_HDMI_CEC>;
-		clock-names = "isfr", "iahb", "cec";
+		clocks = <&cru PCLK_HDMI_CTRL>, <&cru SCLK_HDMI_HDCP>, <&cru SCLK_HDMI_CEC>;
+		clock-names = "iahb", "isfr", "cec";
 		pinctrl-names = "default";
 		pinctrl-0 = <&hdmii2c_xfer &hdmi_hpd &hdmi_cec>;
 		resets = <&cru SRST_HDMI_P>;
-- 
2.34.1

