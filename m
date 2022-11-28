Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B4863AF07
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbiK1Rhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233044AbiK1Rhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:37:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B12D5BBF;
        Mon, 28 Nov 2022 09:37:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C4C7B80E96;
        Mon, 28 Nov 2022 17:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4CEC433C1;
        Mon, 28 Nov 2022 17:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657053;
        bh=Ih164wO2yIVSdRfklyHjNqO9eU+8S3Va5loJX4++x7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1J4kKcMAgj28JOyAoNMvRuo5VnkEOe845PqD0uuJSua0Lh7s8Xx1ifvXFj1RR6sc
         hwQpbB6TYXmt58Xwmqw+DAhpmcgwvaj0qHr1PeomU5fb368JuJQhaAroy1cWxF3g/N
         LJOsNWANm1iU99bLmBEhVsOfzOJDSFQhMgY6toP1lreSC1rT8MY4fPj2g/29Ws2FeE
         5hm0TQPfNO0y+KQ0NqJKQwzauFj0hi+2UG94v43U8WUq/8o5zaoXnkSw9jXi8mDI1x
         cXbVH5a1bzywlRy4eTymmK6icIDHk3cKKYqD6M+0VaUMOfW6wuCgNuIsfULE03jpI3
         jOWbK7JsGGCpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     FUKAUMI Naoki <naoki@radxa.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 6.0 04/39] arm64: dts: rockchip: keep I2S1 disabled for GPIO function on ROCK Pi 4 series
Date:   Mon, 28 Nov 2022 12:35:44 -0500
Message-Id: <20221128173642.1441232-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit 849c19d14940b87332d5d59c7fc581d73f2099fd ]

I2S1 pins are exposed on 40-pin header on Radxa ROCK Pi 4 series.
their default function is GPIO, so I2S1 need to be disabled.

Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://lore.kernel.org/r/20220924112812.1219-1-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
index 401e1ae9d944..b045f74071e4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rock-pi-4.dtsi
@@ -491,7 +491,6 @@ i2s0_p0_0: endpoint {
 &i2s1 {
 	rockchip,playback-channels = <2>;
 	rockchip,capture-channels = <2>;
-	status = "okay";
 };
 
 &i2s2 {
-- 
2.35.1

