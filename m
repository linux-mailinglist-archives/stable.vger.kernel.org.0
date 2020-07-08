Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F7F2180FD
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 09:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbgGHHVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 03:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729340AbgGHHVi (ORCPT <rfc822;Stable@vger.kernel.org>);
        Wed, 8 Jul 2020 03:21:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D02E20771;
        Wed,  8 Jul 2020 07:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594192897;
        bh=3NDrdZYqbDQ/kaKl3I74qf0//5RmFQS6/1yA93z4ctQ=;
        h=Subject:To:From:Date:From;
        b=WXGUMmIAu8ivslqbHewVKnoccWHBHW7sn/uhzlwQE2EEHzTh7Cz227WOHs8xJe3UF
         2OmMa+pgzNjsk6ePbXWwa7cD3RF9+12qVKlun5YRYEctigbYxvMhJVVTpz5Auf5xep
         Z5AcrIrjGFMMJv87NObS5QO4MFeSRLph7w+mNx1w=
Subject: patch "iio: core: add missing IIO_MOD_H2/ETHANOL string identifiers" added to staging-linus
To:     matt.ranostay@konsulko.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Jul 2020 09:21:28 +0200
Message-ID: <1594192888138156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: core: add missing IIO_MOD_H2/ETHANOL string identifiers

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 25f02d3242ab4d16d0cee2dec0d89cedb3747fa9 Mon Sep 17 00:00:00 2001
From: Matt Ranostay <matt.ranostay@konsulko.com>
Date: Tue, 9 Jun 2020 06:01:16 +0300
Subject: iio: core: add missing IIO_MOD_H2/ETHANOL string identifiers

Add missing strings to iio_modifier_names[] for proper modification
of channels.

Fixes: b170f7d48443d (iio: Add modifiers for ethanol and H2 gases)
Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/industrialio-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 1527f01a44f1..352533342702 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -130,6 +130,8 @@ static const char * const iio_modifier_names[] = {
 	[IIO_MOD_PM2P5] = "pm2p5",
 	[IIO_MOD_PM4] = "pm4",
 	[IIO_MOD_PM10] = "pm10",
+	[IIO_MOD_ETHANOL] = "ethanol",
+	[IIO_MOD_H2] = "h2",
 };
 
 /* relies on pairs of these shared then separate */
-- 
2.27.0


