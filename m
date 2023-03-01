Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF526A70DA
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCAQZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCAQZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:25:49 -0500
Received: from out203-205-221-153.mail.qq.com (out203-205-221-153.mail.qq.com [203.205.221.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935243D90C
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 08:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1677687943;
        bh=ZRsgUmOXw6XUFWVPeAJaUIDn3u4EWBcLo5izyxAfE/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=AGZDyd655vystPIx0eEZCGT8+Ks7UU8OxTANEJPM7zwRKfkMFGWENJc5mStVSfvJQ
         IosFbhxJhGLRwf0/n+jdFo2slfyRDUMJrajqq9aU/p2Y5Z5P9pFRilOpAyru/Ml37P
         Sgk3OIMCvQBaPF19NCAF2KK9pR3EEf1idS3isfzc=
Received: from localhost.localdomain ([106.92.97.94])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 65B916D6; Thu, 02 Mar 2023 00:25:27 +0800
X-QQ-mid: xmsmtpt1677687938tuqcw3gjk
Message-ID: <tencent_23D2059843FC3C9F09AAC6A8678272270109@qq.com>
X-QQ-XMAILINFO: MR/iVh5QLeie4+NwYsZDWpZq1BXEbFfBeFxQPxCFZiaXg+zHb7LJI05X5L3r67
         6aTi5wL+LKpmn4Au/y7lLGctDrXyg/+l089sAmwY/xDXW/FXgmCcOCzCP5B7LNOhHwNHa4P4Sad7
         2hUURsGMeEhz6evqJH4wKhsbDnx16U++KlqWE+an2Ij9V4CMXDKRhYsblHzYdMSMkbdMBkuKWSDb
         aNxM8lFOphdcwAGvcrOJOZwnVWha7ucFAiP3fM9/Ba6ASrOlU5rN8SLxSAze5P2diC6CjpnvqajL
         6nEUcA0hJTAPTk4WzM8L9aEukYYymeKrDJ0x9laEtIpXO8IphalkX5LE0xG2hV3ZSp0VzHlyo0sM
         ULEsvZPa6m8PMwWdnF0l5wYlVHKJkcubit76ReEzVBsNAYp/WCEVyAoezWhqR1omqE+c3gxHeMJh
         vBXeM5MxydWmFcPOIPo4v2SWaw7svGAOQRC2+ervUIxEqqRvPEuIAoJBm2d8GOKBZLnFhT9ivk7i
         zFTZA/PgKSbTzOlgLk8f84R01+vbIY4q+ZwMsCersdvN09Y6FxNpl55V0a7B20lmePlWT72Yog8Y
         ms3eL+itYk1P775kkXUZLaqvzqGcMIIMZLAwBP4BIEeTVCADb+STafGajpe3dWdAij8j59HtmSAA
         XKONsrTzwmD5i86psBgGVd0p/paD2DIhCqSGdWZbey7hrBx56EWu8jCeD0/2lLu2IKY5MsL/quVI
         uY7We8BhsXn9qNTwo76vtyCZ2U0y9IkE0NjaHip5SMDq2jBWijs/eNO52BEtaGopO/WIO/GA5Mx/
         7fnAHIg31V8ky01lWnYGrNVoxDLMwBegHVbT99g09BaKXUSDGEHk70mQ1MDUC+R/oJbctkJBxTQQ
         7XkxpJX5UH8MK0q9imx72uh396a29fJajlmkdUl0oJRnNFTVetmm0hXNPOkSoUno4pGm+zFTlr+k
         xg42suzFFgv1jF0+uGY6Jcym6E4bDEkOSFKJvFoAaY087f16neBHo/RuMaL93nt2hxlu3V64nIhA
         yumjob+qexuSGa4xNbTzGDhfHkFbAf60HiJelHXM8WHg6FfYPH94y3G27Sa3akbtmWle05xQ==
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
Subject: [PATCH 5.10 3/3] panic, kexec: make __crash_kexec() NMI safe
Date:   Thu,  2 Mar 2023 00:25:02 +0800
X-OQ-MSGID: <20230301162502.120413-3-wenyang.linux@foxmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230301162502.120413-1-wenyang.linux@foxmail.com>
References: <20230301162502.120413-1-wenyang.linux@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <vschneid@redhat.com>

commit 811d581194f7412eda97acc03d17fc77824b561f upstream.

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
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
---
 kernel/kexec.c          | 11 ++++-------
 kernel/kexec_core.c     | 20 ++++++++++----------
 kernel/kexec_file.c     |  4 ++--
 kernel/kexec_internal.h | 15 ++++++++++++++-
 4 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 9c7aef8f4bb6..f0f0c6555454 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -112,13 +112,10 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 
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
@@ -184,7 +181,7 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 
 	kimage_free(image);
 out_unlock:
-	mutex_unlock(&kexec_mutex);
+	kexec_unlock();
 	return ret;
 }
 
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index e47870f30728..7a8104d48997 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -45,7 +45,7 @@
 #include <crypto/sha.h>
 #include "kexec_internal.h"
 
-DEFINE_MUTEX(kexec_mutex);
+atomic_t __kexec_lock = ATOMIC_INIT(0);
 
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
@@ -943,7 +943,7 @@ int kexec_load_disabled;
  */
 void __noclone __crash_kexec(struct pt_regs *regs)
 {
-	/* Take the kexec_mutex here to prevent sys_kexec_load
+	/* Take the kexec_lock here to prevent sys_kexec_load
 	 * running on one cpu from replacing the crash kernel
 	 * we are using after a panic on a different cpu.
 	 *
@@ -951,7 +951,7 @@ void __noclone __crash_kexec(struct pt_regs *regs)
 	 * of memory the xchg(&kexec_crash_image) would be
 	 * sufficient.  But since I reuse the memory...
 	 */
-	if (mutex_trylock(&kexec_mutex)) {
+	if (kexec_trylock()) {
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
@@ -960,7 +960,7 @@ void __noclone __crash_kexec(struct pt_regs *regs)
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
@@ -1205,7 +1205,7 @@ int kernel_kexec(void)
 #endif
 
  Unlock:
-	mutex_unlock(&kexec_mutex);
+	kexec_unlock();
 	return error;
 }
 
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index fff11916aba3..b9c857782ada 100644
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
index 39d30ccf8d87..49d4e3ab9c96 100644
--- a/kernel/kexec_internal.h
+++ b/kernel/kexec_internal.h
@@ -15,7 +15,20 @@ int kimage_is_destination_range(struct kimage *image,
 
 int machine_kexec_post_load(struct kimage *image);
 
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

