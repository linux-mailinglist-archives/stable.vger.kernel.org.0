Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE1F2B4A60
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbgKPQMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:12:36 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:60531 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729729AbgKPQMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 11:12:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 981531942D8E;
        Mon, 16 Nov 2020 11:12:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 16 Nov 2020 11:12:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NWgU1e
        HxbfpxGMkCo5+dghO6h4b7UJbELnxfM6RX2QE=; b=c/NX+KzEq5SrKdbiG6XJa3
        LD6EgnSWlpLp8k5+v5nTiFj93Mc/RjF7wRLmLzWte7NlVPGRlmxRMf4n4fujK5R+
        3gcpjaqpzw5A8f78UM1zNBusWzJOXxxxU2sfcGkULB3zjTdoznUSx3/RgQLit2NS
        FbeSuTGXQI6WghMAC5goCws8xI/FK3fkbrIKOfbZzVl2PQTuOr/JweZWAQaMv3vL
        0CcazakKEN3WJ1McPlwVoASkH5Uws14jGqBTjlxKPGa1GjfYhfeJyZP9mqqfdUOn
        Y7brStxO1tV2aF7VKCmTuPjZqzRWE3nXwIVZjESMLj/uhuz+p0ajYTiIQDVSHckw
        ==
X-ME-Sender: <xms:8aSyXyuLYYR7JdQyMAlr_faWCtZ48JFiOnHhvMJekymeSOyuVRcvWg>
    <xme:8aSyX3f_Kt67fA6GHX3piP39ax2a37nu847H384yZ4p6m-fxGjVctEoRziobPm7WP
    sddbdC5YPomQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefuddgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:8aSyX9wH6OQUnPOu6kmUALZN0UAjotctNHNVNZ9MMUhia3w3x3uo_g>
    <xmx:8aSyX9Nsjjk9rOqZXr5i5fAnBtwN819DZvK426QRNpbp8uHwPefEVA>
    <xmx:8aSyXy-sMQBbP8d393KrANS_qIE59sXW1KwIN2s1-lj0bG7vFK_zdA>
    <xmx:8qSyXz2op6W9Q_0Fpl_sHc3X5hiBQcAyAemLW44lzo9Bkv_ZnavuK1-_8NU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A44663280059;
        Mon, 16 Nov 2020 11:12:32 -0500 (EST)
Subject: FAILED: patch "[PATCH] Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"" failed to apply to 4.19-stable tree
To:     mcroce@microsoft.com, akpm@linux-foundation.org, arnd@arndb.de,
        fabf@skynet.be, gregkh@linuxfoundation.org, keescook@chromium.org,
        linux@roeck-us.net, pasha.tatashin@soleen.com, pmladek@suse.com,
        robinmholt@gmail.com, rppt@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Nov 2020 17:13:22 +0100
Message-ID: <160554320237238@kroah.com>
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

