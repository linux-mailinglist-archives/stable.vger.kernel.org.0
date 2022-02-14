Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0B44B4A7F
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347772AbiBNKbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:31:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347199AbiBNKaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:30:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C78996B2;
        Mon, 14 Feb 2022 01:59:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6223360B33;
        Mon, 14 Feb 2022 09:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D530C340E9;
        Mon, 14 Feb 2022 09:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832727;
        bh=On09NtlxisAFDWKGqSyeGfJb1Y/OGiixVGVkNghruI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIcDj53V3AOpUzy9vwSDWs6dIXb0H8gD6Jx0OjJzMjBhrrFxBXXWARp/nl+zLBwnl
         WbiFaySZ9FpvK4NCgtkma/6p70JsPiJjlnX2+RGQGg+hcoCPt++Qn3BZZGc7/Ue8GB
         rz95v/+wcqfJrDRT1KsJ0j1eS2IT07ScAlOQsyzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 104/203] ARM: dts: imx7ulp: Fix assigned-clocks-parents typo
Date:   Mon, 14 Feb 2022 10:25:48 +0100
Message-Id: <20220214092513.781966778@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 6d58c5e21a3fe355ce6d1808e96d02a610265218 ]

The correct property name is 'assigned-clock-parents', not
'assigned-clocks-parents'. Though if the platform works with the typo, one
has to wonder if the property is even needed.

Signed-off-by: Rob Herring <robh@kernel.org>
Fixes: 8b8c7d97e2c7 ("ARM: dts: imx7ulp: Add wdog1 node")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7ulp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7ulp.dtsi b/arch/arm/boot/dts/imx7ulp.dtsi
index b7ea37ad4e55c..bcec98b964114 100644
--- a/arch/arm/boot/dts/imx7ulp.dtsi
+++ b/arch/arm/boot/dts/imx7ulp.dtsi
@@ -259,7 +259,7 @@ wdog1: watchdog@403d0000 {
 			interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&pcc2 IMX7ULP_CLK_WDG1>;
 			assigned-clocks = <&pcc2 IMX7ULP_CLK_WDG1>;
-			assigned-clocks-parents = <&scg1 IMX7ULP_CLK_FIRC_BUS_CLK>;
+			assigned-clock-parents = <&scg1 IMX7ULP_CLK_FIRC_BUS_CLK>;
 			timeout-sec = <40>;
 		};
 
-- 
2.34.1



