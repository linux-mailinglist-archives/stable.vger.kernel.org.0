Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4081A4D3737
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235538AbiCIQ1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235821AbiCIQ0F (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:26:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C333F154D34;
        Wed,  9 Mar 2022 08:22:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 453CD6194A;
        Wed,  9 Mar 2022 16:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016E0C340EC;
        Wed,  9 Mar 2022 16:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646842934;
        bh=IO6UVDaLq4MGTBRCBzhs46Izu0yxbl4fllpUsoEd0ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=psoA3LJagQJz1qu+p72nsOd2vS9Ep+20VrLmF/9gQqrU9CgM0gaQugDQVAZHx12jN
         xQFDPUNjdRmXbjsiLdMv7AHk75ypBTIy75aORlIGKG2WVF5sVdYTZLo4n7l75KVZCk
         HOwItaNa8oGfpHFnQGWEzJybkyMNCLtqw33AZ1bIWruQqs0cG4hgFBSOjXHQuMoFm0
         hs3jTQwACMyAwHn5m9qgga89kqMxWBoXZ5jeepQmd9ncKc5UK4uTSauWZ16FZwKq1Q
         mEHDnIouoNPQ67m5zFnWXlZ9UaAxzePcHRHgdEnpaq3xARlxnZWMFOCM6ddNEQWujP
         1Z0wHmRPHoqWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>,
        Quentin Schulz <foss+kernel@0leil.net>,
        Quentin Schulz <quentin.schulz@theobroma-systems.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 03/20] arm64: dts: rockchip: fix rk3399-puma eMMC HS400 signal integrity
Date:   Wed,  9 Mar 2022 11:21:41 -0500
Message-Id: <20220309162158.136467-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309162158.136467-1-sashal@kernel.org>
References: <20220309162158.136467-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>

[ Upstream commit 62966cbdda8a92f82d966a45aa671e788b2006f7 ]

There are signal integrity issues running the eMMC at 200MHz on Puma
RK3399-Q7.

Similar to the work-around found for RK3399 Gru boards, lowering the
frequency to 100MHz made the eMMC much more stable, so let's lower the
frequency to 100MHz.

It might be possible to run at 150MHz as on RK3399 Gru boards but only
100MHz was extensively tested.

Cc: Quentin Schulz <foss+kernel@0leil.net>
Signed-off-by: Jakob Unterwurzacher <jakob.unterwurzacher@theobroma-systems.com>
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20220119134948.1444965-1-quentin.schulz@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index 4660416c8f38..544110aaffc5 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -472,6 +472,12 @@ vcc5v0_host_en: vcc5v0-host-en {
 };
 
 &sdhci {
+	/*
+	 * Signal integrity isn't great at 200MHz but 100MHz has proven stable
+	 * enough.
+	 */
+	max-frequency = <100000000>;
+
 	bus-width = <8>;
 	mmc-hs400-1_8v;
 	mmc-hs400-enhanced-strobe;
-- 
2.34.1

