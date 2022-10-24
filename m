Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDBB60B04E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiJXQFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbiJXQCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:02:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22BD01AE28A;
        Mon, 24 Oct 2022 07:55:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43FA5B8165F;
        Mon, 24 Oct 2022 12:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F82EC433D6;
        Mon, 24 Oct 2022 12:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614231;
        bh=DQNgp2+TWzVV7InN9eXbABN/iKDUNI2vlfGwXizv0BY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHeLuIFdCODZOJ/6FI9ui5KX20fnvxGkksytuyTCeqHJYcXeJf+SPlQLPHRY/Q6ze
         SuPBoUCCLFI6cbcGi8cfuxxeSGqaVCO4ibY4WkoeqW4MIZJev3hJK8edi87gFOURLz
         K8kYTk1hkNjTpOYETa6rWSEVfXpdDdkY80U4sUgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/390] ARM: dts: exynos: correct s5k6a3 reset polarity on Midas family
Date:   Mon, 24 Oct 2022 13:29:38 +0200
Message-Id: <20221024113030.462921312@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 3ba2d4bb9592bf7a6a3fe3dbe711ecfc3d004bab ]

According to s5k6a3 driver code, the reset line for the chip appears to
be active low. This also matches the typical polarity of reset lines in
general. Let's fix it up as having correct polarity in DTS is important
when the driver will be switched over to gpiod API.

Fixes: b4fec64758ab ("ARM: dts: Add camera device nodes for Exynos4412 TRATS2 board")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220913164104.203957-1-dmitry.torokhov@gmail.com
Link: https://lore.kernel.org/r/20220926104354.118578-2-krzysztof.kozlowski@linaro.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos4412-midas.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos4412-midas.dtsi b/arch/arm/boot/dts/exynos4412-midas.dtsi
index 06450066b178..255a13666edc 100644
--- a/arch/arm/boot/dts/exynos4412-midas.dtsi
+++ b/arch/arm/boot/dts/exynos4412-midas.dtsi
@@ -588,7 +588,7 @@
 		clocks = <&camera 1>;
 		clock-names = "extclk";
 		samsung,camclk-out = <1>;
-		gpios = <&gpm1 6 GPIO_ACTIVE_HIGH>;
+		gpios = <&gpm1 6 GPIO_ACTIVE_LOW>;
 
 		port {
 			is_s5k6a3_ep: endpoint {
-- 
2.35.1



