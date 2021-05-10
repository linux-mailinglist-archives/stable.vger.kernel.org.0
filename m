Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C597F377E16
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhEJI0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:26:18 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:60885 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230152AbhEJI0L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:26:11 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id CD562194053A;
        Mon, 10 May 2021 04:25:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 10 May 2021 04:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=agGWTY
        StH2kqVZRdaV+yyom+TlwzDTqPfcSFwP+s6+Q=; b=JytF3tS+nkDenmjrOZIxHj
        3gVfK+sJZsle2XB5Lq5lBPasv6+kXkZ8xiAmjjVPUfUqPDkmSxD9VK0/7pgKgNc6
        lrxEKmKC7V85YjFJjbZ5F5NSzg9UmmvpTl39RCSC8k0L9gpkWP3p8pnsG+4Top30
        McGNV71xEsZXeVrhgUDNZPf/B0AbgRe5YIPSZNHvH4mXG2bJCF7jRoe25YNfFXAE
        JbNp02Nh7/8EJbQHlwmDWT2uNKI1sBzjnyu6Y581lKVx/QZRzzaFaS2YXsoGovkF
        upf1pm06T2t23TOgq21qBikpH9kp/84gTYwk3TdTqie2+drsJkRqw2WVPQHkGegA
        ==
X-ME-Sender: <xms:3-2YYMgxr-XR6VVTBVZNhvCRnV30LVooCLjqelXAZEWr_FjrIgdadw>
    <xme:3-2YYFD-p84VVsjaVFFlLoxUuUfSCV72TARP_Xd5tsehWluhIo7lehpfmZU76gwLL
    Yi53FBnRzq0ZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:3-2YYEGAI7WqP3W3js2wDbSfT7pkW23d-VkumVXTvouICCN0X0TrrQ>
    <xmx:3-2YYNRtJ-Tvq4I4PmRhHgNWL8nIzOCg6rBrKZAvRBzvxGnAqajVdA>
    <xmx:3-2YYJz_KeXMigtiMJSVR7zEmvrQnRVZWR9Ngjyy1ckKW-Dmx8oCrA>
    <xmx:3-2YYE_kgjL8yqgYDyj85w8l2hzETq58R_vHF2quXgd8MWaEzkvAEQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:25:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc2: Fix session request interrupt handler" failed to apply to 4.4-stable tree
To:     Arthur.Petrosyan@synopsys.com, Minas.Harutyunyan@synopsys.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:25:01 +0200
Message-ID: <1620635101225181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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
 

