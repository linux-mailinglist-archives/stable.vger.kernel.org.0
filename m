Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049342B4A63
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbgKPQMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:12:39 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:56879 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729729AbgKPQMi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 11:12:38 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C32FA19432D4;
        Mon, 16 Nov 2020 11:12:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 16 Nov 2020 11:12:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6y7kV4
        KOVkpXbBFXEPCiZaghfKVnkf+JrpsQKxd4X9w=; b=Ge8hgUmIa4NLXouonv3zen
        3YVfePrvgW8wEFGiBm4BK25j+mtYj2MwXnryWCna1/45ec7mqS3R3Ic4ns66uCOF
        3wMmY6yUl5Y8NLCaEzw5GJKUA0n00sSRRxKKPz5+5AxPIlJQEC0TCkqi7HG6PMX6
        +zVhm1I1bRHumDEKf3iGWV8FpXAwL75w32Kq9VzFOjmNTKEAXk5nTJU31x93WBR6
        yFX/NeEEjttfR0yacx0YwM/ehmemMnnXRU6CZoLVssEoJyGi5532guG9ZWnB+qpU
        68PVzleXktpvxvlEi0gpR6yK+xdlLlN+Fuzs+11KAa9Y0k7nSyXkmdycIZvZ2KTw
        ==
X-ME-Sender: <xms:9aSyXy7IpEYfL-vd-r5G1FD2PQhQfo8hmFBwzp6fteYZa_sMuymZ1Q>
    <xme:9aSyX76rYNb8l3v_IGxeeYV30XvImfok9wwa2MnCLVdW4kiIneTUV3euxspkX7JUj
    2sXwjvIXujWVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefuddgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:9aSyXxcs_i_W7cxWpmjZZ2SKZj-6zNntZ5kzJ4khFo7Ddmx_NNFENg>
    <xmx:9aSyX_Lb7KZRDbOpXdFsQLfAt3WrhBjEiC9LQlEnbGvPHlrKS-VV9w>
    <xmx:9aSyX2LW0LvQrHrF97CoTtWrOXgijMDRQWx_IsWobgS1HnEfzNT2Hw>
    <xmx:9aSyXzDFgcZhkMinS-pkbuX8I-IkjdGeeQwXmfD320GWnLnmWyxa26ZAh2c>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 450123280065;
        Mon, 16 Nov 2020 11:12:37 -0500 (EST)
Subject: FAILED: patch "[PATCH] Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"" failed to apply to 4.9-stable tree
To:     mcroce@microsoft.com, akpm@linux-foundation.org, arnd@arndb.de,
        fabf@skynet.be, gregkh@linuxfoundation.org, keescook@chromium.org,
        linux@roeck-us.net, pasha.tatashin@soleen.com, pmladek@suse.com,
        robinmholt@gmail.com, rppt@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Nov 2020 17:13:25 +0100
Message-ID: <160554320515885@kroah.com>
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

