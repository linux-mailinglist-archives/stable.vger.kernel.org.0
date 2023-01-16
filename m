Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A10466C686
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbjAPQVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbjAPQUa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:20:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB8A23DB5
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:11:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C87161041
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB33C433EF;
        Mon, 16 Jan 2023 16:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885472;
        bh=4pX+dpe7clsBdbNw09wIkJLZV9u4bTUOZ5LKtPTOEt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IiPEzjhFZ9sojgzCzIM6+qIGoXQXUIqWX7Fkm0ekAT3g1pgFEg1jk/J08e7WEnoJH
         JTURXvSpEZAhpzOZaEx76rvNjC+2EV4yA2yBBpcH7UrVg+kcqAxvygkwztlU9pM+f0
         SNc9HU72cbB178iUKP0sNw7P/Fs8qtBgYXPz3FsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/658] arm64: dts: mt2712-evb: Fix usb vbus regulators unit names
Date:   Mon, 16 Jan 2023 16:42:03 +0100
Message-Id: <20230116154911.217509530@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index e141a9d8cb47..45e37aa67ce7 100644
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



