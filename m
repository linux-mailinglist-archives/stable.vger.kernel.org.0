Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0FA56BEF23
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 18:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjCQRGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 13:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjCQRFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 13:05:43 -0400
Received: from out203-205-251-84.mail.qq.com (unknown [203.205.251.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6323E099
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 10:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1679072705;
        bh=h9DY8UYvNOid/Y+AHqgj3EVheQKM7/mtmMHElDBB62U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=mubUzkYiuJBUR4Ybi43996woNYVwus4pHM0yy/MRYxFCy/lxZiTXL0pA4pgGeDpTY
         wJd+ZJNkEd2nyD+Bz1f78G8GHcOLOnTGVmvP8iLE0adwLw87mzhiGrbDILOCO+9JlN
         EaE6IeiylwMOPCChNOv9PsJ5mZETvB76xvY2Xt+o=
Received: from wen-VirtualBox.. ([2408:84f6:8034:b52e:a120:6f4e:a714:1661])
        by newxmesmtplogicsvrszb9-0.qq.com (NewEsmtp) with SMTP
        id 13882072; Sat, 18 Mar 2023 01:04:56 +0800
X-QQ-mid: xmsmtpt1679072701ti3wbg0vg
Message-ID: <tencent_209357E952CCAD7EC3CF2755A0D470413508@qq.com>
X-QQ-XMAILINFO: NfHsM/dq2nWIvdvHfqNeQgrB2KfGC0FZdfgWUoKy0+ypUJMdiIJk/45zWj3xuL
         Xe7lMREW5Amz1mcZKDg9XxhIBptELo3FzSr4YO4ihPGlzHyWVWqkc0VadwuzoDX17DNIEERSkH4M
         GJns2p+VK0t9G782fR7oMoVZfIQ0vxqZXmsKwYFt+O1DBXxj1WOLbUCsuXXpvza93C0+4zm11QOw
         krWK3RX17iZYgPnCrzB+wu4V10PGDXdMOd+l/MkKcLxQb+KH7cM3FuFp0vQjlwEnfUfOhzCx28p+
         BNv4XUuiRjxTptQpDeNgIrZaWYANVjV9SuHSNAYOpOWbYC/0etqyxmuUGULc9cNu1yF6ouyQH7Ui
         ZgPfEG4Fjf57STluAQ2xxSuHy2wG29J7Y00/fcwNQY3NA3fdpapVLOe+pPeC9BFg3lXM5Mikpnbi
         2VC1rn4ztVspIbxW7E1Eyk2bKcMuHdAJLJmuX3A1AiFRx7YVbEAHXh/9bhccFr0VBt/lpKzRZyl7
         udzGodUKBt06Y+im+evBmJR/zDHP5XIgct7JvBZ8Erzm9Qw8rGyWfHpjA01Lr3fqIq73H8SIvZqG
         opJp9H4ke6BtWunoKVl33cSxnBDIMbY7JAflqubb3IFZWCki5XE1LsfLrIf1tPkZ/09oGK6oCtmI
         rEYLr2wKXxb938AFAfJdBQlh89SmDUWAEp+ivHWFqsnUOUYAHtAi5+7WRxReTsQMkVPV081Jq9iP
         Ju3my08Yytlcvvw7Z3LOPUI5kAGGt488JgU5hRmahQ3jFlTf/VdciQdRclFPUc62TKcPLj1WqQK2
         NQbqVUbTNnzY0NQ0Hv2P2eoVP6va7eBCxxrPiSmsOAPU2NTrp8he3yr3gMpfcZnK3IG7IE2oBIxF
         dVahXlKFR/xDJFPwOlWDtq1QOIwpuy45OIcXokx9XRLdwuGyvL00H0LtNE5OKJ6PDeaZaZu2Tn7s
         lzeveBMN54lf0XDWhndw/3G0HyubTZx+1YXPsD1aFb4nHcgXyerC6S2eVIOmNS8cbLbd3P3JeYBQ
         f50MGWueM0lYjx1m2NnCEtxTGyXQ2CVXcJK5MmMgVc3WgnuEMROzaoA1nkRVhFu3nBFrNaph2nzT
         tnRLQRzkt+JuT2OBA=
From:   wenyang.linux@foxmail.com
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Valentin Schneider <vschneid@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Baoquan He <bhe@redhat.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Juri Lelli <jlelli@redhat.com>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Petr Mladek <pmladek@suse.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang.linux@foxmail.com>
Subject: [PATCH 5.15 2/2] panic, kexec: make __crash_kexec() NMI safe
Date:   Sat, 18 Mar 2023 01:04:31 +0800
X-OQ-MSGID: <20230317170431.137700-3-wenyang.linux@foxmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230317170431.137700-1-wenyang.linux@foxmail.com>
References: <20230317170431.137700-1-wenyang.linux@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_MSPIKE_H2,RCVD_IN_SBL_CSS,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <vschneid@redhat.com>

commit 05c6257433b7212f07a7e53479a8ab038fc1666a upstream.

Attempting to get a crash dump out of a debug PREEMPT_RT kernel via an NMI
panic() doesn't work.  The cause of that lies in the PREEMPT_RT definition
of mutex_trylock():

	if (IS_ENABLED(CONFIG_DEBUG_RT_MUTEXES) && WARN_ON_ONCE(!in_task()))
		return 0;

This prevents an nmi_panic() from executing the main body of
__crash_kexec() which does the actual kexec into the kdump kernel.  The
warning and return are explained by:

  6ce47fd961fa ("rtmutex: Warn if trylock is called from hard/softirq context")
  [...]
  The reasons for this are:

      1) There is a potential deadlock in the slowpath

      2) Another cpu which blocks on the rtmutex will boost the task
	 which allegedly locked the rtmutex, but that cannot work
	 because the hard/softirq context borrows the task context.

Furthermore, grabbing the lock isn't NMI safe, so do away with kexec_mutex
and replace it with an atomic variable.  This is somewhat overzealous as
*some* callsites could keep using a mutex (e.g.  the sysfs-facing ones
like crash_shrink_memory()), but this has the benefit of involving a
single unified lock and preventing any future NMI-related surprises.

Tested by triggering NMI panics via:

  $ echo 1 > /proc/sys/kernel/panic_on_unrecovered_nmi
  $ echo 1 > /proc/sys/kernel/unknown_nmi_panic
  $ echo 1 > /proc/sys/kernel/panic

  $ ipmitool power diag

Link: https://lkml.kernel.org/r/20220630223258.4144112-3-vschneid@redhat.com
Fixes: 6ce47fd961fa ("rtmutex: Warn if trylock is called from hard/softirq context")
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Juri Lelli <jlelli@redhat.com>
Cc: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org # 5.15.x
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
---
 kernel/kexec.c          | 11 ++++-------
 kernel/kexec_core.c     | 20 ++++++++++----------
 kernel/kexec_file.c     |  4 ++--
 kernel/kexec_internal.h | 15 ++++++++++++++-
 4 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index b5e40f069768..cb8e6e6f983c 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -93,13 +93,10 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 
 	/*
 	 * Because we write directly to the reserved memory region when loading
-	 * crash kernels we need a mutex here to prevent multiple crash kernels
-	 * from attempting to load simultaneously, and to prevent a crash kernel
-	 * from loading over the top of a in use crash kernel.
-	 *
-	 * KISS: always take the mutex.
+	 * crash kernels we need a serialization here to prevent multiple crash
+	 * kernels from attempting to load simultaneously.
 	 */
-	if (!mutex_trylock(&kexec_mutex))
+	if (!kexec_trylock())
 		return -EBUSY;
 
 	if (flags & KEXEC_ON_CRASH) {
@@ -165,7 +162,7 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 
 	kimage_free(image);
 out_unlock:
-	mutex_unlock(&kexec_mutex);
+	kexec_unlock();
 	return ret;
 }
 
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index a101d2b77936..bdc2d952911c 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -46,7 +46,7 @@
 #include <crypto/hash.h>
 #include "kexec_internal.h"
 
-DEFINE_MUTEX(kexec_mutex);
+atomic_t __kexec_lock = ATOMIC_INIT(0);
 
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
@@ -944,7 +944,7 @@ int kexec_load_disabled;
  */
 void __noclone __crash_kexec(struct pt_regs *regs)
 {
-	/* Take the kexec_mutex here to prevent sys_kexec_load
+	/* Take the kexec_lock here to prevent sys_kexec_load
 	 * running on one cpu from replacing the crash kernel
 	 * we are using after a panic on a different cpu.
 	 *
@@ -952,7 +952,7 @@ void __noclone __crash_kexec(struct pt_regs *regs)
 	 * of memory the xchg(&kexec_crash_image) would be
 	 * sufficient.  But since I reuse the memory...
 	 */
-	if (mutex_trylock(&kexec_mutex)) {
+	if (kexec_trylock()) {
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
@@ -961,7 +961,7 @@ void __noclone __crash_kexec(struct pt_regs *regs)
 			machine_crash_shutdown(&fixed_regs);
 			machine_kexec(kexec_crash_image);
 		}
-		mutex_unlock(&kexec_mutex);
+		kexec_unlock();
 	}
 }
 STACK_FRAME_NON_STANDARD(__crash_kexec);
@@ -993,13 +993,13 @@ ssize_t crash_get_memory_size(void)
 {
 	ssize_t size = 0;
 
-	if (!mutex_trylock(&kexec_mutex))
+	if (!kexec_trylock())
 		return -EBUSY;
 
 	if (crashk_res.end != crashk_res.start)
 		size = resource_size(&crashk_res);
 
-	mutex_unlock(&kexec_mutex);
+	kexec_unlock();
 	return size;
 }
 
@@ -1019,7 +1019,7 @@ int crash_shrink_memory(unsigned long new_size)
 	unsigned long old_size;
 	struct resource *ram_res;
 
-	if (!mutex_trylock(&kexec_mutex))
+	if (!kexec_trylock())
 		return -EBUSY;
 
 	if (kexec_crash_image) {
@@ -1058,7 +1058,7 @@ int crash_shrink_memory(unsigned long new_size)
 	insert_resource(&iomem_resource, ram_res);
 
 unlock:
-	mutex_unlock(&kexec_mutex);
+	kexec_unlock();
 	return ret;
 }
 
@@ -1130,7 +1130,7 @@ int kernel_kexec(void)
 {
 	int error = 0;
 
-	if (!mutex_trylock(&kexec_mutex))
+	if (!kexec_trylock())
 		return -EBUSY;
 	if (!kexec_image) {
 		error = -EINVAL;
@@ -1206,7 +1206,7 @@ int kernel_kexec(void)
 #endif
 
  Unlock:
-	mutex_unlock(&kexec_mutex);
+	kexec_unlock();
 	return error;
 }
 
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index f7a4fd4d243f..1fb7ff690577 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -343,7 +343,7 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
 
 	image = NULL;
 
-	if (!mutex_trylock(&kexec_mutex))
+	if (!kexec_trylock())
 		return -EBUSY;
 
 	dest_image = &kexec_image;
@@ -415,7 +415,7 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
 	if ((flags & KEXEC_FILE_ON_CRASH) && kexec_crash_image)
 		arch_kexec_protect_crashkres();
 
-	mutex_unlock(&kexec_mutex);
+	kexec_unlock();
 	kimage_free(image);
 	return ret;
 }
diff --git a/kernel/kexec_internal.h b/kernel/kexec_internal.h
index 48aaf2ac0d0d..74da1409cd14 100644
--- a/kernel/kexec_internal.h
+++ b/kernel/kexec_internal.h
@@ -13,7 +13,20 @@ void kimage_terminate(struct kimage *image);
 int kimage_is_destination_range(struct kimage *image,
 				unsigned long start, unsigned long end);
 
-extern struct mutex kexec_mutex;
+/*
+ * Whatever is used to serialize accesses to the kexec_crash_image needs to be
+ * NMI safe, as __crash_kexec() can happen during nmi_panic(), so here we use a
+ * "simple" atomic variable that is acquired with a cmpxchg().
+ */
+extern atomic_t __kexec_lock;
+static inline bool kexec_trylock(void)
+{
+	return atomic_cmpxchg_acquire(&__kexec_lock, 0, 1) == 0;
+}
+static inline void kexec_unlock(void)
+{
+	atomic_set_release(&__kexec_lock, 0);
+}
 
 #ifdef CONFIG_KEXEC_FILE
 #include <linux/purgatory.h>
-- 
2.37.2

