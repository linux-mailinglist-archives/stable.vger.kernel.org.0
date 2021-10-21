Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC92E435FAD
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 12:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhJUKvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 06:51:41 -0400
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:58471 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbhJUKvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 06:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1634813365;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=mT9LyIsz10E8RQm8NyU4cdSzrzFfqEsqIOfzWYF5PuI=;
  b=RBHcBy6fEs0KDyEtjG2AbHdt/Yj1yr0s666il1ucFJmWdcXsZqGG6c6J
   u3dPpMGd8gSZfZuZcZXTmLLYPoI4wtgcsvo7R3bDOISlUf/gGN7d1dpV4
   BP5yTgW4cflT3qYSWeVwFDYfssc0AzYJ1fqrqq3hA9ZIP6CZcuY6K7mB/
   Q=;
Authentication-Results: esa4.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: ahKLFFRPlmtbid0kL3/+h+yBG+wetL67vIBSW0S8jGX0KGUBier2j6e9rl2rbDepN+fBFcXTCi
 j3QCPgdLmnW8uVzMb/spb5ezNfEmfYDcZ3wQQ6t+j1cU9TOSpWkBilDyXxd2jB+0b765D4YWGN
 zBJoGlO9obYjk9o2kQ/2X8zfAWQuQjDe1L63HsvlxfajAkUGZTxl6DpEeZCMxu8s59KzmrsK+M
 RrvcwWtc3fiQ8mFvY1V0kZg+jCfNg11rWnClU/t8uTLeGgqP8zTbNdklLHsJjoH3PQqWjHWpG5
 05pEWLi/v4X56jLtX5wmVLXP
X-SBRS: 5.1
X-MesageID: 57629076
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
IronPort-Data: A9a23:TlmDuK8HkwG/iCNoyxoUDrUDSXiTJUtcMsCJ2f8bNWPcYEJGY0x3x
 msdDTqAaancN2b2Kt53OoS1/B5XsJ+HnYJjSQFrryk8E34SpcT7XtnIdU2Y0wF+jyHgoOCLy
 +1EN7Es+ehtFie0Si9AttENlFEkvU2ybuOU5NXsZ2YhGmeIdA970Ug6wrZj29Yx6TSEK1jlV
 e3a8pW31GCNg1aYAkpMg05UgEoy1BhakGpwUm0WPZinjneH/5UmJMt3yZWKB2n5WuFp8tuSH
 I4v+l0bElTxpH/BAvv9+lryn9ZjrrT6ZWBigVIOM0Sub4QrSoXfHc/XOdJFAXq7hQllkPhI9
 YpP6JaMFz04O7PhvbkDCBZdTiFhaPguFL/veRBTsOSWxkzCNXDt3+9vHAc9OohwFuRfWD8Us
 6ZCcXZUM07F17neLLGTE4GAguwBJc/meqYWvnhkxDfUJf0nXYrCU+PB4towMDIY258QR6eGO
 JRxhTxHRRn9YhdXGH4sKINgkNvr2lL0Sxd9twfAzUYwyzeKl1EguFT3C/LQe9qFQu1Pk0qYr
 36A9GP8ajkCKcOSzxKF432rgKnEm0vTQ48bEr+z3vFth1KXyyoYDxh+fUOxpv+ri0i/c8hSJ
 0wd5mwlqq1a3EiqSMTtGh61uniJujYCVNdKVe438geAzuzT+QnxLnMYRzRFZfQ4u8IsAz8nz
 FmEm5XuHzMHmL2NQFqP56uTt3W5Pi19BWUaTSYATAYDs5/vrekblBveCNZ+Gai6ptTwFXf7x
 DXihCIkhrcels5NzKS98lDvijeg4JPOS2Yd+grTTkqh7wVkeJSiYY24r1TWhd5DLYPfVlmAu
 HwFg9O25eUCS5qKkUSlULVTNLKk/fCINHvbm1EHN4Es6zm36Vaie45K6T1zLUsvNdwLERfYa
 V3ev0V+5JZVOnKvRaZyb8S6DMFC5az9CdPNVf3OaNdKJJ9re2e6EDpGPBDKmTq3yQ51zP95a
 czznduQ4WgyMJk4zme8e7knwLo16wVj2zjcQM370EHyuVaBX0K9RbAAOVqIS+k26qKYvQnYm
 +pi29u2JwZ3C7KmPHGGmWIHBRVTdyJjXMGpwyBCXrfbelIOJY03NxPGLVrNkaRelKNJivyAw
 Hi5XkJJoLYUrSyacVvUApyPhbWGYHqekZ7ZFXBzVbpL8yJ6CWpK0Ev5X8FqFVXA3Lc7pcOYt
 9FfJ6297g1nE1wrAQg1Y5jnt5BFfx+2nw+INCfNSGFhJMI/GlGVooC7IVCHGMwy4syf75ZWT
 1qIjVuzfHb+b146UJa+hAyHnjtdQkTxaMotBhCVc7G/iW3n8ZRwKjyZsxPEC5pkFPk3/RPDj
 1z+KU5B/YHl+tZpmPGU1fHsh9r4SINWQxsFd1Q3GJ7rbEE2CEL4mtQeOAtJFBiAPF7JFFKKP
 7gOla6gaaxcwj6nceNUSt5W8E733PO3z5cy8+iuNCyTB7hyIr8/cHSAw+dVsahBmu1QtQesA
 xrd8dhGI7SZfsjiFQdJdgYia+2C09ASmyXTsqtpcBmruncv8erVS1hWMjmNlDdZcOl/PrQ6z
 Lpzo8UR8QG+1EYna47UkiBO+m2QBXUcSKF75IoCCYrmh1NzmFFPaJDREAHs55SLZ4keO0UmO
 GbM1qHDm65d1gzJdH9qTSrB2u9UhJIvvhFWzQBdewTVy4Sd3vJuhU9f6zU6SAhR3y5r6eMrN
 zg5LVBxKIWP4yxs2JpJUVezFlwTHxae4EHwlQcEzTWLU0myW2XRB2QhIuLRrlsB+mdRczUHr
 rGVzGHpDWTjcM3rh3ZgXEdkr7roTMBr9x2Ek8eiRpzXE54/aDvjo6mveWtX9Ee3XZJv3BXK9
 btw4eJ9SaznLipB8aQ0Br6T2akUVB3ZdndJRuts/f9REGzREN1oNeNi96xllhtxGsH3
IronPort-HdrOrdr: A9a23:PxWJ5KHPA1WsJ9XspLqE4MeALOsnbusQ8zAXP0AYc31om62j5q
 aTdZsgpHzJYVoqN03I+urwX5VoI0msl6KdiLN5VdzJMWXbUQOTXeVfBODZowEIdReRygck79
 YET5RD
X-IronPort-AV: E=Sophos;i="5.87,169,1631592000"; 
   d="scan'208";a="57629076"
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
Subject: [PATCH v3] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Date:   Thu, 21 Oct 2021 11:47:44 +0100
Message-ID: <20211021104744.24126-1-jane.malalane@citrix.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, Linux probes for X86_BUG_NULL_SEL unconditionally which
makes it unsafe to migrate in a virtualised environment as the
properties across the migration pool might differ.

To be specific, the case which goes wrong is:

1. Zen1 (or earlier) and Zen2 (or later) in a migration pool
2. Linux boots on Zen2, probes and finds the absence of X86_BUG_NULL_SEL
3. Linux is then migrated to Zen1

Linux is now running on a X86_BUG_NULL_SEL-impacted CPU while believing
that the bug is fixed.

The only way to address the problem is to fully trust the "no longer
affected" CPUID bit when virtualised, because in the above case it would
be clear deliberately to indicate the fact "you might migrate to
somewhere which has this behaviour".

Zen3 adds the NullSelectorClearsBase bit to indicate that loading
a NULL segment selector zeroes the base and limit fields, as well as
just attributes. Zen2 also has this behaviour but doesn't have the
NSCB bit.

Signed-off-by: Jane Malalane <jane.malalane@citrix.com>

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
v3:
 * Create one function for probing NSCB in common/cpu and export it to be used in both amd.c and hygon.c.
 * Simplify logic with early returns
---
---
 arch/x86/kernel/cpu/amd.c    |  2 ++
 arch/x86/kernel/cpu/common.c | 44 +++++++++++++++++++++++++++++++++++++-------
 arch/x86/kernel/cpu/cpu.h    |  1 +
 arch/x86/kernel/cpu/hygon.c  |  2 ++
 4 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 2131af9f2fa2..4edb6f0f628c 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -989,6 +989,8 @@ static void init_amd(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_IRPERF) &&
 	    !cpu_has_amd_erratum(c, amd_erratum_1054))
 		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
+
+	check_null_seg_clears_base(c);
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0f8885949e8c..74c3975c94c7 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1395,9 +1395,8 @@ void __init early_cpu_init(void)
 	early_identify_cpu(&boot_cpu_data);
 }
 
-static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
+static bool detect_null_seg_behavior(void)
 {
-#ifdef CONFIG_X86_64
 	/*
 	 * Empirically, writing zero to a segment selector on AMD does
 	 * not clear the base, whereas writing zero to a segment
@@ -1418,10 +1417,43 @@ static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
 	wrmsrl(MSR_FS_BASE, 1);
 	loadsegment(fs, 0);
 	rdmsrl(MSR_FS_BASE, tmp);
-	if (tmp != 0)
-		set_cpu_bug(c, X86_BUG_NULL_SEG);
 	wrmsrl(MSR_FS_BASE, old_base);
-#endif
+	return tmp == 0;
+}
+
+void check_null_seg_clears_base(struct cpuinfo_x86 *c)
+{
+	/* BUG_NULL_SEG is only relevant with 64bit userspace */
+	if (!IS_ENABLED(CONFIG_X86_64))
+		return;
+
+	/* Zen3 CPUs advertise Null Selector Clears Base in CPUID. */
+	if (c->extended_cpuid_level >= 0x80000021 &&
+	    cpuid_eax(0x80000021) & BIT(6))
+		return;
+
+	/*
+	 * CPUID bit above wasn't set. If this kernel is still running
+	 * as a HV guest, then the HV has decided not to advertize
+	 * that CPUID bit for whatever reason.	For example, one
+	 * member of the migration pool might be vulnerable.  Which
+	 * means, the bug is present: set the BUG flag and return.
+	 */
+	if (cpu_has(c, X86_FEATURE_HYPERVISOR)) {
+		set_cpu_bug(c, X86_BUG_NULL_SEG);
+		return;
+	}
+
+	/*
+	 * Zen2 CPUs also have this behaviour, but no CPUID bit.
+	 * 0x18 for Hygon.
+	 */
+	if ((c->x86 == 0x17 || c->x86 == 0x18) &&
+	    detect_null_seg_behavior())
+		return;
+
+	/* All the remaining ones are affected */
+	set_cpu_bug(c, X86_BUG_NULL_SEG);
 }
 
 static void generic_identify(struct cpuinfo_x86 *c)
@@ -1457,8 +1489,6 @@ static void generic_identify(struct cpuinfo_x86 *c)
 
 	get_model_name(c); /* Default name */
 
-	detect_null_seg_behavior(c);
-
 	/*
 	 * ESPFIX is a strange bug.  All real CPUs have it.  Paravirt
 	 * systems that run Linux at CPL > 0 may or may not have the
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 95521302630d..ee6f23f7587d 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -75,6 +75,7 @@ extern int detect_extended_topology_early(struct cpuinfo_x86 *c);
 extern int detect_extended_topology(struct cpuinfo_x86 *c);
 extern int detect_ht_early(struct cpuinfo_x86 *c);
 extern void detect_ht(struct cpuinfo_x86 *c);
+extern void check_null_seg_clears_base(struct cpuinfo_x86 *c);
 
 unsigned int aperfmperf_get_khz(int cpu);
 
diff --git a/arch/x86/kernel/cpu/hygon.c b/arch/x86/kernel/cpu/hygon.c
index 6d50136f7ab9..3fcdda4c1e11 100644
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -335,6 +335,8 @@ static void init_hygon(struct cpuinfo_x86 *c)
 	/* Hygon CPUs don't reset SS attributes on SYSRET, Xen does. */
 	if (!cpu_has(c, X86_FEATURE_XENPV))
 		set_cpu_bug(c, X86_BUG_SYSRET_SS_ATTRS);
+
+	check_null_seg_clears_base(c);
 }
 
 static void cpu_detect_tlb_hygon(struct cpuinfo_x86 *c)
-- 
2.11.0

