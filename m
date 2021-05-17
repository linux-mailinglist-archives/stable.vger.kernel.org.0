Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05E9382667
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbhEQIOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:14:02 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:47175 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235433AbhEQIOB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:14:01 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 53AB08E8;
        Mon, 17 May 2021 04:12:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 17 May 2021 04:12:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ot5JNw
        vLl6A3yySV8zHMy1EA0+JY559eDb5SX0WijdE=; b=ocmXdmUgxMfdCRHlK+6Xkc
        KowHoAi3nSgqH91PTdjmfcKyKiPHNMuSzorEgc/O7EeAdQjGewT828lMKWUpxleS
        BXHx7B2Ivu+h8y9HUrnpv75hFkT38fmGD0/QxWcRulaBQNTunNjfTaCLfhtHxgKi
        GnGwO9PEgLKwKrtLg0F6YkO04EBQgnlIZZ9oOiQhfvKZwAQKkxM/wnWZRLT6Y8ay
        OFd5ItVKQyvfcffeQt6MmUB3pnvgeNgPinZWhX/6tPbBfC4KyC5b7C8KtG9yT4sh
        qYM1PHBCv64j4BhvH3CjSskGMD6bJlBC7QISQA18G6vguj765AowcOZAydU30msQ
        ==
X-ME-Sender: <xms:fCWiYK8KoX-VfbMqiATnFu6iOxdiAQHd1JIqE4agygMV-eZuTidALQ>
    <xme:fCWiYKvidOooV4oGgnmDj5vwCVJLG8SaDFq3LUMATc5aDr3zRjmdb3BTnML6D5vUC
    8mg7OIKVA8hqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:fCWiYAB9bg5X3ACZ3H9BI36L2Z43vv0XKlq2VIVbMWTwGcEYeci6lA>
    <xmx:fCWiYCelPOpxgLtJsIqsb5ky61VBkfb4yvI1YRZwJopU7bDeqqbZDw>
    <xmx:fCWiYPMfa4b3VqaC053hAA_8sVYAPiux1NgbuQ_pLMme5nlDiVBVJg>
    <xmx:fCWiYIYYkSR_e3tNhmeR0uVwdE68LO4BpE3Km5FJ9Whe1_8EJbucOfuv9Ag>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:12:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Enable suspend events" failed to apply to 5.9-stable tree
To:     jackp@codeaurora.org, balbi@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:12:42 +0200
Message-ID: <1621239162239146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
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
 

