Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D08442C334
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 16:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhJMOcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 10:32:25 -0400
Received: from esa1.hc3370-68.iphmx.com ([216.71.145.142]:58692 "EHLO
        esa1.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236309AbhJMOcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 10:32:24 -0400
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Oct 2021 10:32:24 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1634135422;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=MSCf4E3Tz4qdtHA5E3pSrfjXUaNn8IKFyba4JGkpA8M=;
  b=ZDAabLhjXwhXQTZlts6jIvdqCP97/Uk5IGsTNY8fz8xFKGn0VXGeBoDb
   1oR0sHfpZBUuyLqTgbokQUODK4urvvkY3UK958R7y5+CAntBu7Tv01VvM
   105bAhzIT4fqIgmNbpHgx6jivLrL+VZnUA1DLyXWIT96Q+YiUz3bddXyh
   4=;
Authentication-Results: esa1.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: NUn7xP5vaEHCHEuzC1Lri1OKGDkM8lhZnD4/mLdk2tX6xyZ209wrYe7HHaxwarl/3GjKpKjFuw
 9s2QD+z2aCJlWvQc8d5qAge7/RN4f+JtSh7oQBaNYB3ApEFym0PuWoEmSseN2QlnMkM8iqL1U+
 u4fxEuC4TmeqEwCpcbEI9RhMG7V0xxn+CCpWZovOJmUlhRR1lvsnTJF0OeE49EHaiPc+FTHRc9
 Xzu12vswMLzNXr8hExOpA5jevkT42HrED9tUmlKkwgEUoectwWAuuhdB1kGqcherNxeQ0/6ziR
 ToJaT8EYkM23HooNf0BPBumn
X-SBRS: 5.1
X-MesageID: 55497142
X-Ironport-Server: esa1.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
IronPort-Data: A9a23:/k5eRK81Np5XJ9CHsPWUDrUDTniTJUtcMsCJ2f8bNWPcYEJGY0x3x
 mUdWmHXOaqJazH8eoh/PIrj/EsBucKAytFgTVRp/Cs8E34SpcT7XtnIdU2Y0wF+jyHgoOCLy
 +1EN7Es+ehtFie0Si9AttENlFEkvU2ybuOU5NXsZ2YhGGeIdA970Ug6wrZg2dYz6TSEK1jlV
 e3a8pW31GCNg1aYAkpMg05UgEoy1BhakGpwUm0WPZinjneH/5UmJMt3yZWKB2n5WuFp8tuSH
 I4v+l0bElTxpH/BAvv9+lryn9ZjrrT6ZWBigVIOM0Sub4QrSoXfHc/XOdJFAXq7hQllkPht5
 tlgicfzZTsHO6fzpcoEdTUCQiFxaPguFL/veRBTsOSWxkzCNXDt3+9vHAc9OohwFuRfWD8Us
 6ZCcXZUM07F17neLLGTE4GAguwBJc/meqYWvnhkxDfUJf0nXYrCU+PB4towMDIY250STKmHO
 5BxhTxHVkvqTxd1HlwrDo8EmcCKg0jmbjR7kQfAzUYwyzeKl1EguFT3C/Lkc86HQ4N6nk+eo
 GvD1238DlcRM9n34TCf83Chne+JhiL9V4I6Hbi0sPVthTW71jxNIB4bT122pb++kEHWc9ZCN
 0s8+Sc0q6U2skuxQbHVWxy+vW7BvRMGXddUO/M15RvLyafO5QudQG8eQVZpc8Avvss7bSIl2
 0XPnN7zAzFr9rqPRhq17L6F6zOvMC4aBWYHaWkPSg5ty9ripccrjhPLStd7C4a8i9GzEjb1q
 xiKtCEWlaQPitRN3KK+lXjfni2hoLDJXwEy4EPcWAqN8gx9dKahZoq19ULc6/dQaoqUJnGLp
 FANn8mT6rBIAZzlvDeASeMPF5mm4PGKNDCaillqd7E5+iig4WyLfIZe+jhyKU5ldMEedlfBZ
 U7VtgR5/pJfPHK2K6RwZuqZE84ty7rhE9XNTP3YbtNSJJN2cWe6EDpGPBDKmTq3yQ51zP95a
 czznduQ4WgyFYpr4QbtBMsh/7oh+R0Q3EX/H8H7wEHyuVaBX0K9RbAAOVqIS+k26qKYvQnYm
 +pi29u2JwZ3C7KmPHGGmWIHBRVTdyJjXMGpwyBCXrfbelIOJY03NxPGLVrNkaRelKNJivyAw
 Hi5XkJJoLYUrSyacVvUApyPhbWGYHqekZ7ZFXByVbpL8yJ6CWpK0Ev5X8BoFVXA3LYypcOYt
 9FfJ6297g1nE1wrAQg1Y5jnt5BFfx+2nw+INCfNSGFhJMI4GVCTooW4JVeHGMwy4syf7pRWT
 1qIjFKzfHb+b146UJa+hAyHnjtdQkTxaMotBhCVc7G/iW3n8ZRwKjyZsxPEC5pkFPk3/RPDj
 1z+KU5B/YHl+tZpmPGU1fHsh9r4SINWQxsFd1Q3GJ7rbEE2CEL4mtQeOAtJFBiAPF7JFFKKP
 L0Pka6naqFbxT6nceNUSt5W8E733PO3z5cy8+iuNC+jg42DBuwyL3+Y89NIs6ERlLZVtRHvA
 hCE+8VAOKXPM8TgSQZDKA0gZ+WF9PcVhjiNsqhlfBSkvHd6rOidTEFfHxiQkygBfrF7B5won
 LU6s8kM5g3h1hdzaoSajjpZ/ninJ2AbV/l1rYkTBYLm01J5ylxLbZHGJDXx5ZWDN4dFPkUwe
 2fGj6venbVMgEHFdiNrR3TK2ONcg7UIuQxLkwBedwjYxIKdi6ZujhNL8DkxQgBE9Tl90rp+a
 jpxKkl4BaSS5DM01sJNaH+hRlNaDxqD902vl1ZQzD/FT1OlX3DmJXEmPbrf51gQ9m9Rc2QJ/
 Lycz2q5Az/mcNuog3k3UE9h7ffiUcZw5kvJn8X+R5aJGJwzYDzEhK6yZDVX90u7UJ1p3ECX9
 /N3+OtQaLHgMX9CqqI2PICWyLAMRU3WP2dFW/xgoPsEEGy0lOteAtRSx5Rdov9wGsE=
IronPort-HdrOrdr: A9a23:wFY4WqgZqxPZDjVOGzSJcbRRcnBQXswji2hC6mlwRA09TySZ//
 rBoB17726StN9/YhEdcLy7VJVoIkmskaKdg7NhXotKNTOO0ADDQb2KhbGSpgEIcBeeygcy78
 hdmtBFeb/NMWQ=
X-IronPort-AV: E=Sophos;i="5.85,371,1624334400"; 
   d="scan'208";a="55497142"
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
Subject: [PATCH v2] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Date:   Wed, 13 Oct 2021 15:22:30 +0100
Message-ID: <20211013142230.10129-1-jane.malalane@citrix.com>
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

v2:
 * Deliberately not  __init.  early_init_*() not __init functions
 * Fixed whitespace error flagged by scripts/checkpatch.pl
---
 arch/x86/kernel/cpu/amd.c    | 22 ++++++++++++++++++++++
 arch/x86/kernel/cpu/common.c |  8 +++-----
 arch/x86/kernel/cpu/cpu.h    |  1 +
 arch/x86/kernel/cpu/hygon.c  | 22 ++++++++++++++++++++++
 4 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 2131af9f2fa2..1abfb0ae1f74 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -625,6 +625,7 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 {
 	u64 value;
 	u32 dummy;
+	bool nscb = false;
 
 	early_init_amd_mc(c);
 
@@ -650,6 +651,27 @@ static void early_init_amd(struct cpuinfo_x86 *c)
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
+	if (c->extended_cpuid_level >= 0x80000021 && cpuid_eax(0x80000021) & BIT(6))
+		nscb = true;
+
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) && !nscb && c->x86 == 0x17)
+		nscb = check_null_seg_clears_base(c);
+
+	if (!nscb)
+		set_cpu_bug(c, X86_BUG_NULL_SEG);
+
 #ifdef CONFIG_X86_64
 	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
 #else
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0f8885949e8c..2ca4afb97247 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1395,7 +1395,7 @@ void __init early_cpu_init(void)
 	early_identify_cpu(&boot_cpu_data);
 }
 
-static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
+bool check_null_seg_clears_base(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_64
 	/*
@@ -1418,10 +1418,10 @@ static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
 	wrmsrl(MSR_FS_BASE, 1);
 	loadsegment(fs, 0);
 	rdmsrl(MSR_FS_BASE, tmp);
-	if (tmp != 0)
-		set_cpu_bug(c, X86_BUG_NULL_SEG);
 	wrmsrl(MSR_FS_BASE, old_base);
+	return tmp == 0;
 #endif
+	return true;
 }
 
 static void generic_identify(struct cpuinfo_x86 *c)
@@ -1457,8 +1457,6 @@ static void generic_identify(struct cpuinfo_x86 *c)
 
 	get_model_name(c); /* Default name */
 
-	detect_null_seg_behavior(c);
-
 	/*
 	 * ESPFIX is a strange bug.  All real CPUs have it.  Paravirt
 	 * systems that run Linux at CPL > 0 may or may not have the
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 95521302630d..ad88bce508fa 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -75,6 +75,7 @@ extern int detect_extended_topology_early(struct cpuinfo_x86 *c);
 extern int detect_extended_topology(struct cpuinfo_x86 *c);
 extern int detect_ht_early(struct cpuinfo_x86 *c);
 extern void detect_ht(struct cpuinfo_x86 *c);
+extern bool check_null_seg_clears_base(struct cpuinfo_x86 *c);
 
 unsigned int aperfmperf_get_khz(int cpu);
 
diff --git a/arch/x86/kernel/cpu/hygon.c b/arch/x86/kernel/cpu/hygon.c
index 6d50136f7ab9..49bdb55efe52 100644
--- a/arch/x86/kernel/cpu/hygon.c
+++ b/arch/x86/kernel/cpu/hygon.c
@@ -240,6 +240,7 @@ static void bsp_init_hygon(struct cpuinfo_x86 *c)
 static void early_init_hygon(struct cpuinfo_x86 *c)
 {
 	u32 dummy;
+	bool nscb = false;
 
 	early_init_hygon_mc(c);
 
@@ -264,6 +265,27 @@ static void early_init_hygon(struct cpuinfo_x86 *c)
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
+	if (c->extended_cpuid_level >= 0x80000021 && cpuid_eax(0x80000021) & BIT(6))
+		nscb = true;
+
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) && !nscb && c->x86 == 0x18)
+		nscb = check_null_seg_clears_base(c);
+
+	if (!nscb)
+		set_cpu_bug(c, X86_BUG_NULL_SEG);
+
 #ifdef CONFIG_X86_64
 	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
 #endif
-- 
2.11.0

