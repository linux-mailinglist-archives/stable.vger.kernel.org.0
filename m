Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1740D6948FB
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjBMOzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjBMOzD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:55:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0F99EE2
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:54:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7290BB80E62
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00C7C433D2;
        Mon, 13 Feb 2023 14:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300096;
        bh=mIpswickU1cU6+v2M56U3n8ZWhRc4t1EE2hD3nZnAcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UR9MvaedrmkX/9XG6Zf5+eukBria5SLgVIUR5ywKf616++ndtyM8TxWcs/UIdxOR/
         6YfUy+Ir2l+Rmdc/jHe8RBSfJFlpyuz0T+z66jx6ePhMYo1E+I0YSziroZXfhCpxI6
         ApQY7XgW1EMwBGX3rZBnVvKZBW7cUSIy4eu2EdUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Johansen <strit@manjaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/114] arm64: dts: rockchip: set sdmmc0 speed to sd-uhs-sdr50 on rock-3a
Date:   Mon, 13 Feb 2023 15:48:17 +0100
Message-Id: <20230213144745.443270542@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Johansen <strit@manjaro.org>

[ Upstream commit bc121b707e816616567683e51fd9194c2309977a ]

As other rk336x based devices, the Rock 3 Model A has issues with high
speed SD cards, so lower the speed to 50 instead of 104 in the same
manor has the Quartz64 Model B has.

Fixes: 22a442e6586c ("arm64: dts: rockchip: add basic dts for the radxa rock3 model a")
Signed-off-by: Dan Johansen <strit@manjaro.org>
Link: https://lore.kernel.org/r/20230128112432.132302-1-strit@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
index 539ef8cc77923..44313a18e484e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
@@ -642,7 +642,7 @@
 	disable-wp;
 	pinctrl-names = "default";
 	pinctrl-0 = <&sdmmc0_bus4 &sdmmc0_clk &sdmmc0_cmd &sdmmc0_det>;
-	sd-uhs-sdr104;
+	sd-uhs-sdr50;
 	vmmc-supply = <&vcc3v3_sd>;
 	vqmmc-supply = <&vccio_sd>;
 	status = "okay";
-- 
2.39.0



