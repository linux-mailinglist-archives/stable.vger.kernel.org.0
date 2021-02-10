Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56E431682A
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 14:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhBJNkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 08:40:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18178 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229654AbhBJNkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 08:40:06 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11ADWZnW027811;
        Wed, 10 Feb 2021 08:39:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=JeOhYgWABl8vHEfaVaEUGU0iyKhnrw8N9X68EYJpLqc=;
 b=e+Ky5ej94oD/5fB5gBMh1H8a+4jM2ype5KyG7LtTMqOONPSDATDcRFlIK6T14fWotF4+
 Ne1mfKfgrkfOBgdpXNtF3UvRv98rsNsp5NXX42WLThKuBH8qTpkMORtkrY+YalkDzP4t
 Sed+BAohWVJdM39epU9+5k7fTHP5m/BQjLoZw4tVg5stM3bc24NY3XRxZt27ckJ28Gzz
 68ou34h9kzprEOP0NokO5ztdwqiOE0s64/aY3G5Nfq1dd+UQ57TOWjsly7plwF1bLaP1
 4+32Z72nvucW+zF6vUtln4wDPzzl+2LpIHcp1cAmixotuAJpX16GafMCIm3pEMhC8Hu0 WA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mgfcgemc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 08:39:15 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11ADXCtn030512;
        Wed, 10 Feb 2021 08:39:14 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36mgfcgegs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 08:39:14 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11ADXV5i004549;
        Wed, 10 Feb 2021 13:34:11 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 36j94wm28v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Feb 2021 13:34:10 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11ADY8nO43254184
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Feb 2021 13:34:08 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2147AA4057;
        Wed, 10 Feb 2021 13:34:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67932A404D;
        Wed, 10 Feb 2021 13:34:07 +0000 (GMT)
Received: from osiris (unknown [9.171.5.38])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 10 Feb 2021 13:34:07 +0000 (GMT)
Date:   Wed, 10 Feb 2021 14:34:05 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Chris Down <chris@chrisdown.name>,
        Hugh Dickins <hughd@google.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Linux-MM <linux-mm@kvack.org>, Matt Turner <mattst88@gmail.com>,
        mm-commits@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Seth Forshee <seth.forshee@canonical.com>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Tuan Hoang1 <Tuan.Hoang1@ibm.com>
Subject: Re: [patch 09/14] tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha
Message-ID: <YCPgzb1PhtvfUh9y@osiris>
References: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org>
 <20210209214217.gRa4Jmu1g%akpm@linux-foundation.org>
 <CAHk-=wiDt_eJvfrr-dCXq3eZ+ZmVTD2-rM2pcxBk4d-FM3h-bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiDt_eJvfrr-dCXq3eZ+ZmVTD2-rM2pcxBk4d-FM3h-bw@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_05:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 suspectscore=0 spamscore=0 clxscore=1011 mlxlogscore=999 adultscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100126
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 02:03:19PM -0800, Linus Torvalds wrote:
> On Tue, Feb 9, 2021 at 1:42 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > As with s390, alpha is a 64-bit architecture with a 32-bit ino_t.  With
> > CONFIG_TMPFS_INODE64=y tmpfs mounts will get 64-bit inode numbers and
> > display "inode64" in the mount options, whereas passing "inode64" in the
> > mount options will fail.
> 
> Ugh.
> 
> The two patches for s390 and alpha are obviously the right thing to
> do, but I do wonder if we could strive to make __kernel_ino_t go away
> entirely.
> 
> It's actually not used very much, because it's such a nasty type, and
> s390 and alpha are the only ones that override it from the default
> "word length" version (and honestly, even that default is not a great
> type).
> 
> The main use of it is for "ino_t" and for "struct ustat".
> 
> And yes, "ino_t" is widely used, but I think pretty much all uses of
> it are entirely internal to the kernel, and we could just make it be
> "unsigned long".
> 
> Does anybody see any actual user interfaces that depend on
> "__kernel_ino_t", aka "ino_t" (apart from that "struct ustat")?
> 
> I guess this is mostly a question for s390, which is actively maintained?

I couldn't spot any and also gave the patch below a try and my system
still boots without any errors.
So, as far as I can tell it _should_ be ok to change this.

Note that the unusual 32 bit ino_t also recently caused a bug on
s390. See commit ebce3eb2f7ef ("ceph: fix inode number handling on
arches with 32-bit ino_t"). So getting rid of this would be a good
thing.

diff --git a/arch/Kconfig b/arch/Kconfig
index 24862d15f3a3..383c98e86a70 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -327,6 +327,10 @@ config ARCH_32BIT_OFF_T
 	  still support 32-bit off_t. This option is enabled for all such
 	  architectures explicitly.
 
+# Selected by 64 bit architectures which have a 32 bit f_tinode in struct ustat
+config ARCH_32BIT_USTAT_F_TINODE
+	bool
+
 config HAVE_ASM_MODVERSIONS
 	bool
 	help
diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 1f51437d5765..96ce6565890e 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -2,6 +2,7 @@
 config ALPHA
 	bool
 	default y
+	select ARCH_32BIT_USTAT_F_TINODE
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
 	select ARCH_NO_PREEMPT
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index c72874f09741..434efd9ca0c5 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -58,6 +58,7 @@ config S390
 	# Note: keep this list sorted alphabetically
 	#
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT
+	select ARCH_32BIT_USTAT_F_TINODE
 	select ARCH_BINFMT_ELF_STATE
 	select ARCH_HAS_DEBUG_VM_PGTABLE
 	select ARCH_HAS_DEBUG_WX
diff --git a/fs/statfs.c b/fs/statfs.c
index 68cb07788750..0ba34c135593 100644
--- a/fs/statfs.c
+++ b/fs/statfs.c
@@ -255,7 +255,10 @@ SYSCALL_DEFINE2(ustat, unsigned, dev, struct ustat __user *, ubuf)
 
 	memset(&tmp,0,sizeof(struct ustat));
 	tmp.f_tfree = sbuf.f_bfree;
-	tmp.f_tinode = sbuf.f_ffree;
+	if (IS_ENABLED(CONFIG_ARCH_32BIT_USTAT_F_TINODE))
+		tmp.f_tinode = min_t(u64, sbuf.f_ffree, UINT_MAX);
+	else
+		tmp.f_tinode = sbuf.f_ffree;
 
 	return copy_to_user(ubuf, &tmp, sizeof(struct ustat)) ? -EFAULT : 0;
 }
diff --git a/include/linux/types.h b/include/linux/types.h
index a147977602b5..1e9d0a2c1dba 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -14,7 +14,7 @@ typedef u32 __kernel_dev_t;
 
 typedef __kernel_fd_set		fd_set;
 typedef __kernel_dev_t		dev_t;
-typedef __kernel_ino_t		ino_t;
+typedef __kernel_ulong_t	ino_t;
 typedef __kernel_mode_t		mode_t;
 typedef unsigned short		umode_t;
 typedef u32			nlink_t;
@@ -189,7 +189,11 @@ struct hlist_node {
 
 struct ustat {
 	__kernel_daddr_t	f_tfree;
-	__kernel_ino_t		f_tinode;
+#ifdef ARCH_HAS_32BIT_F_TINODE
+	unsigned int		f_tinode;
+#else
+	unsigned long		f_tinode;
+#endif
 	char			f_fname[6];
 	char			f_fpack[6];
 };
