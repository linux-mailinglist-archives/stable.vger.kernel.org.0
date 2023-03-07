Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADB56AEDEB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbjCGSIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:08:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbjCGSIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:08:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3757A8E9A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:01:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86F1F6150D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD4EC433EF;
        Tue,  7 Mar 2023 18:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212111;
        bh=SlMkhGvGyfLvpClQ1lzIYcTY7BdugNBvrQRRXf8glkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xNnPAaB8uIzvLmpaYmIQ2K6X/T8Y/gmpx0JsVx3DIG9L1eDjnRPilGwc4MQYnxomF
         evd3zkPpYGq+ymsg8AVqw4B8F7STml227Q7Amej0xBYZQzwyKmveMBA8Qx9g++azr9
         FigWpyRp3BV78RJucLddDcZzM5MxCLOcT3FtGslI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 050/885] ARM: dts: exynos: correct wr-active property in Exynos3250 Rinato
Date:   Tue,  7 Mar 2023 17:49:44 +0100
Message-Id: <20230307170003.897466817@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index 6d2c7bb191842..2eb682009815a 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -250,7 +250,7 @@ &fimd {
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



