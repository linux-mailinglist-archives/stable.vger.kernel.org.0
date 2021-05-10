Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2339377E1D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhEJI1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:27:33 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:51229 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230098AbhEJI12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:27:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9E0E51940B81;
        Mon, 10 May 2021 04:26:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 10 May 2021 04:26:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aTbakV
        VIADvRllGWAOg39mwKGCl2Vg5JJhEUa/vFTsA=; b=Js/HUVelStKZuiK/xGAK7p
        c1ShUH0h8KJb9GUdSbKbl7P8tNxZEVQ8OZV5Wr6CkVJfgNivb4tXHQDH4PFiuMAD
        3ASnSpwLek+jWj/OwQ78XuuQaZlR1xkroldETOKS1gWOd/7eWWcWH2tu6ufgt6gA
        eWoJ6B2j0YoMGX0reNavA7cQEZldAuoKE3+zCqWqD1L6g+Ag8GJgtHid4mUtrmv3
        sii78DW1MeqO6e5FDBY/EShh+pHIGSgnmksjHLx8YxuUTwt1sV54fXOibVO29VBk
        dvVG7SoFdkbCkiLeL0SDLJfWTb4eXKyFXD2DUAH+PzBoy2Pr2AmRiqGejFt15RdQ
        ==
X-ME-Sender: <xms:Le6YYAht9NHcbKJTBKV_qrfiUBiTmH3-Js-sEwIhPVx8EpftmJ8t2g>
    <xme:Le6YYJC4Xbp1iWbTxFGqe6VwGXExAs8S7s0OiNZlqno07jccfWl1QiC_zt1lMbuUw
    s8UGAIn4qv4lg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Le6YYIFN2Yn5PUsqKi_YnDZ_tVYJXHBXlotqepv5WwXhXcCc9XZogw>
    <xmx:Le6YYBRS94IoYK5y9kdKfuBhGGTfUWEwF_htnCsfNvkxAidYiKe-qg>
    <xmx:Le6YYNyuvzXe-Z1zlm9lN-c197A1CgLIRTkEntIsgD8pixXhA5on8g>
    <xmx:Le6YYI8756HUjWGaYHLmOQDhaotFDKlMVPYYcJ00i36IGKzWpv7fTw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:26:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc2: Fix session request interrupt handler" failed to apply to 4.9-stable tree
To:     Arthur.Petrosyan@synopsys.com, Minas.Harutyunyan@synopsys.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:26:19 +0200
Message-ID: <1620635179172166@kroah.com>
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

From 42b32b164acecd850edef010915a02418345a033 Mon Sep 17 00:00:00 2001
From: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Date: Thu, 8 Apr 2021 13:45:49 +0400
Subject: [PATCH] usb: dwc2: Fix session request interrupt handler

According to programming guide in host mode, port
power must be turned on in session request
interrupt handlers.

Fixes: 21795c826a45 ("usb: dwc2: exit hibernation on session request")
Cc: <stable@vger.kernel.org>
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Link: https://lore.kernel.org/r/20210408094550.75484A0094@mailhost.synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
index 0a7f9330907f..8c0152b514be 100644
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -307,6 +307,7 @@ static void dwc2_handle_conn_id_status_change_intr(struct dwc2_hsotg *hsotg)
 static void dwc2_handle_session_req_intr(struct dwc2_hsotg *hsotg)
 {
 	int ret;
+	u32 hprt0;
 
 	/* Clear interrupt */
 	dwc2_writel(hsotg, GINTSTS_SESSREQINT, GINTSTS);
@@ -328,6 +329,13 @@ static void dwc2_handle_session_req_intr(struct dwc2_hsotg *hsotg)
 		 * established
 		 */
 		dwc2_hsotg_disconnect(hsotg);
+	} else {
+		/* Turn on the port power bit. */
+		hprt0 = dwc2_read_hprt0(hsotg);
+		hprt0 |= HPRT0_PWR;
+		dwc2_writel(hsotg, hprt0, HPRT0);
+		/* Connect hcd after port power is set. */
+		dwc2_hcd_connect(hsotg);
 	}
 }
 

