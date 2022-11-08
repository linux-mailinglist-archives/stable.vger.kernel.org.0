Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC1F621587
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbiKHOM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:12:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbiKHOMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:12:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C86C57B74
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:12:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55882B81AF7
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EB4C433D6;
        Tue,  8 Nov 2022 14:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916752;
        bh=aQf2Dga5L3dlBi888hvxMX1pUWNL5nE4y2ce6Digbko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3aSYOznTcWT1bLW5EFzXDQAnG8Y2zDmaMUhltAWs/zQlLKvMFGaFtBy0E3OnogKb
         gllCUtWTbxUbg+K/7S1KDN2Um3W3wmmX9yw7YwAbMyw40lmetMQc0jAh48WCvFRrpe
         2RN92u389LO1gzbCWKwhX2FUJSrFqMkqCjzRWDHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marek Vasut <marex@denx.de>,
        Fabio Estevam <festevam@denx.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 093/197] arm64: dts: imx8mm: Enable CPLD_Dn pull down resistor on MX8Menlo
Date:   Tue,  8 Nov 2022 14:38:51 +0100
Message-Id: <20221108133359.069805673@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit f23f1a1e8437e38014fe34a2f12e37e861e5bcc7 ]

Enable CPLD_Dn pull down resistor instead of pull up to avoid
intefering with CPLD power off functionality.

Fixes: 510c527b4ff57 ("arm64: dts: imx8mm: Add i.MX8M Mini Toradex Verdin based Menlo board")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/freescale/imx8mm-mx8menlo.dts | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-mx8menlo.dts b/arch/arm64/boot/dts/freescale/imx8mm-mx8menlo.dts
index 32f6f2f50c10..43e89859c044 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-mx8menlo.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-mx8menlo.dts
@@ -250,21 +250,21 @@ MX8MM_IOMUXC_SAI1_RXD1_GPIO4_IO3			0x1c4
 		/* SODIMM 96 */
 		MX8MM_IOMUXC_SAI1_RXD2_GPIO4_IO4			0x1c4
 		/* CPLD_D[7] */
-		MX8MM_IOMUXC_SAI1_RXD3_GPIO4_IO5			0x1c4
+		MX8MM_IOMUXC_SAI1_RXD3_GPIO4_IO5			0x184
 		/* CPLD_D[6] */
-		MX8MM_IOMUXC_SAI1_RXFS_GPIO4_IO0			0x1c4
+		MX8MM_IOMUXC_SAI1_RXFS_GPIO4_IO0			0x184
 		/* CPLD_D[5] */
-		MX8MM_IOMUXC_SAI1_TXC_GPIO4_IO11			0x1c4
+		MX8MM_IOMUXC_SAI1_TXC_GPIO4_IO11			0x184
 		/* CPLD_D[4] */
-		MX8MM_IOMUXC_SAI1_TXD0_GPIO4_IO12			0x1c4
+		MX8MM_IOMUXC_SAI1_TXD0_GPIO4_IO12			0x184
 		/* CPLD_D[3] */
-		MX8MM_IOMUXC_SAI1_TXD1_GPIO4_IO13			0x1c4
+		MX8MM_IOMUXC_SAI1_TXD1_GPIO4_IO13			0x184
 		/* CPLD_D[2] */
-		MX8MM_IOMUXC_SAI1_TXD2_GPIO4_IO14			0x1c4
+		MX8MM_IOMUXC_SAI1_TXD2_GPIO4_IO14			0x184
 		/* CPLD_D[1] */
-		MX8MM_IOMUXC_SAI1_TXD3_GPIO4_IO15			0x1c4
+		MX8MM_IOMUXC_SAI1_TXD3_GPIO4_IO15			0x184
 		/* CPLD_D[0] */
-		MX8MM_IOMUXC_SAI1_TXD4_GPIO4_IO16			0x1c4
+		MX8MM_IOMUXC_SAI1_TXD4_GPIO4_IO16			0x184
 		/* KBD_intK */
 		MX8MM_IOMUXC_SAI2_MCLK_GPIO4_IO27			0x1c4
 		/* DISP_reset */
-- 
2.35.1



