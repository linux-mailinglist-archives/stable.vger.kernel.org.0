Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9EC77EC6
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 11:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbfG1J2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 05:28:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbfG1J2T (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 28 Jul 2019 05:28:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C71E20659;
        Sun, 28 Jul 2019 09:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564306098;
        bh=PTT4yp+KT78s6LWqEpFrDHWQSaMOen+m/twEj3myDLk=;
        h=Subject:To:From:Date:From;
        b=a7zhATGvKNy1m6RDkbztuFz9hv5yvMxH9/ROiwiA/Gz1MEgPpc1ZIcq837CzGZQlP
         oLSVv09TY4QLDdXLvCIhKX1RM5bMfjkFzQoExjfbX0ZxGvVM1QB3+Ptx++lue/SJkg
         eMUdrorHJ9zq4c/W4hmvy0sEBaxEBQyzGlvLw5Rk=
Subject: patch "iio: adc: max9611: Fix misuse of GENMASK macro" added to staging-linus
To:     joe@perches.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Jul 2019 11:28:16 +0200
Message-ID: <1564306096207238@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: max9611: Fix misuse of GENMASK macro

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ae8cc91a7d85e018c0c267f580820b2bb558cd48 Mon Sep 17 00:00:00 2001
From: Joe Perches <joe@perches.com>
Date: Tue, 9 Jul 2019 22:04:17 -0700
Subject: iio: adc: max9611: Fix misuse of GENMASK macro

Arguments are supposed to be ordered high then low.

Signed-off-by: Joe Perches <joe@perches.com>
Fixes: 69780a3bbc0b ("iio: adc: Add Maxim max9611 ADC driver")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/max9611.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/max9611.c b/drivers/iio/adc/max9611.c
index 917223d5ff5b..0e3c6529fc4c 100644
--- a/drivers/iio/adc/max9611.c
+++ b/drivers/iio/adc/max9611.c
@@ -83,7 +83,7 @@
 #define MAX9611_TEMP_MAX_POS		0x7f80
 #define MAX9611_TEMP_MAX_NEG		0xff80
 #define MAX9611_TEMP_MIN_NEG		0xd980
-#define MAX9611_TEMP_MASK		GENMASK(7, 15)
+#define MAX9611_TEMP_MASK		GENMASK(15, 7)
 #define MAX9611_TEMP_SHIFT		0x07
 #define MAX9611_TEMP_RAW(_r)		((_r) >> MAX9611_TEMP_SHIFT)
 #define MAX9611_TEMP_SCALE_NUM		1000000
-- 
2.22.0


