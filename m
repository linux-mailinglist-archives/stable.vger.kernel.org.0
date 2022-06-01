Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE3053A86E
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351160AbiFAOJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355833AbiFAOG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:06:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331FEBA9BA;
        Wed,  1 Jun 2022 07:00:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C25F6155E;
        Wed,  1 Jun 2022 13:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39CEC34119;
        Wed,  1 Jun 2022 13:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091994;
        bh=cJFlLz+jFyLB/OFW6ZZBIAU34k0Q+vivDjWMB3mrnGI=;
        h=From:To:Cc:Subject:Date:From;
        b=BaQr74OVHhEguiDVV9MNq8c1hE9+qJc13C/u0jW01BTQCimWvCkTLkDfHHlRaOwLn
         mXJ0Q3cuwK6LTm1q0I0C9+yu9w1o2v2uk4DdHUgIATK1A0RiKz27fFuxzanhCdmhTV
         807cOwQOaPqwrU10AcbsD1Zitl+Rf2D67AmZ7RLbq7Y1RGHevjAIn+DmQFg/guHdld
         oxXf0P4bBeFZOVmJyaHf+qPV+k3ugUB+MCQNg/K8+Khk5MBk4hF2w8z6287AarUh5V
         OQ1IqnYsljnYLd494YgMjcXHpIcZe1qiXm6+ZafD840+Ubau7Ej3YyfCsaYTlcuLR5
         wV6xSiGChTbPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-oxnas@groups.io,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/15] ARM: dts: ox820: align interrupt controller node name with dtschema
Date:   Wed,  1 Jun 2022 09:59:36 -0400
Message-Id: <20220601135951.2005085-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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
index f7dddfb01f81..d629caf8b98f 100644
--- a/arch/arm/boot/dts/ox820.dtsi
+++ b/arch/arm/boot/dts/ox820.dtsi
@@ -286,7 +286,7 @@ local-timer@600 {
 				clocks = <&armclk>;
 			};
 
-			gic: gic@1000 {
+			gic: interrupt-controller@1000 {
 				compatible = "arm,arm11mp-gic";
 				interrupt-controller;
 				#interrupt-cells = <3>;
-- 
2.35.1

