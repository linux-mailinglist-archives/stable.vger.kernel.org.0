Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA6D1F18BF
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 14:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbgFHM3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 08:29:04 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:45079 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729733AbgFHM3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 08:29:04 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 2BFF75D6;
        Mon,  8 Jun 2020 08:29:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 08 Jun 2020 08:29:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=W4b8QO
        UVKVvPlCN08IDLNhyiCUx6ZtJtyEOmLaORKsk=; b=t/Q2K/iztb05XYTvJdlHFq
        3ys559/u2BOzAhdKmjPLAcQ/+sI4HHFbzQvTaK9sXxrQS2Qr5R8VrD8KtaLrgZLd
        LDNSNws8A6gTnTHqDekmAGhnTVulJZQ4cWDTG3dq+Tal7ojbUqYsv167N5pumznO
        S0ZpeTn+Oerw93pTRFRgwR1ULH8BCwV/3dfs2221vIF8HQSaaxmTL6FOpwO8tp14
        OMpfSQKzwKBbFU3TKdutaw0cIud2oYulg1S20oQPGJUNxDEYpUpHmyif/Ct8EMBY
        x1lK0O6tzxALPlgVBTX9chR6vgFHOiQGcI65pAjmst5L9jB0ncuJjzYyFlheK5BA
        ==
X-ME-Sender: <xms:Di_eXt0HOTFjQPaNh1ikSqtuRkvRBq_nb-GZa87BG9yQXxKo5A6aEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudehuddgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Di_eXkEDC2Cwll1MgHAyc3fMN7jZMwneYVob4a2_Joxk5p_KCxDpdg>
    <xmx:Di_eXt4g6R69zxG-0Kb7FPJ65fGHl9mrM8gLF7BRBwymgaTBcXjHLg>
    <xmx:Di_eXq3eVbKPL2EeguozYVAWUprw8DNswQ3ByvXrQWmKuv0IMzTFyw>
    <xmx:Di_eXjz9mX_Tuo9DRDzXrggEoSuBfFwHZmu02iLYLck6aHTX-hoIQ2QT9eU>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 03BC73061CB6;
        Mon,  8 Jun 2020 08:29:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: musb: start session in resume for host port" failed to apply to 4.9-stable tree
To:     b-liu@ti.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Jun 2020 14:29:00 +0200
Message-ID: <1591619340113189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 7f88a5ac393f39319f69b8b20cc8d5759878d1a1 Mon Sep 17 00:00:00 2001
From: Bin Liu <b-liu@ti.com>
Date: Sun, 24 May 2020 21:50:45 -0500
Subject: [PATCH] usb: musb: start session in resume for host port

Commit 17539f2f4f0b ("usb: musb: fix enumeration after resume") replaced
musb_start() in musb_resume() to not override softconnect bit, but it
doesn't restart the session for host port which was done in musb_start().
The session could be disabled in musb_suspend(), which leads the host
port doesn't stay in host mode.

So let's start the session specifically for host port in musb_resume().

Fixes: 17539f2f4f0b ("usb: musb: fix enumeration after resume")

Cc: stable@vger.kernel.org
Signed-off-by: Bin Liu <b-liu@ti.com>
Link: https://lore.kernel.org/r/20200525025049.3400-3-b-liu@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index d590110539ab..48178aeccf5b 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -2877,6 +2877,13 @@ static int musb_resume(struct device *dev)
 	musb_enable_interrupts(musb);
 	musb_platform_enable(musb);
 
+	/* session might be disabled in suspend */
+	if (musb->port_mode == MUSB_HOST &&
+	    !(musb->ops->quirks & MUSB_PRESERVE_SESSION)) {
+		devctl |= MUSB_DEVCTL_SESSION;
+		musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
+	}
+
 	spin_lock_irqsave(&musb->lock, flags);
 	error = musb_run_resume_work(musb);
 	if (error)

