Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D895D51A90D
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356539AbiEDRNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356195AbiEDRL1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:11:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567794B410;
        Wed,  4 May 2022 09:57:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1539B827A1;
        Wed,  4 May 2022 16:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97253C385A5;
        Wed,  4 May 2022 16:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683448;
        bh=EhPme3Fm74FYoNwPGq+P4J38yUvRFTbwq3ETX9RbL5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvsDsZZLpztMB7CN1LMWcLJT9g68fowUfQ64oi8UsCnnMaT5l7biQv0DOByHFzYYy
         zqhBzPM6s7PX0723N1bG+tF6YOjN3MtXJ3kl4CMH0CrRBdWBv+gkY84qiweiNIrPiS
         92aXKIh8vnaT9MDGOPjkzKPRnT0cqMos/wHvk42Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 111/225] arm64: dts: imx8mn-ddr4-evk: Describe the 32.768 kHz PMIC clock
Date:   Wed,  4 May 2022 18:45:49 +0200
Message-Id: <20220504153120.503966212@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URI_HEX autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 0310b5aa0656a94102344f1e9ae2892e342a665d ]

The ROHM BD71847 PMIC has a 32.768 kHz clock.

Describe the PMIC clock to fix the following boot errors:

bd718xx-clk bd71847-clk.1.auto: No parent clk found
bd718xx-clk: probe of bd71847-clk.1.auto failed with error -22

Based on the same fix done for imx8mm-evk as per commit
a6a355ede574 ("arm64: dts: imx8mm-evk: Add 32.768 kHz clock to PMIC")

Fixes: 3e44dd09736d ("arm64: dts: imx8mn-ddr4-evk: Add rohm,bd71847 PMIC support")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts b/arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts
index 7dfee715a2c4..d8ce217c6016 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mn-ddr4-evk.dts
@@ -59,6 +59,10 @@ pmic@4b {
 		interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 		rohm,reset-snvs-powered;
 
+		#clock-cells = <0>;
+		clocks = <&osc_32k 0>;
+		clock-output-names = "clk-32k-out";
+
 		regulators {
 			buck1_reg: BUCK1 {
 				regulator-name = "buck1";
-- 
2.35.1



