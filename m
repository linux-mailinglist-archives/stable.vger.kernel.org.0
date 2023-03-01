Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90F16A70D9
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjCAQZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjCAQZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:25:43 -0500
Received: from out203-205-251-27.mail.qq.com (out203-205-251-27.mail.qq.com [203.205.251.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 746F23B3C2
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 08:25:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1677687939;
        bh=BNXY/zsjrVTU8AemEq3ugAuB4lxmZ9UEuRzJPFpkHf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=nB8Fv9XsCsg+7e3eaOMte9b5X5qQ4nYqxjJcbE40dmke3WO0c16DLb0cem9jvOcc9
         0uv4jR8w06/+UlUlB9t+ipVGtnoUDs8ox2z2hZrfEICstD7rC4c21UoFH+lec4BQZH
         KWaCfJY24Fe/v/7GDgQ9GyTp3VpWwvSMU2ujxTH0=
Received: from localhost.localdomain ([106.92.97.94])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 65B916D6; Thu, 02 Mar 2023 00:25:27 +0800
X-QQ-mid: xmsmtpt1677687933tvavjsely
Message-ID: <tencent_57D5B357551D355CD0E1644EBA38338B5F06@qq.com>
X-QQ-XMAILINFO: NkHKfw09D6j8daCIQY5P0YXOt/YEz5Em22neWv5PFUrsfHAkl6xQQZaWF2BhOH
         9EQOnF/VR6Gufpi+YVUhRdBxr5PGwiqDGj5ZKqCe5SExULVV46LdAo45AfRVC9emQ0d5wSm1V3Ki
         srod9lK+CcwGasnRBByr9sP8NgSaSxJ4ovJ2T1eYSbxAEpeKRJzkNWHG2FSnX5PLLIhJyqMuCFLn
         f/sb4XGwED0ns6RKOKaYXkk0Yoru+k0qJnMJg+GUZrCzxrnTIiseHvAM0DYcS/Q5FwfcUlqdvolj
         aYJCg58Gr9P8RRvs/UkmZv+19N3AOvqN7QaTSGS2V8nta4+CnCpZp66mTmxKUjIWhNyf2dpfAPTr
         U/kPmW+6yM2M9qd9qqst9JffvnHioCXBIDSoxJojL+eLnul3OV3yNxbHkJWEk+57Y/OjHD3mooFK
         SYx87n8yVQgaFu4/dsOMK9vPX8kGsJo8lB920v7duBMlpdHVOYRBg0a5iO6SPfsABazlw0uAQtwX
         jz3uhPclw/IebDFipf4lIyz0dyO74JUQuFYzzTtorr2c+FoZw4CqJzrK56r6l75p334DxMzot4sp
         wV51+qTxZ0479bbWPHCBjFnvjJwlQPdYwU9sveQP25afQI3jRJWTda7y8iX/8yNxxwnP8ep6uP9J
         V5L3x55s6pmNYaWRZerThbA+lOt81URlgV33XSms4haNw30w0eYj1ndjkxn4G9czWoNyf5oowPXX
         RTBjPddhr6XtX5O74FV3NcPI3Cj0Nc0pHXhMXyogfN4X6kcB+XR+UTWn3elbxNbAb9xuC/tmCbGy
         +pyFngW04sF1BXYuF0nuUTbx04pBCBQ9VpkXjS8riBNbxLuysz1l/3jqbUVVGvSQmflBDfRK3RKa
         8dp0s94zR6WDocW1dFZUi21SYk9wwuVEePBcsvL9dikh7hQFyDxDccYoimixP5h5exhJCjhMjJ3q
         LDBFDjhoT2AllgVeWlodLZLXtTwGbybt3WFb0lHoYn8Rly7wDlpQ5xCFnlrQjk9xU2bbLx4hO0xh
         stZg38NUXbs28RFuTXqRGckTIP0o2XJNVisAhohKYTXjfVLF0L2nDz0JXRoe4=
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
Subject: [PATCH 5.10 2/3] kexec: turn all kexec_mutex acquisitions into trylocks
Date:   Thu,  2 Mar 2023 00:25:01 +0800
X-OQ-MSGID: <20230301162502.120413-2-wenyang.linux@foxmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230301162502.120413-1-wenyang.linux@foxmail.com>
References: <20230301162502.120413-1-wenyang.linux@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
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

