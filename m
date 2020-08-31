Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64659257921
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 14:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgHaMZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 08:25:08 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:58657 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbgHaMZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 08:25:07 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 361B0B3E;
        Mon, 31 Aug 2020 08:25:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 08:25:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=4y4gFT
        7Ay3v+5q0joJW0CaKphc02aPS6FccIK0ocYd0=; b=utMwauzk2VT+TtQZkJQ4mL
        4CEEZgGib9U96kV2mrQvfEerzVINDJ6DdB7KAJ6kHlGP0C60rL/rI2yDuqJ+/rZB
        6SF63Gg1SkAH1OpEjgrTYNuk51BLtI5bB+GSlEK8t6FoRvJUv4wj4Sw4fJBhhF+x
        SCuDwZ+/8P6rmtsw5zZYoxNNQS9iDH5fi5HdVziKAzQKJXrk48A6FfQEGOTg1MTR
        oJsU6BZx1H70RpdWGfWsv+wQItmxgLpXvJj8DOxr+rkLyKpIeUI6YjnFJMSoLRDK
        YApiGCbh76GHmyimbCF8oBTYJNsE+sizgcei4DMIvrTt+14O/X7V3RYs0MhSxvvQ
        ==
X-ME-Sender: <xms:IexMX-3PK7BnZ4Lx_dvEcbwNeH4DCMEWkj2Fu1V1ORXX8UIoOctg-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:IexMXxGS6Ns2S52XsLH4AmWiqiowDg_4CxiPI5h5EETnvHd8h9QkwA>
    <xmx:IexMX27PTfLpomCDzDBzzJwUhFOXjZzf-anPVjRIPK_1nfhMrOX16Q>
    <xmx:IexMX_2RyfWdTMQGUCquz7nfC4mPWVaLWb7Z2NACfDAsMEL_K5zm2g>
    <xmx:IexMX0MsEAWWXCzSPpbf1cDW48CjOicFEk67rJ6U6edxEIJZadx5KCJTVUM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7CAB03280064;
        Mon, 31 Aug 2020 08:25:05 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Fix handling ZLP" failed to apply to 4.19-stable tree
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org,
        stable@vger.kernel.org, thinhn@synopsys.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 14:25:14 +0200
Message-ID: <15988767145098@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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
 

