Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CBF257924
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 14:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgHaMZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 08:25:24 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:59709 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726586AbgHaMZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 08:25:23 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id C9CCEB5F;
        Mon, 31 Aug 2020 08:25:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 08:25:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uhbxqy
        qPIXcxcFA90GCT7xToUaypvh0Sv3ubTEBuAyU=; b=DHWDxLTcTovYu+vkkADMxj
        dZ0J3Pj2gnnKLgBX+jR7ZPU3DsEt1wwn9YBDJNNc2vzL8u+RZ6B/oVi4NVhhsJ+V
        S0R4FyHCab2Jho35QveB38Rx/YLIxHzitqT+M+vEqEuchbhDKQXDsKMDjqW5qoBL
        lUpJ9HyUUpRFjqLQ2dtMzWsbmWx0EdVovQpkq2gQlhb+ycGbnAYLDkoFfI1IwWw0
        S5b0Zo4T/AOtRdT4kqIdeIdZcyRzQWhQtClGtUiGcuj/yOMhXWYnylEN8528nl/k
        tHCNZ5u8hLclBPMBbal5KxIYYWxrBLJuqEVp8uMU3YTOPs0XtzeOOMmKshUWFcfw
        ==
X-ME-Sender: <xms:MuxMX8J8VP53c1a53aEmPnfaVmcRVYMeYa9VC12TiH05jSniwngDUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:MuxMX8KG3bji9Q3tTkLd7sAn9Yrgm6LAYQ21kqTFHJ64Naz3sC_M3A>
    <xmx:MuxMX8sEnSs_8C0kD1S4ZGruqAFYg9MlmfLBoto_dtrSCxZD-cYwAw>
    <xmx:MuxMX5bYMF4trMcGd0grtfJWGKRWLrF_0aONSZscLJKJv56NpOkxOg>
    <xmx:MuxMX0DQ2xOrvqUG99wLJxo0MdNgdPsTm4x4K9VJITbhTKs0Q4wc9M0n6WA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1AA1A30600A9;
        Mon, 31 Aug 2020 08:25:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Handle ZLP for sg requests" failed to apply to 4.19-stable tree
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org,
        stable@vger.kernel.org, thinhn@synopsys.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 14:25:30 +0200
Message-ID: <1598876730249162@kroah.com>
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

From bc9a2e226ea95e1699f7590845554de095308b75 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Thu, 6 Aug 2020 19:46:35 -0700
Subject: [PATCH] usb: dwc3: gadget: Handle ZLP for sg requests

Currently dwc3 doesn't handle usb_request->zero for SG requests. This
change checks and prepares extra TRBs for the ZLP for SG requests.

Cc: <stable@vger.kernel.org> # v4.5+
Fixes: 04c03d10e507 ("usb: dwc3: gadget: handle request->zero")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index df603a817a98..c2a0f64f8d1e 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1143,6 +1143,37 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 					req->request.short_not_ok,
 					req->request.no_interrupt,
 					req->request.is_last);
+		} else if (req->request.zero && req->request.length &&
+			   !usb_endpoint_xfer_isoc(dep->endpoint.desc) &&
+			   !rem && !chain) {
+			struct dwc3	*dwc = dep->dwc;
+			struct dwc3_trb	*trb;
+
+			req->needs_extra_trb = true;
+
+			/* Prepare normal TRB */
+			dwc3_prepare_one_trb(dep, req, trb_length, true, i);
+
+			/* Prepare one extra TRB to handle ZLP */
+			trb = &dep->trb_pool[dep->trb_enqueue];
+			req->num_trbs++;
+			__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, 0,
+					       !req->direction, 1,
+					       req->request.stream_id,
+					       req->request.short_not_ok,
+					       req->request.no_interrupt,
+					       req->request.is_last);
+
+			/* Prepare one more TRB to handle MPS alignment */
+			if (!req->direction) {
+				trb = &dep->trb_pool[dep->trb_enqueue];
+				req->num_trbs++;
+				__dwc3_prepare_one_trb(dep, trb, dwc->bounce_addr, maxp,
+						       false, 1, req->request.stream_id,
+						       req->request.short_not_ok,
+						       req->request.no_interrupt,
+						       req->request.is_last);
+			}
 		} else {
 			dwc3_prepare_one_trb(dep, req, trb_length, chain, i);
 		}

