Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 226D418993A
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 11:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgCRKYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 06:24:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgCRKYb (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 18 Mar 2020 06:24:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53E6620775;
        Wed, 18 Mar 2020 10:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584527069;
        bh=XiCCMX2ejIz42xckZNbE2gR+njGsLL1rbmVijtp5oys=;
        h=Subject:To:From:Date:From;
        b=LlV7/+fAFXu9yGjjq8xQ1Hu+OPfKp74eZ2egskssUdPzShHxFaGfYt36LyGcMKEhy
         Eix59qLZnNcX3PB6pg3VT7drIwabHK4+2Vx5tLEjUgnfZzjQbkrA9L/hwMToRc0Xdb
         Ynry1+J84/WsL+lTRHJPlCSxhhlTvsHkgo4FK+4w=
Subject: patch "iio: accel: adxl372: Set iio_chan BE" added to staging-linus
To:     alexandru.tachici@analog.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 18 Mar 2020 11:24:19 +0100
Message-ID: <1584527059123141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: accel: adxl372: Set iio_chan BE

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From cb2116ff97859d34fda6cb561ac654415f4c6230 Mon Sep 17 00:00:00 2001
From: Alexandru Tachici <alexandru.tachici@analog.com>
Date: Wed, 19 Feb 2020 16:31:12 +0200
Subject: iio: accel: adxl372: Set iio_chan BE

Data stored in the iio-buffer is BE and this
should be specified in the iio_chan_spec struct.

Fixes: f4f55ce38e5f8 ("iio:adxl372: Add FIFO and interrupts support")
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/adxl372.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/accel/adxl372.c b/drivers/iio/accel/adxl372.c
index 67b8817995c0..60daf04ce188 100644
--- a/drivers/iio/accel/adxl372.c
+++ b/drivers/iio/accel/adxl372.c
@@ -237,6 +237,7 @@ static const struct adxl372_axis_lookup adxl372_axis_lookup_table[] = {
 		.realbits = 12,						\
 		.storagebits = 16,					\
 		.shift = 4,						\
+		.endianness = IIO_BE,					\
 	},								\
 }
 
-- 
2.25.1


