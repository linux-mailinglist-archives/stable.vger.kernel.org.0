Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB994509A7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 17:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhKOQeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 11:34:07 -0500
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:43947 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhKOQdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 11:33:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1636993853;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=znT3eu+X4j1qiwRmwQ6Ik3mx+G/++de1zkJpHLdYsmo=;
  b=U02GA7YywG6sRQi5gcApYkV8p/mLTyJhIjTiTOK/M+9wUIDPxEJwcpo2
   qgZ4J27qpSU+A+8FcqaV8RFkAtQ5olksZwXqVMy3KbETXRHz3rsrU7buZ
   xVle1lf32g73dlRQbRCDk8uJNHiu9YxZeqCF81mRP2qXTf5OXMoLW3PxO
   Y=;
Authentication-Results: esa4.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: MFaf394VHxfZu779/EjTc28kzJk3alao24nRo5lpLCtDOADYVbvg17R95H34v2UkaCdWYqPWXU
 BUN1yBfFbSkaJ6Ym0Tr4o1+o2CJcAjVLXqGBszTh/8g+jb8OySJuZvVNsg3bRzxF7Pmfwo5vQf
 oFgBNBgDR/WYE+GkwiUlIRbxaefc0QqEBA9wn8/O4xgcyoQ0BasXSXHpc/qUeEKtkHejWq+tbR
 VnaNM6jM8IdI8EFqB0STm7N9V7/Mc8XtuFr9nJEnHTgFSLHM4QauUmq+sJSDFMj7n5yLa+egBz
 rfz4PGbzsHfXKkEOvc2Gir02
X-SBRS: 5.1
X-MesageID: 59825623
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.83
X-Policy: $RELAYED
IronPort-Data: A9a23:giDmnqN5gT7qVgbvrR1kkMFynXyQoLVcMsEvi/4bfWQNrUp00T1Vz
 mtLCm6GPKqPMDShctx0YIu09x9VuJXRyYQxTQto+SlhQUwRpJueD7x1DKtR0wB+jCHnZBg6h
 ynLQoCYdKjYdpJYz/uUGuCJQUNUjMlkfZKhTr6bUsxNbVU8En540Es+w7dRbrNA2rBVPSvc4
 bsenOWHULOV82Yc3rU8sv/rRLtH5ZweiRtA1rAMTakjUGz2zhH5OKk3N6CpR0YUd6EPdgKMq
 0Qv+5nilo/R109F5tpICd8XeGVSKlLZFVDmZna7x8FOK/WNz8A/+v9TCRYSVatYozOYm+1D+
 s5Ij5qLGBg4Iqnxnrw2dQYNRkmSPYUekFPGCX22sMjVxEzaaXr8hf5pCSnaP6VBpLwxWzsXs
 6VFdnZdNXhvhMrvqF6/YstlgMllCcDvNYcWvHxIxjDFF/c2B5vERs0m4PcFjWdq254URp4yY
 eIAZSpxfAqHcSFUGU0dDosQp8G5t0DWJmgwRFW9+vNsvjm7IBZK+KPxOdDRd/SUSshP2EWVv
 GTL+yL+GB5yHNiezyeVt3GhnOnCmQvlV48IUr617PhnhBuU3GN7IBcOfUCmuvT/hkPWZj5EA
 xVKoGx09/F0rRH1CImmN/GlnJKalhgNX+diIfY/0ge2m7XF/wKkADAvaCEUPbTKq/QKbTAt0
 1aImfbgCjpurKCZRBqhy1uEkd+hEXNLdDFfPEfoWSNAuoC++99r0nojW/46SPbt5uAZDw0c1
 NxjQMIWo7wIxfAG2Kyglbwsq2L9/8OZJuLZC+i+Y45E0u+bTNP9D2BLwQKChRqlEGp+ZgPe1
 EXoY+DEsIgz4WilzURhutklErCz/OqiOzbBm1NpFJRJ323zoCDyJNwOvW0geBsB3iM4ldnBO
 hW7VeR5vsA7AZdXRfUvP9LZ5zoCkMAM6ugJptiLN4ETM/CdhSeM/T10ZF744oweuBNErE3LA
 r/CKZzEJS9DUcxPlWPqL89Age5D7n1vngv7GMGkpylLJJLDPRZ5v59eawDQBg34hYvZyDjoH
 yF3a5HXlk4BCbKmOUE6M+c7dDg3EJTyPriuw+Q/SwJJClUO9LgJB6CDzLU/VZZimqgJxO7E8
 mvkAh1TyUblhG2BIgKPMygxZLTqVJd5jHQ6IS1zYgr4hyl9Od6ivPUFap86Xbg77+g/n/R6e
 OYIJpebCfNVRzWZpzlENcvhrJZvfQiAjB6VO3b3eyA2epNtHlSb+tLtcgb12jMJCy676Zk3r
 7G6j1uJSpsfXQVySs3Rbav3nV+2uHEcnsN0XlfJfYYPKBm9rtAyJnWo3PEtIswKJRHS/Reg1
 l6bUUUCuO3Ag44p692V16qKmJikTrllFU1AEmiFsbvvbXvG/nCuyJNrWfqTeWyPT3v9/aiva
 LkHz/z4N/Fbzl9Gv5AlTuRuxKM6odDuu6Vb3kJvG3CSNwanDbZpI3+n28hTt/ISmu8F6FXuA
 k/fqMNHPbipOd/+FA9DLQUoWe2PyPUIl2SA9v8yOkj7uHd68bfvvZ++5PVQZPix9IdIDb4=
IronPort-HdrOrdr: A9a23:0HKhMq5d1i5eBwOYlwPXwMDXdLJyesId70hD6qhwISY1TiX4rb
 HJoB11726WtN98Yh4dcLO7Sc69qBHnhPxICOAqVN/INmSLhILBFvAH0WKI+V3d8kPFmNK1rZ
 0QFpRDNA==
X-IronPort-AV: E=Sophos;i="5.87,236,1631592000"; 
   d="scan'208";a="59825623"
From:   Jane Malalane <jane.malalane@citrix.com>
To:     LKML <linux-kernel@vger.kernel.org>
CC:     <jane.malalane@citrix.com>, Borislav Petkov <bp@suse.de>,
        <stable@vger.kernel.org>
Subject: [PATCH for 4.19] x86/cpu: Fix migration safety with X86_BUG_NULL_SEL
Date:   Mon, 15 Nov 2021 16:30:20 +0000
Message-ID: <20211115163020.16672-1-jane.malalane@citrix.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 415de44076640483648d6c0f6d645a9ee61328ad upstream.

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

Zen3 adds the NullSelectorClearsBase CPUID bit to indicate that loading
a NULL segment selector zeroes the base and limit fields, as well as
just attributes. Zen2 also has this behaviour but doesn't have the NSCB
bit.

 [ bp: Minor touchups. ]

Signed-off-by: Jane Malalane <jane.malalane@citrix.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
CC: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20211021104744.24126-1-jane.malalane@citrix.com
---
Backport to 4.19.  Drop Hygon modifications.
---
 arch/x86/kernel/cpu/amd.c    |  2 ++
 arch/x86/kernel/cpu/common.c | 44 +++++++++++++++++++++++++++++++++++++-------
 arch/x86/kernel/cpu/cpu.h    |  1 +
 3 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index de69090ca142..98c23126f751 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -993,6 +993,8 @@ static void init_amd(struct cpuinfo_x86 *c)
 	if (cpu_has(c, X86_FEATURE_IRPERF) &&
 	    !cpu_has_amd_erratum(c, amd_erratum_1054))
 		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
+
+	check_null_seg_clears_base(c);
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2058e8c0e61d..7e7400af7797 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1254,9 +1254,8 @@ void __init early_cpu_init(void)
 	early_identify_cpu(&boot_cpu_data);
 }
 
-static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
+static bool detect_null_seg_behavior(void)
 {
-#ifdef CONFIG_X86_64
 	/*
 	 * Empirically, writing zero to a segment selector on AMD does
 	 * not clear the base, whereas writing zero to a segment
@@ -1277,10 +1276,43 @@ static void detect_null_seg_behavior(struct cpuinfo_x86 *c)
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
+	 * 0x18 is the respective family for Hygon.
+	 */
+	if ((c->x86 == 0x17 || c->x86 == 0x18) &&
+	    detect_null_seg_behavior())
+		return;
+
+	/* All the remaining ones are affected */
+	set_cpu_bug(c, X86_BUG_NULL_SEG);
 }
 
 static void generic_identify(struct cpuinfo_x86 *c)
@@ -1316,8 +1348,6 @@ static void generic_identify(struct cpuinfo_x86 *c)
 
 	get_model_name(c); /* Default name */
 
-	detect_null_seg_behavior(c);
-
 	/*
 	 * ESPFIX is a strange bug.  All real CPUs have it.  Paravirt
 	 * systems that run Linux at CPL > 0 may or may not have the
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index e89602d2aff5..4eb9bf68b122 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -76,6 +76,7 @@ extern int detect_extended_topology_early(struct cpuinfo_x86 *c);
 extern int detect_extended_topology(struct cpuinfo_x86 *c);
 extern int detect_ht_early(struct cpuinfo_x86 *c);
 extern void detect_ht(struct cpuinfo_x86 *c);
+extern void check_null_seg_clears_base(struct cpuinfo_x86 *c);
 
 unsigned int aperfmperf_get_khz(int cpu);
 
-- 
2.11.0

