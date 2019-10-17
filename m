Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40BDDDA6E5
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 10:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392911AbfJQIFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 04:05:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392880AbfJQIFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 04:05:18 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9H83EC9082027
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 04:05:17 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vpgyxe2h9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 17 Oct 2019 04:05:17 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <sandipan@linux.ibm.com>;
        Thu, 17 Oct 2019 09:05:15 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 17 Oct 2019 09:05:13 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9H85C6Q45088830
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Oct 2019 08:05:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D3E2A4060;
        Thu, 17 Oct 2019 08:05:12 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6895A4054;
        Thu, 17 Oct 2019 08:05:10 +0000 (GMT)
Received: from tpad450.ibmuc.com (unknown [9.199.32.220])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Oct 2019 08:05:10 +0000 (GMT)
From:   Sandipan Das <sandipan@linux.ibm.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, aneesh.kumar@linux.ibm.com,
        mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH stable 4.14 3/6] powerpc/book3s64/radix: Rename CPU_FTR_P9_TLBIE_BUG feature flag
Date:   Thu, 17 Oct 2019 13:35:02 +0530
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191017080505.8348-1-sandipan@linux.ibm.com>
References: <20191017080505.8348-1-sandipan@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19101708-4275-0000-0000-00000372DF6D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19101708-4276-0000-0000-00003885F71C
Message-Id: <20191017080505.8348-3-sandipan@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-17_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910170071
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>

commit 09ce98cacd51fcd0fa0af2f79d1e1d3192f4cbb0 upstream.

Rename the #define to indicate this is related to store vs tlbie
ordering issue. In the next patch, we will be adding another feature
flag that is used to handles ERAT flush vs tlbie ordering issue.

Cc: stable@vger.kernel.org # v4.14
Fixes: a5d4b5891c2f ("powerpc/mm: Fixup tlbie vs store ordering issue on POWER9")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190924035254.24612-2-aneesh.kumar@linux.ibm.com
[sandipan: Backported to v4.14]
Signed-off-by: Sandipan Das <sandipan@linux.ibm.com>
---
 arch/powerpc/include/asm/cputable.h    | 4 ++--
 arch/powerpc/kernel/dt_cpu_ftrs.c      | 6 +++---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 2 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c    | 2 +-
 arch/powerpc/mm/hash_native_64.c       | 2 +-
 arch/powerpc/mm/tlb-radix.c            | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
index e143017d7549..6a0dfce96d8c 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -215,7 +215,7 @@ enum {
 #define CPU_FTR_DAWR			LONG_ASM_CONST(0x0400000000000000)
 #define CPU_FTR_DABRX			LONG_ASM_CONST(0x0800000000000000)
 #define CPU_FTR_PMAO_BUG		LONG_ASM_CONST(0x1000000000000000)
-#define CPU_FTR_P9_TLBIE_BUG		LONG_ASM_CONST(0x2000000000000000)
+#define CPU_FTR_P9_TLBIE_STQ_BUG	LONG_ASM_CONST(0x0000400000000000)
 #define CPU_FTR_POWER9_DD1		LONG_ASM_CONST(0x4000000000000000)
 
 #ifndef __ASSEMBLY__
@@ -477,7 +477,7 @@ enum {
 	    CPU_FTR_CFAR | CPU_FTR_HVMODE | CPU_FTR_VMX_COPY | \
 	    CPU_FTR_DBELL | CPU_FTR_HAS_PPR | CPU_FTR_DAWR | \
 	    CPU_FTR_ARCH_207S | CPU_FTR_TM_COMP | CPU_FTR_ARCH_300 | \
-	    CPU_FTR_P9_TLBIE_BUG)
+	    CPU_FTR_P9_TLBIE_STQ_BUG)
 #define CPU_FTRS_POWER9_DD1 ((CPU_FTRS_POWER9 | CPU_FTR_POWER9_DD1) & \
 			     (~CPU_FTR_SAO))
 #define CPU_FTRS_CELL	(CPU_FTR_USE_TB | CPU_FTR_LWSYNC | \
diff --git a/arch/powerpc/kernel/dt_cpu_ftrs.c b/arch/powerpc/kernel/dt_cpu_ftrs.c
index 753759a3c8e9..b61b6b1ebf43 100644
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -747,14 +747,14 @@ static __init void update_tlbie_feature_flag(unsigned long pvr)
 		if ((pvr & 0xe000) == 0) {
 			/* Nimbus */
 			if ((pvr & 0xfff) < 0x203)
-				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_STQ_BUG;
 		} else if ((pvr & 0xc000) == 0) {
 			/* Cumulus */
 			if ((pvr & 0xfff) < 0x103)
-				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_STQ_BUG;
 		} else {
 			WARN_ONCE(1, "Unknown PVR");
-			cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+			cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_STQ_BUG;
 		}
 	}
 }
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 559cba16dbe0..7f8f2a0189df 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -160,7 +160,7 @@ static void kvmppc_radix_tlbie_page(struct kvm *kvm, unsigned long addr,
 	asm volatile("ptesync": : :"memory");
 	asm volatile(PPC_TLBIE_5(%0, %1, 0, 0, 1)
 		     : : "r" (addr), "r" (kvm->arch.lpid) : "memory");
-	if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG))
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG))
 		asm volatile(PPC_TLBIE_5(%0, %1, 0, 0, 1)
 			     : : "r" (addr), "r" (kvm->arch.lpid) : "memory");
 	asm volatile("ptesync": : :"memory");
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index b18966a368af..9439fe213070 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -449,7 +449,7 @@ static void do_tlbies(struct kvm *kvm, unsigned long *rbvalues,
 				     "r" (rbvalues[i]), "r" (kvm->arch.lpid));
 		}
 
-		if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG)) {
+		if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 			/*
 			 * Need the extra ptesync to make sure we don't
 			 * re-order the tlbie
diff --git a/arch/powerpc/mm/hash_native_64.c b/arch/powerpc/mm/hash_native_64.c
index 96797bff5937..09b9263e3cc6 100644
--- a/arch/powerpc/mm/hash_native_64.c
+++ b/arch/powerpc/mm/hash_native_64.c
@@ -106,7 +106,7 @@ static inline unsigned long  ___tlbie(unsigned long vpn, int psize,
 
 static inline void fixup_tlbie(unsigned long vpn, int psize, int apsize, int ssize)
 {
-	if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG)) {
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 		/* Need the extra ptesync to ensure we don't reorder tlbie*/
 		asm volatile("ptesync": : :"memory");
 		___tlbie(vpn, psize, apsize, ssize);
diff --git a/arch/powerpc/mm/tlb-radix.c b/arch/powerpc/mm/tlb-radix.c
index 1a4912c5e5a2..5081e03b5e40 100644
--- a/arch/powerpc/mm/tlb-radix.c
+++ b/arch/powerpc/mm/tlb-radix.c
@@ -44,7 +44,7 @@ static inline void fixup_tlbie(void)
 	unsigned long pid = 0;
 	unsigned long va = ((1UL << 52) - 1);
 
-	if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG)) {
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 		asm volatile("ptesync": : :"memory");
 		__tlbie_va(va, pid, mmu_get_ap(MMU_PAGE_64K), RIC_FLUSH_TLB);
 	}
-- 
2.21.0

