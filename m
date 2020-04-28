Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E451BC96A
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgD1SlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:32798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730599AbgD1SlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:41:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E6D4208E0;
        Tue, 28 Apr 2020 18:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099281;
        bh=QxXkUMHVI780GIgldXETM7qyhQBnhJ7oqqVPq9mx3/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ciX/Wv+yFnmkuDfJOQxCOtP6cek2vAbnYV+W/9lNmW4T7I79BDc89XjTOtEeykWmh
         T81vM6G5W1cEy9d0OYq94OylzZ/gzA2pLqwoTLCTLYHufnb0jU+/JrbfACSCtHtHvi
         aeiHviWfcwyx1wmOJOwPUIYGLSvyheseIwB3kGYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars Engebretsen <lars@engebretsen.ch>,
        Stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 087/168] iio: core: remove extra semi-colon from devm_iio_device_register() macro
Date:   Tue, 28 Apr 2020 20:24:21 +0200
Message-Id: <20200428182243.321479028@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars Engebretsen <lars@engebretsen.ch>

commit a07479147be03d2450376ebaff9ea1a0682f25d6 upstream.

This change removes the semi-colon from the devm_iio_device_register()
macro which seems to have been added by accident.

Fixes: 63b19547cc3d9 ("iio: Use macro magic to avoid manual assign of driver_module")
Signed-off-by: Lars Engebretsen <lars@engebretsen.ch>
Cc: <Stable@vger.kernel.org>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/iio/iio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -596,7 +596,7 @@ void iio_device_unregister(struct iio_de
  * 0 on success, negative error number on failure.
  */
 #define devm_iio_device_register(dev, indio_dev) \
-	__devm_iio_device_register((dev), (indio_dev), THIS_MODULE);
+	__devm_iio_device_register((dev), (indio_dev), THIS_MODULE)
 int __devm_iio_device_register(struct device *dev, struct iio_dev *indio_dev,
 			       struct module *this_mod);
 void devm_iio_device_unregister(struct device *dev, struct iio_dev *indio_dev);


