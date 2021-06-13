Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09BC3A5833
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhFMMHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:07:37 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:48039 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFMMHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:07:37 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2AF7119409A7;
        Sun, 13 Jun 2021 08:05:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 13 Jun 2021 08:05:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=aM5NLS
        4ThHYQW20n9EZU+aEIjUS8sHVTOTyfAfMyYKE=; b=ImPy5lTxVGdAEyoKt4qApI
        8eIdgaIir318YZ54MQLECcriUttFyLgjOEJyohNqvdxooNlq96SR8QUKJB9c3iMg
        jRJvnE4+NjMIC06woIMU/uezKoaL13PO/VAV/n2VPEiO/btgkhtWMulMVoVGZ7LM
        OieNydagUQ1GFi8aVcFHJ0in1n1uNvREnMZdizwqw1yQSS9IxUCDJ3qxDeSAmRor
        CH7A11B4B4kVlAhNPRBRru284HAXHbV9tMWLEv6MDdI5Q/LtA8px5cdtEyVdijVz
        dJ9lwLbWW3nEwxu4WyWQpG9/yB+XnJd90IPtzqquIcdAC9xZMNo1Cgu8IDU0mH/g
        ==
X-ME-Sender: <xms:j_TFYGwMrO8jbwsxJRAPvRGsJ1S4ZiUd8VucPlr_zWDwSbL2PrA4nQ>
    <xme:j_TFYCRu8AJA77G0CutiIsLP5TuTJ28Hs7wMJFpg99N4DjPEebKta93M289emx97t
    tTx28C92ketGA>
X-ME-Received: <xmr:j_TFYIWV4_t1uD7wA8UqkpfImutbKWz-DduUvmQoNKb8r3S7niU1DUgfzK1tQFsinuzOAMeXym7QMRSB1FxjdyiIxrXyW6pu>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:j_TFYMiTuymXFUHncU98Wn5xxe5t08OM9V2PzyrLtnpBz_3Om3oKCQ>
    <xmx:j_TFYIBgRzSv4IXM5x5G6DXXQPFHOGDOXHOHPp12ALNBmAJ2w2D4-g>
    <xmx:j_TFYNKy_dnH7N5bNwAqhUl5hl-hOFGsZT4Wb3wmdZr3G7uqQGHhVg>
    <xmx:kPTFYL8dJsVf83T6tPPbZH1_9wio7Gj5muv6CkBqIi48_N2-Ou5WhA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:05:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: musb: fix MUSB_QUIRK_B_DISCONNECT_99 handling" failed to apply to 4.14-stable tree
To:     thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        drew@beagleboard.org, gregkh@linuxfoundation.org, tony@atomide.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:05:32 +0200
Message-ID: <162358593216355@kroah.com>
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

From b65ba0c362be665192381cc59e3ac3ef6f0dd1e1 Mon Sep 17 00:00:00 2001
From: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Date: Fri, 28 May 2021 16:04:46 +0200
Subject: [PATCH] usb: musb: fix MUSB_QUIRK_B_DISCONNECT_99 handling

In commit 92af4fc6ec33 ("usb: musb: Fix suspend with devices
connected for a64"), the logic to support the
MUSB_QUIRK_B_DISCONNECT_99 quirk was modified to only conditionally
schedule the musb->irq_work delayed work.

This commit badly breaks ECM Gadget on AM335X. Indeed, with this
commit, one can observe massive packet loss:

$ ping 192.168.0.100
...
15 packets transmitted, 3 received, 80% packet loss, time 14316ms

Reverting this commit brings back a properly functioning ECM
Gadget. An analysis of the commit seems to indicate that a mistake was
made: the previous code was not falling through into the
MUSB_QUIRK_B_INVALID_VBUS_91, but now it is, unless the condition is
taken.

Changing the logic to be as it was before the problematic commit *and*
only conditionally scheduling musb->irq_work resolves the regression:

$ ping 192.168.0.100
...
64 packets transmitted, 64 received, 0% packet loss, time 64475ms

Fixes: 92af4fc6ec33 ("usb: musb: Fix suspend with devices connected for a64")
Cc: stable@vger.kernel.org
Tested-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Tested-by: Drew Fustini <drew@beagleboard.org>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Link: https://lore.kernel.org/r/20210528140446.278076-1-thomas.petazzoni@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 8f09a387b773..4c8f0112481f 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2009,9 +2009,8 @@ static void musb_pm_runtime_check_session(struct musb *musb)
 			schedule_delayed_work(&musb->irq_work,
 					      msecs_to_jiffies(1000));
 			musb->quirk_retries--;
-			break;
 		}
-		fallthrough;
+		break;
 	case MUSB_QUIRK_B_INVALID_VBUS_91:
 		if (musb->quirk_retries && !musb->flush_irq_work) {
 			musb_dbg(musb,

