Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C753A5834
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhFMMHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:07:46 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:52143 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFMMHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:07:46 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E06BC19405EF;
        Sun, 13 Jun 2021 08:05:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 13 Jun 2021 08:05:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kMSIpO
        IoB6jBCq5XNGEeHZXmDentOewPxvHHGWobxP0=; b=a+BN9tzX29pnCyxVgJ8LRN
        v+MoRPVV6/MWsXdmAifk75SCGIjagCNQFWaPjlSfLMe+TwjdjLB3qqRjrIaGHCAN
        3f00YA25QKysHuwzR9eZBpBgaP68ngUGD4nrbNXKuSSCU0DLvJk77hqqIHP0kyXl
        hN6x9WeCnjXorWs6LVEbLj21iIeasreBn6J2RKOfA5ry0BOuI6idU3bBdz5LfPjk
        GTEFzCXcEujyjcQPXhnWTVayDNc4a5Sgq/OxofLZEJ/A1uo03OZSCcaUhVCJRgr6
        purGqBemqb1OT1p2SyFg1OZiKFjdn37bWBknOnmK+NHwzLACIP7GkvWMXuyou8Ag
        ==
X-ME-Sender: <xms:mPTFYJIozB_MZvSPoFahQJLFgxbufWfUdS0ic_HoCxSqyCj-9itPJw>
    <xme:mPTFYFKO7kD1rwFpJZsXr5yJquodJ9kyaOpXRKCLEDlqztIr8qyiohbFw88mthAXJ
    rlaRf1hzfcIoQ>
X-ME-Received: <xmr:mPTFYBudaEB33dcwKWYSE2lBrG_taooOvzhHywTs-FpQ87omPPMepSybW_RkK9HNBL2TIP2Y4riK6PYAKujhW21Es1y6sFIB>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:mPTFYKaSeO0uzy8mgCNd-639QFMqhxJFUHINU5zyoG9NoEON4YgMnw>
    <xmx:mPTFYAZZY9HyF08pmpOoHI-AjT9ZM414oZ-3NYJLBu5yQ1A9fJvYGg>
    <xmx:mPTFYODnti_vBZu5n_LT20A6yLJptBV49H4xlobdyqsmBzR7paQSvg>
    <xmx:mPTFYHVxlnHLmVlqLITyvJDDqVwq-LHuuXqp4l-zoc1CjXPOEttOTw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:05:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: musb: fix MUSB_QUIRK_B_DISCONNECT_99 handling" failed to apply to 4.19-stable tree
To:     thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        drew@beagleboard.org, gregkh@linuxfoundation.org, tony@atomide.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:05:33 +0200
Message-ID: <162358593315469@kroah.com>
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

