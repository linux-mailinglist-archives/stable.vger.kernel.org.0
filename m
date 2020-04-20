Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABA21B08E1
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgDTMJY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:09:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgDTMJY (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:09:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAC61206DD;
        Mon, 20 Apr 2020 12:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587384563;
        bh=/qs1t9M6hWY3vANHcQND2IJMJOV4Peau2oeMEPeqFl4=;
        h=Subject:To:From:Date:From;
        b=tN8dhFYXA7Way5CHOKYweXCI2ZsfWbsWPTJh+tEAKrkedHCQmJnRZYBColKS+WZjy
         8CHE+kyth7LsEfvSM7crt3/wMaEg5R3AtAgztmCnZs1OpATpRHA6yZIrDzycEWvh9G
         KLa+pbVPXPfACivuwZTgfc1fGW9OP59a+YSM55+M=
Subject: patch "iio: core: remove extra semi-colon from devm_iio_device_register()" added to staging-linus
To:     lars@engebretsen.ch, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, alexandru.ardelean@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Apr 2020 14:08:50 +0200
Message-ID: <158738453014596@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: core: remove extra semi-colon from devm_iio_device_register()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a07479147be03d2450376ebaff9ea1a0682f25d6 Mon Sep 17 00:00:00 2001
From: Lars Engebretsen <lars@engebretsen.ch>
Date: Wed, 15 Apr 2020 12:10:43 +0200
Subject: iio: core: remove extra semi-colon from devm_iio_device_register()
 macro

This change removes the semi-colon from the devm_iio_device_register()
macro which seems to have been added by accident.

Fixes: 63b19547cc3d9 ("iio: Use macro magic to avoid manual assign of driver_module")
Signed-off-by: Lars Engebretsen <lars@engebretsen.ch>
Cc: <Stable@vger.kernel.org>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 include/linux/iio/iio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index eed58ed2f368..4e7848415c4f 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -600,7 +600,7 @@ void iio_device_unregister(struct iio_dev *indio_dev);
  * 0 on success, negative error number on failure.
  */
 #define devm_iio_device_register(dev, indio_dev) \
-	__devm_iio_device_register((dev), (indio_dev), THIS_MODULE);
+	__devm_iio_device_register((dev), (indio_dev), THIS_MODULE)
 int __devm_iio_device_register(struct device *dev, struct iio_dev *indio_dev,
 			       struct module *this_mod);
 void devm_iio_device_unregister(struct device *dev, struct iio_dev *indio_dev);
-- 
2.26.1


