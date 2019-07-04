Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA405F266
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 07:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfGDFwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 01:52:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725861AbfGDFwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Jul 2019 01:52:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4824A218A4;
        Thu,  4 Jul 2019 05:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562219523;
        bh=5NPmZ+EE9tGmh2y0KPL38rJ8TMfLExqpypM703Vpx4M=;
        h=Subject:To:From:Date:From;
        b=lmMNMwM/XUCAC6AL+2jnnF2FhIE3vNpIVzT1p5G1ACygv6DS7Cm92Q9sdIo+MWchb
         dejjwBxtUMXpFrnnmob9K1OoYV04fud8w1kFKu0D6WuBQPG8fKy2rkj7F687lHR76h
         IKKQgeSuVAMQSbIE/Y86MIiVcb9iKlrkUFVUUegk=
Subject: patch "drivers/usb/typec/tps6598x.c: fix portinfo width" added to usb-next
To:     nikolaus.voss@loewensteinmedical.de, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 04 Jul 2019 07:51:36 +0200
Message-ID: <1562219496192140@kroah.com>
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
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


