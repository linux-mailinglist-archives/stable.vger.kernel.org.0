Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C926ADA92
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 10:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjCGJmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 04:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCGJmy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 04:42:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971481717
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 01:42:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 348196126D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DF8C433D2;
        Tue,  7 Mar 2023 09:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678182171;
        bh=2RJWRaGgpeRdVisM9RWmu78KG8XOhuqHqaEIQ46alvg=;
        h=Subject:To:Cc:From:Date:From;
        b=NcDkUHsbR3NXnT9movwBqrzh7mCHQF83AiDX+1j+DyUroIiG8f9JEsUc55aEO8aks
         nkn6z08cvBqeyaAZddpuO7ZT7qQbxC4EzXUnkJPosSps2egFDmDPDr52pa/+9BV7Qk
         ZqRqcil3dtLEGxZ0OKi5wbpwWVJN9a1s0kkAT1KQ=
Subject: FAILED: patch "[PATCH] ARM: dts: exynos: correct TMU phandle in Exynos4210" failed to apply to 4.14-stable tree
To:     krzysztof.kozlowski@linaro.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 10:42:33 +0100
Message-ID: <1678182153823@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.14.y
git checkout FETCH_HEAD
git cherry-pick -x 408ab6786dbf6dd696488054c9559681112ef994
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678182153823@kroah.com' --subject-prefix 'PATCH 4.14.y' HEAD^..

Possible dependencies:

408ab6786dbf ("ARM: dts: exynos: correct TMU phandle in Exynos4210")
1708f56081e2 ("ARM: dts: exynos: Override thermal by label in Exynos4210")
c31b11c3eb4d ("ARM: dts: exynos: Fix language typo and indentation")
9a8665ab920b ("ARM: dts: exynos: Add soc node to exynos4210")
e030be47ac48 ("ARM: dts: exynos: Use labels instead of full paths in exynos4210")
88c166cec136 ("ARM: dts: exynos: Use pinctrl labels in exynos4210-pinctrl")
3be1ecf291df ("ARM: dts: exynos: Use lower case hex addresses in node unit addresses")
6351fe9375f4 ("ARM: dts: exynos: Add G3D power domain to Exynos5250")
c0d40bb3ac71 ("ARM: dts: exynos: Add audio power domain to Exynos5250")
9fbb4c096323 ("ARM: dts: exynos: Fix power domain node names for Exynos5250")
528832d4c01a ("ARM: dts: exynos: Add audio power domain support to Exynos542x SoCs")
cdd745c8c76b ("ARM: dts: exynos: Remove duplicate definitions of SSS nodes for Exynos5")
8dccafaa281a ("arm: dts: fix unit-address leading 0s")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 408ab6786dbf6dd696488054c9559681112ef994 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Thu, 9 Feb 2023 11:58:37 +0100
Subject: [PATCH] ARM: dts: exynos: correct TMU phandle in Exynos4210

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.  Since thermal-sensors property is
already defined in included exynos4-cpu-thermal.dtsi, drop it from
exynos4210.dtsi to fix the error and remoev redundancy.

Fixes: 9843a2236003 ("ARM: dts: Provide dt bindings identical for Exynos TMU")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230209105841.779596-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 2c25cc37934e..f8c6c5d1906a 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -393,7 +393,6 @@
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
 };
 
 &gic {

