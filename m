Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0685B6FA8
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbiIMOQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbiIMOP4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:15:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98BF461D8B;
        Tue, 13 Sep 2022 07:11:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1ED5614B3;
        Tue, 13 Sep 2022 14:10:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD56BC433C1;
        Tue, 13 Sep 2022 14:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078249;
        bh=qfxAm9p8nOOG7d4xhx3T0QX4S+N+glFND1b2ti4REo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Klpuir033fd10J5jzNgenxb5t1HOutxOtt+6gL8MDZKnPAqytRjKnPNvUT4u0bYGd
         XBYkXK5t30B9v90O0wKGlD4ZJxQeD4Ir8pPR5SjK+S4CT9mTudQgwhg//QhC4edkQ3
         YVW3mNAKToOJaEoEfDYgsla9TTpHDqYxBpiozp/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 067/192] arm64: dts: imx8mm-verdin: update CAN clock to 40MHz
Date:   Tue, 13 Sep 2022 16:02:53 +0200
Message-Id: <20220913140413.303366040@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>

[ Upstream commit be1e3dfecf7d2fbcb4a45b113da637983878246c ]

Update SPI CAN controller clock to match current hardware design.

Signed-off-by: Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
Acked-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
index eafa88d980b32..2841c6bfe3a92 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -32,10 +32,10 @@
 	};
 
 	/* Fixed clock dedicated to SPI CAN controller */
-	clk20m: oscillator {
+	clk40m: oscillator {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
-		clock-frequency = <20000000>;
+		clock-frequency = <40000000>;
 	};
 
 	gpio-keys {
@@ -194,7 +194,7 @@
 
 	can1: can@0 {
 		compatible = "microchip,mcp251xfd";
-		clocks = <&clk20m>;
+		clocks = <&clk40m>;
 		interrupts-extended = <&gpio1 6 IRQ_TYPE_EDGE_FALLING>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_can1_int>;
-- 
2.35.1



