Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5F8593CDE
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344948AbiHOUdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347733AbiHOUbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:31:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52282A61D5;
        Mon, 15 Aug 2022 12:04:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AD96612B7;
        Mon, 15 Aug 2022 19:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152DBC433D7;
        Mon, 15 Aug 2022 19:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590294;
        bh=VYfBlipzcVbhm4a67MWNtWYnwO8/NK7weJw/0ZKExAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4orDkO/ZRRYtwfjo2Nd+97vVF4zyY/xWUF8udH9IGvVwjaAEtP2c/xHxvaLez5cN
         Ypm5aiLJ2hZCqAZqNO5VI90ARWoTdZZu7rv6wN+PsCVkIP6tsclX2LkzzSjzUHgQE+
         U9FuvtpGpVkJXDWh4xT7LzjSz3394UV9SOLok+P8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Max Krummenacher <max.krummenacher@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0197/1095] Revert "ARM: dts: imx6qdl-apalis: Avoid underscore in node name"
Date:   Mon, 15 Aug 2022 19:53:16 +0200
Message-Id: <20220815180437.778617589@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Krummenacher <max.krummenacher@toradex.com>

[ Upstream commit 9c0919acb3fa7c1a24e384ff912f2d88f060c373 ]

The STMPE MFD device binding requires the child node to have a fixed
name, i.e. with '_', not '-'. Otherwise the stmpe_adc, stmpe_touchscreen
drivers will not be probed.

Fixes: 56086b5e804f ("ARM: dts: imx6qdl-apalis: Avoid underscore in node name")
Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-apalis.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-apalis.dtsi b/arch/arm/boot/dts/imx6qdl-apalis.dtsi
index bd763bae596b..da919d0544a8 100644
--- a/arch/arm/boot/dts/imx6qdl-apalis.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-apalis.dtsi
@@ -315,7 +315,7 @@ stmpe811@41 {
 		/* ADC conversion time: 80 clocks */
 		st,sample-time = <4>;
 
-		stmpe_touchscreen: stmpe-touchscreen {
+		stmpe_touchscreen: stmpe_touchscreen {
 			compatible = "st,stmpe-ts";
 			/* 8 sample average control */
 			st,ave-ctrl = <3>;
@@ -332,7 +332,7 @@ stmpe_touchscreen: stmpe-touchscreen {
 			st,touch-det-delay = <5>;
 		};
 
-		stmpe_adc: stmpe-adc {
+		stmpe_adc: stmpe_adc {
 			compatible = "st,stmpe-adc";
 			/* forbid to use ADC channels 3-0 (touch) */
 			st,norequest-mask = <0x0F>;
-- 
2.35.1



