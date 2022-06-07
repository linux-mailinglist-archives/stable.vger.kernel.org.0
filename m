Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A671541C4A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382648AbiFGV6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383346AbiFGVxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:53:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BF6243EC8;
        Tue,  7 Jun 2022 12:11:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0DA7B81F6D;
        Tue,  7 Jun 2022 19:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378ADC36AFF;
        Tue,  7 Jun 2022 19:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629091;
        bh=n+ic4T+wFs4qD5yYsGfUnByUbXAWt25GtTmkq8wfrr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnlqmtStpXz7bCdMqUbScnSwN6elTVbBxS3CpiS0yHuNi1qKp2+/A+chiekUNuxMV
         0piyoQ9PMKfEZ+J6Jjh/PC4FVLy9fm4fEFYGJF1u1ZMpg1hdFvcitl0K324R09a9qI
         9lYr2tZ376LkGpz4J2c0o/vXzntLjhXFSR0ubbC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 566/879] ARM: dts: bcm2835-rpi-zero-w: Fix GPIO line name for Wifi/BT
Date:   Tue,  7 Jun 2022 19:01:24 +0200
Message-Id: <20220607165019.289866501@linuxfoundation.org>
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
index 243236bc1e00..8b043ab62dc8 100644
--- a/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts
+++ b/arch/arm/boot/dts/bcm2835-rpi-zero-w.dts
@@ -74,16 +74,18 @@
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



