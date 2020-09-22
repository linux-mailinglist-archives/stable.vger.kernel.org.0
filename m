Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2AB22746C2
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 18:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgIVQhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 12:37:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgIVQhX (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 22 Sep 2020 12:37:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 150A8239D2;
        Tue, 22 Sep 2020 16:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600792643;
        bh=XEZ4MwBZbCDJkYU4fVNtraNK2OvU2KYkLalKB2g4aLc=;
        h=Subject:To:From:Date:From;
        b=QC5eACJD1X9orfXwM/Q8EnYcOgacKdNY9cM4XEhh8Sa12dJHK6eb3CjRWGAjKLFdF
         BD7Xm39pXHu79cI8dsoUt3KhsgX/R7GikGagbtkNSGSI3NUqdNebU7e16HVmWSbsmt
         iy7Z76/EuapSSgaEYPpFnoTPsyvh4jxS2G1AR+gw=
Subject: patch "iio: adc: qcom-spmi-adc5: fix driver name" added to staging-linus
To:     dmitry.baryshkov@linaro.org, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, manivannan.sadhasivam@linaro.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 22 Sep 2020 18:37:36 +0200
Message-ID: <1600792656855@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: qcom-spmi-adc5: fix driver name

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fdb29f4de1374483291232ae7515e5e7bb464762 Mon Sep 17 00:00:00 2001
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Thu, 10 Sep 2020 16:59:51 +0300
Subject: iio: adc: qcom-spmi-adc5: fix driver name

Remove superfluous '.c' from qcom-spmi-adc5 device driver name.
Fixes: e13d757279bb ("iio: adc: Add QCOM SPMI PMIC5 ADC driver")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200910140000.324091-2-dmitry.baryshkov@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/qcom-spmi-adc5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/qcom-spmi-adc5.c b/drivers/iio/adc/qcom-spmi-adc5.c
index b4b73c9920b4..c10aa28be70a 100644
--- a/drivers/iio/adc/qcom-spmi-adc5.c
+++ b/drivers/iio/adc/qcom-spmi-adc5.c
@@ -982,7 +982,7 @@ static int adc5_probe(struct platform_device *pdev)
 
 static struct platform_driver adc5_driver = {
 	.driver = {
-		.name = "qcom-spmi-adc5.c",
+		.name = "qcom-spmi-adc5",
 		.of_match_table = adc5_match_table,
 	},
 	.probe = adc5_probe,
-- 
2.28.0


