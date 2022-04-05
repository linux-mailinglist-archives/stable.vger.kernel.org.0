Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36BAE4F2EF3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343917AbiDEJPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244955AbiDEIwu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCB21C100;
        Tue,  5 Apr 2022 01:47:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BBAE60FFB;
        Tue,  5 Apr 2022 08:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35AC2C385A0;
        Tue,  5 Apr 2022 08:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148468;
        bh=AzruJ7kNpSnT6sSFKy/mtIR2Ku9xH4nvBIs2Jd7NW+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6VROCLfOhPDoNwKSktXrktRK3HEvvEhT6wMzgp+yy0ONNEEWqRe08UrURjQCTBRc
         6KeiOeMJ4y1OZrumxqbFvmcf3mg0MZPc7ZQ0ltIG74FwPYBOlvmXWzLAO4+zSoJIyX
         83szSyACn7k7nY/FpZNNgktA9MlbdNxn+Bh7MuDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0366/1017] arm64: dts: rockchip: Fix SDIO regulator supply properties on rk3399-firefly
Date:   Tue,  5 Apr 2022 09:21:19 +0200
Message-Id: <20220405070405.149503382@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 37cbd3c522869247ed4525b5042ff4c6a276c813 ]

A label reference without brackets is a path string, not a phandle as
intended. Add the missing brackets.

Fixes: a5002c41c383 ("arm64: dts: rockchip: add WiFi module support for Firefly-RK3399")
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220304202559.317749-1-robh@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-firefly.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
index c4dd2a6b4836..f81ce3240342 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-firefly.dts
@@ -770,8 +770,8 @@
 	sd-uhs-sdr104;
 
 	/* Power supply */
-	vqmmc-supply = &vcc1v8_s3;	/* IO line */
-	vmmc-supply = &vcc_sdio;	/* card's power */
+	vqmmc-supply = <&vcc1v8_s3>;	/* IO line */
+	vmmc-supply = <&vcc_sdio>;	/* card's power */
 
 	#address-cells = <1>;
 	#size-cells = <0>;
-- 
2.34.1



