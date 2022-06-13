Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2917A548CE5
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349666AbiFMK5m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350817AbiFMKzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:55:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2505724F23;
        Mon, 13 Jun 2022 03:31:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F9F7B80EB2;
        Mon, 13 Jun 2022 10:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FCDC341D4;
        Mon, 13 Jun 2022 10:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116315;
        bh=87fusB1NbeF9d5w5FokHgelhk1HMeGJ7WnXMAGuYKQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ozj1mguxOOIf+YdesmNrzT5P8QMmwKtNN4f+8wzau3aJkpsFX3AHDqvJa5z4cBpE/
         94+GxVPoNGqgku4gTBlW47z7+9icDBZgKSA6u4WflES6hVMRKssg+XD0XXQmSGUlkb
         q9I7sITptyw7PkwHAu65vJilLGTstOcm7AtSFVws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/411] ARM: dts: ox820: align interrupt controller node name with dtschema
Date:   Mon, 13 Jun 2022 12:05:37 +0200
Message-Id: <20220613094930.437336598@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -287,7 +287,7 @@
 				clocks = <&armclk>;
 			};
 
-			gic: gic@1000 {
+			gic: interrupt-controller@1000 {
 				compatible = "arm,arm11mp-gic";
 				interrupt-controller;
 				#interrupt-cells = <3>;
-- 
2.35.1



