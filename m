Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668FF6A70B2
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjCAQSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCAQSb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:18:31 -0500
Received: from out203-205-221-155.mail.qq.com (out203-205-221-155.mail.qq.com [203.205.221.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE4E302BE
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 08:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1677687507;
        bh=BNXY/zsjrVTU8AemEq3ugAuB4lxmZ9UEuRzJPFpkHf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=WZ1lu/+b0CSaZpjwzIGjbPa7zR5NFfmz/AgbJWJt76C8s89ePHsaGTO8SdiNFDbdG
         8eFgu36xvcr3alDLVxzjx2FcVMLfMzgyrCw5GkmowfB5HtTfr7keh3ZUoQRvoe09bV
         F/eScuPqzPksRFy/mjh0Ok26SiTnwLmi129gTUNY=
Received: from localhost.localdomain ([106.92.97.94])
        by newxmesmtplogicsvrszc2-1.qq.com (NewEsmtp) with SMTP
        id 48D94600; Thu, 02 Mar 2023 00:18:13 +0800
X-QQ-mid: xmsmtpt1677687498ts572jwqz
Message-ID: <tencent_71D0747DE654BF85E7EBAA756AFD20B1C907@qq.com>
X-QQ-XMAILINFO: OZZSS56D9fAjEqre6IPuqYTjG98bp5atZlhysKGyGW0buXw/FNqxwIOQiLYdos
         aluzJTC2fEwd5Ekc67Fq3AFDU2bR0YcjGaxj0uwblxaCgsdZ3blaSSHJGuNIpqfNt7RDRU2wXRiD
         DY8QZYn4cV0+SWy8+1YEidGhOTsHMmZBfxax7qlZD8m2rXIPi9LmWYeOl9pfc6DYidOkQb7Yp9cE
         h95X7kp6gYwEG8BImZiF+iZkLtEhrNJOJChpgJIAWmuHIQQ+CKqFqQ2lldXj93gLdnoaFwKQxsb7
         BZYN3W6MIwKQFCwJcbG+H6S7vpWr3+8FEO+Zjl4duOVTXTLYG3Pgofq/6QC/OOQGFbgVsVgVj9ds
         OXl95tnzY8hZD6+yvoY5zm35tgaSX9DhUObKV+NgjGHdUhylR0ptHukOGjJmm4LhWq2cntr9Szch
         OAJBWWxAivS0t3RzQGFt1S181p7XwabL4Ivm4xhaS/WEB1+LyRJadzjF9zYCafukZJn1MCEcQLC8
         SI4cFslzj1bX56eRWj4+1KF7VqR7F7n4YLaYkeeQgLR16AG5kBkcz2vqhpQB0tMnAlzwP4MHKcx2
         KpSSWQ4WOYNaYGm3IUJE4EE8OM16ppe1uCZFlKb/tgENZgKtsbLJ7WXjGV3hGjBqiB6uM61ejTHm
         A6bM6nlbJHHT3Ttx8d0pT4LvgXqzkQfz3QryjZ41gG/8MCEGfons42kj0ZQdn2l35PwhC8sTePLX
         JryMr1MIdAfzegFUQ/fFdzrfttuGDoSxgHZQ8GrjOi07CvudZn7l+hGJ0fawBQmlMD/S7Ly0rMi/
         rTBI4rZWO5RCVyHQXf7H1kcgLLWCOh7SUfupe9ACiUnfqnDHA4xaosWpGT51YM8ncmoqbhcDdAuO
         EC24zs9RPSIWu5RqWt1VnTPobdyEI6fXIgE1zr42EMunhaeWY8fJV7f33GFsb4WVuWq/aUb4ylkn
         8OYNFipcXu8BfFU3mW+qTHdtCQBai8/IZeZVmmd+uTYYb4s4GyH/jnBeKkQwMQr4ZqVQnePGR6NY
         DP0LEDYhhqNxfBHZeA
From:   wenyang.linux@foxmail.com
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Valentin Schneider <vschneid@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Juri Lelli <jlelli@redhat.com>,
        "Luis Claudio R . Goncalves" <lgoncalv@redhat.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Petr Mladek <pmladek@suse.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Baoquan He <bhe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang.linux@foxmail.com>
Subject: [PATCH 2/3] kexec: turn all kexec_mutex acquisitions into trylocks
Date:   Thu,  2 Mar 2023 00:18:05 +0800
X-OQ-MSGID: <20230301161806.115089-2-wenyang.linux@foxmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230301161806.115089-1-wenyang.linux@foxmail.com>
References: <20230301161806.115089-1-wenyang.linux@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <vschneid@redhat.com>

commit 7bb5da0d490b2d836c5218f5186ee588d2145310 upstream.

Patch series "kexec, panic: Making crash_kexec() NMI safe", v4.

This patch (of 2):

Most acquistions of kexec_mutex are done via mutex_trylock() - those were
a direct "translation" from:

  8c5a1cf0ad3a ("kexec: use a mutex for locking rather than xchg()")

there have however been two additions since then that use mutex_lock():
crash_get_memory_size() and crash_shrink_memory().

A later commit will replace said mutex with an atomic variable, and
locking operations will become atomic_cmpxchg().  Rather than having those
mutex_lock() become while (atomic_cmpxchg(&lock, 0, 1)), turn them into
trylocks that can return -EBUSY on acquisition failure.

This does halve the printable size of the crash kernel, but that's still
neighbouring 2G for 32bit kernels which should be ample enough.

Link: https://lkml.kernel.org/r/20220630223258.4144112-1-vschneid@redhat.com
Link: https://lkml.kernel.org/r/20220630223258.4144112-2-vschneid@redhat.com
Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Juri Lelli <jlelli@redhat.com>
Cc: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
---
 include/linux/kexec.h |  2 +-
 kernel/kexec_core.c   | 12 ++++++++----
 kernel/ksysfs.c       |  7 ++++++-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index a1f12e959bba..3c1deba496c9 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -380,8 +380,8 @@ extern note_buf_t __percpu *crash_notes;
 extern bool kexec_in_progress;
 
 int crash_shrink_memory(unsigned long new_size);
-size_t crash_get_memory_size(void);
 void crash_free_reserved_phys_range(unsigned long begin, unsigned long end);
+ssize_t crash_get_memory_size(void);
 
 void arch_kexec_protect_crashkres(void);
 void arch_kexec_unprotect_crashkres(void);
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index c589c7a9562c..e47870f30728 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -989,13 +989,16 @@ void crash_kexec(struct pt_regs *regs)
 	}
 }
 
-size_t crash_get_memory_size(void)
+ssize_t crash_get_memory_size(void)
 {
-	size_t size = 0;
+	ssize_t size = 0;
+
+	if (!mutex_trylock(&kexec_mutex))
+		return -EBUSY;
 
-	mutex_lock(&kexec_mutex);
 	if (crashk_res.end != crashk_res.start)
 		size = resource_size(&crashk_res);
+
 	mutex_unlock(&kexec_mutex);
 	return size;
 }
@@ -1016,7 +1019,8 @@ int crash_shrink_memory(unsigned long new_size)
 	unsigned long old_size;
 	struct resource *ram_res;
 
-	mutex_lock(&kexec_mutex);
+	if (!mutex_trylock(&kexec_mutex))
+		return -EBUSY;
 
 	if (kexec_crash_image) {
 		ret = -ENOENT;
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 35859da8bd4f..e20c19e3ba49 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -106,7 +106,12 @@ KERNEL_ATTR_RO(kexec_crash_loaded);
 static ssize_t kexec_crash_size_show(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *buf)
 {
-	return sprintf(buf, "%zu\n", crash_get_memory_size());
+	ssize_t size = crash_get_memory_size();
+
+	if (size < 0)
+		return size;
+
+	return sprintf(buf, "%zd\n", size);
 }
 static ssize_t kexec_crash_size_store(struct kobject *kobj,
 				   struct kobj_attribute *attr,
-- 
2.37.2

