Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7251E56FACE
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbiGKJWQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbiGKJVh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:21:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F8E2A97B;
        Mon, 11 Jul 2022 02:13:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 583EECE1179;
        Mon, 11 Jul 2022 09:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3781BC341C8;
        Mon, 11 Jul 2022 09:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530781;
        bh=QsAgcrn3JaM1/cl3jwrUuw5oVetSOCyWU9vP3p1d5M4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCaeFaDjQZpITrZMRXNAXyvDYof+HkSewvuWy2un0ClHdWUWQXgEg7KHWyoDBqdTt
         l1FSIV6TgcBey2bJ8VP/N2HJKnT/XX1LPwA6OEeferE642AMnWm/bFw/Eery9c6Ukn
         mqxK3djw6svkX1Z+PX+Ep2g6iuQyMHfRzI9T1mrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/55] ARM: dts: at91: sama5d2_icp: fix eeprom compatibles
Date:   Mon, 11 Jul 2022 11:07:25 +0200
Message-Id: <20220711090542.853593520@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
References: <20220711090541.764895984@linuxfoundation.org>
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
index 308d472bd104..634411d13b4a 100644
--- a/arch/arm/boot/dts/at91-sama5d2_icp.dts
+++ b/arch/arm/boot/dts/at91-sama5d2_icp.dts
@@ -317,21 +317,21 @@
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



