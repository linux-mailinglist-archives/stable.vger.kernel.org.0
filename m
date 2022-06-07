Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8F8541CB4
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382447AbiFGWDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382951AbiFGWA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:00:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A2924E000;
        Tue,  7 Jun 2022 12:14:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4966B8237B;
        Tue,  7 Jun 2022 19:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DFFC385A5;
        Tue,  7 Jun 2022 19:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629255;
        bh=pi1MZ/7QEmXJOQN0uUmPb5Jkg7rMKRaLhEQEu4gc5yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEzmtGEJ/BUaL0h5bGBg5rlMNY4iFGh50V4OIk3X0wVozzWYgnUNGh9HZhiDSCDen
         TVFVyH0DIyqW9TDcF0lqilEsMXSIKRZo0bbi5UBBpc2M8Ofch5ULD6ceToDSw4pxMp
         90YV8fsWUlQqzGtGjCgvTsjIDrM2DgnCwOP2Pr78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 624/879] ARM: dts: at91: sama7g5: remove interrupt-parent from gic node
Date:   Tue,  7 Jun 2022 19:02:22 +0200
Message-Id: <20220607165020.963251298@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit b7e86ef7afd128577ff7bb0db0ae82d27d7ed7ad ]

interrupt-parent is not to be used as a boolean property.
It is already present in the DT in the proper way it's supposed to be used:
interrupt-parent = <&gic>;

This is also reported by dtbs_check:
arch/arm/boot/dts/at91-sama7g5ek.dtb: interrupt-controller@e8c11000: interrupt-parent: True is not of type 'array'
	From schema: /.local/lib/python3.8/site-packages/dtschema/schemas/interrupts.yaml

Fixes: 7540629e2fc7 ("ARM: dts: at91: add sama7g5 SoC DT and sama7g5-ek")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220503133127.64320-1-eugen.hristev@microchip.com
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sama7g5.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/sama7g5.dtsi b/arch/arm/boot/dts/sama7g5.dtsi
index f691c8f08d04..b63263129692 100644
--- a/arch/arm/boot/dts/sama7g5.dtsi
+++ b/arch/arm/boot/dts/sama7g5.dtsi
@@ -857,7 +857,6 @@
 			#interrupt-cells = <3>;
 			#address-cells = <0>;
 			interrupt-controller;
-			interrupt-parent;
 			reg = <0xe8c11000 0x1000>,
 				<0xe8c12000 0x2000>;
 		};
-- 
2.35.1



