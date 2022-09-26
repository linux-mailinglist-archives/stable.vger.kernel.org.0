Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C925EA57E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238974AbiIZMG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239174AbiIZMCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:02:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12577C30A;
        Mon, 26 Sep 2022 03:53:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7E1160C56;
        Mon, 26 Sep 2022 10:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB28C43470;
        Mon, 26 Sep 2022 10:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189119;
        bh=oi9YcisUecQI4iYkSf9P0Q/7KofFYtJRWLWhXsZagAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7Yk0HDHcnEHO8vom1CNHV0xXxSt2Co4i25+krbNxLL2cv/OLLwgUok7FTeov9hFJ
         V+FTwRLU8XiI/OXqCndY/UIDW6kXbzl+/OQlLts2siA/PESC8GyPPFOBuwzJC1FTOI
         oyeeiB67qq3R3cauWFkMJNNH56bc49s0XKv8rFBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 080/207] arm64: dts: imx8ulp: add #reset-cells for pcc
Date:   Mon, 26 Sep 2022 12:11:09 +0200
Message-Id: <20220926100810.162682338@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 5fa383a25fd8a16a73485c90da4e3e33a78b45cf ]

The binding file clock/imx8ulp-pcc-clock.yaml indicates '#reset-cells'
is a required property, add it.

Fixes: fe6291e96313 ("arm64: dts: imx8ulp: Add the basic dtsi file for imx8ulp")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8ulp.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8ulp.dtsi b/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
index 09f7364dd1d0..1cd389b1b95d 100644
--- a/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
@@ -172,6 +172,7 @@ pcc3: clock-controller@292d0000 {
 				compatible = "fsl,imx8ulp-pcc3";
 				reg = <0x292d0000 0x10000>;
 				#clock-cells = <1>;
+				#reset-cells = <1>;
 			};
 
 			tpm5: tpm@29340000 {
@@ -270,6 +271,7 @@ pcc4: clock-controller@29800000 {
 				compatible = "fsl,imx8ulp-pcc4";
 				reg = <0x29800000 0x10000>;
 				#clock-cells = <1>;
+				#reset-cells = <1>;
 			};
 
 			lpi2c6: i2c@29840000 {
@@ -414,6 +416,7 @@ pcc5: clock-controller@2da70000 {
 				compatible = "fsl,imx8ulp-pcc5";
 				reg = <0x2da70000 0x10000>;
 				#clock-cells = <1>;
+				#reset-cells = <1>;
 			};
 		};
 
-- 
2.35.1



