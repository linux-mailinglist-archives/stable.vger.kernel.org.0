Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00BB08DA8D
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730324AbfHNRMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729616AbfHNRMY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:12:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 513062063F;
        Wed, 14 Aug 2019 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802743;
        bh=ocwnyKs1rifK7iP2Y5EL/eziwLUfhU6jkrxnY1uaWtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HKWwuPqcHNdeWO+fu0XvF5OyV65xw2Qt9lcv66HSMK7sftgsntAEy6wO242F3qoKU
         QpRMVOPn26OqbVgQ6Ah/m1fePBrqMF6dvbP2Q+s06uUoDI0kIHbkdG/fVGd9otM2z3
         K9nnejGYe+v0gTABD3V0Dq9HZw36aIgSeSKulBHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Perches <joe@perches.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 01/69] iio: adc: max9611: Fix misuse of GENMASK macro
Date:   Wed, 14 Aug 2019 19:00:59 +0200
Message-Id: <20190814165745.273353691@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Perches <joe@perches.com>

commit ae8cc91a7d85e018c0c267f580820b2bb558cd48 upstream.

Arguments are supposed to be ordered high then low.

Signed-off-by: Joe Perches <joe@perches.com>
Fixes: 69780a3bbc0b ("iio: adc: Add Maxim max9611 ADC driver")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/max9611.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/max9611.c
+++ b/drivers/iio/adc/max9611.c
@@ -86,7 +86,7 @@
 #define MAX9611_TEMP_MAX_POS		0x7f80
 #define MAX9611_TEMP_MAX_NEG		0xff80
 #define MAX9611_TEMP_MIN_NEG		0xd980
-#define MAX9611_TEMP_MASK		GENMASK(7, 15)
+#define MAX9611_TEMP_MASK		GENMASK(15, 7)
 #define MAX9611_TEMP_SHIFT		0x07
 #define MAX9611_TEMP_RAW(_r)		((_r) >> MAX9611_TEMP_SHIFT)
 #define MAX9611_TEMP_SCALE_NUM		1000000


