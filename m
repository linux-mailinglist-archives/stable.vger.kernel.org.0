Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34481249DDF
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 14:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgHSMcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 08:32:23 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:34761 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726952AbgHSMcV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 08:32:21 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 7590495B;
        Wed, 19 Aug 2020 08:32:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 08:32:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1sutNu
        jIOllIIH/mSPeEZYe6C9FQMOGt7cWbvyyMyFI=; b=OjEaYFGlgZiD68MBI3K0Rt
        nhtEQD7Ti0sOvzDX49gSGJhaLQn5hdfLDapBLHyTq9Qa7QHfH8aBSKGck0QcAXeH
        ZJ5ge8LS4W7odyee3appc7Cuv+Sxe83VH35t70oBvptSsYVjse93IG/8XRnviSqz
        CMzcPz9NQy5ddtczSVAqzF1YcTKfRfta6AE/y3uVG4v2nDldkUv7utjeRHGBPhtu
        EGIWLor3TZLF+H2IUNjptiwIXvcpJEno9xtUD2Cv5b1VSlHB0oQ7+f7zarWVSQ/n
        fWcMp+DEH3cj9o+KZbCPDFceLy3n69ozz+SXh4+LlU5ncurATqd0dSO7Pm8BgPmw
        ==
X-ME-Sender: <xms:0xs9Xx5d6nlvyC0NwhmMEysdcjfK50D88lnpQnrBii1q7-IdXRxl4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:0xs9X-61EJzQzLLoE2E1xEvKxPsgYl9m9pVx4K9dMjM8zpelfR0gdg>
    <xmx:0xs9X4eiWYnrugrxSvTu8AoHyqYw8abKqhPcSbM2mkKElRoRugoVCw>
    <xmx:0xs9X6Lphi7hnO7S4f2_NUUwC79IQobEVcvEMCZckpxNzecEpuNmbg>
    <xmx:1Bs9X3zpT99TkfZpUEN5evY8_Fq8xDLxQi72ILnZMeZL9-GL7hAcho30Tf8>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0464E30600B2;
        Wed, 19 Aug 2020 08:32:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] watchdog: f71808e_wdt: remove use of wrong watchdog_info" failed to apply to 4.4-stable tree
To:     a.fatoum@pengutronix.de, linux@roeck-us.net, wim@linux-watchdog.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 14:32:42 +0200
Message-ID: <1597840362204192@kroah.com>
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

From 802141462d844f2e6a4d63a12260d79b7afc4c34 Mon Sep 17 00:00:00 2001
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
Date: Thu, 11 Jun 2020 21:17:44 +0200
Subject: [PATCH] watchdog: f71808e_wdt: remove use of wrong watchdog_info
 option

The flags that should be or-ed into the watchdog_info.options by drivers
all start with WDIOF_, e.g. WDIOF_SETTIMEOUT, which indicates that the
driver's watchdog_ops has a usable set_timeout.

WDIOC_SETTIMEOUT was used instead, which expands to 0xc0045706, which
equals:

   WDIOF_FANFAULT | WDIOF_EXTERN1 | WDIOF_PRETIMEOUT | WDIOF_ALARMONLY |
   WDIOF_MAGICCLOSE | 0xc0045000

These were so far indicated to userspace on WDIOC_GETSUPPORT.
As the driver has not yet been migrated to the new watchdog kernel API,
the constant can just be dropped without substitute.

Fixes: 96cb4eb019ce ("watchdog: f71808e_wdt: new watchdog driver for Fintek F71808E and F71882FG")
Cc: stable@vger.kernel.org
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200611191750.28096-4-a.fatoum@pengutronix.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>

diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
index c8ce80c13403..8e5584c54423 100644
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -690,8 +690,7 @@ static int __init watchdog_init(int sioaddr)
 	 * into the module have been registered yet.
 	 */
 	watchdog.sioaddr = sioaddr;
-	watchdog.ident.options = WDIOC_SETTIMEOUT
-				| WDIOF_MAGICCLOSE
+	watchdog.ident.options = WDIOF_MAGICCLOSE
 				| WDIOF_KEEPALIVEPING
 				| WDIOF_CARDRESET;
 

