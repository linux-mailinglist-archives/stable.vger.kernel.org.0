Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A679327F62
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbhCANYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:24:20 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:55383 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235678AbhCANYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:24:15 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1949D19412C5;
        Mon,  1 Mar 2021 08:23:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 01 Mar 2021 08:23:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QruOYG
        1exwIVTL7HAk8o16SGbkOeG0mx+j58tAd0Hs0=; b=fKbTfbsQ2ZUSipvUBuqp1+
        ett9Z/5qY7bBmh5dm3+7yRClYu7Rvn1Ly63RV7Oy5Fi/m/NUV5ek07yQI3CSWBd7
        6lUa/SrUjgwtr2sjuVgC4cZzx9rEPEE7QQXcC+xpDv5XiaQyjyR6XppuFFP10j3F
        MC6/mXDkU1TIwrDzHnP7qQK2M51eMy+68duSHnohJwaSrER5XtXmdU8gjeNwlOe4
        KG6e1PLKwFX9M/tCBPFScCIr4Rbey4hdSMxAxUzowEql4dLcm9GXcAno+m+Da5ra
        eY9o2oLJ/ss7R4Eree4bOmObfdoi5zgG17zS0omDnvRJylLsDP/Tr0a3lbcI1HhA
        ==
X-ME-Sender: <xms:zOo8YIQvzJZxUeEam7v_bHveR_ENey4trylWdsa-cOufDJSBpQrcgg>
    <xme:zOo8YHw-c2l8aLbK_YQr5OpUA-zVDwHZmy_s_2h_CciHW4z7KjzjaZA1PALhoFU29
    q1HKtIErE5aLw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtudeuje
    fhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:zOo8YPOD-vqAlEp056ftrMVElkc9Nkn2ig9Rx9oJDP-2TVLmDfbQfg>
    <xmx:zOo8YON1X-7jHWCn5Ev3Np6Wz4wzzVkl-jZcCcRzgREa7peNxs_CpA>
    <xmx:zOo8YJQQfosOlCfktPguppNnt9Tx-CqWUZkwDWbBNnw_uXg39Q9E6Q>
    <xmx:zeo8YC_dkBNt9aJEJhoN-fUeGQrjASoT56fHoXrOXAdRNwiE8sRiqQycwj0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 04F32240054;
        Mon,  1 Mar 2021 08:23:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] kcmp: Support selection of SYS_kcmp without" failed to apply to 4.4-stable tree
To:     chris@chris-wilson.co.uk, airlied@gmail.com,
        akpm@linux-foundation.org, daniel.vetter@ffwll.ch, daniel@ffwll.ch,
        gorcunov@gmail.com, keescook@chromium.org, l.stach@pengutronix.de,
        linux@rasmusvillemoes.dk, luto@amacapital.net, tzimmermann@suse.de,
        wad@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:23:18 +0100
Message-ID: <161460499829120@kroah.com>
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

