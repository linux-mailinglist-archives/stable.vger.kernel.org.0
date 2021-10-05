Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0133D42221F
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 11:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhJEJX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 05:23:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233344AbhJEJX2 (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 5 Oct 2021 05:23:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87DAA61108;
        Tue,  5 Oct 2021 09:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633425697;
        bh=J5BIjn9hYNVu8iDrFl5taFz/BpGyuEa/PDtckRd/Pf0=;
        h=Subject:To:From:Date:From;
        b=ij+yBC4ySUZFlk0rNze9I87iC8sSUiu7siq+8BR8wSCYJh73t3FTPuZyp20meJLNa
         wAsK/U+Ik5GgbbDBm1WebaoIBtvAvWftNXFT0n2g74WbYNrUXgYhv62GwcAMFxv0SH
         UdIx+tvMFnRju6XwIp6UnHOF1ccj13yL53aiq+2I=
Subject: patch "iio: adc: aspeed: set driver data when adc probe." added to staging-linus
To:     billy_tsai@aspeedtech.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 11:21:22 +0200
Message-ID: <163342568217245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: aspeed: set driver data when adc probe.

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From eb795cd97365a3d3d9da3926d234a7bc32a3bb15 Mon Sep 17 00:00:00 2001
From: Billy Tsai <billy_tsai@aspeedtech.com>
Date: Tue, 31 Aug 2021 15:14:44 +0800
Subject: iio: adc: aspeed: set driver data when adc probe.

Fix the issue when adc remove will get the null driver data.

Fixed: commit 573803234e72 ("iio: Aspeed ADC")
Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Link: https://lore.kernel.org/r/20210831071458.2334-2-billy_tsai@aspeedtech.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/aspeed_adc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/aspeed_adc.c b/drivers/iio/adc/aspeed_adc.c
index 19efaa41bc34..34ec0c28b2df 100644
--- a/drivers/iio/adc/aspeed_adc.c
+++ b/drivers/iio/adc/aspeed_adc.c
@@ -183,6 +183,7 @@ static int aspeed_adc_probe(struct platform_device *pdev)
 
 	data = iio_priv(indio_dev);
 	data->dev = &pdev->dev;
+	platform_set_drvdata(pdev, indio_dev);
 
 	data->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(data->base))
-- 
2.33.0


