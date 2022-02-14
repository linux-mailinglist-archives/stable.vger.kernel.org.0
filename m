Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10AB64B4A03
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbiBNKEr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:04:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344798AbiBNKEK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:04:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A7443AF3;
        Mon, 14 Feb 2022 01:48:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0EB16126B;
        Mon, 14 Feb 2022 09:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE17C340E9;
        Mon, 14 Feb 2022 09:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832133;
        bh=On09NtlxisAFDWKGqSyeGfJb1Y/OGiixVGVkNghruI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgpiZS6/wCnUiTwrhuWInUStNCJaF7wX+bOR5b+vfJNUUuQuaXli1CJM91W7G7NnJ
         deGlf4LxuOlYj/lKH77UHd/Ijc09Hd/jd1/sKHAmb81PYuhmhX9Kexn5qXIy4Jn+Vh
         4N9MGyY89mHA2ElgtbGe2Y+YxZ1bRzFLAU2YVMKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/172] ARM: dts: imx7ulp: Fix assigned-clocks-parents typo
Date:   Mon, 14 Feb 2022 10:25:47 +0100
Message-Id: <20220214092509.481822737@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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



