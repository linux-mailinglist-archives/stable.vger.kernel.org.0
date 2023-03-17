Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2D06BEF22
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 18:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjCQRFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 13:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCQRFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 13:05:36 -0400
Received: from out203-205-221-205.mail.qq.com (out203-205-221-205.mail.qq.com [203.205.221.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5225341B75
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 10:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1679072702;
        bh=igsLms0OPWbHmIHb5v2wsojui63iq9Vf0kvnImMGl4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=QiFFV/F5h8TxYd+XShA3eeumaiybIK5XB02TORQhcx19KiwMKOt809wA9eqgsGy+0
         MkgeBpgt6bP/6zIfgOnKDSpB/EyuZZD74AYP4yWbwV/f92qgtlE7bZIadKOQ1F715O
         KAE4gmgTKSz3L4Z5xmIxt9ONUGStA7GtHBv3quF0=
Received: from wen-VirtualBox.. ([2408:84f6:8034:b52e:a120:6f4e:a714:1661])
        by newxmesmtplogicsvrszb9-0.qq.com (NewEsmtp) with SMTP
        id 13882072; Sat, 18 Mar 2023 01:04:56 +0800
X-QQ-mid: xmsmtpt1679072698tmv5iiac6
Message-ID: <tencent_4939B2EA8A3A37E861723BBD8699C6CFEE05@qq.com>
X-QQ-XMAILINFO: OakVxA/3u/8RMvfw4VjH2MqM8hmeBS+UKIPlteOD6KUPLch3YzYMz/wudo00ls
         Ou4HElNNYlD54OsomMhz+UT6f/FZQdm9sxGCITyDHLRgG9VSqp8Ln0AhXVJWio/ZzWlzNPNB8YjU
         2r9+DawBcd+gSCWv1Q93yEvn9Ew0/wn7IOYREtteEidwYzuLuRnSJuUNnWS4Rxo7qPhhzRYZ3tWC
         +3AYhf6Mydj53m/Hg3XDZ+Tu54gPxTij442QDnitbgP3odq5FtoDf8V8+BYwzPH2mV9Ic8WtLM3K
         99bbB+SW5bxY7sWTwUbtXQGeWKvq98OEbSUdTh2up8IrUrsSp64UQ59y7g7V4F6fD4n3KG19Gwp2
         NNM0QKKmsZ6CxD+V0keapRRA0DoOJaB85dDkyKJUhsoD6klgXmlFxSKQm/r577JixGxreMEBbCr4
         +MbGQM9eohhHcXVMqdjRj9wIriLc4aFFWWiLH4KpwsbpTz9walpZe2XXqoGaYx2wjMzNA/Cg9xbJ
         JBJqhKYpzr3S1SrLwyKxhoRyS5jdznJsMu7FW4HRtfBFMxDVwUDLk95HEVCymZYBZCtI4QVe1zZR
         Ri9VC9D14pwmGUoYj9pcVR5XNTNyy2t1/qfCk3idsYU/s35iYLuw/OOOJyXOrovpQeZnOWTvScNf
         FRNwi/2sE0nLyR/9OCWy9fMTKT2ZRku67J5FDK76GHrh6/4/XGWXjSUVaO0A/Qk+EV2zJeDNspMv
         1/6jWow2e85SlQfo31v/u5d3WxNufxfx+w0Vu2x2k2sTa3wvfHTbAD20qNQ6SNlh1iaX8gX7c9Hl
         exrbnKUMNB5MYkNsu4ieOL9MgoTUcRi36Q0FnQQdq7tRBPPMZO+vBBCbco1MWhDf575HD93d1lTv
         1cmOuoEI50rZcvkZ3wm7t8zFM5Eyuch487dblJ4UrR43IB1NJBFFVhJbvw0ulQZvvS/EmtPFD5qv
         6D5y25VinXuNrR16ZjZ6oI3/c9yG9REctY2LyzaMupgfxAkjmv4DO2dtp9Qg7i3ddB3+8k3EfcDB
         ocFc7TRKnafLNaZvfn6jnnWl6GmNdIVSwJhTLA/ohPV/DeKonRzOVEQcbOQRacQXZr/S2X9h2z/1
         qL0DYA7lT6MTIQVQ5VEmhi52Cs9w==
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
Date:   Sat, 18 Mar 2023 01:04:30 +0800
X-OQ-MSGID: <20230317170431.137700-2-wenyang.linux@foxmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230317170431.137700-1-wenyang.linux@foxmail.com>
References: <20230317170431.137700-1-wenyang.linux@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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

