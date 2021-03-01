Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7AF327E14
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbhCAMRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:17:23 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:38023 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232947AbhCAMRQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 07:17:16 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9F0A31941582;
        Mon,  1 Mar 2021 07:16:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 01 Mar 2021 07:16:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CgYFF5
        7gxd9sw8OqKhWEvHar7QlrapZZm5FPPHViWwc=; b=C/x6BamjDSf7EGM1sOyzBH
        Egnu1awsmy2ELxX1oM3JwBVFSTD0ltv/pq+QHsIE94lPYbHhzqvLXr0gLz3hl4bP
        r75H1Cvc5j9425Tm99a+f8L9imEMbX44it1qPF4QE/vWKMbo9ucPWSQFKJQlcZx+
        WJYYiJnybNxr9WlMQmhIy9jZp0C0JIADdkC91FUU87dX4EARLAz2K5SbYMWI0R4u
        VqwmUUn+3rXghnUzMktLry6DRIAkSVRV9xFRLzNqoeTIT2QoiOqUnhZPpdZdnPQ1
        elaOUXngh4Jawmd7tLBnNx0+NnyhHK9eNQGTR+XT0UnP6M4MJgCsymwB6F8QZ0bA
        ==
X-ME-Sender: <xms:Hds8YEQK3VxX6evW_ZTn-oi5vxUqlD8977FBWoxVNPqlgMq0hVZpdg>
    <xme:Hds8YBv4e_hil38Wocz7T9IiqweeCHJ_PnmqTmUj_SnAiPIj8IbOW_1Kku05E2MHr
    IYQ9vLI8p-rPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdefjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Hds8YOvaufHCXcFz16IO3t9WMk2ITuUj1qn-PVOSkil3Un1Eas-sbA>
    <xmx:Hds8YPxEIEMvOGv099iWI0O_jRiEp5Xr8OeL-GtWoN87NGukKhQBng>
    <xmx:Hds8YMjQBsKeZ9I6-oaGJMloM7ynk4IAbkL0RBaXS6W6K4fOgSMekA>
    <xmx:Hds8YDeaFbbD1yOGPhz9bL35v3yxOzxItW65U3-POx5P0zpO-8UEYw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2EC64240065;
        Mon,  1 Mar 2021 07:16:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64 module: set plt* section addresses to 0x0" failed to apply to 4.4-stable tree
To:     shaoyi@amazon.com, fllinden@amazon.com, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 13:16:27 +0100
Message-ID: <1614600987254109@kroah.com>
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

From f5c6d0fcf90ce07ee0d686d465b19b247ebd5ed7 Mon Sep 17 00:00:00 2001
From: Shaoying Xu <shaoyi@amazon.com>
Date: Tue, 16 Feb 2021 18:32:34 +0000
Subject: [PATCH] arm64 module: set plt* section addresses to 0x0

These plt* and .text.ftrace_trampoline sections specified for arm64 have
non-zero addressses. Non-zero section addresses in a relocatable ELF would
confuse GDB when it tries to compute the section offsets and it ends up
printing wrong symbol addresses. Therefore, set them to zero, which mirrors
the change in commit 5d8591bc0fba ("module: set ksymtab/kcrctab* section
addresses to 0x0").

Reported-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210216183234.GA23876@amazon.com
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/include/asm/module.lds.h b/arch/arm64/include/asm/module.lds.h
index 691f15af788e..810045628c66 100644
--- a/arch/arm64/include/asm/module.lds.h
+++ b/arch/arm64/include/asm/module.lds.h
@@ -1,7 +1,7 @@
 #ifdef CONFIG_ARM64_MODULE_PLTS
 SECTIONS {
-	.plt (NOLOAD) : { BYTE(0) }
-	.init.plt (NOLOAD) : { BYTE(0) }
-	.text.ftrace_trampoline (NOLOAD) : { BYTE(0) }
+	.plt 0 (NOLOAD) : { BYTE(0) }
+	.init.plt 0 (NOLOAD) : { BYTE(0) }
+	.text.ftrace_trampoline 0 (NOLOAD) : { BYTE(0) }
 }
 #endif

