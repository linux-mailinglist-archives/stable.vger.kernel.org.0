Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837682A475E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgKCOKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:10:30 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:58565 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729512AbgKCOJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 09:09:30 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 34465A22;
        Tue,  3 Nov 2020 09:09:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:09:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=22u11R
        +izFVEP0hmRFeqcVKcoHL87GXw0fspEGkp8ms=; b=bS0N5GXmny6yDdLOZ+EkD3
        wIHSVqJVb8BcehWjNvI27rIWwLQrXg3yFL55POUZnOjApWH9OBD6EXnQUiDai76B
        vFHDTpQQ7eY9QyYXjbrPzGgLkExUh4pyMkkmyCcXjxV3X7ui/I3n71xwVr6c8X/p
        0/quXqJEh96SZC70W7du56oGdrzI93aKzxA2Rx+D9MUPbeuyYb8bjc0xjl2hK6GF
        yq+476ume/TRH2MsXd38zhxxlbrKIu7qrtNfrbXfQTiPlv12avbBpRkdAtZLJPEQ
        teAUbVKYUWH4uo/LsXW8eudViHUusBmojIqTGo1rCvfbT4T565+XzABjmm8G5VZg
        ==
X-ME-Sender: <xms:mGShX6wMG2DI6axATQQHPJw0NQ8dtswipx_acN5YSFcuaUP76xnePg>
    <xme:mGShX2QJbVfyCZXxTvHc4XmGaKhMu3oqYvJRekOn6p0XKNWaicD3UboctUhqXCB9z
    DLlsug4RJzFBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:mGShX8UvbYeODRjvrL_5CXQ26HeQxNK6VQWVwBRBdCuf408KHL5DEw>
    <xmx:mGShXwjB5-aTvR5L0eMYW_1wBlcbr5jv-p2zpcTHhLMuM-eoBBlXLw>
    <xmx:mGShX8AkvqcrEjWWYD59GKqq6k28uprU71OdQmb-Gi5yYJR3hCzs4Q>
    <xmx:mGShX3qghLD0w0aJ6uTPXSEKv3cCLhbYRCfLEVbiTgfGEV3pmzPPAxVEzq8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D6B03280065;
        Tue,  3 Nov 2020 09:09:28 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Reclaim extra TRBs after request" failed to apply to 4.19-stable tree
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 15:10:09 +0100
Message-ID: <1604412609189172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

