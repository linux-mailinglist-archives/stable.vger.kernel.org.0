Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A07541C55
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382501AbiFGV54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383376AbiFGVxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:53:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52391F61F;
        Tue,  7 Jun 2022 12:11:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E66C1612EC;
        Tue,  7 Jun 2022 19:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE27FC341C0;
        Tue,  7 Jun 2022 19:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629097;
        bh=ubdgmShlCAdXqWClDZ6Hb0uAyoLVgtwPZpi13NuRjMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ks2Db3BEx40hEI5vHiZtxTDtGbB7U8GDN1fkJEJ7j/52+fbL9ErvA7nDuBoFBPghb
         Cg+lOGaTZzEOaq6UFgi9GhzfEiMeSLpIEoon40P11osd9SpVxDERCo/MHMfzEY7PLO
         2t378zmvna5OrCQqlEfUPwwgaUx0+FHcHWY3+iZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 568/879] ARM: dts: bcm2837-rpi-3-b-plus: Fix GPIO line name of power LED
Date:   Tue,  7 Jun 2022 19:01:26 +0200
Message-Id: <20220607165019.346592633@linuxfoundation.org>
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

From: Phil Elwell <phil@raspberrypi.com>

[ Upstream commit 57f718aa4b93392fb1a8c0a874ab882b9e18136a ]

The red LED on the Raspberry Pi 3 B Plus is the power LED.
So fix the GPIO line name accordingly.

Fixes: 71c0cd2283f2 ("ARM: dts: bcm2837: Add Raspberry Pi 3 B+")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts b/arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts
index e12938baaf12..c263f5b48b96 100644
--- a/arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts
+++ b/arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts
@@ -45,7 +45,7 @@
 		#gpio-cells = <2>;
 		gpio-line-names = "BT_ON",
 				  "WL_ON",
-				  "STATUS_LED_R",
+				  "PWR_LED_R",
 				  "LAN_RUN",
 				  "",
 				  "CAM_GPIO0",
-- 
2.35.1



