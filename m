Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823E22A44D0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 13:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgKCMKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 07:10:42 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:40003 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728354AbgKCMKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 07:10:41 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0195CC79;
        Tue,  3 Nov 2020 07:10:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 07:10:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=fvan++
        3cH5YPVkH5ggFC4fz7Nek+OshMXXGrOS//cu0=; b=mnpdGK4/PSy7ZTYCp8ltXB
        iX8dqPJEpXsFSR3f5ZCU6MeaC4oEVAzkuIElfZ/ILNBUC7LyTPNqbF/1dBE6wz2l
        TbzajRK+XEU+1gI+pO5GSMQxs0g7dXh9qqft9V5hhAul/IQVii+UCaU0ploDORUQ
        3M4KG6OTlMEqaCS6gkt2bGUeAoM4jG4XIxt8ZJ3VVs+CWbkJyckYhQwfqLkKvy5f
        z+wtPq2TsiZfxCMFpQSPjfBy+EV5dTNbpCjaGfPhc8Y4H7Dqo4SeMZG9zdjPTwxW
        wouYylOGS+8kUMq6DBojwpY+B/4WmiI5KbECeTabR5QEpexxx3k3F9kFmaOthVFg
        ==
X-ME-Sender: <xms:wEihX0sy3fa33QYVNxcRZc-m_nRjRixMXsQnK22G5Ix2GQpG3Ueq_Q>
    <xme:wEihXxfod4YgMYM8d5bZlZ8unh5TwHzJLkRAI3nHmj1mwCthfCDfoHWNeQqsbCmGO
    DmBHpejniLoHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:wEihX_zTJtoS69bmS5TTes7lHYmZzzt8NC1LFONo_3Wm9x7o-NpSXA>
    <xmx:wEihX3MWMP5If1x2gs8yATpuOVPMQeoVdODJ9rHFICWLm8TdDdRa5A>
    <xmx:wEihX0-l7BYtiNZKwqnBxH1JBEK5LzO7sBHULi5fC6EPCkn6vIbguA>
    <xmx:wEihX5H0Y4xKtufAhTOcsXStmDEiDZcgD4AnQnwBT1gSOTCRRLFpyUJwuF8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B39E33064610;
        Tue,  3 Nov 2020 07:10:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] w1: mxc_w1: Fix timeout resolution problem leading to bus" failed to apply to 4.19-stable tree
To:     martin.fuzzey@flowbird.group, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 13:11:30 +0100
Message-ID: <1604405490163203@kroah.com>
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

From c9723750a699c3bd465493ac2be8992b72ccb105 Mon Sep 17 00:00:00 2001
From: Martin Fuzzey <martin.fuzzey@flowbird.group>
Date: Wed, 30 Sep 2020 10:36:46 +0200
Subject: [PATCH] w1: mxc_w1: Fix timeout resolution problem leading to bus
 error

On my platform (i.MX53) bus access sometimes fails with
	w1_search: max_slave_count 64 reached, will continue next search.

The reason is the use of jiffies to implement a 200us timeout in
mxc_w1_ds2_touch_bit().
On some platforms the jiffies timer resolution is insufficient for this.

Fix by replacing jiffies by ktime_get().

For consistency apply the same change to the other use of jiffies in
mxc_w1_ds2_reset_bus().

Fixes: f80b2581a706 ("w1: mxc_w1: Optimize mxc_w1_ds2_touch_bit()")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Link: https://lore.kernel.org/r/1601455030-6607-1-git-send-email-martin.fuzzey@flowbird.group
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 1ca880e01476..090cbbf9e1e2 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -7,7 +7,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>
-#include <linux/jiffies.h>
+#include <linux/ktime.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
@@ -40,12 +40,12 @@ struct mxc_w1_device {
 static u8 mxc_w1_ds2_reset_bus(void *data)
 {
 	struct mxc_w1_device *dev = data;
-	unsigned long timeout;
+	ktime_t timeout;
 
 	writeb(MXC_W1_CONTROL_RPP, dev->regs + MXC_W1_CONTROL);
 
 	/* Wait for reset sequence 511+512us, use 1500us for sure */
-	timeout = jiffies + usecs_to_jiffies(1500);
+	timeout = ktime_add_us(ktime_get(), 1500);
 
 	udelay(511 + 512);
 
@@ -55,7 +55,7 @@ static u8 mxc_w1_ds2_reset_bus(void *data)
 		/* PST bit is valid after the RPP bit is self-cleared */
 		if (!(ctrl & MXC_W1_CONTROL_RPP))
 			return !(ctrl & MXC_W1_CONTROL_PST);
-	} while (time_is_after_jiffies(timeout));
+	} while (ktime_before(ktime_get(), timeout));
 
 	return 1;
 }
@@ -68,12 +68,12 @@ static u8 mxc_w1_ds2_reset_bus(void *data)
 static u8 mxc_w1_ds2_touch_bit(void *data, u8 bit)
 {
 	struct mxc_w1_device *dev = data;
-	unsigned long timeout;
+	ktime_t timeout;
 
 	writeb(MXC_W1_CONTROL_WR(bit), dev->regs + MXC_W1_CONTROL);
 
 	/* Wait for read/write bit (60us, Max 120us), use 200us for sure */
-	timeout = jiffies + usecs_to_jiffies(200);
+	timeout = ktime_add_us(ktime_get(), 200);
 
 	udelay(60);
 
@@ -83,7 +83,7 @@ static u8 mxc_w1_ds2_touch_bit(void *data, u8 bit)
 		/* RDST bit is valid after the WR1/RD bit is self-cleared */
 		if (!(ctrl & MXC_W1_CONTROL_WR(bit)))
 			return !!(ctrl & MXC_W1_CONTROL_RDST);
-	} while (time_is_after_jiffies(timeout));
+	} while (ktime_before(ktime_get(), timeout));
 
 	return 0;
 }

