Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13BB1F18C0
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 14:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729726AbgFHM3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 08:29:07 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:40759 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729733AbgFHM3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 08:29:05 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 883BB490;
        Mon,  8 Jun 2020 08:29:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 08 Jun 2020 08:29:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kcrAVd
        3vC9HK/+C8FsYV/e7hn1XtQ5NWf7VwkN8A4ds=; b=FALV/GCOLV+wkQYFW9FCqf
        rwfuYItabahtBSOxhcCk36vtdeXX5ZUrUKIbT+e5QcjjMSMh8rN+eqk6Hnm/nYRW
        50MdwQy3x4Ugca04700p2ufVIYoh4WQMDMZQxt1tQ9aUT9iNpmWU3dI6jGt4fZI/
        F9NZfWjSLWPAdz1bzjAkA355RpC+dOiJRjknhDY3ymm2asbZ1Xp+rL5/V8dhLBVx
        9pmQjzwj5tcoh26ys/akV25t3zmPcQi2OWvQWYYxO9twICx47LMKzLNDfBxqLYpe
        XzqwNBNYWcA7PUvs4vzOMZpxIY+XP1TpMaG9YvQq/T2BOSbJkX6D7/YcoIOUvm0A
        ==
X-ME-Sender: <xms:EC_eXgVIM-dZPgYi24kdOcTG47S8TFDZadHKFshk6KNwAQDIkd4sAQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudehuddgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:EC_eXklEHIZcTLcxyntMi6SR38oY5YACOLmwA3PwFrxc0FH61u5GqQ>
    <xmx:EC_eXkYBD7h8VxW-5f-jipz83s5oO5xIQdqjhH5GwXeHOgRZaIFs1w>
    <xmx:EC_eXvXa8_4NvU5RFshw62VWadgrhjQ84Zm1tqhx9lfUayOlItCG9A>
    <xmx:EC_eXkRXX32VMUttO-8ZNg021ahTgVMImd1SMWbIg1I9neOS__FSWot2CQc>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C9C7930618B7;
        Mon,  8 Jun 2020 08:29:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: musb: start session in resume for host port" failed to apply to 4.4-stable tree
To:     b-liu@ti.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Jun 2020 14:29:02 +0200
Message-ID: <1591619342110219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

