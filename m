Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BD36AF305
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbjCGS66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbjCGS6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:58:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE1CAD030
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:45:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A866B819D5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1203C433D2;
        Tue,  7 Mar 2023 18:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214712;
        bh=cFV60SkEvHVpsIwdkGAuYWg9mK1dXn4zdnyELwZyc28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Orz0COm2kr14DpUAq+6TtPKHXEQLKweEZhJD8ZYFMSMKSEhxFlBYAAj0Q0hr9xA86
         RUlkT4J4/3hr9VL2RT7XFOgKnybf81cH/fy5HhtUi3LjLbZG1jMpq92+VrrKCBPiA8
         jyron14lfw7gBZ5s785AZCuEDgIYiHPFsU2IbNRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Peng Fan <peng.fan@nxp.com>,
        Marek Vasut <marex@denx.de>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 009/567] arm64: dts: imx8m: Align SoC unique ID node unit address
Date:   Tue,  7 Mar 2023 17:55:45 +0100
Message-Id: <20230307165906.235008271@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit ee0d68f219be8618f53d3f8808952e20525e3f30 ]

Align the SoC unique ID DT node unit address with its reg property.

Reviewed-by: Peng Fan <peng.fan@nxp.com>
Fixes: cbff23797fa1 ("arm64: dts: imx8m: add NVMEM provider and consumer to read soc unique ID")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm.dtsi | 2 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi | 2 +-
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 2 +-
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index 67e91fdfaf526..2a67122c5624c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -530,7 +530,7 @@ ocotp: efuse@30350000 {
 				#address-cells = <1>;
 				#size-cells = <1>;
 
-				imx8mm_uid: unique-id@410 {
+				imx8mm_uid: unique-id@4 {
 					reg = <0x4 0x8>;
 				};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index 6dcead5bae620..0c47ff2426410 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -533,7 +533,7 @@ ocotp: efuse@30350000 {
 				#address-cells = <1>;
 				#size-cells = <1>;
 
-				imx8mn_uid: unique-id@410 {
+				imx8mn_uid: unique-id@4 {
 					reg = <0x4 0x8>;
 				};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 664177ed38d3e..ab670b5d641b1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -358,7 +358,7 @@ ocotp: efuse@30350000 {
 				#address-cells = <1>;
 				#size-cells = <1>;
 
-				imx8mp_uid: unique-id@420 {
+				imx8mp_uid: unique-id@8 {
 					reg = <0x8 0x8>;
 				};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index fd38092bb247e..2a698c5b87bcd 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -557,7 +557,7 @@ ocotp: efuse@30350000 {
 				#address-cells = <1>;
 				#size-cells = <1>;
 
-				imx8mq_uid: soc-uid@410 {
+				imx8mq_uid: soc-uid@4 {
 					reg = <0x4 0x8>;
 				};
 
-- 
2.39.2



