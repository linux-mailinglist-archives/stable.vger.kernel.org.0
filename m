Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11011C1421
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbgEANgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730341AbgEANgG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:36:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86194216FD;
        Fri,  1 May 2020 13:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340166;
        bh=nB7gP91EFe3d08JibxkrjH5bmM8vd9VvuEXyswdD+/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jw7VxrtAMgBZCNGWJoA5FrIPWZa5S5Myf7nqtwNIc1kb0w8RYyhmg4LhE9POfeNPO
         DGoq7Tm7fTmRlbY+fBoJkvnI5F4S2EUxvEsFzymysX0nq0tsscoSGeQa0fHJYlSLc0
         PF+3vpGMg98H7WQXcWes75tTeIVI7PWCRxytr6/I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 07/46] iio:ad7797: Use correct attribute_group
Date:   Fri,  1 May 2020 15:22:32 +0200
Message-Id: <20200501131501.554087477@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131457.023036302@linuxfoundation.org>
References: <20200501131457.023036302@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit 28535877ac5b2b84f0d394fd67a5ec71c0c48b10 upstream.

It should use ad7797_attribute_group in ad7797_info,
according to commit ("iio:ad7793: Add support for the ad7796 and ad7797").

Scale is fixed for the ad7796 and not programmable, hence
should not have the scale_available attribute.

Fixes: fd1a8b912841 ("iio:ad7793: Add support for the ad7796 and ad7797")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/ad7793.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7793.c
+++ b/drivers/iio/adc/ad7793.c
@@ -542,7 +542,7 @@ static const struct iio_info ad7797_info
 	.read_raw = &ad7793_read_raw,
 	.write_raw = &ad7793_write_raw,
 	.write_raw_get_fmt = &ad7793_write_raw_get_fmt,
-	.attrs = &ad7793_attribute_group,
+	.attrs = &ad7797_attribute_group,
 	.validate_trigger = ad_sd_validate_trigger,
 };
 


