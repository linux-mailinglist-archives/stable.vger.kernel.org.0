Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893E12B4A64
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731202AbgKPQMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:12:41 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:42675 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729729AbgKPQMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 11:12:40 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 508C419432CD;
        Mon, 16 Nov 2020 11:12:39 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 16 Nov 2020 11:12:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=0GFFZZ
        hUMuiszQJXoMxwxFfCgTG6TJQ43p0+8OoKOg8=; b=mW/7i4jIe65EEgKk/W1D/g
        7MeSrASR/L5GrxxgfVxN4HSNjjvZjgDhye5SEikE1ipfqBgydLN21bp2kgIZ9w41
        lZMkUCuufiJpfpMX5dYsAi4wehCyz9+G4ycTUWI4+B2fukup+xhFtEDMWWdBLn0p
        XGdF1VOFHuMr2hn55/AziHMWn/3gczLeg0DuyfOCI6d6Zv+lOuC/875Z3G+1DO6I
        8e9ZOSJctH4yDWmU1BgVJzr90rLZ2d9f+DDmScxZawpkVuDezIUubWEp7uuHzHwp
        A9dRSZ+GcjP+AQHe/sbyaUhDublFbhE+pn57kLWLQ0+Nod1ySpyQ2Ydu2luaRDTQ
        ==
X-ME-Sender: <xms:96SyX-qPwq0bXTV8Xevv9bk3D2E-A7iQVMtOpZJqyNj6Oz-IgmZArg>
    <xme:96SyX8qe0ahig4r-k25mgh9iJtQGa9r4IYBpPGXM1La-CHX8RBZvllVW9MQ3RrjX-
    m61hBK7s1vECA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefuddgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:96SyXzNwgrtUFTEqKjIwGmMckjcQrabSu6QQ7eZRlrj2JIvLg_WyHQ>
    <xmx:96SyX94DP_WxzsY03FMUXXwJv963EZeBFVafOIvA1pcEdK3mqXA_Tw>
    <xmx:96SyX97dOVq5-NGq_zRRgHyH7OauuTi3t4zov1xFGJiiCyNBm2UbRQ>
    <xmx:96SyX6yja7XbQZPl2qJemzqFC6pmS1_NxmTqlT7WbAyn70Bowu0oJwUiIbk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C94543064AB0;
        Mon, 16 Nov 2020 11:12:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"" failed to apply to 4.4-stable tree
To:     mcroce@microsoft.com, akpm@linux-foundation.org, arnd@arndb.de,
        fabf@skynet.be, gregkh@linuxfoundation.org, keescook@chromium.org,
        linux@roeck-us.net, pasha.tatashin@soleen.com, pmladek@suse.com,
        robinmholt@gmail.com, rppt@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Nov 2020 17:13:26 +0100
Message-ID: <1605543206123223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 8b92c4ff4423aa9900cf838d3294fcade4dbda35 Mon Sep 17 00:00:00 2001
From: Matteo Croce <mcroce@microsoft.com>
Date: Fri, 13 Nov 2020 22:52:02 -0800
Subject: [PATCH] Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"

Patch series "fix parsing of reboot= cmdline", v3.

The parsing of the reboot= cmdline has two major errors:

 - a missing bound check can crash the system on reboot

 - parsing of the cpu number only works if specified last

Fix both.

This patch (of 2):

This reverts commit 616feab753972b97.

kstrtoint() and simple_strtoul() have a subtle difference which makes
them non interchangeable: if a non digit character is found amid the
parsing, the former will return an error, while the latter will just
stop parsing, e.g.  simple_strtoul("123xyx") = 123.

The kernel cmdline reboot= argument allows to specify the CPU used for
rebooting, with the syntax `s####` among the other flags, e.g.
"reboot=warm,s31,force", so if this flag is not the last given, it's
silently ignored as well as the subsequent ones.

Fixes: 616feab75397 ("kernel/reboot.c: convert simple_strtoul to kstrtoint")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201103214025.116799-2-mcroce@linux.microsoft.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/kernel/reboot.c b/kernel/reboot.c
index e7b78d5ae1ab..8fbba433725e 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -551,22 +551,15 @@ static int __init reboot_setup(char *str)
 			break;
 
 		case 's':
-		{
-			int rc;
-
-			if (isdigit(*(str+1))) {
-				rc = kstrtoint(str+1, 0, &reboot_cpu);
-				if (rc)
-					return rc;
-			} else if (str[1] == 'm' && str[2] == 'p' &&
-				   isdigit(*(str+3))) {
-				rc = kstrtoint(str+3, 0, &reboot_cpu);
-				if (rc)
-					return rc;
-			} else
+			if (isdigit(*(str+1)))
+				reboot_cpu = simple_strtoul(str+1, NULL, 0);
+			else if (str[1] == 'm' && str[2] == 'p' &&
+							isdigit(*(str+3)))
+				reboot_cpu = simple_strtoul(str+3, NULL, 0);
+			else
 				*mode = REBOOT_SOFT;
 			break;
-		}
+
 		case 'g':
 			*mode = REBOOT_GPIO;
 			break;

