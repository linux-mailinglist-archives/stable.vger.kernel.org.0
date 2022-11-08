Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52811621566
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbiKHOMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbiKHOLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:11:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6B47721B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:11:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 798ED615B8
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897F8C433C1;
        Tue,  8 Nov 2022 14:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916674;
        bh=h1iURzbfoq0edqJMS4a5XFHmbappEIQyqMCWZ2/kDfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZivSZT7kvsyILMFk6ybQIRHENOX1QB6u/slNecizP07p0L67bv+74ngzfPb0R8ZKH
         7J4AzL5ibgLcWQz7omQI67+qZlar+T1h8i9HVLpiAGXtCVRGeXL9gWxyEm8fdGTZ5G
         wI4hc+2sxatAwXz5db6SNDXT7K3DgEvqLSyTfUNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Jun <jun.li@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 098/197] arm64: dts: imx8mm: remove otg1/2 power domain dependency on hsio
Date:   Tue,  8 Nov 2022 14:38:56 +0100
Message-Id: <20221108133359.316842949@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,TVD_SUBJ_WIPE_DEBT autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Jun <jun.li@nxp.com>

[ Upstream commit e1ec45b9a8127d9d31bb9fc1d802571a2ba8dd89 ]

pgc_otg1/2 are independent power domain of hsio, they for usb phy,
so remove hsio power domain dependency from its node.

Fixes: d39d4bb15310 ("arm64: dts: imx8mm: add GPC node")
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index afb90f59c83c..41204b871f4f 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -674,13 +674,11 @@ pgc_pcie: power-domain@1 {
 					pgc_otg1: power-domain@2 {
 						#power-domain-cells = <0>;
 						reg = <IMX8MM_POWER_DOMAIN_OTG1>;
-						power-domains = <&pgc_hsiomix>;
 					};
 
 					pgc_otg2: power-domain@3 {
 						#power-domain-cells = <0>;
 						reg = <IMX8MM_POWER_DOMAIN_OTG2>;
-						power-domains = <&pgc_hsiomix>;
 					};
 
 					pgc_gpumix: power-domain@4 {
-- 
2.35.1



