Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78F66DD8CE
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 13:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjDKLFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 07:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjDKLFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 07:05:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6250C4493
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 04:04:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52424622EB
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 11:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A025C433D2;
        Tue, 11 Apr 2023 11:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681210993;
        bh=PUo2KwPi+32FmETRMdw6mb3sILQum4eVzNLRiGO3z8E=;
        h=Subject:To:Cc:From:Date:From;
        b=a2K+TahT3Mrs0XzgcsHyauHLrnfoa3Kdj+mR2qCSvYxNKfQUK0mDfB5cjbKyaqxA5
         bP94IvX9o/EnERrU0iNW/UHwf88J2l/UXzt4yU1X/ByVd11NKXT1PUajMnc0MEMEWV
         SxTWCFyeMjmWKa+ktf82oO+ugJ85ztkPRzn/Vuks=
Subject: FAILED: patch "[PATCH] counter: 104-quad-8: Fix Synapse action reported for Index" failed to apply to 5.10-stable tree
To:     william.gray@linaro.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 13:03:02 +0200
Message-ID: <2023041102-fleshy-condiment-a713@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
git checkout FETCH_HEAD
git cherry-pick -x 00f4bc5184c19cb33f468f1ea409d70d19f8f502
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041102-fleshy-condiment-a713@gregkh' --subject-prefix 'PATCH 5.10.y' HEAD^..

Possible dependencies:

00f4bc5184c1 ("counter: 104-quad-8: Fix Synapse action reported for Index signals")
aaec1a0f76ec ("counter: Internalize sysfs interface code")
ea434ff82649 ("counter: stm32-timer-cnt: Provide defines for slave mode selection")
05593a3fd103 ("counter: stm32-lptimer-cnt: Provide defines for clock polarities")
394a0150a064 ("counter: Rename counter_count_function to counter_function")
493b938a14ed ("counter: Rename counter_signal_value to counter_signal_level")
b11eed1554e8 ("counter: Return error code on invalid modes")
728246e8f726 ("counter: 104-quad-8: Return error when invalid mode during ceiling_write")
d0ce3d5cf77d ("counter: stm32-timer-cnt: Add const qualifier for actions_list array")
f83e6e59366b ("counter: stm32-lptimer-cnt: Add const qualifier for actions_list array")
0056a405c7ad ("counter: microchip-tcb-capture: Add const qualifier for actions_list array")
9b2574f61c49 ("counter: ftm-quaddec: Add const qualifier for actions_list array")
6a9eb0e31044 ("counter: 104-quad-8: Add const qualifier for actions_list array")
45af9ae84c60 ("counter: stm32-timer-cnt: Add const qualifier for functions_list array")
8a00fed665ad ("counter: stm32-lptimer-cnt: Add const qualifier for functions_list array")
7e0dcfcefeca ("counter: microchip-tcb-capture: Add const qualifier for functions_list array")
891b58b35fd6 ("counter: interrupt-cnt: Add const qualifier for functions_list array")
fca2534fddfa ("counter: 104-quad-8: Add const qualifier for functions_list array")
b711f687a1c1 ("counter: Add support for Intel Quadrature Encoder Peripheral")
9c15db92a8e5 ("Merge tag 'iio-for-5.13a' of https://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-next")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 00f4bc5184c19cb33f468f1ea409d70d19f8f502 Mon Sep 17 00:00:00 2001
From: William Breathitt Gray <william.gray@linaro.org>
Date: Thu, 16 Mar 2023 16:34:26 -0400
Subject: [PATCH] counter: 104-quad-8: Fix Synapse action reported for Index
 signals

Signal 16 and higher represent the device's Index lines. The
priv->preset_enable array holds the device configuration for these Index
lines. The preset_enable configuration is active low on the device, so
invert the conditional check in quad8_action_read() to properly handle
the logical state of preset_enable.

Fixes: f1d8a071d45b ("counter: 104-quad-8: Add Generic Counter interface support")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230316203426.224745-1-william.gray@linaro.org/
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index d59e4f34a680..d9cb937665cf 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -368,7 +368,7 @@ static int quad8_action_read(struct counter_device *counter,
 
 	/* Handle Index signals */
 	if (synapse->signal->id >= 16) {
-		if (priv->preset_enable[count->id])
+		if (!priv->preset_enable[count->id])
 			*action = COUNTER_SYNAPSE_ACTION_RISING_EDGE;
 		else
 			*action = COUNTER_SYNAPSE_ACTION_NONE;

