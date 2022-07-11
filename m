Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37AF56FB7E
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232615AbiGKJbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbiGKJbF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:31:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BF63F326;
        Mon, 11 Jul 2022 02:16:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7FF5B80E7A;
        Mon, 11 Jul 2022 09:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D3AC34115;
        Mon, 11 Jul 2022 09:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531016;
        bh=eChDofblrc/z9HyIYPzqly3n06khJx7Bm7VoQk/EUFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y2xg124P+uh5tqRD4mses5C/p3KSxWCwCoIg8XeDzJ/tNSG+3vhtJ9c+Zub1CsMQE
         hTkNWPih5zfV1YXgS7+AtoIcQ/mGXaQA6m/z0FP2YSSBvIxQkLlGRmCb8BjdgQuWQ6
         YTgyB8+hHxmNxhhGKUz8I9yJUdNRKsqEgTCNP62Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 065/112] arm64: dts: imx8mp-phyboard-pollux-rdk: correct uart pad settings
Date:   Mon, 11 Jul 2022 11:07:05 +0200
Message-Id: <20220711090551.418604348@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
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

[ Upstream commit e266c155bd88e95f9b86379d6b0add6ac6e5452e ]

BIT3 and BIT0 are reserved bits, should not touch.

Fixes: 846f752866bd ("arm64: dts: imx8mp-phyboard-pollux-rdk: Change debug UART")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts b/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts
index 984a6b9ded8d..e34076954897 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-phyboard-pollux-rdk.dts
@@ -156,8 +156,8 @@
 
 	pinctrl_uart1: uart1grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_UART1_RXD__UART1_DCE_RX	0x49
-			MX8MP_IOMUXC_UART1_TXD__UART1_DCE_TX	0x49
+			MX8MP_IOMUXC_UART1_RXD__UART1_DCE_RX	0x40
+			MX8MP_IOMUXC_UART1_TXD__UART1_DCE_TX	0x40
 		>;
 	};
 
-- 
2.35.1



