Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC3D257923
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 14:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgHaMZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 08:25:17 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:41455 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbgHaMZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 08:25:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id E590EB2C;
        Mon, 31 Aug 2020 08:25:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 08:25:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rSnfRx
        mSK/IkaUe2714kjs8CjQcmc7JGwTQS5m4uSg8=; b=oU1+yhM4jG+g/QYY1VAT6Q
        0LK0/+xsgn7rb0SzJDGTMPoIGhgxrul7wdxnHw9874gQ1z0fx2Z3Jo382bKfR72L
        pQ6WMDlHdxUGGooEbl4/teIMFYlEcYMuSAiH7LrwkAw2LNVNx6vZwt/u/+kijiQ+
        kqhToOrIOOiM5o1kzSG131qCXjszHNe4LERbH480m3cL2ldAqKiIA7NOxnNKsQ6g
        4Eo0ryvBr9FbldvyUZd4RwHZYwBbiQsr6JrHxA2aWMB3XxOi7tNZY5pthhUQJ+f4
        oY1d01W/JUakp+sBoJ/85HOfLFUbphl6on+DOHLaMGTGwR2QEAjNsZ0p5Vf6wbnw
        ==
X-ME-Sender: <xms:KuxMX_RbM8rLnBRuhZXWUcBTMHez5mz5T8W1ZKCKdKeHNmsm_Hyg_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:KuxMXwx7YeGKI7HCzXMvRikdkSshwz66q80NyM9IIOqhVEIRJaCakQ>
    <xmx:KuxMX02EflkxpYh3XN1pAfxm6fysUVvzjkNYEMev93HiuYiaocWUiw>
    <xmx:KuxMX_DumscVhPggrL7VegIueXDA4kGgk1ueqXofe4YPetD-kQxb-A>
    <xmx:KuxMXwL-6DeCehtyCqHRWqI2Z0WfLdCZOjApOyUaK1mV2Ci87kg7dVQi0MU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 352E230600B7;
        Mon, 31 Aug 2020 08:25:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Fix handling ZLP" failed to apply to 5.4-stable tree
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org,
        stable@vger.kernel.org, thinhn@synopsys.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 14:25:15 +0200
Message-ID: <1598876715180107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d2ee3ff79e6a3d4105e684021017d100524dc560 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Thu, 6 Aug 2020 19:46:29 -0700
Subject: [PATCH] usb: dwc3: gadget: Fix handling ZLP

The usb_request->zero doesn't apply for isoc. Also, if we prepare a
0-length (ZLP) TRB for the OUT direction, we need to prepare an extra
TRB to pad up to the MPS alignment. Use the same bounce buffer for the
ZLP TRB and the extra pad TRB.

Cc: <stable@vger.kernel.org> # v4.5+
Fixes: d6e5a549cc4d ("usb: dwc3: simplify ZLP handling")
Fixes: 04c03d10e507 ("usb: dwc3: gadget: handle request->zero")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index f9231253cbed..df603a817a98 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1199,6 +1199,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 				req->request.no_interrupt,
 				req->request.is_last);
 	} else if (req->request.zero && req->request.length &&
+		   !usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
 		   (IS_ALIGNED(req->request.length, maxp))) {
 		struct dwc3	*dwc = dep->dwc;
 		struct dwc3_trb	*trb;
@@ -1208,14 +1209,25 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 		/* prepare normal TRB */
 		dwc3_prepare_one_trb(dep, req, length, true, 0);
 
-		/* Now prepare one extra TRB to handle ZLP */
+		/* Prepare one extra TRB to handle ZLP */
 		trb = &dep->trb_pool[dep->trb_enqueue];
 		req->num_trbs++;
 		__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, 0,
-				false, 1, req->request.stream_id,
+				!req->direction, 1, req->request.stream_id,
 				req->request.short_not_ok,
 				req->request.no_interrupt,
 				req->request.is_last);
+
+		/* Prepare one more TRB to handle MPS alignment for OUT */
+		if (!req->direction) {
+			trb = &dep->trb_pool[dep->trb_enqueue];
+			req->num_trbs++;
+			__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, maxp,
+					       false, 1, req->request.stream_id,
+					       req->request.short_not_ok,
+					       req->request.no_interrupt,
+					       req->request.is_last);
+		}
 	} else {
 		dwc3_prepare_one_trb(dep, req, length, false, 0);
 	}
@@ -2690,8 +2702,17 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 				status);
 
 	if (req->needs_extra_trb) {
+		unsigned int maxp = usb_endpoint_maxp(dep->endpoint.desc);
+
 		ret = dwc3_gadget_ep_reclaim_trb_linear(dep, req, event,
 				status);
+
+		/* Reclaim MPS padding TRB for ZLP */
+		if (!req->direction && req->request.zero && req->request.length &&
+		    !usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
+		    (IS_ALIGNED(req->request.length, maxp)))
+			ret = dwc3_gadget_ep_reclaim_trb_linear(dep, req, event, status);
+
 		req->needs_extra_trb = false;
 	}
 

