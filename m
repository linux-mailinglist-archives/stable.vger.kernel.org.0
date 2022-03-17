Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062194DC71D
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiCQM4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbiCQM4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:56:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFD2E6C43;
        Thu, 17 Mar 2022 05:54:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1612C6157E;
        Thu, 17 Mar 2022 12:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A364C340E9;
        Thu, 17 Mar 2022 12:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521656;
        bh=ZfN1xncFxQf811d6fskGB28xJbXGUg/Vxmh4O5Hkydc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mlmF19uT/nwPBdx2YSVfpHjKlWGQCBowUzz9/3pZsQFpGV2YhibgxshxFXsnnLlwU
         daqOGuxhASuiitY84efbUfxOSWRUWSuuSRuoo0+CKM7OCF2vY/0xVYb0MryGe4o9U6
         GoxyOfrJqiN2bLpv6TXhDgLdXAzDp17l5gfvzP2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 09/28] arm64: dts: agilex: use the compatible "intel,socfpga-agilex-hsotg"
Date:   Thu, 17 Mar 2022 13:46:00 +0100
Message-Id: <20220317124527.035775085@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
References: <20220317124526.768423926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 0dd2d2ee765a..f4270cf18996 100644
--- a/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
@@ -502,7 +502,7 @@
 		};
 
 		usb0: usb@ffb00000 {
-			compatible = "snps,dwc2";
+			compatible = "intel,socfpga-agilex-hsotg", "snps,dwc2";
 			reg = <0xffb00000 0x40000>;
 			interrupts = <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&usbphy0>;
@@ -515,7 +515,7 @@
 		};
 
 		usb1: usb@ffb40000 {
-			compatible = "snps,dwc2";
+			compatible = "intel,socfpga-agilex-hsotg", "snps,dwc2";
 			reg = <0xffb40000 0x40000>;
 			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
 			phys = <&usbphy0>;
-- 
2.34.1



