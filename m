Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D600F28246D
	for <lists+stable@lfdr.de>; Sat,  3 Oct 2020 16:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgJCODP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Oct 2020 10:03:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgJCODP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Oct 2020 10:03:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA743206A5;
        Sat,  3 Oct 2020 14:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601733793;
        bh=Aj3puJXg//L/x0hyGhARWUwA7AcKLro9niqPXSVsyyU=;
        h=Subject:To:From:Date:From;
        b=P4H43SiGZp4ZHkgVKpKMFm+OYSC6KrV4fjgoxXc80rnn2hvaTM4k8OpoDoDVpd3//
         AX6TrtF/OFHnd3eq39roTyOvOUCe1gAqt7UbSykbNNctbrmj8X3OwrMN0yOgablVYt
         pVB7NhW23Dgcd4rUEzbeIo3mhfoKlhU9jjlqlsyU=
Subject: patch "usb: gadget: bcm63xx_udc: fix up the error of undeclared" added to usb-testing
To:     chunfeng.yun@mediatek.com, balbi@kernel.org, lkp@intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Oct 2020 16:01:30 +0200
Message-ID: <1601733690234135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: bcm63xx_udc: fix up the error of undeclared

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 5b35dd1a5a666329192a9616ec21098591259058 Mon Sep 17 00:00:00 2001
From: Chunfeng Yun <chunfeng.yun@mediatek.com>
Date: Mon, 14 Sep 2020 14:17:30 +0800
Subject: usb: gadget: bcm63xx_udc: fix up the error of undeclared
 usb_debug_root

Fix up the build error caused by undeclared usb_debug_root

Cc: stable <stable@vger.kernel.org>
Fixes: a66ada4f241c ("usb: gadget: bcm63xx_udc: create debugfs directory under usb root")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
---
 drivers/usb/gadget/udc/bcm63xx_udc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/udc/bcm63xx_udc.c b/drivers/usb/gadget/udc/bcm63xx_udc.c
index feaec00a3c16..9cd4a70ccdd6 100644
--- a/drivers/usb/gadget/udc/bcm63xx_udc.c
+++ b/drivers/usb/gadget/udc/bcm63xx_udc.c
@@ -26,6 +26,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/timer.h>
+#include <linux/usb.h>
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
 #include <linux/workqueue.h>
-- 
2.28.0


