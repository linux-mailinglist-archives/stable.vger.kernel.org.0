Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5AC6D262A
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387738AbfJJJUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387478AbfJJJUu (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 10 Oct 2019 05:20:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AC4021D7A;
        Thu, 10 Oct 2019 09:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570699249;
        bh=qby+o55nipuRxov+w0S+fuJgofFCvVS/guCcruHdElI=;
        h=Subject:To:From:Date:From;
        b=v/FFBa+IKy93LkxZdYSyO4XVgsLuFGqSdlYe5dbp8kYLlGsxKl9mWTy9JxLMwZyM5
         72Jeq7yxfb1po3soPj/KShXYpXxLZM0mB6ejfPY7j5HrmNdmwuYSDLObchP+kROXuk
         a2ZWwV9xWcAhrJbzXh31r0qyRykOOUgiQ9hpL7kM=
Subject: patch "iio: Fix an undefied reference error in noa1305_probe" added to staging-linus
To:     zhongjiang@huawei.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Oct 2019 11:20:09 +0200
Message-ID: <15706992099520@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: Fix an undefied reference error in noa1305_probe

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a26e0fbe06e20077afdaa40d1a90092f16b0bc67 Mon Sep 17 00:00:00 2001
From: zhong jiang <zhongjiang@huawei.com>
Date: Mon, 23 Sep 2019 10:04:32 +0800
Subject: iio: Fix an undefied reference error in noa1305_probe

I hit the following error when compile the kernel.

drivers/iio/light/noa1305.o: In function `noa1305_probe':
noa1305.c:(.text+0x65): undefined reference to `__devm_regmap_init_i2c'
make: *** [vmlinux] Error 1

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
index 08d7e1ef2186..4a1a883dc061 100644
--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -314,6 +314,7 @@ config MAX44009
 config NOA1305
 	tristate "ON Semiconductor NOA1305 ambient light sensor"
 	depends on I2C
+	select REGMAP_I2C
 	help
 	 Say Y here if you want to build support for the ON Semiconductor
 	 NOA1305 ambient light sensor.
-- 
2.23.0


