Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BC22F92DA
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbhAQOXt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:23:49 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:45353 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729171AbhAQOXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:23:42 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E3E421953A02;
        Sun, 17 Jan 2021 09:22:31 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:22:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oeEpnY
        av79oc4HGrqHrHu2lyFPXVJtkPwBebg2b+MXU=; b=PBCTO81TGI0p/NUHL9j3QN
        kmLVFO/nZnrWeD3le3K/MDZyd8SpeJ1Qvr5bAqqnl/ZlQGpBwf9qH90uPm5nfl97
        5M/G6Ewityvp9dJ/OIqcyJkLuON2iK/UlmFdogwGcaXI6ctybGAg9f2v9rRNOOsF
        3SFA5Ntco0ccU6nk1iQwWe86sgIpzKW9bcbKpzGcndwc+loGflCtyh+8cdsrHZ8K
        V/7Ec15kzNVAjkvfCkJrUdN8fpxX44vnOZYmlRYzHAdJJUfH39Aa6DRDaHtmjdh4
        c0WG1SR3tyul+Mmg1nN23cqSf6QUebnysewZ3TlUMF50veBBSKSNYaFb6cAO3NCw
        ==
X-ME-Sender: <xms:JkgEYHDdlbbqjMvc_lRdWgTpa_GS_rYaTOZbiXzNxeszCI0RdqXH-w>
    <xme:JkgEYNgE-O1eNprLOXWz1dQufEXeq38jIKJf6MLWaoqiM2kBc2SlsYsSCneFVzPaG
    hu1Bk7QBfEgnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpedvjeefiedvgfegtdetleejffekudegvdfgteethffhfe
    egtdegffevteegjefhjeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhgnhhurdho
    rhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:JkgEYCl4dOVx1GB64EfZv00CwvcFoejbthKf4X0pNn8DxzUhENEvAw>
    <xmx:JkgEYJxrO-8LoHdeVL11BOfd01PahALqJ2boF5HwnGBa0vUZDWKvug>
    <xmx:JkgEYMS9DvfjokZOCq0U_Ijo3TEQc1CAHzeoyK52mAn-AVPQp32QkA>
    <xmx:J0gEYPG8xTWqGSJKxBtBJb_rZW7vjxrHT4GpvJqyC3vBsMPktA2cm-N3XOE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F4FF24005A;
        Sun, 17 Jan 2021 09:22:30 -0500 (EST)
Subject: FAILED: patch "[PATCH] compiler.h: Raise minimum version of GCC to 5.1 for arm64" failed to apply to 5.4-stable tree
To:     will@kernel.org, arnd@kernel.org, catalin.marinas@arm.com,
        fweimer@redhat.com, linux@armlinux.org.uk,
        natechancellor@gmail.com, ndesaulniers@google.com,
        peterz@infradead.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:22:29 +0100
Message-ID: <1610893349137115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dca5244d2f5b94f1809f0c02a549edf41ccd5493 Mon Sep 17 00:00:00 2001
From: Will Deacon <will@kernel.org>
Date: Tue, 12 Jan 2021 22:48:32 +0000
Subject: [PATCH] compiler.h: Raise minimum version of GCC to 5.1 for arm64

GCC versions >= 4.9 and < 5.1 have been shown to emit memory references
beyond the stack pointer, resulting in memory corruption if an interrupt
is taken after the stack pointer has been adjusted but before the
reference has been executed. This leads to subtle, infrequent data
corruption such as the EXT4 problems reported by Russell King at the
link below.

Life is too short for buggy compilers, so raise the minimum GCC version
required by arm64 to 5.1.

Reported-by: Russell King <linux@armlinux.org.uk>
Suggested-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Link: https://lore.kernel.org/r/20210105154726.GD1551@shell.armlinux.org.uk
Link: https://lore.kernel.org/r/20210112224832.10980-1-will@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 74c6c0486eed..555ab0fddbef 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -13,6 +13,12 @@
 /* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145 */
 #if GCC_VERSION < 40900
 # error Sorry, your version of GCC is too old - please use 4.9 or newer.
+#elif defined(CONFIG_ARM64) && GCC_VERSION < 50100
+/*
+ * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63293
+ * https://lore.kernel.org/r/20210107111841.GN1551@shell.armlinux.org.uk
+ */
+# error Sorry, your version of GCC is too old - please use 5.1 or newer.
 #endif
 
 /*

