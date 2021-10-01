Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C6141EEC1
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 15:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353427AbhJANnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 09:43:35 -0400
Received: from esa5.hc3370-68.iphmx.com ([216.71.155.168]:3391 "EHLO
        esa5.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352761AbhJANnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 09:43:35 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Oct 2021 09:43:34 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1633095711;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=zyrYxS31DlDQsiUuEYQyKQVGd43v6Z84P7SkT3jY84I=;
  b=Pu2nI2EH11F4VeboQmIHyWMqT1eDuJa22oKVIohj0zopfUgqN1tMd/PP
   lzGfMRMu3+HvKLgpRHG5xxJGQ9XphtAREZZk0zM0fBrAzu9ZAKt1JU2V1
   fqtHewFBN69Z8fBJEngt9aWSz1EzRdfa5bPLWq98daffhttFjfnBuThgY
   c=;
Authentication-Results: esa5.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: LAgkcqnN4dpWrgEgejG2uDUm41zlKnV3vF0z+Y0ebp+j3qYaSxySsgPytjMW0dcNvLq4AsQ3J8
 y4tuFl13p+3Vf7rqwqskySUZwj0CrAy+RUfZ/kDlisKKyZcYnWFtgodop9xsvsAGQtXQoXWFtU
 XKtAVjDhJgbu5DkCh7wLWrDqlF9/tsAmECY47Lu018bpo7VgFLDDGAH+gSQg3A2P1YRcGZP+4q
 M8f0wuZj85TwVNWZ10UnKW0UV8h9XuaM17moz2uPMcwdNJBJzF0qJ5qDrO0JdEotXUcjbRwQRF
 Sq7s+tzMfh3irQB1LLUr1cbZ
X-SBRS: 5.1
X-MesageID: 53719107
X-Ironport-Server: esa5.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
IronPort-Data: A9a23:fgadx6mCdh5CQuTYaZG9gl7o5gxOIERdPkR7XQ2eYbSJt1+Wr1Gzt
 xJOXm3Xb/jeY2GgKopzb42+8U0PusXdxt4xQAtuqioxRiMWpZLJC+rCIxarNUt+DCFioGGLT
 Sk6QoOdRCzhZiaE/n9BClVlxJVF/fngqoDUUYYoAQgsA185IMsdoUg7wbdg2tYx2YPR7z6l4
 rseneWOYDdJ5BYsWo4kw/rrRMRH5amaVJsw5zTSVNgT1LPsvyB94KE3fMldG0DQUIhMdtNWc
 s6YpF2PEsE1yD92Yj+tuu6TnkTn2dc+NyDW4pZdc/DKbhSvOkXee0v0XRYRQR4/ttmHozx+4
 PRE6biqd1YsBPLNgMdBaDhaTn5yE4QTrdcrIVDn2SCS50jPcn+qyPRyFkAme4Yf/46bA0kXq
 6ZecmpUKEne2aTmm9pXScE17ignBOviOo5Zn3hkxDXQC/sOSpHfWaTao9Rf2V/cg+gTRqmHN
 pNBNlKDajzuPQweBFQVDK44u9jxrXnybhhZgWyK8P9fD2/7k1UqjemF3MDuUtmLQ8pStlyVq
 mLP4yLyBRRyHMSC1jeD2nK9iejJ2yj9MKoJGbS+9PVCj1qUyWgeThYRUDOTufO+jFy/XdN3M
 UEY+iMy66M18SSDStj7Qg39o3OeuBMYc8RfHvd86wyXzKfQpQGDCQAsVSJIYtgrnNE5SCZs1
 VKTmd7tQzt1v9W9SWqU3qWFsTSofyMSKAcqbzcsRA8E7t+z5o0+5jrVR8clELO8iNLdEDT8h
 TuNqUAWja8Sj8MQ1+Og/FbIgxqlo5SPRQkwji3LUWa1xgd4YpO5fYuu6Eid4fsoBIWYSx+Zv
 HkAn8mG98gHCJ3LnyuIKM0dTO+B5PufNjDYx1l1EPEJ7zmx9mSxVYFW7it3KEpgPoADYzCBS
 H7aqw5XorBTNX2sZKpfaoe9Tc8tyMDIEcn5UdjXY8BIb5w3cxWIlByCfmbJgTqryhJ11/hiZ
 9HLKq5AEEr2F4xGxWaSXdlM1IV0xzgdmVjyR82kwzqOhO/2iGGudZ8JN16Hb+Yc5ayCoRnI/
 9s3C/Zm2ymzQ8WkPHCIoNd7wUQiaChjXM+q+6S7Y8bZemJb9Hcd5+g9KF/LU6Jihbgdsu7V8
 nynVkZcxTITblWccl7SOxiPhF71NKuTTE7X3wRwYD5EOFB5OO5DCZvzkbNsIdHLE8Q5k5ZJo
 wEtIZnoPxi2Ym2vF84hRZf8tpd+Ux+gmBiDOSGoCBBmIcU7H1aWoYG9I1u+nMXrMsZRnZBiy
 1FH/lmFKafvuiw4VJqGAB5R5wnZUYchdBJaABKTf4g7lLTE+4l2MS3h5sLb0OlXQSgvMgCyj
 l7MaT9B/LGli9ZsrLHh2PDVx6/0QrAWNhcLQAHmAUOeaHCyEpyLmtQbDo5lvFn1CQvJxUlVT
 b8Okq6gYKFZxgYiXkgVO+8D8J/SLuDH/9dypjmI1l2XB7hyIr8/cHSAw+dVsahBmu1QtQesA
 xrd8dhGI7SZfsjiFQdJdgYia+2C09ASmyXTsqtpcBmruncv8erVS1hWMjmNlDdZcOl/PrQ6z
 Lpzo8UR8QG+1EYna47UkiBO+m2QBXUcSKF75IoCCYrmh1NzmFFPaJDREAHs55SLZ4keO0UmO
 GbM1qHDm65d1gzJdH9qTSrB2u9UhJIvvhFWzQBdewTVy4Sd3vJuhU9f6zU6SAhR3y5r6eMrN
 zg5LVBxKIWP4yxs2JpJUVezFlwTHxae4EHwlQcEzTWLU0myW2XRB2QhIuLRrlsB+mdRczUHr
 rGVzGHpDWTjcM3rh3ZgXEdkr7roTMBr9x2Ek8eiRpzXE54/aDvjo6mveWtX9Ee3XZJv3BXK9
 btw4eJ9SaznLipB8aQ0Br6T2akUVB3ZdndJRuts/f9REGzREN1oNeNi96xllhtxGsH3
IronPort-HdrOrdr: A9a23:2DIfbqNwWe8umcBcTsmjsMiBIKoaSvp037Eqv3oRdfU1SL3/qy
 nApoV56faZslkssRIb6Le90cu7MBHhHPdOiOF7V9rPYOCPghrNEGgI1+vfKlPbdREWjtQtsJ
 tdTw==
X-IronPort-AV: E=Sophos;i="5.85,339,1624334400"; 
   d="scan'208";a="53719107"
From:   Jane Malalane <jane.malalane@citrix.com>
To:     LKML <linux-kernel@vger.kernel.org>
CC:     <jane.malalane@citrix.com>, <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Pu Wen <puwen@hygon.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Yazen Ghannam <Yazen.Ghannam@amd.com>,
        "Brijesh Singh" <brijesh.singh@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kim Phillips <kim.phillips@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Date:   Fri, 1 Oct 2021 14:33:49 +0100
Message-ID: <20211001133349.9825-1-jane.malalane@citrix.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, Linux probes for X86_BUG_NULL_SEL unconditionally which
makes it unsafe to migrate in a virtualised environment as the
properties across the migration pool might differ.

Zen3 adds the NullSelectorClearsBase bit to indicate that loading
a NULL segment selector zeroes the base and limit fields, as well as
just attributes. Zen2 also has this behaviour but doesn't have the
NSCB bit.

When virtualised, NSCB might be cleared for migration safety,
therefore we must not probe. Always honour the NSCB bit in this case,
as the hypervisor is expected to synthesize it in the Zen2 case.

Signed-off-by: Jane Malalane <jane.malalane@citrix.com>
---
CC: <x86@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
CC: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Pu Wen <puwen@hygon.cn>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Cooper <andrew.cooper3@citrix.com>
CC: Yazen Ghannam <Yazen.Ghannam@amd.com>
CC: Brijesh Singh <brijesh.singh@amd.com>
CC: Huang Rui <ray.huang@amd.com>
CC: Andy Lutomirski <luto@kernel.org>
CC: Kim Phillips <kim.phillips@amd.com>
CC: <stable@vger.kernel.org>
---
 arch/x86/include/asm/cpufeatures.h |  2 +-
 arch/x86/kernel/cpu/amd.c          | 23 +++++++++++++++++++++++
 arch/x86/kernel/cpu/common.c       |  6 ++----
 arch/x86/kernel/cpu/cpu.h          |  1 +
 arch/x86/kernel/cpu/hygon.c        | 23 +++++++++++++++++++++++
 5 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index d0ce5cfd3ac1..f571e4f6fe83 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -96,7 +96,7 @@
 #define X86_FEATURE_SYSCALL32		( 3*32+14) /* "" syscall in IA32 userspace */
 #define X86_FEATURE_SYSENTER32		( 3*32+15) /* "" sysenter in IA32 userspace */
 #define X86_FEATURE_REP_GOOD		( 3*32+16) /* REP microcode works well */
-/* FREE!                                ( 3*32+17) */
+#define X86_FEATURE_NSCB		( 3*32+17) /* Null Selector Clears Base */
 #define X86_FEATURE_LFENCE_RDTSC	( 3*32+18) /* "" LFENCE synchronizes RDTSC */
 #define X86_FEATURE_ACC_POWER		( 3*32+19) /* AMD Accumulated Power Mechanism */
 #define X86_FEATURE_NOPL		( 3*32+20) /* The NOPL (0F 1F) instructions */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 2131af9f2fa2..73c4863fe0f4 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -650,6 +650,29 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 	if (c->x86_power & BIT(14))
 		set_cpu_cap(c, X86_FEATURE_RAPL);
 
+	/*
+	 * Zen1 and earlier CPUs don't clear segment base/limits when
+	 * loading a NULL selector.  This has been designated
+	 * X86_BUG_NULL_SEG.
+	 *
+	 * Zen3 CPUs advertise Null Selector Clears Base in CPUID.
+	 * Zen2 CPUs also have this behaviour, but no CPUID bit.
+	 *
+	 * A hypervisor may sythesize the bit, but may also hide it
+	 * for migration safety, so we must not probe for model
+	 * specific behaviour when virtualised.
+	 */
+	if (c->extended_cpuid_level >= 0x80000021 &&
+	    cpuid_eax(0x80000021) & BIT(6))
+		set_cpu_cap(c, X86_FEATURE_NSCB);
+
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) && !cpu_has(c, X86_FEATURE_NSCB) &&
+	    c->x86 == 0x17)
+		detect_null_seg_behavior(c);
+
+	if (!cpu_has(c, X86_FEATURE_NSCB))
+		set_cpu_bug(c, X86_BUG_NULL_SEG);
+
 #ifdef CONFIG_X86_64
 	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
 #else
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0f8885949e8c..690337796e61 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1395,7 +1395,7 @@ void __init early_cpu_init(void)
 	early_identify_cpu(&boot_cpu_data);
 }
 
-static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
+void detect_null_seg_behavior(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_64
 	/*
@@ -1419,7 +1419,7 @@ static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
 	loadsegment(fs, 0);
 	rdmsrl(MSR_FS_BASE, tmp);
 	if (tmp != 0)
-		set_cpu_bug(c, X86_BUG_NULL_SEG);
+		set_cpu_cap(c, X86_FEATURE_NSCB);
 	wrmsrl(MSR_FS_BASE, old_base);
 #endif
 }
@@ -1457,8 +1457,6 @@ static void generic_identify(struct cpuinfo_x86 *c)
 
 	get_model_name(c); /* Default name */
 
-	detect_null_seg_behavior(c);
-
 	/*
 	 * ESPFIX is a strange bug.  All real CPUs have it.  Paravirt
 	 * systems that run Linux at CPL > 0 may or may not have the
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 95521302630d..642f46e0dd67 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -75,6 +75,7 @@ extern int detect_extended_topology_early(struct cpuinfo_x86 *c);
 extern int detect_extended_topology(struct cpuinfo_x86 *c);
 extern int detect_ht_early(struct cpuinfo_x86 *c);
 extern void detect_ht(struct cpuinfo_x86 *c);
+extern void detect_null_seg_behavior(struct cpuinfo_x86 *c);
 
 unsigned int aperfmperf_get_khz(int cpu);
 
diff --git a/arch/x86/kernel/cpu/hygon.c b/arch/x86/kernel/cpu/hygon.c
index 6d50136f7ab9..765f1556d964 100644
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -264,6 +264,29 @@ static void early_init_hygon(struct cpuinfo_x86 *c)
 	if (c->x86_power & BIT(14))
 		set_cpu_cap(c, X86_FEATURE_RAPL);
 
+	/*
+	 * Zen1 and earlier CPUs don't clear segment base/limits when
+	 * loading a NULL selector.  This has been designated
+	 * X86_BUG_NULL_SEG.
+	 *
+	 * Zen3 CPUs advertise Null Selector Clears Base in CPUID.
+	 * Zen2 CPUs also have this behaviour, but no CPUID bit.
+	 *
+	 * A hypervisor may sythesize the bit, but may also hide it
+	 * for migration safety, so we must not probe for model
+	 * specific behaviour when virtualised.
+	 */
+	if (c->extended_cpuid_level >= 0x80000021 &&
+	    cpuid_eax(0x80000021) & BIT(6))
+	        set_cpu_cap(c, X86_FEATURE_NSCB);
+
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) && !cpu_has(c, X86_FEATURE_NSCB) &&
+	    c->x86 == 0x18)
+                detect_null_seg_behavior(c);
+
+	if (!cpu_has(c, X86_FEATURE_NSCB))
+		set_cpu_bug(c, X86_BUG_NULL_SEG);
+
 #ifdef CONFIG_X86_64
 	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
 #endif
-- 
2.11.0

