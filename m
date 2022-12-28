Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1F6657982
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbiL1PCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233433AbiL1PCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:02:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0730F13DDF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:01:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9898061541
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:01:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B21C433D2;
        Wed, 28 Dec 2022 15:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239704;
        bh=C5LCNxx27JrnHNGcVXG8Z8y7QGx76sJN0z+c5Ri6/5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPniqj/neiOn6kMgJjgKlmJGb/cg3+z0FQ7oya1jkH/SH5rQPV37bCfL+EY/C9Ggk
         jL8HkjGPm5JYTmU6CbRyjsk4vD9NJims4kVvCrkBJrpFBUGQbNaxTI9TegJozF9oWc
         r0ehv8opw30r0fb/9lToUki7fptgAX0lzWK8AFuI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0066/1073] arm64: dts: mt2712-evb: Fix usb vbus regulators unit names
Date:   Wed, 28 Dec 2022 15:27:34 +0100
Message-Id: <20221228144329.881936434@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit ec1ae39a8d25cfb067b5459fac7c5b7b9bce6f6a ]

Update the names to regulator-usb-p{0-3}-vbus to fix unit_address_vs_reg
warnings for those.

Fixes: 1724f4cc5133 ("arm64: dts: Add USB3 related nodes for MT2712")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221013152212.416661-7-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
index 638908773706..d31a194124c9 100644
--- a/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt2712-evb.dts
@@ -50,7 +50,7 @@ extcon_usb1: extcon_iddig1 {
 		id-gpio = <&pio 14 GPIO_ACTIVE_HIGH>;
 	};
 
-	usb_p0_vbus: regulator@2 {
+	usb_p0_vbus: regulator-usb-p0-vbus {
 		compatible = "regulator-fixed";
 		regulator-name = "p0_vbus";
 		regulator-min-microvolt = <5000000>;
@@ -59,7 +59,7 @@ usb_p0_vbus: regulator@2 {
 		enable-active-high;
 	};
 
-	usb_p1_vbus: regulator@3 {
+	usb_p1_vbus: regulator-usb-p1-vbus {
 		compatible = "regulator-fixed";
 		regulator-name = "p1_vbus";
 		regulator-min-microvolt = <5000000>;
@@ -68,7 +68,7 @@ usb_p1_vbus: regulator@3 {
 		enable-active-high;
 	};
 
-	usb_p2_vbus: regulator@4 {
+	usb_p2_vbus: regulator-usb-p2-vbus {
 		compatible = "regulator-fixed";
 		regulator-name = "p2_vbus";
 		regulator-min-microvolt = <5000000>;
@@ -77,7 +77,7 @@ usb_p2_vbus: regulator@4 {
 		enable-active-high;
 	};
 
-	usb_p3_vbus: regulator@5 {
+	usb_p3_vbus: regulator-usb-p3-vbus {
 		compatible = "regulator-fixed";
 		regulator-name = "p3_vbus";
 		regulator-min-microvolt = <5000000>;
-- 
2.35.1



