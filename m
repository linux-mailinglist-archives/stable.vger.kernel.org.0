Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AA14F3404
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238105AbiDEJEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243671AbiDEIuz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:50:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1653DF1;
        Tue,  5 Apr 2022 01:39:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BA6B61003;
        Tue,  5 Apr 2022 08:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85637C385A0;
        Tue,  5 Apr 2022 08:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147957;
        bh=rxSC1Q8UZg6s7D6ZuFhMZ73XWIIqRVLONcnqQ9q8kC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SmccdRGUXT24fzpCDrJd+vWQ5/b4OLMxFhYGistHAY1qLkzdbS7uwCPog7yrWp70G
         XBw0Q4G1J+el8Lx/BBicY8GW6e1kp4/5yVCV2f5NcXDLfHGqqWOVwPVTBPplyN9Tkz
         eeOj4EXnczGnb+4D3GnKm8VwE0opOXC5/2v6zFaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 5.16 0156/1017] ARM: dts: exynos: fix UART3 pins configuration in Exynos5250
Date:   Tue,  5 Apr 2022 09:17:49 +0200
Message-Id: <20220405070358.845178264@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 372d7027fed43c8570018e124cf78b89523a1f8e upstream.

The gpa1-4 pin was put twice in UART3 pin configuration of Exynos5250,
instead of proper pin gpa1-5.

Fixes: f8bfe2b050f3 ("ARM: dts: add pin state information in client nodes for Exynos5 platforms")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Link: https://lore.kernel.org/r/20211230195325.328220-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos5250-pinctrl.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos5250-pinctrl.dtsi
@@ -260,7 +260,7 @@
 	};
 
 	uart3_data: uart3-data {
-		samsung,pins = "gpa1-4", "gpa1-4";
+		samsung,pins = "gpa1-4", "gpa1-5";
 		samsung,pin-function = <EXYNOS_PIN_FUNC_2>;
 		samsung,pin-pud = <EXYNOS_PIN_PULL_NONE>;
 		samsung,pin-drv = <EXYNOS4_PIN_DRV_LV1>;


