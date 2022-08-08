Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0FB58C09D
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbiHHBwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243651AbiHHBvb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:51:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30884193F5;
        Sun,  7 Aug 2022 18:38:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62ED3B80E0F;
        Mon,  8 Aug 2022 01:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE4FC4347C;
        Mon,  8 Aug 2022 01:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922700;
        bh=YWfPQ3t+jkwgV2snpf/9bjEHZjXzjouQLMHW9tuflZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KmVq/FVKeGMllPZ80dR1IXnok0tcwNuw6WRkc4cIGZPdiEzzap0ytn6XSyNkiuN45
         NQocnazs6QvpbPxoFIl3ZB1Osn3fqN2vhSBp4CHMWkTLQXM47IJKNJvWCWB3Yu0L4k
         XReGBe0C1ghZ9OeQSoUxttJYat4ddmYdQOsBTqtEsbJrlbMcxbTe8CPbreajxZU3KM
         L8wSk1rX/HSoxqiLsbomwO1gYqAtAhIyqHDO46VtOlv4IZdLtqX98VmitwR1PHCvZh
         b/FnfZKUQNaQjiYC8tFhMaa0CgoTl3B9Md9eVe2uhywk5LpHML7BVyx1jtBYg79uBl
         RghQN8sIS0nyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Samuel Holland <samuel@sholland.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, wens@csie.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 24/29] arm64: dts: allwinner: a64: orangepi-win: Fix LED node name
Date:   Sun,  7 Aug 2022 21:37:34 -0400
Message-Id: <20220808013741.316026-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013741.316026-1-sashal@kernel.org>
References: <20220808013741.316026-1-sashal@kernel.org>
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

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit b8eb2df19fbf97aa1e950cf491232c2e3bef8357 ]

"status" does not match any pattern in the gpio-leds binding. Rename the
node to the preferred pattern. This fixes a `make dtbs_check` error.

Signed-off-by: Samuel Holland <samuel@sholland.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20220702132816.46456-1-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts
index 70e31743f0ba..3c08497568ea 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-orangepi-win.dts
@@ -40,7 +40,7 @@ hdmi_con_in: endpoint {
 	leds {
 		compatible = "gpio-leds";
 
-		status {
+		led-0 {
 			label = "orangepi:green:status";
 			gpios = <&pio 7 11 GPIO_ACTIVE_HIGH>; /* PH11 */
 		};
-- 
2.35.1

