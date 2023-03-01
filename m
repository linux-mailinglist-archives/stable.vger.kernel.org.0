Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2A36A70B9
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCAQV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjCAQV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:21:28 -0500
Received: from out203-205-221-210.mail.qq.com (out203-205-221-210.mail.qq.com [203.205.221.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E442C47439
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 08:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1677687685;
        bh=igsLms0OPWbHmIHb5v2wsojui63iq9Vf0kvnImMGl4k=;
        h=From:To:Cc:Subject:Date;
        b=Xk1tqcjdoCxyKCogNDLMJTJjIA5xhGzV5ckWh/Jr6zuKMiRxJkmtqo70i4eCiFCcc
         mK95ju6w5Bwu4W2T4NHDLbYlKmjIhqbBKm6foiCb2gwaOTEyTzwJ+pFy4Tp71/cmvS
         jQYJqvvO9c7hmxIsg0DywmJOIepiDHgPNoU36uAo=
Received: from localhost.localdomain ([106.92.97.94])
        by newxmesmtplogicsvrsza10-0.qq.com (NewEsmtp) with SMTP
        id 5553FA9D; Thu, 02 Mar 2023 00:21:21 +0800
X-QQ-mid: xmsmtpt1677687681t7c56ixbk
Message-ID: <tencent_723A1433AA1FC1F369D538F57E90D0A47806@qq.com>
X-QQ-XMAILINFO: NMGzQWUSIfvTFcZFqvJx6DjC2TmgmJCX7cltufGsdh7S2kW+lbzyzxzxR3szCM
         lIaESD2NEt5ZuQsscbOHnNqmaegIID01SONZchpTld6zTR4h8oPt/2sbA1cwn1xFSC0WD5ylscft
         Gb99ig/eB8IxKIlYiuLqooI3RR7EVquvQr9iZhigRZTHGYIttb3CjL9tzw+BGAKamBCqS/FZiTj+
         LNzjMGMDbo6RlCCO2L3Dde3caDF0ji+2Dzdcit404IRpmGZVYy+qiM4s+lYq2ylsLANDfBDeMB7n
         HkOKbycCtdaay7riRpUWuBh8qEMocY4wmD7vZuzeBZcguA2ylvb8A0oHWhFmYXHUHgJn4DhHbpUy
         Dmh3nscKUor1b8C6tNl/5vkFDARidbbVSN9VSYE/yH2mDj2jGsrEq6KeZcaPIOwh2i9Hx3Fl9Tk2
         2GtL3dqcDIjokjkOTQs/AZjKopGRExwpf4Jo0VzKbSUI/cSzZqZx6O5OYx+WuCjXSd0JRpITY+lQ
         oUW0d8CylKV+1BHRWzX4sVwU9D4DIMzJ8eCWGIwVcwVo7hFOrNXieyfD0IiVv0Ft5IAsqL25CXHL
         pAQbLqbSuOIwq+Hvhp2Ho1hlico2byKQ4ZGtc1qfRThL+WtlrDsNVBWupC0Kv2SREoJ12Tu7QBn6
         lc9lzXw1tmrfFkikVYHWQNqJljV8+tyssW8Enc1xfWsiKIGCvMP5FmTUzhPYvN1YudE+pwAerNHf
         ZpIuS1IPR9PcekExMebGIhYqQae/1P0yxY3uY4+Ck4MG6RnYL1cxrw7MwJF0sdAGb/MbIFCDAS0q
         KqeUFjoerRSubFqF/o9acT7bmAy16XvL3eYzDLKyHqtMzOoN3lbtUkWaZQ/QIDTJtvN75dCMGN3q
         aUsOOv3HK81PhDBMMAfLyRPkd4FbNKdBzncFL0lUY0uf3oLNH7AN7WZPcVJlRJYKaXkemJI5sw2q
         n22AA3/mKh0cuxy5OpERbAgofSFa0+gQJjIwa/mMVmfvPCH5nLvOVMzrFJHe8vR/vPKBObiYDflv
         60/NBthSVx1heppFU9fqm41+RP1fdjFQuP/wP1dSfCyiqRJqIaEk9Q3YJX9Vc=
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
Subject: [PATCH 5.15 1/2] kexec: turn all kexec_mutex acquisitions into trylocks
Date:   Thu,  2 Mar 2023 00:20:56 +0800
X-OQ-MSGID: <20230301162057.120317-1-wenyang.linux@foxmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        RCVD_IN_SBL_CSS,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
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
Cc: <stable@vger.kernel.org> # v5.15+
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
---
 include/linux/kexec.h |  2 +-
 kernel/kexec_core.c   | 12 ++++++++----
 kernel/ksysfs.c       |  7 ++++++-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index cf042d41c87b..88c289ce3039 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -390,8 +390,8 @@ extern note_buf_t __percpu *crash_notes;
 extern bool kexec_in_progress;
 
 int crash_shrink_memory(unsigned long new_size);
-size_t crash_get_memory_size(void);
 void crash_free_reserved_phys_range(unsigned long begin, unsigned long end);
+ssize_t crash_get_memory_size(void);
 
 void arch_kexec_protect_crashkres(void);
 void arch_kexec_unprotect_crashkres(void);
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 5a5d192a89ac..a101d2b77936 100644
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

