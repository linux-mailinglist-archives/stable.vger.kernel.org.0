Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0316F6ECE16
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjDXN3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232369AbjDXN2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:28:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2205A65B0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:28:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAD2661F10
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9FAC433EF;
        Mon, 24 Apr 2023 13:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342922;
        bh=kPloWq5A06YkRwk68lZriilTQTimsbYwliNvFvrFVu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbZk66pNAj6P1KAzuYrBwq/NJBEW08rRO9D+SWPh+g8yoqVzZb/bQNI8LU8MoY453
         8B2H+Sw2oOdRcm7bbQ/q0/5/EglzzotZV1CsHiyLksRAXXGaoJTcwB6Pjsjy/8fXAl
         AvaYq5p4iQE9DUEiBX63yKST8VZDqUHDdZYVOtJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peng Fan <peng.fan@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 010/110] arm64: dts: imx8mm-verdin: correct off-on-delay
Date:   Mon, 24 Apr 2023 15:16:32 +0200
Message-Id: <20230424131136.507515940@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 130c1f4306d56301216baaea68afdd909892c73f ]

The property should be off-on-delay-us, not off-on-delay

Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
index 702d87621bb43..1381b9ce3d5ee 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -95,7 +95,7 @@
 		compatible = "regulator-fixed";
 		enable-active-high;
 		gpio = <&gpio2 20 GPIO_ACTIVE_HIGH>; /* PMIC_EN_ETH */
-		off-on-delay = <500000>;
+		off-on-delay-us = <500000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_reg_eth>;
 		regulator-always-on;
@@ -135,7 +135,7 @@
 		enable-active-high;
 		/* Verdin SD_1_PWR_EN (SODIMM 76) */
 		gpio = <&gpio3 5 GPIO_ACTIVE_HIGH>;
-		off-on-delay = <100000>;
+		off-on-delay-us = <100000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_usdhc2_pwr_en>;
 		regulator-max-microvolt = <3300000>;
-- 
2.39.2



