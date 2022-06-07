Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01293540CCC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242489AbiFGSlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351738AbiFGSjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:39:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9CD18484D;
        Tue,  7 Jun 2022 10:58:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FDD3617A7;
        Tue,  7 Jun 2022 17:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D48AC34119;
        Tue,  7 Jun 2022 17:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624698;
        bh=2jA/GTMKTJHBY2Oc4pOOiy4bZGaqPB82S9nyCCUHw2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9ZvgkFRs15gHm+zASOewDHlcIe/4ugLPehS2on8G0VTqWNrCmK4wNVWLV7wkGtHA
         FOI++PMNesy0Vc87lwE7Q6o90r27sRwZihdAbZaFcNMSXMDHpQ57An9g2xRb2rHGeg
         UkM8PgsCzkOZQPHSSm29S2nONCcZD6QExAX5tGH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thorsten Scherer <t.scherer@eckelmann.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 394/667] ARM: dts: ci4x10: Adapt to changes in imx6qdl.dtsi regarding fec clocks
Date:   Tue,  7 Jun 2022 19:00:59 +0200
Message-Id: <20220607164946.562434947@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thorsten Scherer <t.scherer@eckelmann.de>

[ Upstream commit 3d397a1277853498e8b7b305f2610881357c033f ]

Commit f3e7dae323ab ("ARM: dts: imx6qdl: add enet_out clk
support") added another item to the list of clocks for the fec
device. As imx6dl-eckelmann-ci4x10.dts only overwrites clocks,
but not clock-names this resulted in an inconsistency with
clocks having one item more than clock-names.

Also overwrite clock-names with the same value as in
imx6qdl.dtsi. This is a no-op today, but prevents similar
inconsistencies if the soc file will be changed in a similar way
in the future.

Signed-off-by: Thorsten Scherer <t.scherer@eckelmann.de>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Fixes: f3e7dae323ab ("ARM: dts: imx6qdl: add enet_out clk support")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6dl-eckelmann-ci4x10.dts | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6dl-eckelmann-ci4x10.dts b/arch/arm/boot/dts/imx6dl-eckelmann-ci4x10.dts
index b4a9523e325b..864dc5018451 100644
--- a/arch/arm/boot/dts/imx6dl-eckelmann-ci4x10.dts
+++ b/arch/arm/boot/dts/imx6dl-eckelmann-ci4x10.dts
@@ -297,7 +297,11 @@
 	phy-mode = "rmii";
 	phy-reset-gpios = <&gpio1 18 GPIO_ACTIVE_LOW>;
 	phy-handle = <&phy>;
-	clocks = <&clks IMX6QDL_CLK_ENET>, <&clks IMX6QDL_CLK_ENET>, <&rmii_clk>;
+	clocks = <&clks IMX6QDL_CLK_ENET>,
+		 <&clks IMX6QDL_CLK_ENET>,
+		 <&rmii_clk>,
+		 <&clks IMX6QDL_CLK_ENET_REF>;
+	clock-names = "ipg", "ahb", "ptp", "enet_out";
 	status = "okay";
 
 	mdio {
-- 
2.35.1



