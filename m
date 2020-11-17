Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306C72B5C3E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 10:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgKQJwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 04:52:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbgKQJwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 04:52:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15F332465B;
        Tue, 17 Nov 2020 09:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605606764;
        bh=38pr+kXfmHiA9FaIYCblbhXcCLTj4t8xfGeT+4LacOk=;
        h=Subject:To:From:Date:From;
        b=M68stvTaSRztklOcUx2jsBmEicBfeBP+1EhAMpcYM6bWYFQR3toHw5GsMFYjGwLGT
         MN9TtsiY9+EqNahRj/cDtkc9ULjBW2/aFoaKkVdDYMcWuGP/T0XcDMjr9/gV0gdxcH
         T9TUs9+rowQuJHQuTj9B3j3UHUTooF70oONneUXs=
Subject: patch "iio/adc: ingenic: Fix battery VREF for JZ4770 SoC" added to staging-linus
To:     paul@crapouillou.net, Jonathan.Cameron@huawei.com,
        contact@artur-rojek.eu, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 17 Nov 2020 10:53:24 +0100
Message-ID: <160560680424846@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio/adc: ingenic: Fix battery VREF for JZ4770 SoC

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c91ebcc578e09783cfa4d85c1b437790f140f29a Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Wed, 4 Nov 2020 19:28:43 +0000
Subject: iio/adc: ingenic: Fix battery VREF for JZ4770 SoC

The reference voltage for the battery is clearly marked as 1.2V in the
programming manual. With this fixed, the battery channel now returns
correct values.

Fixes: a515d6488505 ("IIO: Ingenic JZ47xx: Add support for JZ4770 SoC ADC.")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Acked-by: Artur Rojek <contact@artur-rojek.eu>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201104192843.67187-1-paul@crapouillou.net
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/ingenic-adc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ingenic-adc.c b/drivers/iio/adc/ingenic-adc.c
index 92b25083e23f..973e84deebea 100644
--- a/drivers/iio/adc/ingenic-adc.c
+++ b/drivers/iio/adc/ingenic-adc.c
@@ -71,7 +71,7 @@
 #define JZ4725B_ADC_BATTERY_HIGH_VREF_BITS	10
 #define JZ4740_ADC_BATTERY_HIGH_VREF		(7500 * 0.986)
 #define JZ4740_ADC_BATTERY_HIGH_VREF_BITS	12
-#define JZ4770_ADC_BATTERY_VREF			6600
+#define JZ4770_ADC_BATTERY_VREF			1200
 #define JZ4770_ADC_BATTERY_VREF_BITS		12
 
 #define JZ_ADC_IRQ_AUX			BIT(0)
-- 
2.29.2


