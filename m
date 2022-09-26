Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B83EA5EA468
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238152AbiIZLp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238612AbiIZLoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:44:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA37572FDC;
        Mon, 26 Sep 2022 03:46:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28CB7604F5;
        Mon, 26 Sep 2022 10:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0E3C433D6;
        Mon, 26 Sep 2022 10:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189137;
        bh=ye4d7nWt6PaBGVeDnX10up4GLLnV0qxdz5CZ5E2WPSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zTH3O0IuaH/sXDHC+42snR9wHzh35cZSaY+De41T11dYWeQtzMIe4SXGUUbZsUGpS
         YYL9OfYMLYuiPH0OPdC9QGHE+cnzsL8+6qwz4QK6H0c0AEe8m/j/GF6HID1KFiT3JM
         FngxVbDxhiZaKGpwZlrylrBggyIvGz/30FhIbdeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 085/207] arm64: dts: rockchip: Remove enable-active-low from rk3566-quartz64-a
Date:   Mon, 26 Sep 2022 12:11:14 +0200
Message-Id: <20220926100810.389879213@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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

[ Upstream commit ea89926d9690f055fd8da929f6621a760e8e0f14 ]

The 'enable-active-low' property is not a valid one.

Only 'enable-active-high' is valid, and when this property is absent
the gpio regulator will act as active low by default.

Remove the invalid 'enable-active-low' property.

Fixes: b33a22a1e7c4 ("arm64: dts: rockchip: add basic dts for Pine64 Quartz64-A")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Link: https://lore.kernel.org/r/20220827175140.1696699-2-festevam@denx.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts b/arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts
index fa953b736642..fdbfdf3634e4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-quartz64-a.dts
@@ -163,7 +163,6 @@ vcc5v0_usb20_otg: vcc5v0_usb20_otg {
 
 	vcc3v3_sd: vcc3v3_sd {
 		compatible = "regulator-fixed";
-		enable-active-low;
 		gpio = <&gpio0 RK_PA5 GPIO_ACTIVE_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&vcc_sd_h>;
-- 
2.35.1



