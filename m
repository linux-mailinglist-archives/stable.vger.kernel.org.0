Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F6E55C1B1
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237026AbiF0LoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237367AbiF0Lmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:42:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F5DDA0;
        Mon, 27 Jun 2022 04:37:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 643F5609D0;
        Mon, 27 Jun 2022 11:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7B6C3411D;
        Mon, 27 Jun 2022 11:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329829;
        bh=w8pEeD49eTpvRe45M7NoRlebckBgfBtMDWOyG0gSJaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3ptwaDU+hNCj01H7ROYVdR8iEFLRuzCE9HmRqnwidbSk+8xlEAf6gnvoHFiP3GB8
         RFabHgfaFu587c/8sw7uyvwphX19SM+xdieU6Rglpe2761FQILB6a6gxo0gFXWHu8h
         2H5+ZdFHRByrDGZ4+bFDPVOhEAoTzcdT7iAhkvCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Ivan T. Ivanov" <iivanov@suse.de>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.15 130/135] ARM: dts: bcm2711-rpi-400: Fix GPIO line names
Date:   Mon, 27 Jun 2022 13:22:17 +0200
Message-Id: <20220627111941.923820586@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

commit b9b6d4c925604b70d007feb4c77b8cc4c038d2da upstream.

The GPIO expander line names has been fixed in the vendor tree last year,
so upstream these changes.

Fixes: 1c701accecf2 ("ARM: dts: Add Raspberry Pi 400 support")
Reported-by: Ivan T. Ivanov <iivanov@suse.de>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/bcm2711-rpi-400.dts |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/boot/dts/bcm2711-rpi-400.dts
+++ b/arch/arm/boot/dts/bcm2711-rpi-400.dts
@@ -28,12 +28,12 @@
 &expgpio {
 	gpio-line-names = "BT_ON",
 			  "WL_ON",
-			  "",
+			  "PWR_LED_OFF",
 			  "GLOBAL_RESET",
 			  "VDD_SD_IO_SEL",
-			  "CAM_GPIO",
+			  "GLOBAL_SHUTDOWN",
 			  "SD_PWR_ON",
-			  "SD_OC_N";
+			  "SHUTDOWN_REQUEST";
 };
 
 &genet_mdio {


