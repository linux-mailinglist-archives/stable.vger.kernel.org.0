Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F212B4A69
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731248AbgKPQNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:13:02 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:35951 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729729AbgKPQNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 11:13:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3E6EA19432D9;
        Mon, 16 Nov 2020 11:13:01 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 16 Nov 2020 11:13:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=55jx9V
        4OxwZlYJzaTx2LUqEK+XqLrYewCHp9m3BY5KI=; b=NA1DNxzdSm+dy+gkvnvRhX
        Au6+riWXXGO/0B0usPS/n4IdMqxLwMS/lIHmHJES4CeFJsFzuy2woXuiEKOMJHxK
        OPmKF9fqZYlkS6trLSbWmoxcnulcfM1S1MVDLv7a4MWZZe6jWty6tm+Qix6GS23+
        77EDAWjuHC4Su1rBNlNJr0wfKxN5slkxEEco/4FfKwlB1a4L+lGd9/ekA+ljgz40
        jNFC9J+wccM4kcT2crXIlzqbAMluVKNUUVr8rPqiNpykJ8v1dQYj3jaHJlp5TGms
        VE4YC5Wh2vsvjMxhfn+aaO3E42BOob1x9ohiipuKKBhRHJHlQr1mze2/GRnXfBkw
        ==
X-ME-Sender: <xms:DaWyX32F1H0LDTWcy094OQ3bWb0Y6YCio-qKM50PhAEJT1d__5nVJA>
    <xme:DaWyX2FAnUA59K-HVrvLE7hAs1pQNYhBlIPbrSfwG_1pxSQl8O2qvuhDSkIgfUnIV
    4VMCMZHg1xLSg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudefuddgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:DaWyX37nlznIzDLGXyvupb_4ASdG1yvp4ZHBzzDY1szRh2m6FQ3-rw>
    <xmx:DaWyX80wtPB5ZBDJqYXKZaj-VU6oXjfXDv4TaTH9DLNHU_hSG_ZMTw>
    <xmx:DaWyX6G50F-74Zfs7ihQ0K-QpXNAt0wYGiTge4IjYignPnYuIokCmw>
    <xmx:DaWyXy_2zAKGgMCqZgZSNgCSKfxJWfFUVpe0fJlVOkt1558-tUIHXbi9mh8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B3141328005A;
        Mon, 16 Nov 2020 11:13:00 -0500 (EST)
Subject: FAILED: patch "[PATCH] reboot: fix overflow parsing reboot cpu number" failed to apply to 4.4-stable tree
To:     mcroce@microsoft.com, akpm@linux-foundation.org, arnd@arndb.de,
        fabf@skynet.be, gregkh@linuxfoundation.org, keescook@chromium.org,
        linux@roeck-us.net, pasha.tatashin@soleen.com, pmladek@suse.com,
        robinmholt@gmail.com, rppt@kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Nov 2020 17:13:50 +0100
Message-ID: <160554323054178@kroah.com>
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

From df5b0ab3e08a156701b537809914b339b0daa526 Mon Sep 17 00:00:00 2001
From: Matteo Croce <mcroce@microsoft.com>
Date: Fri, 13 Nov 2020 22:52:07 -0800
Subject: [PATCH] reboot: fix overflow parsing reboot cpu number

Limit the CPU number to num_possible_cpus(), because setting it to a
value lower than INT_MAX but higher than NR_CPUS produces the following
error on reboot and shutdown:

    BUG: unable to handle page fault for address: ffffffff90ab1bb0
    #PF: supervisor read access in kernel mode
    #PF: error_code(0x0000) - not-present page
    PGD 1c09067 P4D 1c09067 PUD 1c0a063 PMD 0
    Oops: 0000 [#1] SMP
    CPU: 1 PID: 1 Comm: systemd-shutdow Not tainted 5.9.0-rc8-kvm #110
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
    RIP: 0010:migrate_to_reboot_cpu+0xe/0x60
    Code: ea ea 00 48 89 fa 48 c7 c7 30 57 f1 81 e9 fa ef ff ff 66 2e 0f 1f 84 00 00 00 00 00 53 8b 1d d5 ea ea 00 e8 14 33 fe ff 89 da <48> 0f a3 15 ea fc bd 00 48 89 d0 73 29 89 c2 c1 e8 06 65 48 8b 3c
    RSP: 0018:ffffc90000013e08 EFLAGS: 00010246
    RAX: ffff88801f0a0000 RBX: 0000000077359400 RCX: 0000000000000000
    RDX: 0000000077359400 RSI: 0000000000000002 RDI: ffffffff81c199e0
    RBP: ffffffff81c1e3c0 R08: ffff88801f41f000 R09: ffffffff81c1e348
    R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
    R13: 00007f32bedf8830 R14: 00000000fee1dead R15: 0000000000000000
    FS:  00007f32bedf8980(0000) GS:ffff88801f480000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: ffffffff90ab1bb0 CR3: 000000001d057000 CR4: 00000000000006a0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
    Call Trace:
      __do_sys_reboot.cold+0x34/0x5b
      do_syscall_64+0x2d/0x40

Fixes: 1b3a5d02ee07 ("reboot: move arch/x86 reboot= handling to generic kernel")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201103214025.116799-3-mcroce@linux.microsoft.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/kernel/reboot.c b/kernel/reboot.c
index 8fbba433725e..af6f23d8bea1 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -558,6 +558,13 @@ static int __init reboot_setup(char *str)
 				reboot_cpu = simple_strtoul(str+3, NULL, 0);
 			else
 				*mode = REBOOT_SOFT;
+			if (reboot_cpu >= num_possible_cpus()) {
+				pr_err("Ignoring the CPU number in reboot= option. "
+				       "CPU %d exceeds possible cpu number %d\n",
+				       reboot_cpu, num_possible_cpus());
+				reboot_cpu = 0;
+				break;
+			}
 			break;
 
 		case 'g':

