Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A2956FB9A
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbiGKJct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiGKJcN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:32:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D013C4330F;
        Mon, 11 Jul 2022 02:17:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB32D61243;
        Mon, 11 Jul 2022 09:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3689C341C0;
        Mon, 11 Jul 2022 09:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531044;
        bh=sHcfpShKWSDRKQYb8GObnyX1seYyzwG9Pz2xF486Y9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3OXiC661ocFEmfXf4AXNmQUHiaaq5j5N+YfRtYZWsF0qYphlBZidyApwbkLMXtRW
         23fZCl26JefuXfsoBGCZwfn6nFUlTEFO69T8pvu/F3VKBth3yUp8mY6xdTSh1PL4oy
         pkTClaSO116nQJH/oezYuUaYSLEzwhU2KEc4v54U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 074/112] ARM: dts: at91: sama5d2_icp: fix eeprom compatibles
Date:   Mon, 11 Jul 2022 11:07:14 +0200
Message-Id: <20220711090551.672969978@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 416ce193d73a734ded6d09fe141017b38af1c567 ]

The eeprom memories on the board are microchip 24aa025e48, which are 2 Kbits
and are compatible with at24c02 not at24c32.

Fixes: 68a95ef72cefe ("ARM: dts: at91: sama5d2-icp: add SAMA5D2-ICP")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220607090455.80433-2-eugen.hristev@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama5d2_icp.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/at91-sama5d2_icp.dts b/arch/arm/boot/dts/at91-sama5d2_icp.dts
index 806eb1d911d7..164201a8fbf2 100644
--- a/arch/arm/boot/dts/at91-sama5d2_icp.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_icp.dts
@@ -329,21 +329,21 @@
 	status = "okay";
 
 	eeprom@50 {
-		compatible = "atmel,24c32";
+		compatible = "atmel,24c02";
 		reg = <0x50>;
 		pagesize = <16>;
 		status = "okay";
 	};
 
 	eeprom@52 {
-		compatible = "atmel,24c32";
+		compatible = "atmel,24c02";
 		reg = <0x52>;
 		pagesize = <16>;
 		status = "disabled";
 	};
 
 	eeprom@53 {
-		compatible = "atmel,24c32";
+		compatible = "atmel,24c02";
 		reg = <0x53>;
 		pagesize = <16>;
 		status = "disabled";
-- 
2.35.1



