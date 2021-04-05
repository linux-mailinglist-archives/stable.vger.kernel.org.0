Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC38B353C4E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhDEIQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:16:25 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:59155 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229660AbhDEIQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 04:16:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 63BF31940A49;
        Mon,  5 Apr 2021 04:16:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 05 Apr 2021 04:16:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=53dunG
        h7zEs3+K0t4XCMPOeUTfOFB6mR3XaEKEkc3A8=; b=PMsBdEJUA7xbanV6UqToWQ
        5x8oU39T15lZ/hvDGE57T17M0YNHE1DDxwiJsOp9WhwPE6G/eQpZ2mDVlOIXZJDY
        O8jJ3WEQDqeJaCF7glAzqafsHUzc9c9SuTi26vEx2FpYW/4yEfpQJkrkLFI9M83y
        Rzh1+CjkK6A6GlJzK9eyvHBu/YyPwjbyXnJ7Ro4n5wfrO6epbUuou3Zvxy8KsO30
        UxTX+EvjooPI4JP2G+jnMGbkhhMhGCEABVEBnqYWJCNa4Ei2rHwEc+MFW3TtJvAT
        McYKJJpQQhsiQiFjmdR3CNfhcZbekQWnIaYhrEx8+5D7M1TJgQtHtZuUf9pAHCTQ
        ==
X-ME-Sender: <xms:UcdqYGGSXxTuZdmInb05gD4wRsMouGkD5yRpHVi7r6Yty56fwlh3UQ>
    <xme:UcdqYHWVluGwagHLGyAIMk5bXvpNbQE5Jl6xtLrOL4NCbsiO69C_6QngviuIfS0l_
    U-xXS357jomXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejvddgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:UcdqYAIZoYzQIkgx4NYd6MsTQunIX3GJPwfWaVCPZHYS40ZaSrR8WA>
    <xmx:UcdqYAHeyqtfN90dif-DuJhv6oTMHFlR52bmNEhlUXNsB8vAvkrRPg>
    <xmx:UcdqYMUwBSzlkNsafgqSslW2oUHI0m9So2FG57edAOdtV_vqH5rtvQ>
    <xmx:UsdqYHdIhfWw9YNrX8oJL4AmyMjxRjtE7pUbuYOc5fmO_CtTeHxhqA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B4C6D240057;
        Mon,  5 Apr 2021 04:16:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: musb: Fix suspend with devices connected for a64" failed to apply to 4.9-stable tree
To:     tony@atomide.com, bshah@kde.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Apr 2021 10:16:14 +0200
Message-ID: <1617610574159134@kroah.com>
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

From 92af4fc6ec331228aca322ca37c8aea7b150a151 Mon Sep 17 00:00:00 2001
From: Tony Lindgren <tony@atomide.com>
Date: Wed, 24 Mar 2021 09:11:41 +0200
Subject: [PATCH] usb: musb: Fix suspend with devices connected for a64

Pinephone running on Allwinner A64 fails to suspend with USB devices
connected as reported by Bhushan Shah <bshah@kde.org>. Reverting
commit 5fbf7a253470 ("usb: musb: fix idling for suspend after
disconnect interrupt") fixes the issue.

Let's add suspend checks also for suspend after disconnect interrupt
quirk handling like we already do elsewhere.

Fixes: 5fbf7a253470 ("usb: musb: fix idling for suspend after disconnect interrupt")
Reported-by: Bhushan Shah <bshah@kde.org>
Tested-by: Bhushan Shah <bshah@kde.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20210324071142.42264-1-tony@atomide.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 1cd87729ba60..fc0457db62e1 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2004,10 +2004,14 @@ static void musb_pm_runtime_check_session(struct musb *musb)
 		MUSB_DEVCTL_HR;
 	switch (devctl & ~s) {
 	case MUSB_QUIRK_B_DISCONNECT_99:
-		musb_dbg(musb, "Poll devctl in case of suspend after disconnect\n");
-		schedule_delayed_work(&musb->irq_work,
-				      msecs_to_jiffies(1000));
-		break;
+		if (musb->quirk_retries && !musb->flush_irq_work) {
+			musb_dbg(musb, "Poll devctl in case of suspend after disconnect\n");
+			schedule_delayed_work(&musb->irq_work,
+					      msecs_to_jiffies(1000));
+			musb->quirk_retries--;
+			break;
+		}
+		fallthrough;
 	case MUSB_QUIRK_B_INVALID_VBUS_91:
 		if (musb->quirk_retries && !musb->flush_irq_work) {
 			musb_dbg(musb,

