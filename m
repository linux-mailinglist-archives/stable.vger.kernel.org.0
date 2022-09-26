Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4C55EA5F7
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234490AbiIZM0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234230AbiIZMZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:25:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F33476FD;
        Mon, 26 Sep 2022 04:07:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0768B809E3;
        Mon, 26 Sep 2022 10:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EC0C433D6;
        Mon, 26 Sep 2022 10:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189128;
        bh=c7JOaXN/WLY2Wp5a0pAQO8DiiZGcoD8h3orQYV0f5mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RL6YGCJ4xto9Dv9KZ5Y3KpZi0YokolQuCORmWsF2DaZolXWrM49WAhBc1CYTJM4Ru
         OOvWvwM1Fvxb+WNRIOUuQaqjm4WcPstg8H3MmwXyNy8bM2jPSJc3AKaAeRfYFo1Mwz
         BnMGdiMSTug+D/wFxbC3cYsXUOLLucLUcpLBHlPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Riesch <michael.riesch@wolfvision.net>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 083/207] arm64: dts: rockchip: fix property for usb2 phy supply on rk3568-evb1-v10
Date:   Mon, 26 Sep 2022 12:11:12 +0200
Message-Id: <20220926100810.294829989@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Riesch <michael.riesch@wolfvision.net>

[ Upstream commit 1988e3ef0544bbe54cffa4ec30a5883e5a08c2b6 ]

The property "vbus-supply" was copied from the vendor kernel but is not
available in mainstream. Use correct property "phy-supply".

Fixes: d6cfb110b0fd ("arm64: dts: rockchip: add usb3 support to rk3568-evb1-v10")
Signed-off-by: Michael Riesch <michael.riesch@wolfvision.net>
Link: https://lore.kernel.org/r/20220905064335.104650-2-michael.riesch@wolfvision.net
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts b/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts
index 622be8be9813..282f5c74d5cd 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-evb1-v10.dts
@@ -618,7 +618,7 @@ &usb2phy0_host {
 };
 
 &usb2phy0_otg {
-	vbus-supply = <&vcc5v0_usb_otg>;
+	phy-supply = <&vcc5v0_usb_otg>;
 	status = "okay";
 };
 
-- 
2.35.1



