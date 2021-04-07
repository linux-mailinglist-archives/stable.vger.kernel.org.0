Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCED356635
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 10:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344602AbhDGIPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 04:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233700AbhDGIPc (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 7 Apr 2021 04:15:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 499E3611AF;
        Wed,  7 Apr 2021 08:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617783321;
        bh=GE9jEXqIbzW7QFTvANxdh62E/e6uZcQw1EBM35UUT9c=;
        h=Subject:To:From:Date:From;
        b=pNH8jWl4/XDc5WWYEgaRVA9+6ePl7EUPXPPOfr21y5m1qoSMd5VpMna1F6oSGnylq
         KB47Jpz4YVHN9rV2hNzmon1MRzLXAf1p1ouZQ3qKKs/u5Kmo64k2joXQ58Egbo+7Rn
         awiFSgVvbw84wi3gNCktoOdDCo6vnEn/dWRSrTJI=
Subject: patch "iio: magnetometer: yas530: Include right header" added to staging-next
To:     linus.walleij@linaro.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, harvey.harrison@gmail.com, lkp@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 07 Apr 2021 10:10:39 +0200
Message-ID: <161778303913249@kroah.com>
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
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


