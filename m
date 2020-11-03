Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAE02A4752
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbgKCOKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:10:30 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:32881 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729514AbgKCOJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 09:09:31 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id DECA9D0F;
        Tue,  3 Nov 2020 09:09:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:09:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xoNa4t
        bYR+3v/jRuAZ37YemyucAZBMB9Goz729HQGRg=; b=MYM4cNd8Fd3tDv4rWnxn/U
        z9h0mvAMj6DKkBu1k0Mq1o176HV9tWUB2ymccWRwX+WRbtZ4CiHrd0t4IVL8/+Vn
        i/9Kb+eBEZOoSl42iD3awpSMoIa0K3AWkxyDsOhhFZ7HNODS3za6fXFBIuVH7EO1
        rQcgNl491t1Kk9DHWzCY27ZPLOVbePwnKkZOwrWTa94x/gVQDvdN9utQLXVDKlsQ
        KTJwiEXnQdak2Alim6QAj8mPPjRdB62k2XtnYF/zKkuqenRjlzZQygUaeFOLgEtw
        oHXJVWwwOJ9aEne3Y+5Ru162KyjwzDsbjZBMHdfxhF4Esm7nabBELOe6dx/K92pw
        ==
X-ME-Sender: <xms:mmShX9nrtw3WZw2lBQNHTEO6rqOcMg3e8QvDNmSrm6_3S2hDLcMfBQ>
    <xme:mmShX419NvfTNZD4t9xa920lhbW1evSojOy4aZz5AAlSoQDlZfbC8HIiTubOP4_Qc
    EoEk_zm6Mbj8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:mmShXzp7XDKkAf4Yo6qsuHp4cHvtHG-EZMPGV-15-kasq7_YkBZj9w>
    <xmx:mmShX9n_cbLdQ6-s_4zYvuy-j6gpg6jbt4UurTwK8-Pe64x_2_wFdw>
    <xmx:mmShX72ptqx14q4BfagYMejXCUegyI4rBIMJEFcNzitSqrw4m1sPhw>
    <xmx:mmShX48FJOx-WzyjWJ9JyIcppyBQGSA84gKO_H-owcmuwQtg298RiGcgddk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2CE183064610;
        Tue,  3 Nov 2020 09:09:30 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Reclaim extra TRBs after request" failed to apply to 4.9-stable tree
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 15:10:10 +0100
Message-ID: <160441261075157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

