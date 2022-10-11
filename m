Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF2F5FB59E
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiJKO4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiJKOyy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:54:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89FF56DAD1;
        Tue, 11 Oct 2022 07:51:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80A2B611B0;
        Tue, 11 Oct 2022 14:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B19C433D6;
        Tue, 11 Oct 2022 14:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499903;
        bh=PK9pyYValBcm9OunKPNfoo7NdKhgn7VnsG70GI4Y2E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaNbo3kOep6uWjVVWJ4Hinc+PiotGef+VipATicf1ZAtF2gCEsJwOl+qagGCnCTGe
         8xGCpykSGG33ZFVuAopbsEJrqJ9dFjx/+d+VJer8aO/ps7shRC9ysPCr822r1VrDM/
         vLduhq2aSpWtSp5h1dTe8gjNuW+dxCTbPt4LQ7C0PnQ48dz8HiDoPOicc5XrnkfVp9
         qUeen1WjvZ+z6tb9zvCZm5+RAuB9bq+1QjoaumsVjLTpW6jfVtsP/sZ/91RKyaV3J2
         fibdYBteCLASiDFY7K1qDZLQeL+40HCLrMLLoPi912LReGraDbsz5uN8oPX9AR+qzS
         K1dhsqwbUoA8A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.19 09/40] ARM: dts: imx6sl: add missing properties for sram
Date:   Tue, 11 Oct 2022 10:50:58 -0400
Message-Id: <20221011145129.1623487-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145129.1623487-1-sashal@kernel.org>
References: <20221011145129.1623487-1-sashal@kernel.org>
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

[ Upstream commit 60c9213a1d9941a8b33db570796c3f9be8984974 ]

All 3 properties are required by sram.yaml. Fixes the dtbs_check warning:
sram@900000: '#address-cells' is a required property
sram@900000: '#size-cells' is a required property
sram@900000: 'ranges' is a required property

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sl.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index 06a515121dfc..cfd6b4972ae7 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -115,6 +115,9 @@ soc {
 		ocram: sram@900000 {
 			compatible = "mmio-sram";
 			reg = <0x00900000 0x20000>;
+			ranges = <0 0x00900000 0x20000>;
+			#address-cells = <1>;
+			#size-cells = <1>;
 			clocks = <&clks IMX6SL_CLK_OCRAM>;
 		};
 
-- 
2.35.1

