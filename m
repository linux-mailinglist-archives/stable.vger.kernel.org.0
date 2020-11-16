Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E3D2B500B
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 19:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgKPSmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 13:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbgKPSmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 13:42:15 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBB1C0613CF
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 10:42:15 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id s13so251073wmh.4
        for <stable@vger.kernel.org>; Mon, 16 Nov 2020 10:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9L65A0dxDhXukycconay8uPiRfEP5x6cWJgWRs9sTYg=;
        b=fP0Tzwfcj1OpaVH3FbwEVOeprTu0GEq1MoG8XlgqCa5v5umOjx1WOOirXuPb0lmjAH
         SqD0GdnfH1HMtXCmmqur5HnnW5j6CASp7GTVHLHATeKSMj7w8xVGpIFqcJSAoBuuGKYS
         +4e4C6LengfLEMb+mLIFfV40ql9BZjtBiwNalh1c/Lo1e9X8U6IAFVlel9+/hXqHul4T
         oNH4j5o5f3Tx3bmXwIZOXEA1/B5Kx+x8Ou0x3BJMufAA6esoBoA2P4pWiPrSPZSeTKmJ
         f8+xLR1LvtKkeFCtIvYeROXeuVqfsmF3DhVZWt+LZTehhFAiKFvonxb/36AWITZy5hcm
         AKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9L65A0dxDhXukycconay8uPiRfEP5x6cWJgWRs9sTYg=;
        b=fP7AdfjBRLvTfEQt8P1XzP8BM5CPrz8916bbGTMAvFveiJMEYufGc75/U72V4vAdM3
         vsfc5l70QJF3EVjCxkmkIZCz+2Ilw4ohYueEDZiyn7Y9KbJECBhWbJJCkKib5GeJ+DHA
         HHVVn5UlQTWL2ud2uIfEcEntLDOBf4z+5nJtM4oA7aOurSx5eLmeNoRL5kWJJebhNimC
         IUKI7PqJ0AsGdwxrVVzDI14+maBWk3mWR7OXUOR+Rn7PJ6zE02I9yRONE0swR3r3m5D6
         HF21/OS2I+jfx7tz4/K9MfrwNhXWlW5AyTZz5g9hOO46H5PvL7WwEhfnnuhQVJgfh9AC
         euDQ==
X-Gm-Message-State: AOAM532aKEESPWnXpIOs58t2e6O2qoU6VUlt1Oo8ugwT6Nr0sCEGuPT3
        X6CrUGmAH9ZIYPxw9JfAE24=
X-Google-Smtp-Source: ABdhPJyT5U+rENp2faDZIAalx3qP8Bv9IT9dXmZK5W1VJUUgP7xIpOGsx/OMEjvds3Q3CYm4oYN77w==
X-Received: by 2002:a7b:cbc8:: with SMTP id n8mr274236wmi.124.1605552134200;
        Mon, 16 Nov 2020 10:42:14 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id x12sm17571987wrt.18.2020.11.16.10.42.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 16 Nov 2020 10:42:13 -0800 (PST)
Date:   Mon, 16 Nov 2020 18:42:11 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     mcroce@microsoft.com, akpm@linux-foundation.org, arnd@arndb.de,
        fabf@skynet.be, keescook@chromium.org, linux@roeck-us.net,
        pasha.tatashin@soleen.com, pmladek@suse.com, robinmholt@gmail.com,
        rppt@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] Revert "kernel/reboot.c: convert
 simple_strtoul to kstrtoint"" failed to apply to 4.19-stable tree
Message-ID: <20201116184211.lq6lxexxsai5jz6q@debian>
References: <160554320237238@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="o4oqbbcfyjckw77p"
Content-Disposition: inline
In-Reply-To: <160554320237238@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--o4oqbbcfyjckw77p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Nov 16, 2020 at 05:13:22PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. This will apply to v4.19.y, v4.14.y, v4.9.y and
also v4.4.y.

--
Regards
Sudip

--o4oqbbcfyjckw77p
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-Revert-kernel-reboot.c-convert-simple_strtoul-to-kst.patch"

From 1a6b4cbf9d73b7af385ea40b70f65a16876bf4fe Mon Sep 17 00:00:00 2001
From: Matteo Croce <mcroce@microsoft.com>
Date: Fri, 13 Nov 2020 22:52:02 -0800
Subject: [PATCH] Revert "kernel/reboot.c: convert simple_strtoul to kstrtoint"

commit 8b92c4ff4423aa9900cf838d3294fcade4dbda35 upstream

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
[sudip: use reboot_mode instead of mode]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 kernel/reboot.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index 8fb44dec9ad7..db0eed5916d5 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -539,22 +539,15 @@ static int __init reboot_setup(char *str)
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
 				reboot_mode = REBOOT_SOFT;
 			break;
-		}
+
 		case 'g':
 			reboot_mode = REBOOT_GPIO;
 			break;
-- 
2.11.0


--o4oqbbcfyjckw77p--
