Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E3551A885
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356110AbiEDRLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356907AbiEDRJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D66E4707C;
        Wed,  4 May 2022 09:56:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0BE8617DE;
        Wed,  4 May 2022 16:56:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5A4C385AF;
        Wed,  4 May 2022 16:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683383;
        bh=Q4xe/cCPs1I/xcsBu11NvEr+YguYEoIJM0ARX5r5B/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5pLymYeD6Mept3CZ2itaErob+ZFBEnDy4WfFckib1OAOkoAkjGae9cAYtV+t3Y5S
         Xl6Jg7B1R4nUuK+aom4I4pPj9NABfEw6z3QjcOlmcsLZ2Sa1Fn6qHhHz8ttO3X2Eou
         N1UzSbfgo6oQPVDfeKYRBlhiQXIY6lc07l2ICGus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Liu Ying <victor.liu@nxp.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 068/225] arm64: dts: imx8qm: Correct SCU clock controllers compatible property
Date:   Wed,  4 May 2022 18:45:06 +0200
Message-Id: <20220504153117.665187713@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit dd2737fab4a6ce9ba4eb84842bedbd87d55241a6 ]

The fsl,scu.txt dt-binding documentation explicitly mentions
that the compatible string should be either "fsl,imx8qm-clock"
or "fsl,imx8qxp-clock", followed by "fsl,scu-clk".  Also, i.MX8qm
SCU clocks and i.MX8qxp SCU clocks are really not the same, so
we have to set the compatible property according to SoC name.
Let's correct the i.MX8qm clock controller's compatible property
from
"fsl,imx8qxp-clk", "fsl,scu-clk"
to
"fsl,imx8qm-clk", "fsl,scu-clk" .

Fixes: f2180be18a63 ("arm64: dts: imx: add imx8qm common dts file")
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: NXP Linux Team <linux-imx@nxp.com>
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8qm.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8qm.dtsi b/arch/arm64/boot/dts/freescale/imx8qm.dtsi
index 4a7c017b5f31..8fecd54198fb 100644
--- a/arch/arm64/boot/dts/freescale/imx8qm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8qm.dtsi
@@ -193,7 +193,7 @@ pd: imx8qx-pd {
 		};
 
 		clk: clock-controller {
-			compatible = "fsl,imx8qxp-clk", "fsl,scu-clk";
+			compatible = "fsl,imx8qm-clk", "fsl,scu-clk";
 			#clock-cells = <2>;
 		};
 
-- 
2.35.1



