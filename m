Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D0663AFEA
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbiK1Rqx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233498AbiK1RqN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:46:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7EB2A244;
        Mon, 28 Nov 2022 09:41:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92E18612FB;
        Mon, 28 Nov 2022 17:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199F8C433D6;
        Mon, 28 Nov 2022 17:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657286;
        bh=omV9gOWDMSbqKUYZDzNaiOfBi3Px658B3WX5l37rH8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qB/84NA6eEtSWmjJiLjBJoprCaWk7qgjUrvZZPPOPVI53XFvxacdfGWsPPkliZj0H
         tpZRPNsVoqWiHWKcwRuj4WkVAsOK4AOkzGB4uiwaGFUO1bq+zwAyN9LvXYPHXpTA61
         uBYoZCxx2nbKL6HWFWqL66v6NIsn638kJrDBiv2snKb8yOMCUqIZmLUOcOODIM0z0b
         EGeas0iAz/xZX6tX46EcjqVZ+J9xPSfOM7WphtAMNG+7on4TTN72oPUaEvkXaAuZn5
         6xrqr26nEW2acvxLKly6MZKZO2d6imQwC38mwaAV5twcLvAfVVSVLdOOUpT0d/9Cal
         PQwrsAiAQjPlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 03/19] ARM: dts: rockchip: fix ir-receiver node names
Date:   Mon, 28 Nov 2022 12:41:03 -0500
Message-Id: <20221128174120.1442235-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174120.1442235-1-sashal@kernel.org>
References: <20221128174120.1442235-1-sashal@kernel.org>
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

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit dd847fe34cdf1e89afed1af24986359f13082bfb ]

Fix ir-receiver node names on Rockchip boards,
so that they match with regex: '^ir(-receiver)?(@[a-f0-9]+)?$'

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/ea5af279-f44c-afea-023d-bb37f5a0d58d@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3188-radxarock.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3188-radxarock.dts b/arch/arm/boot/dts/rk3188-radxarock.dts
index b0fef82c0a71..39b913f8d701 100644
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@ -67,7 +67,7 @@ spdif_out: spdif-out {
 		#sound-dai-cells = <0>;
 	};
 
-	ir_recv: gpio-ir-receiver {
+	ir_recv: ir-receiver {
 		compatible = "gpio-ir-receiver";
 		gpios = <&gpio0 RK_PB2 GPIO_ACTIVE_LOW>;
 		pinctrl-names = "default";
-- 
2.35.1

