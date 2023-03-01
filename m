Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87BBC6A70D8
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjCAQZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCAQZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:25:38 -0500
Received: from out203-205-221-209.mail.qq.com (out203-205-221-209.mail.qq.com [203.205.221.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F70D3BDBA
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 08:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1677687934;
        bh=ejvuR/427GAOicBpVwcwiGr2d1L0Paq/tBXRyaa6gjg=;
        h=From:To:Cc:Subject:Date;
        b=i9ajLs6plqAYYgWwPai9pwmCDAkvehXwObYG3oHsTZG2akII+d90Mgp/7X4xbfe7W
         n3LcGQJTTCkXuxiJ4nKCwSCXLQcJ+OZCp48MiqHm2Tc0ThOhxUXcOiLo3K/E2/z0sI
         FrLde9k0/1AL8Fk3RpO8sB09njzI7+AcF8LOh6B4=
Received: from localhost.localdomain ([106.92.97.94])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 65B916D6; Thu, 02 Mar 2023 00:25:27 +0800
X-QQ-mid: xmsmtpt1677687927tw9qko60r
Message-ID: <tencent_461ABFAD67C42A066A83A0E54993F41A6607@qq.com>
X-QQ-XMAILINFO: OYMEOeTae7mlQJbtFX9H8tGORg7vbrpG70IVd6ZTREdvKLH+VuyYfCW22QaEhJ
         KIK52CwD9NEVIA18sUTNfW5fYEkBt0oB9SPc2WEERopWb8+E9yeAxz08IjbimjFJnqPVbZGwQyzk
         PATIXwKu/OgvPcxlsv2TfIR2YPQeG3LHBSUacSjTz0Sk5rO/pz0Aztbv1r4ok4zU4ebaSplxU+GJ
         ZStRo/ISWw+UUY6p5iqQz6S6x6RcAxM+hTETbbpoVQkDvGkSn3VWaV+gg0pOaZHtdgqpN/8t0RPo
         jSgLXLhidzXo/lutMnuJcaTF6XtvAzpeFAK5Yxx4oaVIe7I6cM/Xr0ze8tKslB5NgnoXJobyT0lR
         J/Jayrr15TrMJuXjl4e6VM/JiEbLjQ3NfurJRhNp3MnSKYUtZ13DdjoMRPy8aDNLvFPGO/Wm0xyh
         MmTQ9RMD4P2VaoOprfTUFVYnlY93COCrsgYn/KwJ2Zi2WaQE/9FwhU+kGY3w/sidakP/O6Bo3Dz3
         hHU2/xNBw0Rgzo3UAjBaa5ZG4uVWz4GuPY/6OZHdyj1ZQhaf2sN7REIxTshHqZsMiVq1Mi/G3uwz
         NLnSuu9PoUGx92fXHeG4dQZC/Cc8KK+44nc5Rfdf5thVg4IJIFNqqPAr1+XejtolApipEAKdoHIm
         H1pXQyANK9kpXwpS+DWcVD1MxVSbaldz2/BCzQRW54mihTsz0VeLLUeVDoONI53/LcgEkO9QjinZ
         DtwieAYJkEYpFVfvFXHB/Jgb0yyons75to8sWF5Mx+L6+yKfvtFxZ4PTnP2MSjf2UAYc78Ivj5Gy
         UyCMtgiK/K8HX3cVV6Os+we/PW76eFcDf97PDFW6krUE/9yHS37wwhNxYr/E4C8xmUMV+cWrFU50
         f0at8E94w/zT0w2SKA/1vatm94d6uEN35E53qkeX3EifCqb6W8Arb+PPQBD8VdNLcIxViwvnKYbi
         Yffluf3sD3wA4HrT/eIGe2K3fUhuy1k/TGXHLo5Obep+gSGyOmwZ7DdIwFEYKYO9dMlBsWn3xTfs
         Avr+1wIpj2YbxA7Y3G2fHzk4KeAuKu3Er7QrZLfK2yQH0aQZybjdBzXBhEeV55Z+5ViOmSALEJsF
         ZLFU9G
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
Date:   Thu,  2 Mar 2023 00:25:00 +0800
X-OQ-MSGID: <20230301162502.120413-1-wenyang.linux@foxmail.com>
X-Mailer: git-send-email 2.37.2
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

