Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8875E97B
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 18:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfGCQrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 12:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:51358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbfGCQrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 12:47:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9046B2189E;
        Wed,  3 Jul 2019 16:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562172436;
        bh=gTJzFZ9To3+KtqnUf21LuumOPLHHLW5i9sWE1ihzwd0=;
        h=Subject:To:From:Date:From;
        b=O7hA6rK1/L6UJ4TNJm2NFI4l2waVtJ8d8kQ+gFuWh53Q5oxtO7cdHAqbgprSMoV9u
         QEa24a0KzdxdMHofCOvb3ZGN34zHSc32i1SXOg+r5mLpV1b/dWpMBZ/luNUNQcxLO1
         9I3epy9tizxpbS9xK86ZTJAspCz2ruolLWUHo5X8=
Subject: patch "drivers/usb/typec/tps6598x.c: fix portinfo width" added to usb-testing
To:     nikolaus.voss@loewensteinmedical.de, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 03 Jul 2019 18:47:05 +0200
Message-ID: <15621724258100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    drivers/usb/typec/tps6598x.c: fix portinfo width

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 05da75fc651138e51ff74ace97174349910463f5 Mon Sep 17 00:00:00 2001
From: Nikolaus Voss <nikolaus.voss@loewensteinmedical.de>
Date: Fri, 28 Jun 2019 11:01:08 +0200
Subject: drivers/usb/typec/tps6598x.c: fix portinfo width

Portinfo bit field is 3 bits wide, not 2 bits. This led to
a wrong driver configuration for some tps6598x configurations.

Fixes: 0a4c005bd171 ("usb: typec: driver for TI TPS6598x USB Power Delivery controllers")
Signed-off-by: Nikolaus Voss <nikolaus.voss@loewensteinmedical.de>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tps6598x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tps6598x.c b/drivers/usb/typec/tps6598x.c
index c674abe3cf99..a170c49c2542 100644
--- a/drivers/usb/typec/tps6598x.c
+++ b/drivers/usb/typec/tps6598x.c
@@ -41,7 +41,7 @@
 #define TPS_STATUS_VCONN(s)		(!!((s) & BIT(7)))
 
 /* TPS_REG_SYSTEM_CONF bits */
-#define TPS_SYSCONF_PORTINFO(c)		((c) & 3)
+#define TPS_SYSCONF_PORTINFO(c)		((c) & 7)
 
 enum {
 	TPS_PORTINFO_SINK,
-- 
2.22.0


