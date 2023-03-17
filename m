Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6402D6BEF11
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 18:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjCQRDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 13:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbjCQRDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 13:03:51 -0400
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2635D3B64C
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 10:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1679072621;
        bh=ejvuR/427GAOicBpVwcwiGr2d1L0Paq/tBXRyaa6gjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=hh21f9btamga8IcneViSegKiiIJdE0NYTaV0bIPUs6MxrDD0EiLiX7UEeOc8GtS4u
         bfaPoy0EsSN4eqlw9wojhNxEhgjL5rLknxOo4KOaEQqaXO3pvTpRIOJrlN8yyzMpQB
         gOzklBZ+VOi+5/mAnkHiYLex3spuccSDSEOnO/x0=
Received: from wen-VirtualBox.. ([2408:84f6:8034:b52e:a120:6f4e:a714:1661])
        by newxmesmtplogicsvrszc5-0.qq.com (NewEsmtp) with SMTP
        id CCBF8DA; Sat, 18 Mar 2023 01:03:12 +0800
X-QQ-mid: xmsmtpt1679072594t5sgzmdf9
Message-ID: <tencent_42743A0C33995FF3F341951BB56050E6E406@qq.com>
X-QQ-XMAILINFO: NkHKfw09D6j8O6okZ09uAdqqUYKBU5mDTIB/UUjIpy3Y77AAje/yKLMiN5fyta
         pFtCTp3G0ZkRIqgisHD0nmvJqfbPc4alDvtJfqNXEz7D1yaf3v+j4iLVF3RtxITVIJBR8CzcT4jr
         s5g03RmyhLMEE9Qu+pIxjwyGKIfLo1HuW+dfjwE3JJq4IkzavTD1alrw9KDk0zHgCFz27z2v2aWx
         0Q06we1ZC41zdzL1zXSbevAwbT130UZuJpDjZGr1dvdoLd8G7faYtYYn8TTKjI8rtcO5AHzVGJGz
         g+mimPU5RVzTnivyDakaYm3drLCgx6RlW3+NxFPR++LPBO/uMEyFmy9VwmTa2Eg40p3dKooDBmER
         ggimHERGh6dowUwgVl0L8IaPmYQRKViHb8+jt/W42c7EFbMx5deVAZQPhqqXw1C4sYfLJe7r692K
         SJGNasvLBaz15iqAkLnSHQZDqWxAb+4POkikKFUA0YIqUhqQlwM1wKDfC069Q79V1w1Y3Gl8M+H7
         fx7ZXWAODMBicPuyK/PSqibmHTwl8MKuig+s6N461ac7tCstGCwQv337zPyWroDeaxT7ftYeU/tK
         iPVq6CW+Zqa/3kotLyqKbraJ/2bTacNyCsvdJxE0o3Dl+64O2Bq34z7S6EVNniv9XJUedSRhWBUb
         vB82vL8FIlBAoZfY6qrvRIYAffkD/0pw5KTDXzlDpjMuPrXgvL89CkUM7y1W2E7zJLfOs9+E9dUa
         JUhfxDpZGVgXhucp7EXG//LMRV4+GUuD611zDpUngLTvXL/xQINfUCCq2b8NU60jnFW1CaRaDegb
         HcVld1vpNoQkpAfw0t0zQQvM4V1mZY0oA/o5APhp0DW0qleRrUrQRvqIvCu2sopG7JOO6sBkvCV9
         8XXlVQdyYujGtj0uzp1NNQGs8fnF4YUY4KPvpZkXoXFiWPd5KMpc6/g0bDGwZPnVVYgn/0RDIShM
         HfoGeNYmV4hf/sMR3RCaLOA4PJ0yOB3tckKFWnYVWI64LkoJaSJZF/91fjuFLG3yzQc9zU6xxLJe
         fcRVvz3er2z4p5hNif
From:   wenyang.linux@foxmail.com
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Christoph Hellwig <hch@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Feng Tang <feng.tang@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang.linux@foxmail.com>
Subject: [PATCH 5.10 1/3] kexec: move locking into do_kexec_load
Date:   Sat, 18 Mar 2023 01:03:07 +0800
X-OQ-MSGID: <20230317170309.136117-2-wenyang.linux@foxmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230317170309.136117-1-wenyang.linux@foxmail.com>
References: <20230317170309.136117-1-wenyang.linux@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 4b692e861619353ce069e547a67c8d0e32d9ef3d upstream.

Patch series "compat: remove compat_alloc_user_space", v5.

Going through compat_alloc_user_space() to convert indirect system call
arguments tends to add complexity compared to handling the native and
compat logic in the same code.

This patch (of 6):

The locking is the same between the native and compat version of
sys_kexec_load(), so it can be done in the common implementation to reduce
duplication.

Link: https://lkml.kernel.org/r/20210727144859.4150043-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20210727144859.4150043-2-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Co-developed-by: Eric Biederman <ebiederm@xmission.com>
Co-developed-by: Christoph Hellwig <hch@infradead.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org # 5.10+
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
---
 kernel/kexec.c | 44 ++++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 28 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index c82c6c06f051..9c7aef8f4bb6 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -110,6 +110,17 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 	unsigned long i;
 	int ret;
 
+	/*
+	 * Because we write directly to the reserved memory region when loading
+	 * crash kernels we need a mutex here to prevent multiple crash kernels
+	 * from attempting to load simultaneously, and to prevent a crash kernel
+	 * from loading over the top of a in use crash kernel.
+	 *
+	 * KISS: always take the mutex.
+	 */
+	if (!mutex_trylock(&kexec_mutex))
+		return -EBUSY;
+
 	if (flags & KEXEC_ON_CRASH) {
 		dest_image = &kexec_crash_image;
 		if (kexec_crash_image)
@@ -121,7 +132,8 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 	if (nr_segments == 0) {
 		/* Uninstall image */
 		kimage_free(xchg(dest_image, NULL));
-		return 0;
+		ret = 0;
+		goto out_unlock;
 	}
 	if (flags & KEXEC_ON_CRASH) {
 		/*
@@ -134,7 +146,7 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 
 	ret = kimage_alloc_init(&image, entry, nr_segments, segments, flags);
 	if (ret)
-		return ret;
+		goto out_unlock;
 
 	if (flags & KEXEC_PRESERVE_CONTEXT)
 		image->preserve_context = 1;
@@ -171,6 +183,8 @@ static int do_kexec_load(unsigned long entry, unsigned long nr_segments,
 		arch_kexec_protect_crashkres();
 
 	kimage_free(image);
+out_unlock:
+	mutex_unlock(&kexec_mutex);
 	return ret;
 }
 
@@ -247,21 +261,8 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 		((flags & KEXEC_ARCH_MASK) != KEXEC_ARCH_DEFAULT))
 		return -EINVAL;
 
-	/* Because we write directly to the reserved memory
-	 * region when loading crash kernels we need a mutex here to
-	 * prevent multiple crash  kernels from attempting to load
-	 * simultaneously, and to prevent a crash kernel from loading
-	 * over the top of a in use crash kernel.
-	 *
-	 * KISS: always take the mutex.
-	 */
-	if (!mutex_trylock(&kexec_mutex))
-		return -EBUSY;
-
 	result = do_kexec_load(entry, nr_segments, segments, flags);
 
-	mutex_unlock(&kexec_mutex);
-
 	return result;
 }
 
@@ -301,21 +302,8 @@ COMPAT_SYSCALL_DEFINE4(kexec_load, compat_ulong_t, entry,
 			return -EFAULT;
 	}
 
-	/* Because we write directly to the reserved memory
-	 * region when loading crash kernels we need a mutex here to
-	 * prevent multiple crash  kernels from attempting to load
-	 * simultaneously, and to prevent a crash kernel from loading
-	 * over the top of a in use crash kernel.
-	 *
-	 * KISS: always take the mutex.
-	 */
-	if (!mutex_trylock(&kexec_mutex))
-		return -EBUSY;
-
 	result = do_kexec_load(entry, nr_segments, ksegments, flags);
 
-	mutex_unlock(&kexec_mutex);
-
 	return result;
 }
 #endif
-- 
2.37.2

