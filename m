Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A2856FDC8
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 12:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiGKKAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 06:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234488AbiGKJ7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:59:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F0174E37;
        Mon, 11 Jul 2022 02:27:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4AF26136E;
        Mon, 11 Jul 2022 09:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91A1C34115;
        Mon, 11 Jul 2022 09:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531676;
        bh=eChDofblrc/z9HyIYPzqly3n06khJx7Bm7VoQk/EUFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJpJwCYu8Wu/gnTj6vMXBmTqeT0oOYOGuPwSlAWoVax/N3lcwPFAkz/rqKKmJuom+
         vlAybCSZcHqgcTD1MeEPgv5Qbi+KwlTgwYfi/+64a7vAyMxUQ7pb2mcFr93IM/udv2
         +GJXHpiqufwYtjs798lB+LyaLFRElZkoq5U+3ZNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 192/230] arm64: dts: imx8mp-phyboard-pollux-rdk: correct uart pad settings
Date:   Mon, 11 Jul 2022 11:07:28 +0200
Message-Id: <20220711090609.552212460@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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



