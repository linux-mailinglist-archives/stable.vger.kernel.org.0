Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F87377E20
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 10:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhEJI1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 04:27:35 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:50133 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230153AbhEJI1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 04:27:35 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 96E5E1940B81;
        Mon, 10 May 2021 04:26:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 10 May 2021 04:26:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=i0ip41
        Bo4NleMhy7NmUQcSlFiZYzm9etxDlRv0jd9bk=; b=DJtlpme7fOYF8Gq63s3Q3X
        rPrdRKsviWsMZasYHI2MbG2pZ9l33K0YNdv0WFhXCn2DO8G+6fo1OOb6PPYH5XGz
        QQh06TYwcSp960TnMP/il0bVtLmhpHvSm+AelURRv/2U3ogBZDoKWngnviDVvRA1
        wUptk8cJK15j+hv82G5zIIDdoTordrKAF8ezi0T/Lk2S5M6avaTAuo4J5G1gKB5/
        22bZ/Ad3X9k/KffCpI1iyOKwRhuLDGiOC4R2P9vHgKKU/UJgUk+SVv7MuHy9fo33
        WxJtOCfFzuIh13V7adxjOe4bhG00NTJs5JZLN//Eoajvz2UJBL4hAU6eYdLfd32A
        ==
X-ME-Sender: <xms:Nu6YYG2QDa7XIkqVsDbFBvHycgFxZpJulDowGI33rdZTauIK_cXjzQ>
    <xme:Nu6YYJGI-j0XFi9q3VlLukIgmbK9HSJx5CmSWSEBbz--aV5MJbAHmWPiwtN0GkB3K
    LWBgFaoREF05A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegkedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Nu6YYO7DahV6SLOk7uVb0KQ3R6Xn3FoGrPk9uAa0pTPowN6O4mUTCg>
    <xmx:Nu6YYH2syFJtorKSKaVUZskEiMzY_LXZou19dXmuSMFEgMOmefRu3w>
    <xmx:Nu6YYJGD6S9-nn9etZnpEC4AmPqtDj7yfH7y8WMy-csGb_a1pXIDsg>
    <xmx:Nu6YYOQRkQXLD7hhpz_OuBD3rLFF70EFGq-t-pyN22XWBDcUrEkNRA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 04:26:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc2: Fix session request interrupt handler" failed to apply to 4.14-stable tree
To:     Arthur.Petrosyan@synopsys.com, Minas.Harutyunyan@synopsys.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 10:26:20 +0200
Message-ID: <1620635180139140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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
 

