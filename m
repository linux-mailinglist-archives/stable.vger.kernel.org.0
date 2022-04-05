Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDB34F36B5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239149AbiDELHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348486AbiDEJru (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:47:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B156F49B;
        Tue,  5 Apr 2022 02:34:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBD64B81B75;
        Tue,  5 Apr 2022 09:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F740C385A3;
        Tue,  5 Apr 2022 09:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151240;
        bh=AzruJ7kNpSnT6sSFKy/mtIR2Ku9xH4nvBIs2Jd7NW+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdD28Crbo3yTGOi3byNT7RBeYHW9uZRxj6oKUgRfF8nvmEezejJNUDPwlSUD13b3P
         iRMZ3QCvpwIufXJmQMbOtYmkzX/W6fZNZ2jf4xZUOG2uCJj8Nmsc1EjNwsCUFD046T
         hZfrllTrPI0IEEu06Ivrgu9HcXCTVoXeoH23OtEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 345/913] arm64: dts: rockchip: Fix SDIO regulator supply properties on rk3399-firefly
Date:   Tue,  5 Apr 2022 09:23:27 +0200
Message-Id: <20220405070350.187305362@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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



