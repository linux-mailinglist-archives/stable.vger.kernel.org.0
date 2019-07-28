Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7796777EC8
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 11:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725961AbfG1J20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 05:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbfG1J2Z (ORCPT <rfc822;Stable@vger.kernel.org>);
        Sun, 28 Jul 2019 05:28:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69F4420659;
        Sun, 28 Jul 2019 09:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564306104;
        bh=8YjYCK2UzJdWnCJDbKHEMoeWiDIoyQfNfJ1qC2xzSBY=;
        h=Subject:To:From:Date:From;
        b=j+rYfBIMyphZXKW+gnmsWILMhaTcNvjQkShI23sakyRtlW4RcTLEQYiKsBk7/VDap
         o6DOrTjOJoqIv/+Xhmm9KbdrEnTqxVohQ1rqxfLRmAuSxf3r8+rcgOYaBVJQHCNGPc
         E2eC7cWTn3ckzrC3/r7Cam0SSJFGSgeIlPPNQJi4=
Subject: patch "iio: cros_ec_accel_legacy: Fix incorrect channel setting" added to staging-linus
To:     gwendal@chromium.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 28 Jul 2019 11:28:19 +0200
Message-ID: <156430609910771@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: cros_ec_accel_legacy: Fix incorrect channel setting

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6cdff99c9f7d7d28b87cf05dd464f7c7736332ae Mon Sep 17 00:00:00 2001
From: Gwendal Grignou <gwendal@chromium.org>
Date: Fri, 28 Jun 2019 12:17:09 -0700
Subject: iio: cros_ec_accel_legacy: Fix incorrect channel setting

INFO_SCALE is set both for each channel and all channels.
iio is using all channel setting, so the error was not user visible.

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/cros_ec_accel_legacy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/accel/cros_ec_accel_legacy.c b/drivers/iio/accel/cros_ec_accel_legacy.c
index 46bb2e421bb9..ad19d9c716f4 100644
--- a/drivers/iio/accel/cros_ec_accel_legacy.c
+++ b/drivers/iio/accel/cros_ec_accel_legacy.c
@@ -319,7 +319,6 @@ static const struct iio_chan_spec_ext_info cros_ec_accel_legacy_ext_info[] = {
 		.modified = 1,					        \
 		.info_mask_separate =					\
 			BIT(IIO_CHAN_INFO_RAW) |			\
-			BIT(IIO_CHAN_INFO_SCALE) |			\
 			BIT(IIO_CHAN_INFO_CALIBBIAS),			\
 		.info_mask_shared_by_all = BIT(IIO_CHAN_INFO_SCALE),	\
 		.ext_info = cros_ec_accel_legacy_ext_info,		\
-- 
2.22.0


