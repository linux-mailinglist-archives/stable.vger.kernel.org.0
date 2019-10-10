Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60252D2627
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387590AbfJJJUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 05:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387478AbfJJJUm (ORCPT <rfc822;Stable@vger.kernel.org>);
        Thu, 10 Oct 2019 05:20:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1045821D56;
        Thu, 10 Oct 2019 09:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570699241;
        bh=65qmS9WpDrCCjb8XIKekHB2cF/M/IwayJZvi4BL+UZE=;
        h=Subject:To:From:Date:From;
        b=qcxeZGZAKhNBUq2TUjGwhO+TWHuVJ/eqLvz9qhJozPo7hXHLEfxAqC79zquFb3LyS
         7fZXCVU3VJDM0Xvl6ONOjdaiSkbT4cx7J79A32YTFRML7P8oRqRAIuUJiekTcdO1rd
         BqZyvuPZDd1OIBy/bq5Wdh+b67g7Y5bxq/i421Ho=
Subject: patch "iio: light: add missing vcnl4040 of_compatible" added to staging-linus
To:     m.felsch@pengutronix.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Oct 2019 11:20:08 +0200
Message-ID: <1570699208183134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: light: add missing vcnl4040 of_compatible

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 7fd1c2606508eb384992251e87d50591393a48d0 Mon Sep 17 00:00:00 2001
From: Marco Felsch <m.felsch@pengutronix.de>
Date: Tue, 17 Sep 2019 16:56:37 +0200
Subject: iio: light: add missing vcnl4040 of_compatible

Commit 5a441aade5b3 ("iio: light: vcnl4000 add support for the VCNL4040
proximity and light sensor") added the support for the vcnl4040 but
forgot to add the of_compatible. Fix this by adding it now.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Fixes: 5a441aade5b3 ("iio: light: vcnl4000 add support for the VCNL4040 proximity and light sensor")
Reviewed-by: Angus Ainslie (Purism) angus@akkea.ca
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/light/vcnl4000.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iio/light/vcnl4000.c b/drivers/iio/light/vcnl4000.c
index f522cb863e8c..16dacea9eadf 100644
--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -408,6 +408,10 @@ static const struct of_device_id vcnl_4000_of_match[] = {
 		.compatible = "vishay,vcnl4020",
 		.data = (void *)VCNL4010,
 	},
+	{
+		.compatible = "vishay,vcnl4040",
+		.data = (void *)VCNL4040,
+	},
 	{
 		.compatible = "vishay,vcnl4200",
 		.data = (void *)VCNL4200,
-- 
2.23.0


