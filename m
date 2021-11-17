Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2366454813
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbhKQOGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:06:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:60392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238089AbhKQOGG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 09:06:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD061613AC;
        Wed, 17 Nov 2021 14:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637157788;
        bh=v2ROQ6ToJl0l+smko6lhx94UwHX6HqypQlXuQnQalmA=;
        h=Subject:To:From:Date:From;
        b=V7nQKBBhUKPd3fyuy3uvN9Aq3SFVu+lM/UX5HCIvTaRvTQwbKBA+sQGdIgb7ngJzv
         HhvTf76u6sewCqb+wcQRdRd93STilB42jRwYR2d1gkRMOwNBuSqJdBD3OzE1RiL3lB
         TV7YjXVnuWCujDgKEFxL8ETMDyCV/uOAmH0+36AQ=
Subject: patch "usb: dwc3: core: Revise GHWPARAMS9 offset" added to usb-linus
To:     Thinh.Nguyen@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Nov 2021 15:03:05 +0100
Message-ID: <163715778598190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: core: Revise GHWPARAMS9 offset

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 250fdabec6ffcaf895c5e0dedca62706ef10d8f6 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Mon, 25 Oct 2021 16:15:32 -0700
Subject: usb: dwc3: core: Revise GHWPARAMS9 offset

During our predesign phase for DWC_usb32, the GHWPARAMS9 register offset
was 0xc680. We revised our final design, and the GHWPARAMS9 offset is
now moved to 0xc6e8 on release.

Fixes: 16710380d3aa ("usb: dwc3: Capture new capability register GHWPARAMS9")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/1541737108266a97208ff827805be1f32852590c.1635202893.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 620c8d3914d7..5c491d0a19d7 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -143,7 +143,7 @@
 #define DWC3_GHWPARAMS8		0xc600
 #define DWC3_GUCTL3		0xc60c
 #define DWC3_GFLADJ		0xc630
-#define DWC3_GHWPARAMS9		0xc680
+#define DWC3_GHWPARAMS9		0xc6e0
 
 /* Device Registers */
 #define DWC3_DCFG		0xc700
-- 
2.34.0


