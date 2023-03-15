Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497826BB04D
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjCOMRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbjCOMQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:16:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAAD93E10
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:16:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CA1961D48
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED01C433EF;
        Wed, 15 Mar 2023 12:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882606;
        bh=6f/KDhcbebeBOCaNjTR0EzTauJY5Ac8dnsqaT93Sy+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpFoSlnG8ThHLQ5wtOKaBom+8xmIvDGCWl95vTPD2bZf8rQwtIHOhMgIU50MBzIZx
         Dqcp6s2fcGWVFYacI1cZrKFm89MnkvOwDm/VFxZIOIgwlSqV2RgVQp5JNknsQDvhmf
         GirXKuZUAB/PfFQif8BdXf/9/PirokrSLL0GX0XM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/39] ARM: dts: exynos: correct TMU phandle in Exynos5250
Date:   Wed, 15 Mar 2023 13:12:34 +0100
Message-Id: <20230315115721.967580546@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
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

[ Upstream commit 33e2c595e2e4016991ead44933a29d1ef93d5f26 ]

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.

Cc: <stable@vger.kernel.org>
Fixes: 9843a2236003 ("ARM: dts: Provide dt bindings identical for Exynos TMU")
Link: https://lore.kernel.org/r/20230209105841.779596-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/exynos5250.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 1883b8c2cd7b9..c6b0e6413c683 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -1061,7 +1061,7 @@
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
+	thermal-sensors = <&tmu>;
 
 	cooling-maps {
 		map0 {
-- 
2.39.2



