Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D51657A2B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbiL1PIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233646AbiL1PI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:08:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4759413DC9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:08:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBF8261541
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC97C433F0;
        Wed, 28 Dec 2022 15:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240105;
        bh=ND+BedeYHZbCMv73VCEgQu6HL1RjoTLG7dn1UPClbsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRX3aPJ8SAHsXugAi7WXci81Opjzs3t5pkjo4pNO8sstNQFys5Wx06Pa1z+LRzIBH
         rIHWnC1lp9/taTKdVqBRmZIKujDoow7eXOYVoWQcDLYn8aXvd3dCpezId1lOYPraEP
         gmpZCFPW2yK2Fwq2vyk0521qDTUTKWyVTvc8rcrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0081/1146] ARM: dts: dove: Fix assigned-addresses for every PCIe Root Port
Date:   Wed, 28 Dec 2022 15:27:00 +0100
Message-Id: <20221228144332.345995072@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit dcc7d8c72b64a479b8017e4332d99179deb8802d ]

BDF of resource in DT assigned-addresses property of Marvell PCIe Root Port
(PCI-to-PCI bridge) should match BDF in address part in that DT node name
as specified resource belongs to Marvell PCIe Root Port itself.

Fixes: 74ecaa403a74 ("ARM: dove: add PCIe controllers to SoC DT")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dove.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 00a36fba2fd2..9aee3cfd3e98 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -139,7 +139,7 @@ pcie0_intc: interrupt-controller {
 			pcie1: pcie@2 {
 				device_type = "pci";
 				status = "disabled";
-				assigned-addresses = <0x82002800 0 0x80000 0 0x2000>;
+				assigned-addresses = <0x82001000 0 0x80000 0 0x2000>;
 				reg = <0x1000 0 0 0 0>;
 				clocks = <&gate_clk 5>;
 				marvell,pcie-port = <1>;
-- 
2.35.1



