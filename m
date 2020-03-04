Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C753178DE7
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 10:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbgCDJ6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 04:58:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727002AbgCDJ6J (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 04:58:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F89A2072D;
        Wed,  4 Mar 2020 09:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583315889;
        bh=nLwims6HwXmlU6Az4Ou2RpnnAtr+qrF9Iykmlw8laOY=;
        h=Subject:To:From:Date:From;
        b=jSGq6omyKjGhXRPLa5YunBa0tDXHi1Dy9voYwKlh5hYhS5QN4GU6Zs3CiUUQaSWcb
         QM3pRuQ6DDatpuZlyCJeXa0Vh3nTJU2hviTeOb3Eg13ZtDDy+9JKfPmlNDLSmveFP+
         /6X0AtekezWJByDOGZEMmmyVwvgcJVBGkMhwFRzc=
Subject: patch "phy: allwinner: Fix GENMASK misuse" added to usb-linus
To:     rikard.falkeborn@gmail.com, gregkh@linuxfoundation.org,
        megous@megous.com, mripard@kernel.org, stable@vger.kernel.org,
        wens@csie.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Mar 2020 10:57:52 +0100
Message-ID: <15833158727313@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    phy: allwinner: Fix GENMASK misuse

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 96b4ea324ae92386db2b0c73ace597c80cde1ecb Mon Sep 17 00:00:00 2001
From: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Date: Sun, 23 Feb 2020 00:41:25 +0100
Subject: phy: allwinner: Fix GENMASK misuse

Arguments are supposed to be ordered high then low.

Fixes: a228890f9458 ("phy: allwinner: add phy driver for USB3 PHY on Allwinner H6 SoC")
Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Tested-by: Ondrej Jirman <megous@megous.com>
Signed-off-by: Ondrej Jirman <megous@megous.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191110124355.1569-1-rikard.falkeborn@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/allwinner/phy-sun50i-usb3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/allwinner/phy-sun50i-usb3.c b/drivers/phy/allwinner/phy-sun50i-usb3.c
index 1169f3e83a6f..b1c04f71a31d 100644
--- a/drivers/phy/allwinner/phy-sun50i-usb3.c
+++ b/drivers/phy/allwinner/phy-sun50i-usb3.c
@@ -49,7 +49,7 @@
 #define SUNXI_LOS_BIAS(n)		((n) << 3)
 #define SUNXI_LOS_BIAS_MASK		GENMASK(5, 3)
 #define SUNXI_TXVBOOSTLVL(n)		((n) << 0)
-#define SUNXI_TXVBOOSTLVL_MASK		GENMASK(0, 2)
+#define SUNXI_TXVBOOSTLVL_MASK		GENMASK(2, 0)
 
 struct sun50i_usb3_phy {
 	struct phy *phy;
-- 
2.25.1


