Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB712A4755
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgKCOKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:10:31 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:39985 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729504AbgKCOJT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 09:09:19 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C26EE452;
        Tue,  3 Nov 2020 09:09:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:09:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7VQv/W
        hGwsafC1peQBjWQ8quVmqKKg/1mWg/YmBL/LY=; b=Jp3u9aLV81acVeF74fqHeQ
        xFm18sn1qK0/nIOwVH4RX8c/RpBceXaPCcpYzgvWxgOJf3mGGPj2ezHCbnZBU8qM
        z4NrJB3T3IprLewRPTknTzqRHh9ReH16OdOt/XJONwloOxmdUW0Q7dWryH+2HElN
        4amq31O1n9asx+cRlE54VZA19UNxJZAt/lrK/Aj9eWo7LQeBXgVCMWFD5EUl3bWh
        LZa+slp8YlwYcWLV9UZ2AhGMvsvAATJL5pALeXAv5Byw8OoKfD6FsRwsrJDah73j
        8JSIfS9Ui7McrWGfEVr15NHZRNJlUOXim0VygDwjUKNUbuPpXUHDHdwwDWyemtNw
        ==
X-ME-Sender: <xms:jmShX3WiWLQc_mUzjgOFcQ9nXhGpZy2lZVESZ9NqFz9Ms204q2GQ9A>
    <xme:jmShX_llhO1R2P9CjM3h3k0Gie3y32z8eeh2KqaiwzNV-foDoYTiNAWJG2BVOkwi_
    DDh2oM_PDmpcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:jmShXzZ56fu_zLOlPq7olBXgGo4Yxcq7O27ilhPkfL1WRewbcJR7NA>
    <xmx:jmShXyWM-tu6eVSCDTnq7nOEFgPA-PBh7AlhCUxiebLrLMyo60AV3g>
    <xmx:jmShXxmu9kepwSThfq80k8zTBeQ-qgxoYJsz29APYD7xL6Hn_ESlCg>
    <xmx:jmShXwtHfLIKaInPynebp7nRz62gJAlU-tIKyxxcGo5As8Z2_DI_Ilu0W74>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C2E0C3280065;
        Tue,  3 Nov 2020 09:09:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Reclaim extra TRBs after request" failed to apply to 5.4-stable tree
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 15:10:08 +0100
Message-ID: <160441260893153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 690e5c2dc29f8891fcfd30da67e0d5837c2c9df5 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Thu, 24 Sep 2020 01:21:24 -0700
Subject: [PATCH] usb: dwc3: gadget: Reclaim extra TRBs after request
 completion

An SG request may be partially completed (due to no available TRBs).
Don't reclaim extra TRBs and clear the needs_extra_trb flag until the
request is fully completed. Otherwise, the driver will reclaim the wrong
TRB.

Cc: stable@vger.kernel.org
Fixes: 1f512119a08c ("usb: dwc3: gadget: add remaining sg entries to ring")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 7e1909dd041b..173421508635 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2744,6 +2744,11 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 		ret = dwc3_gadget_ep_reclaim_trb_linear(dep, req, event,
 				status);
 
+	req->request.actual = req->request.length - req->remaining;
+
+	if (!dwc3_gadget_ep_request_completed(req))
+		goto out;
+
 	if (req->needs_extra_trb) {
 		unsigned int maxp = usb_endpoint_maxp(dep->endpoint.desc);
 
@@ -2759,11 +2764,6 @@ static int dwc3_gadget_ep_cleanup_completed_request(struct dwc3_ep *dep,
 		req->needs_extra_trb = false;
 	}
 
-	req->request.actual = req->request.length - req->remaining;
-
-	if (!dwc3_gadget_ep_request_completed(req))
-		goto out;
-
 	dwc3_gadget_giveback(dep, req, status);
 
 out:

