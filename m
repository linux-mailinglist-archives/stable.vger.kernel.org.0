Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A4B382668
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbhEQIOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:14:40 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:56647 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231919AbhEQIOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:14:39 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 5A97F1E8;
        Mon, 17 May 2021 04:13:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 May 2021 04:13:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5P0j7+
        tz2NizXepgPgxvStnNXLkRxU1xKhSd7lluo3A=; b=m4yYIs+GI1O8+zjZMoUUcl
        MgeDAjXtZNzYycUrpyZ8sV7tFk9b98Tf2pLed00OWjW2JW5Q7x2W1lqaKkgi57+w
        0DWmxzdcwBNb4xVF1IhlrP8/Tkrx9Z18pqLLR117gEgwgDwmkA++INut3oT0ek14
        ih5u5N+ikhZ3pKYPPeWASpk/Br6QvwhiKXQjxRI8dHfQYhT8RSZJHLrVbERNNwiG
        +wWQ4q12ufrQ/sudYmfTP2sxELdCHfXiUXCuajgi4BBdcjrs2D2dxI9TRPZfCZ+G
        hk0TFbmWcAUMaz1QvCg19ou0P3ldG9ccro/wFYzhPAmhmg1bKdMW7ws4yVQCC6Jg
        ==
X-ME-Sender: <xms:oiWiYPzEMbuL2IcCOq24wT5tQ7RM2iVKvz1iLxjv-Rp6Htmfzz4Prg>
    <xme:oiWiYHRjcdO8IMhjKKiVoDN4_X0FWc8a6SvAXl9QJf_NXJpHhZt5sdAUhYo12P4p5
    t3pFdbQpPAYSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:oiWiYJXo8SRd14qRW12GHD021V3Gg3mL6APWA89Il15fPqiGO7S7VA>
    <xmx:oiWiYJhRNfYJ5h-P-vNT4qqomV-dYweLXaHxhp2f-zSq5TQint3FWQ>
    <xmx:oiWiYBASZgBiOEOsu-oZdkj195kzIwPlinQpdMdZ8kPjl2OKYj84Fg>
    <xmx:oyWiYENRe7uM6dmW44KWoU7oLhIA2vwi5C8jSeB3XoEpNX82y_Pcyjiqdeg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:13:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Enable suspend events" failed to apply to 4.14-stable tree
To:     jackp@codeaurora.org, balbi@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:13:15 +0200
Message-ID: <16212391955939@kroah.com>
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

From d1d90dd27254c44d087ad3f8b5b3e4fff0571f45 Mon Sep 17 00:00:00 2001
From: Jack Pham <jackp@codeaurora.org>
Date: Wed, 28 Apr 2021 02:01:10 -0700
Subject: [PATCH] usb: dwc3: gadget: Enable suspend events

commit 72704f876f50 ("dwc3: gadget: Implement the suspend entry event
handler") introduced (nearly 5 years ago!) an interrupt handler for
U3/L1-L2 suspend events.  The problem is that these events aren't
currently enabled in the DEVTEN register so the handler is never
even invoked.  Fix this simply by enabling the corresponding bit
in dwc3_gadget_enable_irq() using the same revision check as found
in the handler.

Fixes: 72704f876f50 ("dwc3: gadget: Implement the suspend entry event handler")
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210428090111.3370-1-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index dd80e5ca8c78..cab3a9184068 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2323,6 +2323,10 @@ static void dwc3_gadget_enable_irq(struct dwc3 *dwc)
 	if (DWC3_VER_IS_PRIOR(DWC3, 250A))
 		reg |= DWC3_DEVTEN_ULSTCNGEN;
 
+	/* On 2.30a and above this bit enables U3/L2-L1 Suspend Events */
+	if (!DWC3_VER_IS_PRIOR(DWC3, 230A))
+		reg |= DWC3_DEVTEN_EOPFEN;
+
 	dwc3_writel(dwc->regs, DWC3_DEVTEN, reg);
 }
 

