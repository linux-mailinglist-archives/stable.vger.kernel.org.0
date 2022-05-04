Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B709351A79A
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354956AbiEDRGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355884AbiEDREp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E92E49C8D;
        Wed,  4 May 2022 09:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D106AB827A5;
        Wed,  4 May 2022 16:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8D9C385BB;
        Wed,  4 May 2022 16:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683205;
        bh=vZgK6Y9PLhjhFdFkYNeKjuquI8/FQ9aIPBNEBrVREaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ha051dtufBKCLdMXprHQhC1KHgjUlqbakIM9OBq/OSigPtDzyeHKwTOF5SZzDZNNz
         vHjWbzk+HXpo0qWuzdF30lumSajapRtS/PKN7dxExC+Hn8wAC571HKVo5IgwakELNA
         b8d/mVEW4rPeQwZuxGBqY8aYOeMUcNYWcws1xcC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Giraudon <ggiraudon@prism19.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/177] arm64: dts: meson-sm1-bananapi-m5: fix wrong GPIO pin labeling for CON1
Date:   Wed,  4 May 2022 18:44:10 +0200
Message-Id: <20220504153058.119528435@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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

From: Guillaume Giraudon <ggiraudon@prism19.com>

[ Upstream commit 962dd65e575dde950ef0844568edc37cfb39f302 ]

The labels for lines 61 through 84 on the periphs-banks were offset by 2.
2 lines are missing in the BOOT GPIO lines (contains 14, should be 16)
Added 2 empty entries in BOOT to realigned the rest of GPIO labels
to match the Banana Pi M5 schematics.

(Thanks to Neil Armstrong for the heads up on the position of the missing pins)

Fixes: 976e920183e4 ("arm64: dts: meson-sm1: add Banana PI BPI-M5 board dts")
Signed-off-by: Guillaume Giraudon <ggiraudon@prism19.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20220411144427.874-1-ggiraudon@prism19.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
index 5751c48620ed..cadba194b149 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
@@ -437,6 +437,7 @@ &gpio {
 		"",
 		"eMMC_RST#", /* BOOT_12 */
 		"eMMC_DS", /* BOOT_13 */
+		"", "",
 		/* GPIOC */
 		"SD_D0_B", /* GPIOC_0 */
 		"SD_D1_B", /* GPIOC_1 */
-- 
2.35.1



