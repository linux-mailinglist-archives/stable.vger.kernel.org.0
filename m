Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2764E549198
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357147AbiFML6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357134AbiFML4C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:56:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8272C30550;
        Mon, 13 Jun 2022 03:56:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C7FD60EFE;
        Mon, 13 Jun 2022 10:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E39C3411C;
        Mon, 13 Jun 2022 10:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117769;
        bh=O2U7niaNKRznqwGIrZsnCrwPoHy13uTgEBBLHKiI2xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eN/CXyAhYplwpP7LFlaPGgmbOmCQqOYrS4LYhqvn+p3JoJnCC9qExUVFWDC27hhna
         aFbkwuLK3Wgdb13iMi/Lriq812+XqiGZJUrrTTYttg24xCDGD1c+x3iIJoZhEXth47
         1Uyj6+FpR57YNl1IAsfd5jL1yL7Zz3IzfrtpxP+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/287] ARM: dts: bcm2835-rpi-zero-w: Fix GPIO line name for Wifi/BT
Date:   Mon, 13 Jun 2022 12:08:57 +0200
Message-Id: <20220613094927.304273773@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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

[ Upstream commit 2c663e5e5bbf2a5b85e0f76ccb69663f583c3e33 ]

The GPIOs 30 to 39 are connected to the Cypress CYW43438 (Wifi/BT).
So fix the GPIO line names accordingly.

Fixes: 2c7c040c73e9 ("ARM: dts: bcm2835: Add Raspberry Pi Zero W")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts b/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts
index 9f7145b1cc5e..3509582f92f1 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts
@@ -77,16 +77,18 @@
 			  "GPIO27",
 			  "SDA0",
 			  "SCL0",
-			  "NC", /* GPIO30 */
-			  "NC", /* GPIO31 */
-			  "NC", /* GPIO32 */
-			  "NC", /* GPIO33 */
-			  "NC", /* GPIO34 */
-			  "NC", /* GPIO35 */
-			  "NC", /* GPIO36 */
-			  "NC", /* GPIO37 */
-			  "NC", /* GPIO38 */
-			  "NC", /* GPIO39 */
+			  /* Used by BT module */
+			  "CTS0",
+			  "RTS0",
+			  "TXD0",
+			  "RXD0",
+			  /* Used by Wifi */
+			  "SD1_CLK",
+			  "SD1_CMD",
+			  "SD1_DATA0",
+			  "SD1_DATA1",
+			  "SD1_DATA2",
+			  "SD1_DATA3",
 			  "CAM_GPIO1", /* GPIO40 */
 			  "WL_ON", /* GPIO41 */
 			  "NC", /* GPIO42 */
-- 
2.35.1



