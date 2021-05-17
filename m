Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A0538268D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbhEQIRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:17:10 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:59331 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235567AbhEQIQh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:16:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 3612C88A;
        Mon, 17 May 2021 04:15:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 17 May 2021 04:15:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jcs0OH
        adnmkbPJ+l3JHq/+SURT385UC7+tflWPHiZZw=; b=T94nnO6eXEpPdD3RK07bu3
        OOvZbqb86L9nEiETddSKILMnTZf+yJYPwPlBvj8JdaAVLypTFJSS0heVmavtc0WZ
        OkHbOTAqug0I+g8QxaXvxguRVZ2u2Rixu3VWtUAOAjGzR8KfbwK2qXRtV4JEIo3w
        e/MNRo/8uybzCJ1dJD0re9+5CCWO7Rt6MfOOisx4OEBRZQ/0+62rzoZkYU50z6gg
        aYM4OY/HCmFNbZaOOhUnRb6k6T6TKzoGEH2VGw2ycZ0u/7v1YmcBO9k7lLXK61eE
        ywRmVt78jF0Ihdmgi5A8xuWmHIRE5TUWrmvITzcBHJo1jP0IDSJ8+leRqgCDxh+w
        ==
X-ME-Sender: <xms:GCaiYBLNvRpE7CtNHRWPQdawIoSf7_jBYLgB041RsfvZcGSWeVnsVA>
    <xme:GCaiYNKYnNn9ihtvk_YgRbDC8h7mW9lbOxR0XKpiR2TFJ-vlH-VxJTPSzX4Oh4OUG
    GdlekQrFP0p0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:GCaiYJsV8k0TAQlBG4HautLItXE-SE1Ja8VlJALyRJf-1ojEZyAFxA>
    <xmx:GCaiYCbhQ0kt1vq02GCB70Ya3gY__EKfbvagxZjWAOVqI3r2ZPIjfw>
    <xmx:GCaiYIbFeu3bsURlR6k9YdbNKwlJSzxuN7Rc3TsXk8E-kJ_hQN9-cg>
    <xmx:GCaiYHm9qmAV9T6yapM-8N-T5IisrV2aQTlePmWDJl6TzofOtlfmZYKR0DU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:15:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Enable suspend events" failed to apply to 5.4-stable tree
To:     jackp@codeaurora.org, balbi@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:15:18 +0200
Message-ID: <1621239318160213@kroah.com>
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
 

