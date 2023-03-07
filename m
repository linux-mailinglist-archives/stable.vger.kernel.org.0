Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 937706AEDDA
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbjCGSHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbjCGSHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:07:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053BF95447
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:01:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA14161509
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1D3C433EF;
        Tue,  7 Mar 2023 18:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212061;
        bh=qLiiu76Zk9G3EoJefkKVTcr2rDyDR3hPVfxdCqXIdSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yokvDMODyCwiqxR5ieu0EI5+ZgrhmR6PPuPqyWxXEDvLmat0rwTv73AvEeFCOpE7c
         OYPwVBJbA3UmJiliGiNJ7FP5Czed5lATnT8bgzzIduPHhsp48z2dCxsTr0PZc27M4x
         IW0gWOpK3ojkQvyxHgV29oydPAHnDo2dKzxRR/Xk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/885] arm64: dts: amlogic: meson-gxbb-kii-pro: fix led node name
Date:   Tue,  7 Mar 2023 17:49:58 +0100
Message-Id: <20230307170004.560953642@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit afdef3b188c934f79ad4b0a7bd8c692742f9b5af ]

Fixes:
leds: status: {...} is not of type 'array'

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-13-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
index 6d8cc00fedc7f..5f2d4317ecfbf 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
@@ -16,7 +16,7 @@ / {
 
 	leds {
 		compatible = "gpio-leds";
-		status {
+		led {
 			gpios = <&gpio_ao GPIOAO_13 GPIO_ACTIVE_LOW>;
 			default-state = "off";
 			color = <LED_COLOR_ID_RED>;
-- 
2.39.2



