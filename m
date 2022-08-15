Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2E4594676
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbiHOW5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352583AbiHOW4W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:56:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E373DF12;
        Mon, 15 Aug 2022 12:55:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FA3661299;
        Mon, 15 Aug 2022 19:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7299EC433D6;
        Mon, 15 Aug 2022 19:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593337;
        bh=4u9rt+QdDkILcLD1KYvH6bN5uEpsuSs4RqAANrQI8zM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6N6ZseH4QbZtNl7KwMyqB92CUTANga5JzhV1Iir7MqxG0RZEZCDkNBhQgTmLAD4T
         B2wW/06yI9p4VNlqo2HG+3wYoQNmmul+99cmZZ9rrNQ2QQwixZ8XjiyRcQhhEDU3lQ
         pPEx522+zHnsKqKX5uoDT4l2u2BdZCnZSls4I6Xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0253/1157] arm64: dts: exynosautov9: correct spi11 pin names
Date:   Mon, 15 Aug 2022 19:53:29 +0200
Message-Id: <20220815180449.728087866@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Chanho Park <chanho61.park@samsung.com>

[ Upstream commit ba205449828f47f80532a1453beef5eed2982176 ]

They should be started with "gpp5-".

Fixes: 31bbac5263aa ("arm64: dts: exynos: add initial support for exynosautov9 SoC")
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20220627005832.8709-1-chanho61.park@samsung.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/exynos/exynosautov9-pinctrl.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/exynos/exynosautov9-pinctrl.dtsi b/arch/arm64/boot/dts/exynos/exynosautov9-pinctrl.dtsi
index ef0349d1c3d0..68f4a0fae7cf 100644
--- a/arch/arm64/boot/dts/exynos/exynosautov9-pinctrl.dtsi
+++ b/arch/arm64/boot/dts/exynos/exynosautov9-pinctrl.dtsi
@@ -1089,21 +1089,21 @@ spi10_cs_func: spi10-cs-func-pins {
 
 	/* PERIC1 USI11_SPI */
 	spi11_bus: spi11-pins {
-		samsung,pins = "gpp3-6", "gpp3-5", "gpp3-4";
+		samsung,pins = "gpp5-6", "gpp5-5", "gpp5-4";
 		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
 		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
 		samsung,pin-drv = <EXYNOS5420_PIN_DRV_LV1>;
 	};
 
 	spi11_cs: spi11-cs-pins {
-		samsung,pins = "gpp3-7";
+		samsung,pins = "gpp5-7";
 		samsung,pin-function = <EXYNOS_PIN_FUNC_OUTPUT>;
 		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
 		samsung,pin-drv = <EXYNOS5420_PIN_DRV_LV1>;
 	};
 
 	spi11_cs_func: spi11-cs-func-pins {
-		samsung,pins = "gpp3-7";
+		samsung,pins = "gpp5-7";
 		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
 		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
 		samsung,pin-drv = <EXYNOS5420_PIN_DRV_LV1>;
-- 
2.35.1



