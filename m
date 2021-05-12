Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F77237CB19
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242360AbhELQee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241459AbhELQ1U (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A84C61DCF;
        Wed, 12 May 2021 15:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834765;
        bh=s3tGQ9UwHytX5Q2vyQ9xT5vry/2ryPXxWMtK3jK/U+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIg250da3LbKIsNDMUt/sA+u0SE0muLgRBueYOQIvHEweL2gmtQSNCEsQDKDueGj8
         /cmvjViRj1CYk5L40ttPclah4CHJ24AuUBqU4V1VPw+gF6kMQ7mNongIe7TFLqCWGN
         Ju8b3GV4z1o55V3aeIyVilQFm1bnLfOcmghi/+dY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.12 040/677] iio: magnetometer: yas530: Include right header
Date:   Wed, 12 May 2021 16:41:26 +0200
Message-Id: <20210512144838.541776265@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

commit bb354aeb364f9dee51e16edfdf6194ce4ba9237e upstream.

To get access to the big endian byte order parsing helpers
drivers need to include <asm/unaligned.h> and nothing else.

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210215153032.47962-1-linus.walleij@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/yamaha-yas530.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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


