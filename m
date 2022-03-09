Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 713024D35CB
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236498AbiCIQfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237464AbiCIQas (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:30:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4EA16DACB;
        Wed,  9 Mar 2022 08:24:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43BEBB81FF7;
        Wed,  9 Mar 2022 16:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A0FC340F3;
        Wed,  9 Mar 2022 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646843042;
        bh=36/+4igTpfhkDAFpcO4bC2t5KUkZCKJICtxetdAfry4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSVEJvHOMHqaPModspSpnDfLEZJHHBH41Q2VIlxGIHIfjsWS6+d6CjJOa0tD02OfH
         CYAQZYygz9+3oNZCAMo3GzNEHMrcNlcUz8srWy9N0dneKh8hc1Z/KCHl6xZNMYEE2z
         4pMl6qHbB15+AmVXciwYlKXN2MJLyonwkrhIBSAt9monD/C05R0x78HQoW01A/kSxQ
         KOPRWhl1QOrnpnY2b3TcnEBekuAQABNtG2uqxID7iFGin7Guinp1I+SnXcHMnGQbuk
         K6+Vg9tOXfwxWL4tdzPoOYYfExZBH9GCRHIDAOScjV1MYt51u/0Rhfk8nAmTvMyTql
         BEO5LRAWsk5iw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinh Nguyen <dinguyen@kernel.org>, Sasha Levin <sashal@kernel.org>,
        robh+dt@kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/19] arm64: dts: agilex: use the compatible "intel,socfpga-agilex-hsotg"
Date:   Wed,  9 Mar 2022 11:23:22 -0500
Message-Id: <20220309162337.136773-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162337.136773-1-sashal@kernel.org>
References: <20220309162337.136773-1-sashal@kernel.org>
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
index d911d38877e5..19f17bb29e4b 100644
--- a/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
+++ b/arch/arm64/boot/dts/intel/socfpga_agilex.dtsi
@@ -369,7 +369,7 @@ usbphy0: usbphy@0 {
 		};
 
 		usb0: usb@ffb00000 {
-			compatible = "snps,dwc2";
+			compatible = "intel,socfpga-agilex-hsotg", "snps,dwc2";
 			reg = <0xffb00000 0x40000>;
 			interrupts = <0 93 4>;
 			phys = <&usbphy0>;
@@ -381,7 +381,7 @@ usb0: usb@ffb00000 {
 		};
 
 		usb1: usb@ffb40000 {
-			compatible = "snps,dwc2";
+			compatible = "intel,socfpga-agilex-hsotg", "snps,dwc2";
 			reg = <0xffb40000 0x40000>;
 			interrupts = <0 94 4>;
 			phys = <&usbphy0>;
-- 
2.34.1

