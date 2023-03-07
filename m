Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4048D6AECFD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjCGSAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjCGR70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:59:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EC5DBF1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:53:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D0AE6152D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1846FC4339B;
        Tue,  7 Mar 2023 17:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211628;
        bh=UWLThVzDV7ZJE7s7ShauHgMP9/ILRfV2ccr+Ii9WPR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/Xs79F0JepqIjI3A3axPJElWSx0dAjZpQvFD9Fr5PtQauootSjjxfoXFEiKa9u9M
         wYzvQb3jjqLfBexCz2bsZE/Setxtoy5UgLlDwoAVUKYeZUeLNNxZVzhJu6mDaEf3TX
         tg9VgqKF6JtLBWdqA2+QPC+ZLTg0UsXxzNiR/Q88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.2 0923/1001] ARM: dts: exynos: correct TMU phandle in Exynos5250
Date:   Tue,  7 Mar 2023 18:01:35 +0100
Message-Id: <20230307170102.143662862@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

commit 33e2c595e2e4016991ead44933a29d1ef93d5f26 upstream.

TMU node uses 0 as thermal-sensor-cells, thus thermal zone referencing
it must not have an argument to phandle.

Cc: <stable@vger.kernel.org>
Fixes: 9843a2236003 ("ARM: dts: Provide dt bindings identical for Exynos TMU")
Link: https://lore.kernel.org/r/20230209105841.779596-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos5250.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -1107,7 +1107,7 @@
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
+	thermal-sensors = <&tmu>;
 
 	cooling-maps {
 		map0 {


