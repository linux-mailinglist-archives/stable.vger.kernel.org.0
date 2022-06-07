Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9D05414E1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358905AbiFGUXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359269AbiFGUWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:22:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FC117CCA5;
        Tue,  7 Jun 2022 11:31:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 774BD61553;
        Tue,  7 Jun 2022 18:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858BAC341CA;
        Tue,  7 Jun 2022 18:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626712;
        bh=THnhl6EqQFhS3geuRLyG54hpkwuwb34QL3RX6SGZLlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZcq+gm2NlmZ0Kmj4zThaUFpWA0NUWje8kWR1RMhYBhNyWQzQGEsHkmdOj2yQ72Fu
         KHNzIlqhkzjR97Z+d+38XrBTHlONWRqvck+GYV2sNE7HrNGAf5tJrnnAuw3LWzTORj
         hxkD702eLXyjhZUefeWWkveVTRPYY1bIYhf6Imy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Max Krummenacher <max.krummenacher@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 470/772] ARM: dts: imx6dl-colibri: Fix I2C pinmuxing
Date:   Tue,  7 Jun 2022 19:01:02 +0200
Message-Id: <20220607165002.847331484@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Max Krummenacher <max.krummenacher@toradex.com>

[ Upstream commit 5f5c579a34a87117c20b411df583ae816c1ec84f ]

Fix names of extra pingroup node and property for gpio bus recovery.
Without the change i2c2 is not functional.

Fixes: 56f0df6b6b58 ("ARM: dts: imx*(colibri|apalis): add missing recovery modes to i2c")
Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-colibri.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-colibri.dtsi b/arch/arm/boot/dts/imx6qdl-colibri.dtsi
index 4e2a309c93fa..1e86b3814708 100644
--- a/arch/arm/boot/dts/imx6qdl-colibri.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-colibri.dtsi
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+ OR MIT
 /*
- * Copyright 2014-2020 Toradex
+ * Copyright 2014-2022 Toradex
  * Copyright 2012 Freescale Semiconductor, Inc.
  * Copyright 2011 Linaro Ltd.
  */
@@ -132,7 +132,7 @@
 	clock-frequency = <100000>;
 	pinctrl-names = "default", "gpio";
 	pinctrl-0 = <&pinctrl_i2c2>;
-	pinctrl-0 = <&pinctrl_i2c2_gpio>;
+	pinctrl-1 = <&pinctrl_i2c2_gpio>;
 	scl-gpios = <&gpio2 30 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 	sda-gpios = <&gpio3 16 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 	status = "okay";
@@ -488,7 +488,7 @@
 		>;
 	};
 
-	pinctrl_i2c2_gpio: i2c2grp {
+	pinctrl_i2c2_gpio: i2c2gpiogrp {
 		fsl,pins = <
 			MX6QDL_PAD_EIM_EB2__GPIO2_IO30 0x4001b8b1
 			MX6QDL_PAD_EIM_D16__GPIO3_IO16 0x4001b8b1
-- 
2.35.1



