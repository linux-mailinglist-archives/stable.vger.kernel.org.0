Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7C94F3BC7
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244940AbiDEMB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357933AbiDEK13 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30288EB76;
        Tue,  5 Apr 2022 03:11:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6FB2B81B7A;
        Tue,  5 Apr 2022 10:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CBD6C385A0;
        Tue,  5 Apr 2022 10:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153479;
        bh=TSkjUvSIf7iqr5LKRP7s/684quQnt42SIhJS2ZaWp8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B3lcp7DNnHaYkTroSGl85J8O3IPh3a8x1g+sqknYKkoeXGKnxR040g0H8wNqMFFax
         eZgaGpiJNOT7Jtj+ST7ST6io0HDAzz6dNHIkCmP9J0UGgq1ILBDRHlI9dkSPwyC0le
         tYRjn1CYTkZvwZYm8mUydhMKPA9lBKVd+7yygHbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/599] arm64: dts: rockchip: Fix SDIO regulator supply properties on rk3399-firefly
Date:   Tue,  5 Apr 2022 09:28:49 +0200
Message-Id: <20220405070305.833345505@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Rob Herring <robh@kernel.org>

[ Upstream commit 37cbd3c522869247ed4525b5042ff4c6a276c813 ]

A label reference without brackets is a path string, not a phandle as
intended. Add the missing brackets.

Fixes: a5002c41c383 ("arm64: dts: rockchip: add WiFi module support for Firefly-RK3399")
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220304202559.317749-1-robh@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-firefly.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
index 6db18808b9c5..dc45ec372ada 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
@@ -665,8 +665,8 @@
 	sd-uhs-sdr104;
 
 	/* Power supply */
-	vqmmc-supply = &vcc1v8_s3;	/* IO line */
-	vmmc-supply = &vcc_sdio;	/* card's power */
+	vqmmc-supply = <&vcc1v8_s3>;	/* IO line */
+	vmmc-supply = <&vcc_sdio>;	/* card's power */
 
 	#address-cells = <1>;
 	#size-cells = <0>;
-- 
2.34.1



