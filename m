Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988CD4D348E
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbiCIQZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238185AbiCIQVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:21:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09F8E39;
        Wed,  9 Mar 2022 08:20:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DDEC61926;
        Wed,  9 Mar 2022 16:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77A2C340EC;
        Wed,  9 Mar 2022 16:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842829;
        bh=G7vomioLKGsnrReJw234jc68lDEtP2SUursbB4wq+/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZlehPZCDq+DzPJqnbcjW9BcjVDS1Q6rqPHpj0FhYjYxIPCr8y5vlxPQnyhSGx6o3j
         L+AkrvlCjJibmd58Ovwodbp20ARJN27PVsb6gyWJc7cwnM1fMSFOMgyI8ZtN7pW3Ec
         aS8NdsR6bSwvEn7jMChsbpIesgCUPwk0VAFQoGMEx5LFAa3D6w6XX9Vh4+9dRRlE11
         qo05Bf170MDiBbEhdOVVEpzCQOaNc33XaE04uk8SAX5KUIuUG+nXzo/Mn5HSTN7Iss
         LFJXVm3WJUp5MDKzH2nNeBaUb10Ytw7+BGhse43Fy2swiPOjBHj8rt/XYeYNy3Qoju
         Y21QtczWI5F/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinh Nguyen <dinguyen@kernel.org>, Sasha Levin <sashal@kernel.org>,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/24] arm64: dts: agilex: use the compatible "intel,socfpga-agilex-hsotg"
Date:   Wed,  9 Mar 2022 11:19:26 -0500
Message-Id: <20220309161946.136122-7-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309161946.136122-1-sashal@kernel.org>
References: <20220309161946.136122-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit 268a491aebc25e6dc7c618903b09ac3a2e8af530 ]

The DWC2 USB controller on the Agilex platform does not support clock
gating, so use the chip specific "intel,socfpga-agilex-hsotg"
compatible.

Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/intel/socfpga_agilex.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi b/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
index 163f33b46e4f..de1e98c99ec5 100644
--- a/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
@@ -502,7 +502,7 @@ uart1: serial@ffc02100 {
 		};
 
 		usb0: usb@ffb00000 {
-			compatible = "snps,dwc2";
+			compatible = "intel,socfpga-agilex-hsotg", "snps,dwc2";
 			reg = <0xffb00000 0x40000>;
 			interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&usbphy0>;
@@ -515,7 +515,7 @@ usb0: usb@ffb00000 {
 		};
 
 		usb1: usb@ffb40000 {
-			compatible = "snps,dwc2";
+			compatible = "intel,socfpga-agilex-hsotg", "snps,dwc2";
 			reg = <0xffb40000 0x40000>;
 			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&usbphy0>;
-- 
2.34.1

