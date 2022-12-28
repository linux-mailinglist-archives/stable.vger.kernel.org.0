Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CA16579A0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbiL1PDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbiL1PDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:03:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B8E12D24
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:03:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4DB96154C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69E5C433EF;
        Wed, 28 Dec 2022 15:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239783;
        bh=R7eEvx7+R5QLJO+xBoq0aYJw0hQrhodQIEGIk3zghV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vb88QNY/fcpftFN0bPo1+pw+U0520A6p7pi3BAoVIOME7gJFhz7deAHIsI55vH5K/
         Rc7qbISoasFDcbbm71ey/psT7PuMjBbgLOWOfGu4DfsFyDTZv9/qL8tNtkro87TnA7
         r8OPZ0zkRRoWWidc9k8KtFUTnlpaGZchJvRmECJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0078/1073] ARM: dts: armada-39x: Fix compatible string for gpios
Date:   Wed, 28 Dec 2022 15:27:46 +0100
Message-Id: <20221228144330.189148748@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Pali Rohár <pali@kernel.org>

[ Upstream commit d10886a4e6f85ee18d47a1066a52168461370ded ]

Armada 39x supports per CPU interrupts for gpios, like Armada XP.

So add compatible string "marvell,armadaxp-gpio" for Armada 39x GPIO nodes.

Driver gpio-mvebu.c which handles both pre-XP and XP variants already
provides support for per CPU interrupts on XP and newer variants.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: d81a914fc630 ("ARM: dts: mvebu: armada-39x: add missing nodes describing GPIO's")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-39x.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/armada-39x.dtsi b/arch/arm/boot/dts/armada-39x.dtsi
index 9525e7b7f436..9aad10fd3823 100644
--- a/arch/arm/boot/dts/armada-39x.dtsi
+++ b/arch/arm/boot/dts/armada-39x.dtsi
@@ -213,7 +213,7 @@ nand_pins: nand-pins {
 			};
 
 			gpio0: gpio@18100 {
-				compatible = "marvell,orion-gpio";
+				compatible = "marvell,armadaxp-gpio", "marvell,orion-gpio";
 				reg = <0x18100 0x40>;
 				ngpios = <32>;
 				gpio-controller;
@@ -227,7 +227,7 @@ gpio0: gpio@18100 {
 			};
 
 			gpio1: gpio@18140 {
-				compatible = "marvell,orion-gpio";
+				compatible = "marvell,armadaxp-gpio", "marvell,orion-gpio";
 				reg = <0x18140 0x40>;
 				ngpios = <28>;
 				gpio-controller;
-- 
2.35.1



