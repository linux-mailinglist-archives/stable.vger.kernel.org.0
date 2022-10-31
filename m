Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBDB612FBD
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 06:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJaFiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 01:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiJaFiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 01:38:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540677673
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 22:38:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E113860FA5
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 05:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFEBC433D6;
        Mon, 31 Oct 2022 05:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667194698;
        bh=66FFalY8qezplTrHdtlYqLg48YC0b4Q+6agbiE8Gh6Y=;
        h=Subject:To:Cc:From:Date:From;
        b=pTP8goa3pVJmoN51zarFZQYQvrkdG5N7OOTyYkAFofBguRL1CwsJcH5QpaHGD5052
         wQr6dTCMzZkuoqK0XMWClzsNTZRauI8EmmuUwKmk+HHgvfFoePr1Oa4LLDvvQPuKWK
         /7bQjeSOsNGenAONfoRIk5B6C9l/G8MFN+3I7Xjg=
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Stop processing more requests on IMI" failed to apply to 4.9-stable tree
To:     Thinh.Nguyen@synopsys.com, gregkh@linuxfoundation.org,
        jdv1029@gmail.com, w36195@motorola.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 06:39:06 +0100
Message-ID: <1667194746149205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f78961f8380b ("usb: dwc3: gadget: Stop processing more requests on IMI")
5ee858975b13 ("usb: dwc3: gadget: Check for IOC/LST bit in TRB->ctrl fields")
e0c42ce590fe ("usb: dwc3: gadget: simplify IOC handling")
d36929538f8b ("usb: dwc3: gadget: split scatterlist and linear handlers")
12a3a4ada816 ("usb: dwc3: gadget: make cleanup_completed_requests() return nothing")
8f608e8ab628 ("usb: dwc3: gadget: remove unnecessary 'dwc' parameter")
320338651d33 ("usb: dwc3: gadget: move handler closer to calling site")
ed27442e5093 ("usb: dwc3: gadget: rename dwc3_gadget_start_isoc()")
a24a6ab1493a ("usb: dwc3: gadget: remove some pointless checks")
0bd0f6d201eb ("usb: dwc3: gadget: remove allocated/queued request tracking")
66f5dd5a0379 ("usb: dwc3: gadget: rename done_trbs and done_reqs")
fbea935accf4 ("usb: dwc3: gadget: rename dwc3_endpoint_transfer_complete()")
742a4fff5f29 ("usb: dwc3: gadget: XferComplete only for EP0")
38408464aa76 ("usb: dwc3: gadget: XferNotReady is Isoc-only")
c96e6725db9d ("usb: dwc3: gadget: Correct the logic for queuing sgs")
a31e63b608ff ("usb: dwc3: gadget: Correct handling of scattergather lists")
c91815b59624 ("usb: dwc3: gadget: never call ->complete() from ->ep_queue()")
7fdca766499b ("usb: dwc3: gadget: simplify __dwc3_gadget_kick_transfer() prototype")
502a37b98a7b ("usb: dwc3: gadget: cache frame number in struct dwc3_ep")
64e010802997 ("usb: dwc3: gadget: simplify __dwc3_gadget_ep_queue()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f78961f8380b940e0cfc7e549336c21a2ad44f4d Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Tue, 25 Oct 2022 15:10:14 -0700
Subject: [PATCH] usb: dwc3: gadget: Stop processing more requests on IMI

When servicing a transfer completion event, the dwc3 driver will reclaim
TRBs of started requests up to the request associated with the interrupt
event. Currently we don't check for interrupt due to missed isoc, and
the driver may attempt to reclaim TRBs beyond the associated event. This
causes invalid memory access when the hardware still owns the TRB. If
there's a missed isoc TRB with IMI (interrupt on missed isoc), make sure
to stop servicing further.

Note that only the last TRB of chained TRBs has its status updated with
missed isoc.

Fixes: 72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver")
Cc: stable@vger.kernel.org
Reported-by: Jeff Vanhoof <jdv1029@gmail.com>
Reported-by: Dan Vacura <w36195@motorola.com>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Jeff Vanhoof <jdv1029@gmail.com>
Tested-by: Jeff Vanhoof <jdv1029@gmail.com>
Link: https://lore.kernel.org/r/b29acbeab531b666095dfdafd8cb5c7654fbb3e1.1666735451.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index dd8ecbe61bec..230b3c660054 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3248,6 +3248,10 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
 	if (event->status & DEPEVT_STATUS_SHORT && !chain)
 		return 1;
 
+	if ((trb->ctrl & DWC3_TRB_CTRL_ISP_IMI) &&
+	    DWC3_TRB_SIZE_TRBSTS(trb->size) == DWC3_TRBSTS_MISSED_ISOC)
+		return 1;
+
 	if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
 	    (trb->ctrl & DWC3_TRB_CTRL_LST))
 		return 1;

