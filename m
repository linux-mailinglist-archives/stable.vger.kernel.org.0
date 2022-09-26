Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58EC75EA318
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbiIZLTj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237780AbiIZLS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:18:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A9952DE9;
        Mon, 26 Sep 2022 03:38:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEA06B801BF;
        Mon, 26 Sep 2022 10:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136D3C43147;
        Mon, 26 Sep 2022 10:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188611;
        bh=8oRT6RvoMg7THuVshV6qhn0V2DoX726qshBoMBIeeRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSWUNwJNOb6az+MVXToO7AuOTSLypr5vmGlW5sBBXAmm9iLFiENRFq5a8k1Nni4D4
         Ftj4lgBuIxZ+28EzBs7X7l++H660O+XarsVY4H39ElXvmx8cp5rx/sQtdxBjk6t3Xg
         Fe7OVunIAgvolpmhAUIGuEZAYlc7+330yixMPxUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/148] arm64: dts: rockchip: Remove enable-active-low from rk3399-puma
Date:   Mon, 26 Sep 2022 12:11:39 +0200
Message-Id: <20220926100758.485374586@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit a994b34b9abb9c08ee09e835b4027ff2147f9d94 ]

The 'enable-active-low' property is not a valid one.

Only 'enable-active-high' is valid, and when this property is absent
the gpio regulator will act as active low by default.

Remove the invalid 'enable-active-low' property.

Fixes: 2c66fc34e945 ("arm64: dts: rockchip: add RK3399-Q7 (Puma) SoM")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Link: https://lore.kernel.org/r/20220827175140.1696699-1-festevam@denx.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index 08fa00364b42..7b27079fd611 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -62,7 +62,6 @@ vcc3v3_sys: vcc3v3-sys {
 	vcc5v0_host: vcc5v0-host-regulator {
 		compatible = "regulator-fixed";
 		gpio = <&gpio4 RK_PA3 GPIO_ACTIVE_LOW>;
-		enable-active-low;
 		pinctrl-names = "default";
 		pinctrl-0 = <&vcc5v0_host_en>;
 		regulator-name = "vcc5v0_host";
-- 
2.35.1



