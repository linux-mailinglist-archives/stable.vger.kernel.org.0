Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2BE6BEF0E
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 18:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjCQRDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 13:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjCQRDc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 13:03:32 -0400
Received: from out203-205-251-59.mail.qq.com (out203-205-251-59.mail.qq.com [203.205.251.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C6510CF
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 10:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1679072604;
        bh=BNXY/zsjrVTU8AemEq3ugAuB4lxmZ9UEuRzJPFpkHf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=t0TEnDXgBKbGrD8qQaWrBnVPIPS/LadjdVfvfAj3cYoHdbZad/4Seg43OeVDSJW/3
         WocqUSm8W1xvZF1buT8lcq9F5PxR5YLlsrhyccNWGgekPaLS0DGfbyTqEgkByRkMpj
         tC8o6YVmVHSLJqmavIlSgk581aSR2XcMh8izpEAg=
Received: from wen-VirtualBox.. ([2408:84f6:8034:b52e:a120:6f4e:a714:1661])
        by newxmesmtplogicsvrszc5-0.qq.com (NewEsmtp) with SMTP
        id CCBF8DA; Sat, 18 Mar 2023 01:03:12 +0800
X-QQ-mid: xmsmtpt1679072600tooe41yz9
Message-ID: <tencent_5026A54F3363F9153DBF5405512705414D0A@qq.com>
X-QQ-XMAILINFO: MmpliBmRb3iCCCnB8G0h+f77naejpbQj6j1+HxF/rX/ZIQNU7naQ9qqGM2F/F7
         S/LVh0i583IMKPQV6TBwTq3DpHSV9Pt/oxwLL1WJMmLit0CbSAGqjn2PSWXuODWGz/UB+9sFvKkT
         dYU7seDPtfhElSF16CVm1Tikn4vh+TrXgKBYl3ZpK6TG1MnJAxkeEXUWaAomh9CganrhLhY2ss74
         yNrnm1UP+y9TMfNBw3WSPzQhYHDgcJQ6k9iEFwfOZTKXIh5cHEMGiQS2Qz4Pf3xSpP447gsz8g9i
         /y29NCqqK02HoVhFsgntpTglDTnbj5ZNueE7mAW3YRKHWRBBK3/gjycen0y18x4N3tNZizDwHm0T
         oG4P0zKHw5oe7Iv/FA/AgB92eSDASmGxu8WlwqynYp66ZCx0Uvu/ShjCaytyEVg8om7Wb3wa22I7
         YgsFYMvgYDFcrmX28lKO++ojFSbhT08TvUb5lKOrhEq9COmilsSVrS5cDmUak0qK7ZaFi/cgE/Og
         94xX/QblUBh/e3fZzGeMsZpi44nVe+LWe2LBifTZBZovR0PYT8i5pzIFhwjQ2H9fn+G670OwnUR/
         Ymvm7ZFKyuQAdpauaeTT1+OOstghxfrxvGxiws4qcVuGfezBCkEJKJXb91WDOvGajpYGyzpNi44x
         wjnX/30oqeY7s0FPr4OLPfRPg+B0lRG13ovQYw5ML2cwZB+eGK+66Q9pd2L/lqXfvIj2/Trs66SQ
         SQoYEadxJ1lgZNE774grtEaUrOW85De82NZ891WD2NBkBJPkeVUYDin26YxNDflt/wtXNbrZczDH
         H+upC1Q2Hg1dVedx24bPb8OvynCdWvit0RXp2QOPKnmPlEpPAEWlJdmhVVPBwYVweYEbuLN3UefC
         zHd8vB4NyD1KYY2y8ukWl0wXnH3nqsmaDOfjGCIoeiWnX2PvVWDFdJkATuruHpWMZ60r6MvELWaj
         zwD5qmFL3MTxosawTz1uBerx2dj+2A55DEIQlM7QZJ/O3pe8nN79uaG6KUrnJw/SUq9ptDP0FBIq
         ngJwd3wdiZenCCyuI/dO5EtgDyl8M=
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
Date:   Sat, 18 Mar 2023 01:03:08 +0800
X-OQ-MSGID: <20230317170309.136117-3-wenyang.linux@foxmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230317170309.136117-1-wenyang.linux@foxmail.com>
References: <20230317170309.136117-1-wenyang.linux@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        RCVD_IN_SBL_CSS,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
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

