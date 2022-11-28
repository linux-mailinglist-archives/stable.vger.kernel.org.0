Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9177863B077
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbiK1Rvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiK1Rtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:49:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B622EF18;
        Mon, 28 Nov 2022 09:43:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1C7D612ED;
        Mon, 28 Nov 2022 17:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C884C43470;
        Mon, 28 Nov 2022 17:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657408;
        bh=mz3vz6o7JaaQKhVGgMgC8tbJOFZ1haZmzuc36K26sU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prbmVLienj3oKODpc/zdDzwV2GEdmI+6ScR0z6o2Jv/9/zUy/P3fU2iztK6L3/BlZ
         GfRxm1j+8LYJy9QE2lV0fDkgjidza6vxTQPEvJMKjrTJePju5fw+AOekLBPl3sVBmR
         VsxA5em24rdJOZq2gHB0+28lDzrGdvP6AvIboqygwYxvO+Er1YUbCqJPUyVJwGRq9Z
         tHc2qob4EgwDCFx5xU8CCw71SBkJAgR5ys0uosks+Mg2CAx2I6fvlqlJfG+HjROIiH
         IKSpjZGTUsOTeOaI3agok/SvzsvF5DwCtVHqRc1MVM2Gz2OVPa23r34qlyIA0BdtqO
         wASz5htZU7goQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/5] ARM: dts: rockchip: fix ir-receiver node names
Date:   Mon, 28 Nov 2022 12:43:20 -0500
Message-Id: <20221128174324.1443132-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128174324.1443132-1-sashal@kernel.org>
References: <20221128174324.1443132-1-sashal@kernel.org>
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
index 1da46d138029..54e8e5dca93b 100644
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@ -104,7 +104,7 @@ spdif_out: spdif-out {
 		#sound-dai-cells = <0>;
 	};
 
-	ir_recv: gpio-ir-receiver {
+	ir_recv: ir-receiver {
 		compatible = "gpio-ir-receiver";
 		gpios = <&gpio0 10 1>;
 		pinctrl-names = "default";
-- 
2.35.1

