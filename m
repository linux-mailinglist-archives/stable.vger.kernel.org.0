Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF6C4DC69E
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbiCQMzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbiCQMyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:54:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046CB1EE8E5;
        Thu, 17 Mar 2022 05:52:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93993614F0;
        Thu, 17 Mar 2022 12:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18E5C340E9;
        Thu, 17 Mar 2022 12:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521538;
        bh=R/C8STymm8ReCkBQLt18z2XcBrbpXSFwqEfZsjQ2/iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUZj78snFCjDuFVcGosogCXj3XRkG8vjKswoSK5JPJ2FrSK+uGU0k9rDLiOwIl94+
         nVb/BpBfjd7SaTHusMffU3DW1iOKTYtJ9nul9XviSVKSxHJzJ1ao5VVNm0oMDo/CzO
         vDTWdbjHAohB3N1p5KXHbCVuOQZmZ1mNAPkyoY4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/25] ARM: dts: rockchip: reorder rk322x hmdi clocks
Date:   Thu, 17 Mar 2022 13:45:56 +0100
Message-Id: <20220317124526.575679406@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124526.308079100@linuxfoundation.org>
References: <20220317124526.308079100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 75af99c76d7e..f31cf1df892b 100644
--- a/arch/arm/boot/dts/rk322x.dtsi
+++ b/arch/arm/boot/dts/rk322x.dtsi
@@ -718,8 +718,8 @@
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



