Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743694B4785
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245531AbiBNJwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:52:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245617AbiBNJui (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:50:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F39652E8;
        Mon, 14 Feb 2022 01:41:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2E1261172;
        Mon, 14 Feb 2022 09:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98936C340E9;
        Mon, 14 Feb 2022 09:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831688;
        bh=OHldYB6mu4betx+t+BXF4bKjjju8Vk//4Z3uCKR9SHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4+2cPBMAY3OJzwYbvlmJMmNe7vhZB7gxUJMbBxvCJmGHyNfjp6pNzxJtnXBPZHlB
         ZlY8xbOs07u8+XqRA7jJEBQxf3ZGAquxGCA06hbJhs8dmtWsSaax6qG828mF3H3sNZ
         dMVb219kiChVwd4jsskyhE/5VurqhWX4kG0eYyQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongjin Kim <tobetter@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/116] arm64: dts: meson-g12b-odroid-n2: fix typo dio2133
Date:   Mon, 14 Feb 2022 10:26:02 +0100
Message-Id: <20220214092500.928145195@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongjin Kim <tobetter@gmail.com>

[ Upstream commit bc41099f060ea74ac8d02c51bd0f5f46d969bedf ]

Typo in audio amplifier node, dioo2133 -> dio2133

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
Fixes: ef599f5f3e10 ("arm64: dts: meson: convert ODROID-N2 to dtsi")
Fixes: 67d141c1f8e6 ("arm64: dts: meson: odroid-n2: add jack audio output support")
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/YfKQJejh0bfGYvof@anyang
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
index b9b8cd4b5ba9d..87e8e64ad5cae 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
@@ -15,7 +15,7 @@ aliases {
 		ethernet0 = &ethmac;
 	};
 
-	dioo2133: audio-amplifier-0 {
+	dio2133: audio-amplifier-0 {
 		compatible = "simple-audio-amplifier";
 		enable-gpios = <&gpio_ao GPIOAO_2 GPIO_ACTIVE_HIGH>;
 		VCC-supply = <&vcc_5v>;
@@ -215,7 +215,7 @@ sound {
 		audio-widgets = "Line", "Lineout";
 		audio-aux-devs = <&tdmout_b>, <&tdmout_c>, <&tdmin_a>,
 				 <&tdmin_b>, <&tdmin_c>, <&tdmin_lb>,
-				 <&dioo2133>;
+				 <&dio2133>;
 		audio-routing = "TDMOUT_B IN 0", "FRDDR_A OUT 1",
 				"TDMOUT_B IN 1", "FRDDR_B OUT 1",
 				"TDMOUT_B IN 2", "FRDDR_C OUT 1",
-- 
2.34.1



