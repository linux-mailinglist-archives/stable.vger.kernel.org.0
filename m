Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C49155E617
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 18:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347967AbiF1PoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 11:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347112AbiF1PoG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 11:44:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEAA36692;
        Tue, 28 Jun 2022 08:44:05 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SFhMwL008302;
        Tue, 28 Jun 2022 15:43:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=jhHNPTOGV8YFp2rt4yx5OjxclG5ryctYia2mNsVtOIE=;
 b=p8bWQJeaeuk9642kVAaO+9SXfTnwwVqwD/uztjo4HKH6w9JuTWLBwOVeUIjYUk/ob5PZ
 bbpteZYnoPooQkMbBqYboPQWWwzzbdjuRPU3cuaSBzYJ6VWpKHo/h1yz0nVhDmD6kqE8
 xxTDqE7N8spasdq9u3HmQrBIPc6W+ti3CWk3UhvcH7sLB0rhsFK6Gjf5JlPfAfnvEZZU
 BHFJNTeEJjZKzqCTj+lPOimvINUfmqpuIuOMlJ1WtwU8qqRQYzeJwjyWicQhSt4QooBL
 TvXkKwUwHdqEJZGayZkO4vs1GdS2GpujfMEr76NL3g1k3Abpkvq8XQJVWVevN9kWDFMY wg== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h04hh00n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 15:43:57 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SFcGTH024244;
        Tue, 28 Jun 2022 15:43:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3gwt08ut43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 15:43:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SFhqa021758348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 15:43:52 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2552B5204E;
        Tue, 28 Jun 2022 15:43:52 +0000 (GMT)
Received: from li-NotSettable.ibm.com.com (unknown [9.43.54.243])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id E940B52051;
        Tue, 28 Jun 2022 15:43:49 +0000 (GMT)
From:   "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To:     Greg KH <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
Cc:     <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        kexec@lists.infradead.org, Michael Ellerman <mpe@ellerman.id.au>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v5.4] kexec_file: drop weak attribute from arch_kexec_apply_relocations[_add]
Date:   Tue, 28 Jun 2022 21:12:49 +0530
Message-Id: <20220628154249.204911-4-naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.31.1
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7l8CfJ41She0JTa67nlMYtuIlwbqEwwl
X-Proofpoint-GUID: 7l8CfJ41She0JTa67nlMYtuIlwbqEwwl
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_09,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 adultscore=0
 phishscore=0 mlxlogscore=958 impostorscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3e35142ef99fe6b4fe5d834ad43ee13cca10a2dc upstream.

Since commit d1bcae833b32f1 ("ELF: Don't generate unused section
symbols") [1], binutils (v2.36+) started dropping section symbols that
it thought were unused.  This isn't an issue in general, but with
kexec_file.c, gcc is placing kexec_arch_apply_relocations[_add] into a
separate .text.unlikely section and the section symbol ".text.unlikely"
is being dropped. Due to this, recordmcount is unable to find a non-weak
symbol in .text.unlikely to generate a relocation record against.

Address this by dropping the weak attribute from these functions.
Instead, follow the existing pattern of having architectures #define the
name of the function they want to override in their headers.

[1] https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=d1bcae833b32f1

[akpm@linux-foundation.org: arch/s390/include/asm/kexec.h needs linux/module.h]
Link: https://lkml.kernel.org/r/20220519091237.676736-1-naveen.n.rao@linux.vnet.ibm.com
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 arch/s390/include/asm/kexec.h | 10 ++++++++
 arch/x86/include/asm/kexec.h  |  9 +++++++
 include/linux/kexec.h         | 46 +++++++++++++++++++++++++++++------
 kernel/kexec_file.c           | 34 --------------------------
 4 files changed, 57 insertions(+), 42 deletions(-)

diff --git a/arch/s390/include/asm/kexec.h b/arch/s390/include/asm/kexec.h
index 7f3c9ac34bd8d1..63098df81c9f2a 100644
--- a/arch/s390/include/asm/kexec.h
+++ b/arch/s390/include/asm/kexec.h
@@ -9,6 +9,8 @@
 #ifndef _S390_KEXEC_H
 #define _S390_KEXEC_H
 
+#include <linux/module.h>
+
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/setup.h>
@@ -83,4 +85,12 @@ struct kimage_arch {
 extern const struct kexec_file_ops s390_kexec_image_ops;
 extern const struct kexec_file_ops s390_kexec_elf_ops;
 
+#ifdef CONFIG_KEXEC_FILE
+struct purgatory_info;
+int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
+				     Elf_Shdr *section,
+				     const Elf_Shdr *relsec,
+				     const Elf_Shdr *symtab);
+#define arch_kexec_apply_relocations_add arch_kexec_apply_relocations_add
+#endif
 #endif /*_S390_KEXEC_H */
diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index 5e7d6b46de97d6..367da081f7d9d9 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -22,6 +22,7 @@
 
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/module.h>
 
 #include <asm/page.h>
 #include <asm/ptrace.h>
@@ -201,6 +202,14 @@ extern int arch_kexec_post_alloc_pages(void *vaddr, unsigned int pages,
 extern void arch_kexec_pre_free_pages(void *vaddr, unsigned int pages);
 #define arch_kexec_pre_free_pages arch_kexec_pre_free_pages
 
+#ifdef CONFIG_KEXEC_FILE
+struct purgatory_info;
+int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
+				     Elf_Shdr *section,
+				     const Elf_Shdr *relsec,
+				     const Elf_Shdr *symtab);
+#define arch_kexec_apply_relocations_add arch_kexec_apply_relocations_add
+#endif
 #endif
 
 typedef void crash_vmclear_fn(void);
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index a1cffce3de8cd7..64f23bab6255da 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -186,14 +186,6 @@ void *kexec_purgatory_get_symbol_addr(struct kimage *image, const char *name);
 int __weak arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
 					 unsigned long buf_len);
 void * __weak arch_kexec_kernel_image_load(struct kimage *image);
-int __weak arch_kexec_apply_relocations_add(struct purgatory_info *pi,
-					    Elf_Shdr *section,
-					    const Elf_Shdr *relsec,
-					    const Elf_Shdr *symtab);
-int __weak arch_kexec_apply_relocations(struct purgatory_info *pi,
-					Elf_Shdr *section,
-					const Elf_Shdr *relsec,
-					const Elf_Shdr *symtab);
 
 extern int kexec_add_buffer(struct kexec_buf *kbuf);
 int kexec_locate_mem_hole(struct kexec_buf *kbuf);
@@ -216,6 +208,44 @@ extern int crash_exclude_mem_range(struct crash_mem *mem,
 				   unsigned long long mend);
 extern int crash_prepare_elf64_headers(struct crash_mem *mem, int kernel_map,
 				       void **addr, unsigned long *sz);
+
+#ifndef arch_kexec_apply_relocations_add
+/*
+ * arch_kexec_apply_relocations_add - apply relocations of type RELA
+ * @pi:		Purgatory to be relocated.
+ * @section:	Section relocations applying to.
+ * @relsec:	Section containing RELAs.
+ * @symtab:	Corresponding symtab.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+static inline int
+arch_kexec_apply_relocations_add(struct purgatory_info *pi, Elf_Shdr *section,
+				 const Elf_Shdr *relsec, const Elf_Shdr *symtab)
+{
+	pr_err("RELA relocation unsupported.\n");
+	return -ENOEXEC;
+}
+#endif
+
+#ifndef arch_kexec_apply_relocations
+/*
+ * arch_kexec_apply_relocations - apply relocations of type REL
+ * @pi:		Purgatory to be relocated.
+ * @section:	Section relocations applying to.
+ * @relsec:	Section containing RELs.
+ * @symtab:	Corresponding symtab.
+ *
+ * Return: 0 on success, negative errno on error.
+ */
+static inline int
+arch_kexec_apply_relocations(struct purgatory_info *pi, Elf_Shdr *section,
+			     const Elf_Shdr *relsec, const Elf_Shdr *symtab)
+{
+	pr_err("REL relocation unsupported.\n");
+	return -ENOEXEC;
+}
+#endif
 #endif /* CONFIG_KEXEC_FILE */
 
 #ifdef CONFIG_KEXEC_ELF
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index b17998fa03f125..5b58149bcd900b 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -107,40 +107,6 @@ int __weak arch_kexec_kernel_verify_sig(struct kimage *image, void *buf,
 }
 #endif
 
-/*
- * arch_kexec_apply_relocations_add - apply relocations of type RELA
- * @pi:		Purgatory to be relocated.
- * @section:	Section relocations applying to.
- * @relsec:	Section containing RELAs.
- * @symtab:	Corresponding symtab.
- *
- * Return: 0 on success, negative errno on error.
- */
-int __weak
-arch_kexec_apply_relocations_add(struct purgatory_info *pi, Elf_Shdr *section,
-				 const Elf_Shdr *relsec, const Elf_Shdr *symtab)
-{
-	pr_err("RELA relocation unsupported.\n");
-	return -ENOEXEC;
-}
-
-/*
- * arch_kexec_apply_relocations - apply relocations of type REL
- * @pi:		Purgatory to be relocated.
- * @section:	Section relocations applying to.
- * @relsec:	Section containing RELs.
- * @symtab:	Corresponding symtab.
- *
- * Return: 0 on success, negative errno on error.
- */
-int __weak
-arch_kexec_apply_relocations(struct purgatory_info *pi, Elf_Shdr *section,
-			     const Elf_Shdr *relsec, const Elf_Shdr *symtab)
-{
-	pr_err("REL relocation unsupported.\n");
-	return -ENOEXEC;
-}
-
 /*
  * Free up memory used by kernel, initrd, and command line. This is temporary
  * memory allocation which is not needed any more after these buffers have

base-commit: 23db944f754e99abf814a79a2273b0191d35e4ff
-- 
2.36.1

