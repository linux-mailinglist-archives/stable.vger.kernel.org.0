Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C4D5EA59D
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239253AbiIZMJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235272AbiIZMIU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:08:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C683D7FE46;
        Mon, 26 Sep 2022 03:56:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B72E6B802C5;
        Mon, 26 Sep 2022 10:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1331DC433D6;
        Mon, 26 Sep 2022 10:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189233;
        bh=bcAJ4z+RO/wsgHLdxnKwfFtoMvVcRDNQlF5P/39RL6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bYR3a68FD1S7J8esMZBXW55QiK5HYKNxAluagndrglfo0Y0t3H5EeRG1drFkejFok
         Y10ZsRlzYLNnvMW6h4GVS0znoB2Img92kkEZTd4fuUq1ZLCntRkjYDflTUitBAFYWg
         CApDiUkfWA9kEFN6ySomlfY3qMQ7kkrwr7nEsq2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 100/207] ARM: dts: lan966x: Fix the interrupt number for internal PHYs
Date:   Mon, 26 Sep 2022 12:11:29 +0200
Message-Id: <20220926100811.060351218@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit f5fc22cbbdcd349402faaddf1a07eb8403658ae8 ]

According to the datasheet the interrupts for internal PHYs are
80 and 81.

Fixes: 6ad69e07def67c ("ARM: dts: lan966x: add MIIM nodes")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220912192629.461452-1-horatiu.vultur@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/lan966x.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/lan966x.dtsi b/arch/arm/boot/dts/lan966x.dtsi
index 38e90a31d2dd..25c19f9d0a12 100644
--- a/arch/arm/boot/dts/lan966x.dtsi
+++ b/arch/arm/boot/dts/lan966x.dtsi
@@ -515,13 +515,13 @@ mdio1: mdio@e200413c {
 
 			phy0: ethernet-phy@1 {
 				reg = <1>;
-				interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 
 			phy1: ethernet-phy@2 {
 				reg = <2>;
-				interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 		};
-- 
2.35.1



