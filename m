Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62B201BC874
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgD1Sco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:32:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729354AbgD1Scl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:32:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C81721707;
        Tue, 28 Apr 2020 18:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098760;
        bh=kOV7JqRDnFkxVT6LtsTvnIEUm78zYiAZ1wZkelLJWgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zewUpDqPZ9UQhPNo/esxjpC3nD2MxnNp+ywCDhNHHuAWUoC/8wiS/mDZhsX/1l5rQ
         v3q09jnYC6roTiDDLg/dYYvvIB850/hm7g3/YPApXdPKmu6t+P2vg+UJu5amvTP7QK
         0dtCuiJZbj4fqiKAxvz3zOC1OZA5s+4n/zn8lUkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars Engebretsen <lars@engebretsen.ch>,
        Stable@vger.kernel.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.6 081/167] iio: core: remove extra semi-colon from devm_iio_device_register() macro
Date:   Tue, 28 Apr 2020 20:24:17 +0200
Message-Id: <20200428182235.220522218@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
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
@@ -598,7 +598,7 @@ void iio_device_unregister(struct iio_de
  * 0 on success, negative error number on failure.
  */
 #define devm_iio_device_register(dev, indio_dev) \
-	__devm_iio_device_register((dev), (indio_dev), THIS_MODULE);
+	__devm_iio_device_register((dev), (indio_dev), THIS_MODULE)
 int __devm_iio_device_register(struct device *dev, struct iio_dev *indio_dev,
 			       struct module *this_mod);
 void devm_iio_device_unregister(struct device *dev, struct iio_dev *indio_dev);


