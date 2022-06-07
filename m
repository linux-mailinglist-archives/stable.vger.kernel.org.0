Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467B4541C1A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352803AbiFGV4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383365AbiFGVxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:53:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DAC243EEF;
        Tue,  7 Jun 2022 12:11:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96A62B823B7;
        Tue,  7 Jun 2022 19:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAD9C3411C;
        Tue,  7 Jun 2022 19:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629094;
        bh=EFmUdl9NrFEx7bbsKO6ZCv5QzcIZLGeHdaaADbLR9TU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8OKxU7snTp2wMlJyf7hRRO/9C62Tp9nwCeuJeTSN05uriS9D0GhMACI5j/+kwIq2
         kBMiE5G47DOgsmLSnmjNRmaC8K0jKFnIJdMXf2gDuEFb+FEFhZwsUaiun1QeRtZD3d
         ul/ZIBYvG3m3i30Vpk1Wpr8QXeTYFx08JPpv+NIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 567/879] ARM: dts: bcm2837-rpi-cm3-io3: Fix GPIO line names for SMPS I2C
Date:   Tue,  7 Jun 2022 19:01:25 +0200
Message-Id: <20220607165019.318429221@linuxfoundation.org>
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



