Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E3F5FB6E1
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 17:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbiJKPWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 11:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbiJKPWP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 11:22:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2385B120EFF;
        Tue, 11 Oct 2022 08:13:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57701611F3;
        Tue, 11 Oct 2022 14:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB49C433C1;
        Tue, 11 Oct 2022 14:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665500071;
        bh=/iqkabe4/Udc0EeO9w2yGyjZaD+6E56McrBeuyFxdgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWsrKP32uMqEJtss4Y157ovzbvsGIg9WlVmWviiicOY0ERc7NStiuETaMXAYchyvV
         mURE+aVTOnjn/uhfDduPs69TUJndGdo39UAwjtrMDQhb+uxVviPjODTHJuW3aqNx+q
         Bf9k6M0k8ApydJJ267nfmg46w+TvJzrLSWHnkYzFVt7aknJbskY8NBMIyDjwQp//Ne
         shMV8zRKGlLKWbuViIPfO5Wn5wEOI6OOhz9jSppvEWxcJDlaXcE15mRudlBRReGIBK
         uCbL2NZGGaffFRalmQ6jIVBSN2CWeObHRTZPrTAjuvmne8EeRRUeBSYRHl+SqVRngN
         qeoZ67urtl4Lw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.9 4/6] ARM: dts: imx6qp: add missing properties for sram
Date:   Tue, 11 Oct 2022 10:54:23 -0400
Message-Id: <20221011145425.1625494-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145425.1625494-1-sashal@kernel.org>
References: <20221011145425.1625494-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 088fe5237435ee2f7ed4450519b2ef58b94c832f ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@940000: '#address-cells' is a required property
sram@940000: '#size-cells' is a required property
sram@940000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qp.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qp.dtsi b/arch/arm/boot/dts/imx6qp.dtsi
index 886dbf2eca49..711ab061c81d 100644
--- a/arch/arm/boot/dts/imx6qp.dtsi
+++ b/arch/arm/boot/dts/imx6qp.dtsi
@@ -47,12 +47,18 @@ soc {
 		ocram2: sram@00940000 {
 			compatible = "mmio-sram";
 			reg = <0x00940000 0x20000>;
+			ranges = <0 0x00940000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
 		ocram3: sram@00960000 {
 			compatible = "mmio-sram";
 			reg = <0x00960000 0x20000>;
+			ranges = <0 0x00960000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6QDL_CLK_OCRAM>;
 		};
 
-- 
2.35.1

