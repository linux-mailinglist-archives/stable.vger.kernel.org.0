Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CB42D5F3A
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 16:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391750AbgLJPMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 10:12:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:38440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389313AbgLJPMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 10:12:35 -0500
Subject: patch "USB: gadget: f_acm: add support for SuperSpeed Plus" added to usb-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607613114;
        bh=qbuNxNlTSRhKU3nV/AQ8dtpuDAC2udy+5SCRcQ89wfM=;
        h=To:From:Date:From;
        b=lBGEmnRy3cu01MnhDiHht+MQ7d8BHjPyLyK0TYrvtaZL57JdiGqsNx14mHFmLwv0z
         McF/PqalJkvLkOOLtM8UNMN3qpzDoebad9P1fPQhC6wvtWjO/07fAkqzJsxPTl2JwE
         1K4UpEyEEMg/cPT+H1cl18l9yFxxQXP1dOWao2dM=
To:     taehyun.cho@samsung.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, peter.chen@nxp.com,
        stable@vger.kernel.org, willmcvicker@google.com
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 10 Dec 2020 16:13:00 +0100
Message-ID: <160761318018073@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: gadget: f_acm: add support for SuperSpeed Plus

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 3ee05c20656782387aa9eb010fdb9bb16982ac3f Mon Sep 17 00:00:00 2001
From: "taehyun.cho" <taehyun.cho@samsung.com>
Date: Fri, 27 Nov 2020 15:05:56 +0100
Subject: USB: gadget: f_acm: add support for SuperSpeed Plus

Setup the SuperSpeed Plus descriptors for f_acm.  This allows the gadget
to work properly without crashing at SuperSpeed rates.

Cc: Felipe Balbi <balbi@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: taehyun.cho <taehyun.cho@samsung.com>
Signed-off-by: Will McVicker <willmcvicker@google.com>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20201127140559.381351-3-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_acm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_acm.c b/drivers/usb/gadget/function/f_acm.c
index 46647bfac2ef..349945e064bb 100644
--- a/drivers/usb/gadget/function/f_acm.c
+++ b/drivers/usb/gadget/function/f_acm.c
@@ -686,7 +686,7 @@ acm_bind(struct usb_configuration *c, struct usb_function *f)
 	acm_ss_out_desc.bEndpointAddress = acm_fs_out_desc.bEndpointAddress;
 
 	status = usb_assign_descriptors(f, acm_fs_function, acm_hs_function,
-			acm_ss_function, NULL);
+			acm_ss_function, acm_ss_function);
 	if (status)
 		goto fail;
 
-- 
2.29.2


