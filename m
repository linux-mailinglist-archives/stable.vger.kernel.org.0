Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7F3F56FAAF
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiGKJVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiGKJUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:20:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E91E545C5;
        Mon, 11 Jul 2022 02:12:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BED10611EA;
        Mon, 11 Jul 2022 09:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80C4C341C0;
        Mon, 11 Jul 2022 09:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530754;
        bh=Yw6CvDlaFnh/HUoADg5MBXYUAT5+p+xm/ldRU9fTv6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfFzf+08JQPY7FlOTw67wuP6tK7FUqUc8EwKgmM2ULzXwXwQ4o6VaoP+UjSxE5soV
         kgGkK/WeAGP0ZeRYyCIfOGW3XD0JEQkPKDtRGq/Se9y/OIiOMsC611RmCna0kBhc6x
         2jvJNw84ai9IXqYeL9+Tfn1RIpGcApL0aVXJ+RgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/55] arm64: dts: imx8mp-evk: correct mmc pad settings
Date:   Mon, 11 Jul 2022 11:07:16 +0200
Message-Id: <20220711090542.595260718@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
References: <20220711090541.764895984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 01785f1f156511c4f285786b4192245d4f476bf1 ]

According to RM bit layout, BIT3 and BIT0 are reserved.
  8  7   6   5   4   3  2 1  0
 PE HYS PUE ODE FSEL X  DSE  X

Not set reserved bit.

Fixes: 9e847693c6f3 ("arm64: dts: freescale: Add i.MX8MP EVK board support")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-evk.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
index c13b4a02d12f..64f0455e14f8 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-evk.dts
@@ -161,7 +161,7 @@
 
 	pinctrl_reg_usdhc2_vmmc: regusdhc2vmmcgrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_SD2_RESET_B__GPIO2_IO19	0x41
+			MX8MP_IOMUXC_SD2_RESET_B__GPIO2_IO19	0x40
 		>;
 	};
 
@@ -180,7 +180,7 @@
 			MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d0
 			MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d0
 			MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d0
-			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc1
+			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT	0xc0
 		>;
 	};
 
@@ -192,7 +192,7 @@
 			MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d4
 			MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d4
 			MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d4
-			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT 0xc1
+			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT 0xc0
 		>;
 	};
 
@@ -204,7 +204,7 @@
 			MX8MP_IOMUXC_SD2_DATA1__USDHC2_DATA1	0x1d6
 			MX8MP_IOMUXC_SD2_DATA2__USDHC2_DATA2	0x1d6
 			MX8MP_IOMUXC_SD2_DATA3__USDHC2_DATA3	0x1d6
-			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT 0xc1
+			MX8MP_IOMUXC_GPIO1_IO04__USDHC2_VSELECT 0xc0
 		>;
 	};
 
-- 
2.35.1



