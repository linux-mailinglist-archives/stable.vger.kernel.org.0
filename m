Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D66E53A794
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351095AbiFAOCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354627AbiFAOAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:00:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECBB12AAE;
        Wed,  1 Jun 2022 06:57:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71A1CCE1C0A;
        Wed,  1 Jun 2022 13:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D183BC341C0;
        Wed,  1 Jun 2022 13:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091786;
        bh=meEEYYb4Q/Zwm6saccKdiTfafAQE+aqAUob7xdy2nqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xxs+paFeRaBnnb4ePsrWtRwFWTriKFJLA58Bzz8rOYWkDoCE9b6qa+fQiHkXkOtEI
         Nq/+rph0Sv98+2ZjpKrjr/CvyG5PmrF8j8UjxgRk17yyk5ns24kCTsNJkiSGd4//jS
         pA0LZMrL3GJ6mJs+47SzuxkUilZKfMn2Vx3lwuP0lkpjazrQiy+m0gGS+lhYdZRRAf
         T8SidftQ9TpTnOacsvy8BqcWfbePjjipHGyZu7tT2Hc6Zk2ZlB5YPnLMjHAaUQuysN
         O1x6EaEHzkcLCwLOT9JMG3MjDC+mL3UfbkS0DMocOSJOA8OK7k+OdfxbKcuA00Z/Z+
         Xver3eaOFv9cQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-oxnas@groups.io,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 02/37] ARM: dts: ox820: align interrupt controller node name with dtschema
Date:   Wed,  1 Jun 2022 09:55:47 -0400
Message-Id: <20220601135622.2003939-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135622.2003939-1-sashal@kernel.org>
References: <20220601135622.2003939-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit fbcd5ad7a419ad40644a0bb8b4152bc660172d8a ]

Fixes dtbs_check warnings like:

  gic@1000: $nodename:0: 'gic@1000' does not match '^interrupt-controller(@[0-9a-f,]+)*$'

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20220317115705.450427-1-krzysztof.kozlowski@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ox820.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ox820.dtsi b/arch/arm/boot/dts/ox820.dtsi
index 90846a7655b4..dde4364892bf 100644
--- a/arch/arm/boot/dts/ox820.dtsi
+++ b/arch/arm/boot/dts/ox820.dtsi
@@ -287,7 +287,7 @@ local-timer@600 {
 				clocks = <&armclk>;
 			};
 
-			gic: gic@1000 {
+			gic: interrupt-controller@1000 {
 				compatible = "arm,arm11mp-gic";
 				interrupt-controller;
 				#interrupt-cells = <3>;
-- 
2.35.1

