Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EAE6B46D2
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbjCJOrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbjCJOrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:47:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AAC11F62A
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:46:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8218961965
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850D4C433A0;
        Fri, 10 Mar 2023 14:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459592;
        bh=2lTAVfia+nvvMz671qQ0e+zfSUwIXJvwhXYCk6V73n0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0NEjVHkRyim4hxRz006DYVsQnR1HajuR1r5LHHCAHKJMCU7tyP1pqj38795pR9Ajl
         p2hX8L1zaRdKnO+ZwelHMup2Z6iRX3FiUP6UJqcxZFtLdJb9MInmah0eUXfc4tse9L
         14yBAmaGDlkpr4BG471XVJ7T/wgfFaKoIZGcx4Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/529] ARM: dts: exynos: correct wr-active property in Exynos3250 Rinato
Date:   Fri, 10 Mar 2023 14:32:48 +0100
Message-Id: <20230310133806.162401430@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit d15d2a617499882971ddb773a583015bf36fa492 ]

The property is wr-active:

  exynos3250-rinato.dtb: fimd@11c00000: i80-if-timings: 'wr-act' does not match any of the regexes: 'pinctrl-[0-9]+'

Fixes: b59b3afb94d4 ("ARM: dts: add fimd device support for exynos3250-rinato")
Link: https://lore.kernel.org/r/20230120155404.323386-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index f9e3b13d3aac2..bbf01f76ce3b1 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -249,7 +249,7 @@ &fimd {
 	i80-if-timings {
 		cs-setup = <0>;
 		wr-setup = <0>;
-		wr-act = <1>;
+		wr-active = <1>;
 		wr-hold = <0>;
 	};
 };
-- 
2.39.2



