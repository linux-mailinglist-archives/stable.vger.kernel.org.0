Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B344060A56B
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiJXMYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbiJXMXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:23:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716F71AF15;
        Mon, 24 Oct 2022 04:59:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B59F6129B;
        Mon, 24 Oct 2022 11:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50818C433C1;
        Mon, 24 Oct 2022 11:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612777;
        bh=PjdSAhHFsEcQmApOu7TJ6TUEWQhU3Y739C1c8IFEpF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E738jcCP2MUsQ2ew8BI6HWfUbvcv18FV4JLcKyZPo7Ucryv6nmUx4HSrTnH1q6IHC
         9SxOWGI0KJM/wad2Xv++pV4nWV9MFvf7zXnv7iBNfmuyvugmiSuPeAz/upGYXccn0I
         4Pb0QYtUyQMOUAInAhFsLh2P8mPUvqdMUk1vPiig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 114/229] ARM: dts: exynos: correct s5k6a3 reset polarity on Midas family
Date:   Mon, 24 Oct 2022 13:30:33 +0200
Message-Id: <20221024113002.689910603@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
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
index 60fbad25b5f2..93c8918e599b 100644
--- a/arch/arm/boot/dts/exynos4412-midas.dtsi
+++ b/arch/arm/boot/dts/exynos4412-midas.dtsi
@@ -525,7 +525,7 @@
 		clocks = <&camera 1>;
 		clock-names = "extclk";
 		samsung,camclk-out = <1>;
-		gpios = <&gpm1 6 GPIO_ACTIVE_HIGH>;
+		gpios = <&gpm1 6 GPIO_ACTIVE_LOW>;
 
 		port {
 			is_s5k6a3_ep: endpoint {
-- 
2.35.1



