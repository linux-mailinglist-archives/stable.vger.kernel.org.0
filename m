Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BE8257925
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 14:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgHaMZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 08:25:23 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:53303 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbgHaMZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 08:25:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 6175BB32;
        Mon, 31 Aug 2020 08:25:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 08:25:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=cZufRe
        OYeIii2B2Fu0hLbAcG3BtABOw19gmRE/M5GmE=; b=NTzClbkrnnWBh6FWyPa8zA
        ISkHl10RSdSDWCDX4ItIFR65wR5pEQvsnVU6jndLNb4Vp3wzxfpBaSMdVMEPmNOx
        c9USgrF28s3+T9e8t8yVee3t3TpBO1D8HqUVsTm3ZNIs3F4zNu1nFQ0H8voz4sgp
        +6qhGLOX0hP7DvmN6YZcjjI5EVwHWHlBuuWd6l62bf+sWtSdX4oT2ayKK73ro529
        +Bp/gIHnl/WiTREauhO00VoLLcaJaNAiD37Nft4aMjhMw3A7jZK60zHTrTUZCViz
        qXm8+tn9jkk6qWUO8FII78q1/wxXVGm7QPB2bs6Q4+5uSMJgokZ2LwOwhw5Z3KiA
        ==
X-ME-Sender: <xms:MOxMX43IYhGJathnqF-nOUpW4bVVVIYpolrB2Nm9zIvGMV9wviBkMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:MOxMXzEuMJcvttgSi9182o1C4MuIzeGgkrceqgC21xj8Nssyj1M_LQ>
    <xmx:MOxMXw4JkLNtpslS1KNrrYegVAqd3YzKZVrTKCWNoCU3ShRqkB6CIQ>
    <xmx:MOxMXx3bQZ6HciCRj56EPwXspOZKtETVYhDAwuYjRjxwRX_UDqb20g>
    <xmx:MexMX-P5g8TQXPlxgXH7Q-CUJEBTe7dUTJU0b38HBCWsEeQ9CPCLiyV9F64>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A5920328005D;
        Mon, 31 Aug 2020 08:25:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Handle ZLP for sg requests" failed to apply to 4.9-stable tree
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org,
        stable@vger.kernel.org, thinhn@synopsys.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 14:25:29 +0200
Message-ID: <1598876729124251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

