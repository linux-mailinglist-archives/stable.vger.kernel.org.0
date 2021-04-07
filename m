Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96ACC356626
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240718AbhDGIMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:42950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233700AbhDGIMH (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 7 Apr 2021 04:12:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52E4761005;
        Wed,  7 Apr 2021 08:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617783118;
        bh=IKHTn1OpPi0qWFWxmtAxyMQFWxPkTb9jDGsGCty6gZs=;
        h=Subject:To:From:Date:From;
        b=gCLhcvGV1VlO9ajVbRAIcsGqhMn6xFWvQvIoPMBqZrv7fhzO/DmQnf2KTwxCBZKC/
         J2xQ36FyCjUuwgDYhgskrhm+iHZZM7qlZX2z0JKwarr2jWU6V0rXKuiRot4yLkFH4j
         CWJiavc6C+2JGMh2ZiU+a3qMFBuE34S9xaJCzj6c=
Subject: patch "iio: magnetometer: yas530: Include right header" added to staging-testing
To:     linus.walleij@linaro.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, harvey.harrison@gmail.com, lkp@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 07 Apr 2021 10:09:19 +0200
Message-ID: <1617782959127195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: magnetometer: yas530: Include right header

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From bb354aeb364f9dee51e16edfdf6194ce4ba9237e Mon Sep 17 00:00:00 2001
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 15 Feb 2021 16:30:32 +0100
Subject: iio: magnetometer: yas530: Include right header

To get access to the big endian byte order parsing helpers
drivers need to include <asm/unaligned.h> and nothing else.

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210215153032.47962-1-linus.walleij@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/magnetometer/yamaha-yas530.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/magnetometer/yamaha-yas530.c b/drivers/iio/magnetometer/yamaha-yas530.c
index cee6207d8847..2f2f8cb3c26c 100644
--- a/drivers/iio/magnetometer/yamaha-yas530.c
+++ b/drivers/iio/magnetometer/yamaha-yas530.c
@@ -32,13 +32,14 @@
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 #include <linux/random.h>
-#include <linux/unaligned/be_byteshift.h>
 
 #include <linux/iio/buffer.h>
 #include <linux/iio/iio.h>
 #include <linux/iio/trigger_consumer.h>
 #include <linux/iio/triggered_buffer.h>
 
+#include <asm/unaligned.h>
+
 /* This register map covers YAS530 and YAS532 but differs in YAS 537 and YAS539 */
 #define YAS5XX_DEVICE_ID		0x80
 #define YAS5XX_ACTUATE_INIT_COIL	0x81
-- 
2.31.1


