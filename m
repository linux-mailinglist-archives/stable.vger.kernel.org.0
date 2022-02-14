Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B8A4B49AE
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347363AbiBNK1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:27:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348046AbiBNK0m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:26:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F8880939;
        Mon, 14 Feb 2022 01:57:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DB96B80DC8;
        Mon, 14 Feb 2022 09:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9936CC340E9;
        Mon, 14 Feb 2022 09:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832648;
        bh=cK9ecw/EFhSoO7tLE759EsN5OX8WHGKfTJe7PYjYBbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IoNV7niv9mBeBo5UxmhMZYtzqU4JvfYIVYUHaYwcqsQ2N2NJLdFSYGtx7d62dRZl0
         pjFvRAYl8f0cSXW0N7MJWe32+9zjpIz0Cef7K0gUx1dWx86l9vX5tEgYq8zasnLdsg
         oFOTWYTxB8MPDRFFItYKQ0T5ocoscv7kJLUHHTZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stefan Hansson <newbyte@disroot.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.16 082/203] ARM: dts: Fix boot regression on Skomer
Date:   Mon, 14 Feb 2022 10:25:26 +0100
Message-Id: <20220214092513.064687097@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit d9058d6a0e92d8e4a00855f8fe204792f42794db upstream.

The signal routing on the Skomer board was incorrect making
it impossible to mount root from the SD card. Fix this up.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Cc: Stefan Hansson <newbyte@disroot.org>
Link: https://lore.kernel.org/r/20220205235312.446730-1-linus.walleij@linaro.org'
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/ste-ux500-samsung-skomer.dts |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-skomer.dts
@@ -185,10 +185,6 @@
 			cap-sd-highspeed;
 			cap-mmc-highspeed;
 			/* All direction control is used */
-			st,sig-dir-cmd;
-			st,sig-dir-dat0;
-			st,sig-dir-dat2;
-			st,sig-dir-dat31;
 			st,sig-pin-fbclk;
 			full-pwr-cycle;
 			vmmc-supply = <&ab8500_ldo_aux3_reg>;


