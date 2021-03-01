Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E360327F67
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbhCANZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:25:01 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:41167 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235614AbhCANY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:24:26 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1F1F319419E5;
        Mon,  1 Mar 2021 08:23:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Mon, 01 Mar 2021 08:23:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0yshrg
        MKdu4yKqsqEZ5RP2CtVx066Il2Am3xv2cN8X8=; b=rlN9VoaOpUaF5KbhCLudGs
        ZEMhaPX3BKiMgkqPiYPIR9R18/iI4OA+MK9F3ll1z/SXm7qeDmF5Yvuu4L7Xml3F
        tf/ULqBVXqenexCRf6nYF187u5YMRWSLfieB4vUZleUFQf7PXB58LKpYEyPb3aib
        WvBQdNRryXM4DPqziTD+ASROzLESBIQxUQBuwfK5ri5U7BSGFy/SLMk83Q2jdc06
        tkwbGFTS6+k7cU2xb3KoDheEjPLiM01w3ayL66a5y/sKCfXyRQdrxNt6hCq4UMA7
        dhijWDCGK37N+zTa4ybyjb+SkaUfUBzWITLq3oLkTMoiVenE7wQ7uQhE5Cq5tm2A
        ==
X-ME-Sender: <xms:xOo8YBeELEpgHy8B-BzjiL8n5C3HtsOztZoxEpTVcjsE7bwDZwRZMA>
    <xme:xOo8YDfd-evTRQdGSp769qHNmvvJkDoSAu84pfDjF5Skbo1k7pQNNCA-X21EHOpSt
    18I0qMqnWHwKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtudeuje
    fhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:xOo8YFiHgVhSRIYjLZclx4NSW-tUU-k9NQwa_xh2RNpC42yLsbBkTA>
    <xmx:xOo8YPS53jJTulrsQKF63F0jtjGoR_qySlHJgEhvAQiJMMFQB8dyVQ>
    <xmx:xOo8YGwEaqFC6N_jwRyzmHFdwDzcQkWPG6NwMHiSQxGA8P0BvyAWqw>
    <xmx:xeo8YN0X2h7xpl9k3teTejR8EiK1uBu5CeZ3FXsoGx2Dupg1Dnr77NLRVXc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C014D24005C;
        Mon,  1 Mar 2021 08:23:15 -0500 (EST)
Subject: FAILED: patch "[PATCH] kcmp: Support selection of SYS_kcmp without" failed to apply to 5.4-stable tree
To:     chris@chris-wilson.co.uk, airlied@gmail.com,
        akpm@linux-foundation.org, daniel.vetter@ffwll.ch, daniel@ffwll.ch,
        gorcunov@gmail.com, keescook@chromium.org, l.stach@pengutronix.de,
        linux@rasmusvillemoes.dk, luto@amacapital.net, tzimmermann@suse.de,
        wad@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:23:13 +0100
Message-ID: <161460499374173@kroah.com>
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

From bfe3911a91047557eb0e620f95a370aee6a248c7 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Fri, 5 Feb 2021 22:00:12 +0000
Subject: [PATCH] kcmp: Support selection of SYS_kcmp without
 CHECKPOINT_RESTORE

Userspace has discovered the functionality offered by SYS_kcmp and has
started to depend upon it. In particular, Mesa uses SYS_kcmp for
os_same_file_description() in order to identify when two fd (e.g. device
or dmabuf) point to the same struct file. Since they depend on it for
core functionality, lift SYS_kcmp out of the non-default
CONFIG_CHECKPOINT_RESTORE into the selectable syscall category.

Rasmus Villemoes also pointed out that systemd uses SYS_kcmp to
deduplicate the per-service file descriptor store.

Note that some distributions such as Ubuntu are already enabling
CHECKPOINT_RESTORE in their configs and so, by extension, SYS_kcmp.

References: https://gitlab.freedesktop.org/drm/intel/-/issues/3046
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: stable@vger.kernel.org
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch> # DRM depends on kcmp
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk> # systemd uses kcmp
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210205220012.1983-1-chris@chris-wilson.co.uk

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 0973f408d75f..af6c6d214d91 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -15,6 +15,9 @@ menuconfig DRM
 	select I2C_ALGOBIT
 	select DMA_SHARED_BUFFER
 	select SYNC_FILE
+# gallium uses SYS_kcmp for os_same_file_description() to de-duplicate
+# device and dmabuf fd. Let's make sure that is available for our userspace.
+	select KCMP
 	help
 	  Kernel-level support for the Direct Rendering Infrastructure (DRI)
 	  introduced in XFree86 4.0. If you say Y here, you need to select
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index a829af074eb5..3196474cbe24 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -979,7 +979,7 @@ static struct epitem *ep_find(struct eventpoll *ep, struct file *file, int fd)
 	return epir;
 }
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
+#ifdef CONFIG_KCMP
 static struct epitem *ep_find_tfd(struct eventpoll *ep, int tfd, unsigned long toff)
 {
 	struct rb_node *rbp;
@@ -1021,7 +1021,7 @@ struct file *get_epoll_tfile_raw_ptr(struct file *file, int tfd,
 
 	return file_raw;
 }
-#endif /* CONFIG_CHECKPOINT_RESTORE */
+#endif /* CONFIG_KCMP */
 
 /**
  * Adds a new entry to the tail of the list in a lockless way, i.e.
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 0350393465d4..593322c946e6 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -18,7 +18,7 @@ struct file;
 
 #ifdef CONFIG_EPOLL
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
+#ifdef CONFIG_KCMP
 struct file *get_epoll_tfile_raw_ptr(struct file *file, int tfd, unsigned long toff);
 #endif
 
diff --git a/init/Kconfig b/init/Kconfig
index 29ad68325028..b7d3c6a12196 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1193,6 +1193,7 @@ endif # NAMESPACES
 config CHECKPOINT_RESTORE
 	bool "Checkpoint/restore support"
 	select PROC_CHILDREN
+	select KCMP
 	default n
 	help
 	  Enables additional kernel features in a sake of checkpoint/restore.
@@ -1736,6 +1737,16 @@ config ARCH_HAS_MEMBARRIER_CALLBACKS
 config ARCH_HAS_MEMBARRIER_SYNC_CORE
 	bool
 
+config KCMP
+	bool "Enable kcmp() system call" if EXPERT
+	help
+	  Enable the kernel resource comparison system call. It provides
+	  user-space with the ability to compare two processes to see if they
+	  share a common resource, such as a file descriptor or even virtual
+	  memory space.
+
+	  If unsure, say N.
+
 config RSEQ
 	bool "Enable rseq() system call" if EXPERT
 	default y
diff --git a/kernel/Makefile b/kernel/Makefile
index aa7368c7eabf..320f1f3941b7 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -51,7 +51,7 @@ obj-y += livepatch/
 obj-y += dma/
 obj-y += entry/
 
-obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
+obj-$(CONFIG_KCMP) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 26c72f2b61b1..1b6c7d33c4ff 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -315,7 +315,7 @@ TEST(kcmp)
 	ret = __filecmp(getpid(), getpid(), 1, 1);
 	EXPECT_EQ(ret, 0);
 	if (ret != 0 && errno == ENOSYS)
-		SKIP(return, "Kernel does not support kcmp() (missing CONFIG_CHECKPOINT_RESTORE?)");
+		SKIP(return, "Kernel does not support kcmp() (missing CONFIG_KCMP?)");
 }
 
 TEST(mode_strict_support)

