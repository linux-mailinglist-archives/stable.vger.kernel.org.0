Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5449D541529
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347754AbiFGU3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377068AbiFGU2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:28:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32061DAE79;
        Tue,  7 Jun 2022 11:33:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CAAFB82367;
        Tue,  7 Jun 2022 18:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78372C385A2;
        Tue,  7 Jun 2022 18:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626826;
        bh=EFmUdl9NrFEx7bbsKO6ZCv5QzcIZLGeHdaaADbLR9TU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mnnHyDCOvGutB6aatHO/z6Ig57oHIpCG2cGkXYJbxOlkUA9FaM6B1u7g9yjk9ybo9
         l9GMY6jEwscTBCRpqT8UmoyB8ln5r6WQ+rFax4m2MWw12SSpTVGC75vUMgKUPoiuXU
         mnZlbj+Jd3p5SnNx+Plw392v97jXC87AQabYGonc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 477/772] ARM: dts: bcm2837-rpi-cm3-io3: Fix GPIO line names for SMPS I2C
Date:   Tue,  7 Jun 2022 19:01:09 +0200
Message-Id: <20220607165003.049352180@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

[ Upstream commit 9fd26fd02749ec964eb0d588a3bab9e09bf77927 ]

The GPIOs 46 & 47 are already used for a I2C interface to a SMPS.
So fix the GPIO line names accordingly.

Fixes: a54fe8a6cf66 ("ARM: dts: add Raspberry Pi Compute Module 3 and IO board")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts b/arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts
index 588d9411ceb6..3dfce4312dfc 100644
--- a/arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts
+++ b/arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts
@@ -63,8 +63,8 @@
 			  "GPIO43",
 			  "GPIO44",
 			  "GPIO45",
-			  "GPIO46",
-			  "GPIO47",
+			  "SMPS_SCL",
+			  "SMPS_SDA",
 			  /* Used by eMMC */
 			  "SD_CLK_R",
 			  "SD_CMD_R",
-- 
2.35.1



