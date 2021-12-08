Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B09C46D3D0
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233858AbhLHM6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 07:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbhLHM6S (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Dec 2021 07:58:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D060C061746
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 04:54:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 520E3CE216A
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 12:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BE9C00446;
        Wed,  8 Dec 2021 12:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638968083;
        bh=eYY9criEr/a3LXRztwJlw+J/7OdPKpUCOneSNm9eaeE=;
        h=Subject:To:From:Date:From;
        b=uWEqCyLIEIXj51NexVSQAkXiYPq7sliuHM6eOXdP8ZbYJxokirq2Dis5q/da/F18t
         yfzb+bVH2kX0I4D8MH6OD7/Ftyx8rlTKvkjmqtv+rSi7mcz1lRCzVpmMhBs9eiLxk1
         7QBKLe2h6EdABuZ3GwpyS77RiHQ+iNmGf3Mwny14=
Subject: patch "iio: trigger: stm32-timer: fix MODULE_ALIAS" added to char-misc-linus
To:     hi@alyssa.is, Jonathan.Cameron@huawei.com, Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Dec 2021 13:53:59 +0100
Message-ID: <163896803922980@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: trigger: stm32-timer: fix MODULE_ALIAS

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 893621e0606747c5bbefcaf2794d12c7aa6212b7 Mon Sep 17 00:00:00 2001
From: Alyssa Ross <hi@alyssa.is>
Date: Thu, 25 Nov 2021 18:28:48 +0000
Subject: iio: trigger: stm32-timer: fix MODULE_ALIAS

modprobe can't handle spaces in aliases.

Fixes: 93fbe91b5521 ("iio: Add STM32 timer trigger driver")
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Link: https://lore.kernel.org/r/20211125182850.2645424-1-hi@alyssa.is
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/trigger/stm32-timer-trigger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/trigger/stm32-timer-trigger.c b/drivers/iio/trigger/stm32-timer-trigger.c
index 33083877cd19..4353b749ecef 100644
--- a/drivers/iio/trigger/stm32-timer-trigger.c
+++ b/drivers/iio/trigger/stm32-timer-trigger.c
@@ -912,6 +912,6 @@ static struct platform_driver stm32_timer_trigger_driver = {
 };
 module_platform_driver(stm32_timer_trigger_driver);
 
-MODULE_ALIAS("platform: stm32-timer-trigger");
+MODULE_ALIAS("platform:stm32-timer-trigger");
 MODULE_DESCRIPTION("STMicroelectronics STM32 Timer Trigger driver");
 MODULE_LICENSE("GPL v2");
-- 
2.34.1


