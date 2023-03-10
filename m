Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0A96B40AC
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjCJNou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCJNot (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:44:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8289387359
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:44:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17B6BB822B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CEEC433D2;
        Fri, 10 Mar 2023 13:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678455885;
        bh=TGryrwuA6HKr9VvU/8RU+K/sgCT6aPGkXxCYLy38lwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bh6gK51E1vsmGzNjzBK9lIVWUzpR5iT9e/455BopE6Hon2OKzNdJMqTed2uEKJO6M
         PyDslfR5FE0Y1M2RAlmfrKhZJGXm7ziYTymjLI4kq/UcG6KtBiPDXZ+5jZ1QYheVuw
         4sOyZFGF+dHjiinsE37N+czKBIEmA0ANGyi6Q+Y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 001/193] ARM: dts: rockchip: add power-domains property to dp node on rk3288
Date:   Fri, 10 Mar 2023 14:36:23 +0100
Message-Id: <20230310133710.974830282@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 80422339a75088322b4d3884bd12fa0fe5d11050 ]

The clocks in the Rockchip rk3288 DisplayPort node are
included in the power-domain@RK3288_PD_VIO logic, but the
power-domains property in the dp node is missing, so fix it.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/dab85bfb-9f55-86a1-5cd5-7388c43e0ec5@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3288.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 872e4e690beb4..c3440adc763ce 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -1096,6 +1096,7 @@ edp: dp@ff970000 {
 		clock-names = "dp", "pclk";
 		phys = <&edp_phy>;
 		phy-names = "dp";
+		power-domains = <&power RK3288_PD_VIO>;
 		resets = <&cru SRST_EDP>;
 		reset-names = "dp";
 		rockchip,grf = <&grf>;
-- 
2.39.0



