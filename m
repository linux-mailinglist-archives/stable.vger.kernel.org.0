Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9DD29BB34
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368918AbgJ0P7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:59:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1804290AbgJ0Py2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:54:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CB9820678;
        Tue, 27 Oct 2020 15:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603814068;
        bh=rozxnVf81Em0tR+ad5yS6RN+XWIJ4mwYZE4do9mDHPI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07iIeAiNWNnbXxesbTgFI3TXV2klus1l4z9Dn4r+BIiQa9ZQ0TXzvNgM+6txZd5l5
         TvmONaBeDSLSv1WDJH4w63IyhmR/4oSWzXTCMLsE5zkd8GywJGX1PJKnDHvtC/Ye+h
         zUV+EBIUlMpv2SokzWxJdej/cgRhPgFHB905+dvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Felipe Balbi <balbi@kernel.org>
Subject: [PATCH 5.9 752/757] usb: gadget: bcm63xx_udc: fix up the error of undeclared usb_debug_root
Date:   Tue, 27 Oct 2020 14:56:42 +0100
Message-Id: <20201027135525.788823067@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

commit 5b35dd1a5a666329192a9616ec21098591259058 upstream.

Fix up the build error caused by undeclared usb_debug_root

Cc: stable <stable@vger.kernel.org>
Fixes: a66ada4f241c ("usb: gadget: bcm63xx_udc: create debugfs directory under usb root")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/bcm63xx_udc.c |    1 +
 1 file changed, 1 insertion(+)

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


