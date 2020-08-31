Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE296257920
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 14:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgHaMY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 08:24:56 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:48439 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726121AbgHaMYz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 08:24:55 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 87F70B25;
        Mon, 31 Aug 2020 08:24:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 08:24:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=iEdYRs
        k1O2fXj79gEdqTK41aBLKqiM9+Qs+bFcAjBZs=; b=adPasgIN3u0++Naz/htujJ
        GiL28G5bAKW+wk4mauQ5iXrO/VlztmnRQdpFStGUtOLnfzJGuT1O3PtrKvTQeY4n
        SvKRPp5Zg1cHtTkB1I0ZFgTd580MXQmxwwrYgIBaNFYwF4j6VJzBRJeFwCYrIFqu
        cCPep8y2Rs8RtPSc8KMbVq/RT8icBH3EuB5BkX2WqbVX1ZgA2+omSRCmyc9zAnV7
        +Aw2q70Ki+VmudaJ8onH84HhwLH7c+SpUzObzOOb6qmlMoHltPUus3/OEcuWt3IH
        5GeFSfoNsN4O6+3zS2o9CD0XZYaDqS7FP/PM/DweflkHqhjB4Ha/+gn6QPNzVmdQ
        ==
X-ME-Sender: <xms:FuxMX2usqf5K6rNVteLMLje_Vq_DJj66xJrV5D1kEbrmG0UbkBwqig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:FuxMX7enwOO1JpDKNT1YuB26RVK3hsbZhENWKz_2lrDDMJM7KkCpIw>
    <xmx:FuxMXxwrylWrvRJqW7qXvdjT_p40N7jGIMYlGBtnMIXd9Yad2NcIPg>
    <xmx:FuxMXxPvgnRc2gIJ_Jc0QaVuWYrf3dVWYC6ItdG-N4pj57OrgPZLmg>
    <xmx:FuxMX7EPL2chQD2uL-axsRxpd7xNl30j3i8uMdQyhw09yIPzjb0_0MHqJug>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CC07E3060067;
        Mon, 31 Aug 2020 08:24:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Don't setup more than requested" failed to apply to 5.4-stable tree
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org,
        stable@vger.kernel.org, thinhn@synopsys.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 14:24:54 +0200
Message-ID: <1598876694219243@kroah.com>
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

From 5d187c0454ef4c5e046a81af36882d4d515922ec Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Thu, 6 Aug 2020 19:46:23 -0700
Subject: [PATCH] usb: dwc3: gadget: Don't setup more than requested

The SG list may be set up with entry size more than the requested
length. Check the usb_request->length and make sure that we don't setup
the TRBs to send/receive more than requested. This case may occur when
the SG entry is allocated up to a certain minimum size, but the request
length is less than that. It can also occur when the request is reused
for a different request length.

Cc: <stable@vger.kernel.org> # v4.18+
Fixes: a31e63b608ff ("usb: dwc3: gadget: Correct handling of scattergather lists")
Signed-off-by: Thinh Nguyen <thinhn@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index e44bfc3b5096..f9231253cbed 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1054,27 +1054,25 @@ static void __dwc3_prepare_one_trb(struct dwc3_ep *dep, struct dwc3_trb *trb,
  * dwc3_prepare_one_trb - setup one TRB from one request
  * @dep: endpoint for which this request is prepared
  * @req: dwc3_request pointer
+ * @trb_length: buffer size of the TRB
  * @chain: should this TRB be chained to the next?
  * @node: only for isochronous endpoints. First TRB needs different type.
  */
 static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
-		struct dwc3_request *req, unsigned chain, unsigned node)
+		struct dwc3_request *req, unsigned int trb_length,
+		unsigned chain, unsigned node)
 {
 	struct dwc3_trb		*trb;
-	unsigned int		length;
 	dma_addr_t		dma;
 	unsigned		stream_id = req->request.stream_id;
 	unsigned		short_not_ok = req->request.short_not_ok;
 	unsigned		no_interrupt = req->request.no_interrupt;
 	unsigned		is_last = req->request.is_last;
 
-	if (req->request.num_sgs > 0) {
-		length = sg_dma_len(req->start_sg);
+	if (req->request.num_sgs > 0)
 		dma = sg_dma_address(req->start_sg);
-	} else {
-		length = req->request.length;
+	else
 		dma = req->request.dma;
-	}
 
 	trb = &dep->trb_pool[dep->trb_enqueue];
 
@@ -1086,7 +1084,7 @@ static void dwc3_prepare_one_trb(struct dwc3_ep *dep,
 
 	req->num_trbs++;
 
-	__dwc3_prepare_one_trb(dep, trb, dma, length, chain, node,
+	__dwc3_prepare_one_trb(dep, trb, dma, trb_length, chain, node,
 			stream_id, short_not_ok, no_interrupt, is_last);
 }
 
@@ -1096,16 +1094,27 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 	struct scatterlist *sg = req->start_sg;
 	struct scatterlist *s;
 	int		i;
-
+	unsigned int length = req->request.length;
 	unsigned int remaining = req->request.num_mapped_sgs
 		- req->num_queued_sgs;
 
+	/*
+	 * If we resume preparing the request, then get the remaining length of
+	 * the request and resume where we left off.
+	 */
+	for_each_sg(req->request.sg, s, req->num_queued_sgs, i)
+		length -= sg_dma_len(s);
+
 	for_each_sg(sg, s, remaining, i) {
-		unsigned int length = req->request.length;
 		unsigned int maxp = usb_endpoint_maxp(dep->endpoint.desc);
 		unsigned int rem = length % maxp;
+		unsigned int trb_length;
 		unsigned chain = true;
 
+		trb_length = min_t(unsigned int, length, sg_dma_len(s));
+
+		length -= trb_length;
+
 		/*
 		 * IOMMU driver is coalescing the list of sgs which shares a
 		 * page boundary into one and giving it to USB driver. With
@@ -1113,7 +1122,7 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 		 * sgs passed. So mark the chain bit to false if it isthe last
 		 * mapped sg.
 		 */
-		if (i == remaining - 1)
+		if ((i == remaining - 1) || !length)
 			chain = false;
 
 		if (rem && usb_endpoint_dir_out(dep->endpoint.desc) && !chain) {
@@ -1123,7 +1132,7 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 			req->needs_extra_trb = true;
 
 			/* prepare normal TRB */
-			dwc3_prepare_one_trb(dep, req, true, i);
+			dwc3_prepare_one_trb(dep, req, trb_length, true, i);
 
 			/* Now prepare one extra TRB to align transfer size */
 			trb = &dep->trb_pool[dep->trb_enqueue];
@@ -1135,7 +1144,7 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 					req->request.no_interrupt,
 					req->request.is_last);
 		} else {
-			dwc3_prepare_one_trb(dep, req, chain, i);
+			dwc3_prepare_one_trb(dep, req, trb_length, chain, i);
 		}
 
 		/*
@@ -1150,6 +1159,16 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
 
 		req->num_queued_sgs++;
 
+		/*
+		 * The number of pending SG entries may not correspond to the
+		 * number of mapped SG entries. If all the data are queued, then
+		 * don't include unused SG entries.
+		 */
+		if (length == 0) {
+			req->num_pending_sgs -= req->request.num_mapped_sgs - req->num_queued_sgs;
+			break;
+		}
+
 		if (!dwc3_calc_trbs_left(dep))
 			break;
 	}
@@ -1169,7 +1188,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 		req->needs_extra_trb = true;
 
 		/* prepare normal TRB */
-		dwc3_prepare_one_trb(dep, req, true, 0);
+		dwc3_prepare_one_trb(dep, req, length, true, 0);
 
 		/* Now prepare one extra TRB to align transfer size */
 		trb = &dep->trb_pool[dep->trb_enqueue];
@@ -1187,7 +1206,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 		req->needs_extra_trb = true;
 
 		/* prepare normal TRB */
-		dwc3_prepare_one_trb(dep, req, true, 0);
+		dwc3_prepare_one_trb(dep, req, length, true, 0);
 
 		/* Now prepare one extra TRB to handle ZLP */
 		trb = &dep->trb_pool[dep->trb_enqueue];
@@ -1198,7 +1217,7 @@ static void dwc3_prepare_one_trb_linear(struct dwc3_ep *dep,
 				req->request.no_interrupt,
 				req->request.is_last);
 	} else {
-		dwc3_prepare_one_trb(dep, req, false, 0);
+		dwc3_prepare_one_trb(dep, req, length, false, 0);
 	}
 }
 

