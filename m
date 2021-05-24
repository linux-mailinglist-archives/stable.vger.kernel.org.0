Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B038938E656
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 14:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhEXMMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 08:12:17 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:46829 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232734AbhEXMMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 08:12:16 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 48EA41940AE3;
        Mon, 24 May 2021 08:10:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 24 May 2021 08:10:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Pepg74
        mxQlOvp7RJhqt/w3+uTZMu/bzuPZVEjwp3LJ0=; b=Gb2sYtyhCt6wQRofGzXsHZ
        5hsMzzHViGeir2G0NrVbnVd/ialeVZnz41VLcoKyWAc9C8ctqR1IF7AEkB1bAKqh
        H4mqgud9VKKtFLevPaU0/6dTsR8zXQnEfwdZ0ZGtHFsP8aGU/gVzrLaPQSN1YVB8
        tzPcT10KN42S4GOGCPnkLj83P5oa6gg+mnb7NXvYFL5Kr5UvySQDDubXAHSblKfA
        57bmngrdYgaV3aMZIbjRXC6+wxdFmoMVbm1d05rU7yanuroovjVjnBJLre5zP9KM
        C7532O6ot5r43vXJ2HH0OnH31tGQ+mbWWETqySAxGBRRi8pDU7hG15/XClHriEvw
        ==
X-ME-Sender: <xms:xperYBo9VprJOUXtp-zzPe2_nlLdsqG1_pgWxgD0kBSHvS6H--6N5w>
    <xme:xperYDp8i1kyaUyEu56eEdGxa4qz4_DbfrWonwxWDgLvWNB17iZE67ONc2FvJWAw8
    7VkQdd8FNFTjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdejledghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:xperYONY2DqtTueKlxGV1FJ9reHXLn0qgVRzVJ1Z5W6ndYG4pP00fQ>
    <xmx:xperYM42IX5cPBAjCG9u9mZ8UF48g7CLVuRnGipmrmMrDEeEnMTRtQ>
    <xmx:xperYA4ujfG2DEL3qnuCDDFCvYTLOew8CrNZ9Ql_lFmsmUmw-7Ks8g>
    <xmx:x5erYOQNb9yFGGNyKOlmx3vMGe_cOE4sRuuhIftpGO4oi37SDN989Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 24 May 2021 08:10:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/Xen: swap NX determination and GDT setup on BSP" failed to apply to 4.14-stable tree
To:     jbeulich@suse.com, jgross@suse.com, olaf@aepfle.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 May 2021 14:10:44 +0200
Message-ID: <162185824413812@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ae897fda4f507e4b239f0bdfd578b3688ca96fb4 Mon Sep 17 00:00:00 2001
From: Jan Beulich <jbeulich@suse.com>
Date: Thu, 20 May 2021 13:42:42 +0200
Subject: [PATCH] x86/Xen: swap NX determination and GDT setup on BSP

xen_setup_gdt(), via xen_load_gdt_boot(), wants to adjust page tables.
For this to work when NX is not available, x86_configure_nx() needs to
be called first.

[jgross] Note that this is a revert of 36104cb9012a82e73 ("x86/xen:
Delay get_cpu_cap until stack canary is established"), which is possible
now that we no longer support running as PV guest in 32-bit mode.

Cc: <stable.vger.kernel.org> # 5.9
Fixes: 36104cb9012a82e73 ("x86/xen: Delay get_cpu_cap until stack canary is established")
Reported-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>

Link: https://lore.kernel.org/r/12a866b0-9e89-59f7-ebeb-a2a6cec0987a@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 17503fed2017..e87699aa2dc8 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1273,16 +1273,16 @@ asmlinkage __visible void __init xen_start_kernel(void)
 	/* Get mfn list */
 	xen_build_dynamic_phys_to_machine();
 
+	/* Work out if we support NX */
+	get_cpu_cap(&boot_cpu_data);
+	x86_configure_nx();
+
 	/*
 	 * Set up kernel GDT and segment registers, mainly so that
 	 * -fstack-protector code can be executed.
 	 */
 	xen_setup_gdt(0);
 
-	/* Work out if we support NX */
-	get_cpu_cap(&boot_cpu_data);
-	x86_configure_nx();
-
 	/* Determine virtual and physical address sizes */
 	get_cpu_address_sizes(&boot_cpu_data);
 

