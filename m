Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10A9214F75C
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 10:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgBAJaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 04:30:09 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33996 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgBAJaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Feb 2020 04:30:08 -0500
Received: by mail-wm1-f68.google.com with SMTP id s144so10518293wme.1
        for <stable@vger.kernel.org>; Sat, 01 Feb 2020 01:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=r7NfiI/MdGurvRL+JjrVISYMNgtGcHXBbEDbLewASac=;
        b=jKg9TFZs+NL4usLk6CtTddl8IZ+JQtJH44hWGp3m6tBzIpTYuZIIBOgeaQC0vxw/9/
         irQDHKvlMW3AQKceYo37Esm5rxqaGYfwr3FMoIRUa06I3BLQTDumPJbsAE/NQmTe3+m1
         qrpt3NDGr7vR6vD5W1ieyF044BsmXvgtZU8+i0w1InahPvcHV9gDqZ/I61gY7MxVZoMP
         efAaMI+I3rQDJTCAqIPdWJkUaxUThqX9wG0UE5dti9+5mRZ8dGg4X2OmQmZPPemW6aKd
         PsI0C/zTFzfmjwonWm5PImOEsvzIj7s+gCJkzagji4wc1HXRYwo1DlvJfwzEJO2GLNAP
         Lyhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=r7NfiI/MdGurvRL+JjrVISYMNgtGcHXBbEDbLewASac=;
        b=JQzHJtqt8k0xUKPczsMez4tJWrOlS2dsyqTElbBiJhtx/POzM2TgEQWRsvz9uIMRSI
         Kvh6xmKnJPRpWgIvBAXNbqKynrGZEmd7YSIkYE/EHEw693WTO9bpYfVOIzinz0EhKaYv
         gsBW/VHd+NqmRalB//eQJCts/PPYZtKnQHzUeWhhlVOnejuXQr2fo5NkjzOq4IxCMzaP
         cCGtaAtXXSBcJiGsYwpCZQfJhIb5CudWekNoEPd3jzQb9gPnfqaO84Mlrq8UlfWCJui3
         SFgXPY/kdsSWrUEJ6PyDwGEE084LtyQvHncM4uysEkPVgV88urpvf52+qvMoIgi15lmk
         U2Wg==
X-Gm-Message-State: APjAAAUKSa9q7fVnaBhenh4SP2zMepwRimLEBEXO2DLYHyQV0LDOGpGZ
        CKu0GE9uhynQu3d8m/tS+l+XRZ+y
X-Google-Smtp-Source: APXvYqxBCZR5vvQzSq+rvv0+qhSQjeyttKG+py4iz0hehJqGwid9pJx5UjW62NNJDR6DDNBand/aVA==
X-Received: by 2002:a1c:4d08:: with SMTP id o8mr17820734wmh.86.1580549404130;
        Sat, 01 Feb 2020 01:30:04 -0800 (PST)
Received: from gmail.com (54033286.catv.pool.telekom.hu. [84.3.50.134])
        by smtp.gmail.com with ESMTPSA id q14sm15803969wrj.81.2020.02.01.01.30.03
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 01:30:03 -0800 (PST)
Date:   Sat, 1 Feb 2020 10:30:01 +0100
From:   Ingo Molnar <mingo@kernel.org>
To:     stable kernel team <stable@vger.kernel.org>
Subject: [tip-bot2@linutronix.de: [tip: x86/urgent] x86/timer: Don't skip PIT
 setup when APIC is disabled or in legacy mode]
Message-ID: <20200201093001.GB71555@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


hi Greg,

Wondering whether you could include 979923871f69a4 in -stable once it 
hits upstream - we forgot to tag it. Or should I track it myself and 
notify you once that happens?

Thanks,

	Ingo

----- Forwarded message from tip-bot2 for Thomas Gleixner <tip-bot2@linutronix.de> -----

Date: Fri, 31 Jan 2020 12:28:12 -0000
From: tip-bot2 for Thomas Gleixner <tip-bot2@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Cc: Anthony Buckley <tony.buckley000@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Daniel Drake <drake@endlessm.com>, x86 <x86@kernel.org>, LKML
	<linux-kernel@vger.kernel.org>
Subject: [tip: x86/urgent] x86/timer: Don't skip PIT setup when APIC is disabled or in legacy mode

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     979923871f69a4dc926658f9f9a1a4c1bde57552
Gitweb:        https://git.kernel.org/tip/979923871f69a4dc926658f9f9a1a4c1bde57552
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 23 Jan 2020 12:54:53 +01:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Wed, 29 Jan 2020 12:50:12 +01:00

x86/timer: Don't skip PIT setup when APIC is disabled or in legacy mode

Tony reported a boot regression caused by the recent workaround for systems
which have a disabled (clock gate off) PIT.

On his machine the kernel fails to initialize the PIT because
apic_needs_pit() does not take into account whether the local APIC
interrupt delivery mode will actually allow to setup and use the local
APIC timer. This should be easy to reproduce with acpi=off on the
command line which also disables HPET.

Due to the way the PIT/HPET and APIC setup ordering works (APIC setup can
require working PIT/HPET) the information is not available at the point
where apic_needs_pit() makes this decision.

To address this, split out the interrupt mode selection from
apic_intr_mode_init(), invoke the selection before making the decision
whether PIT is required or not, and add the missing checks into
apic_needs_pit().

Fixes: c8c4076723da ("x86/timer: Skip PIT initialization on modern chipsets")
Reported-by: Anthony Buckley <tony.buckley000@gmail.com>
Tested-by: Anthony Buckley <tony.buckley000@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Daniel Drake <drake@endlessm.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206125
Link: https://lore.kernel.org/r/87sgk6tmk2.fsf@nanos.tec.linutronix.de
---
 arch/x86/include/asm/apic.h     |  2 ++
 arch/x86/include/asm/x86_init.h |  2 ++
 arch/x86/kernel/apic/apic.c     | 23 ++++++++++++++++++-----
 arch/x86/kernel/time.c          | 12 ++++++++++--
 arch/x86/kernel/x86_init.c      |  1 +
 arch/x86/xen/enlighten_pv.c     |  1 +
 6 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 2ebc17d..be0b9cf 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -140,6 +140,7 @@ extern void apic_soft_disable(void);
 extern void lapic_shutdown(void);
 extern void sync_Arb_IDs(void);
 extern void init_bsp_APIC(void);
+extern void apic_intr_mode_select(void);
 extern void apic_intr_mode_init(void);
 extern void init_apic_mappings(void);
 void register_lapic_address(unsigned long address);
@@ -188,6 +189,7 @@ static inline void disable_local_APIC(void) { }
 # define setup_secondary_APIC_clock x86_init_noop
 static inline void lapic_update_tsc_freq(void) { }
 static inline void init_bsp_APIC(void) { }
+static inline void apic_intr_mode_select(void) { }
 static inline void apic_intr_mode_init(void) { }
 static inline void lapic_assign_system_vectors(void) { }
 static inline void lapic_assign_legacy_vector(unsigned int i, bool r) { }
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 1943585..96d9cd2 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -51,12 +51,14 @@ struct x86_init_resources {
  *				are set up.
  * @intr_init:			interrupt init code
  * @trap_init:			platform specific trap setup
+ * @intr_mode_select:		interrupt delivery mode selection
  * @intr_mode_init:		interrupt delivery mode setup
  */
 struct x86_init_irqs {
 	void (*pre_vector_init)(void);
 	void (*intr_init)(void);
 	void (*trap_init)(void);
+	void (*intr_mode_select)(void);
 	void (*intr_mode_init)(void);
 };
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 28446fa..4b0f911 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -830,8 +830,17 @@ bool __init apic_needs_pit(void)
 	if (!tsc_khz || !cpu_khz)
 		return true;
 
-	/* Is there an APIC at all? */
-	if (!boot_cpu_has(X86_FEATURE_APIC))
+	/* Is there an APIC at all or is it disabled? */
+	if (!boot_cpu_has(X86_FEATURE_APIC) || disable_apic)
+		return true;
+
+	/*
+	 * If interrupt delivery mode is legacy PIC or virtual wire without
+	 * configuration, the local APIC timer wont be set up. Make sure
+	 * that the PIT is initialized.
+	 */
+	if (apic_intr_mode == APIC_PIC ||
+	    apic_intr_mode == APIC_VIRTUAL_WIRE_NO_CONFIG)
 		return true;
 
 	/* Virt guests may lack ARAT, but still have DEADLINE */
@@ -1322,7 +1331,7 @@ void __init sync_Arb_IDs(void)
 
 enum apic_intr_mode_id apic_intr_mode __ro_after_init;
 
-static int __init apic_intr_mode_select(void)
+static int __init __apic_intr_mode_select(void)
 {
 	/* Check kernel option */
 	if (disable_apic) {
@@ -1384,6 +1393,12 @@ static int __init apic_intr_mode_select(void)
 	return APIC_SYMMETRIC_IO;
 }
 
+/* Select the interrupt delivery mode for the BSP */
+void __init apic_intr_mode_select(void)
+{
+	apic_intr_mode = __apic_intr_mode_select();
+}
+
 /*
  * An initial setup of the virtual wire mode.
  */
@@ -1440,8 +1455,6 @@ void __init apic_intr_mode_init(void)
 {
 	bool upmode = IS_ENABLED(CONFIG_UP_LATE_INIT);
 
-	apic_intr_mode = apic_intr_mode_select();
-
 	switch (apic_intr_mode) {
 	case APIC_PIC:
 		pr_info("APIC: Keep in PIC mode(8259)\n");
diff --git a/arch/x86/kernel/time.c b/arch/x86/kernel/time.c
index 7ce29ce..d8673d8 100644
--- a/arch/x86/kernel/time.c
+++ b/arch/x86/kernel/time.c
@@ -91,10 +91,18 @@ void __init hpet_time_init(void)
 
 static __init void x86_late_time_init(void)
 {
+	/*
+	 * Before PIT/HPET init, select the interrupt mode. This is required
+	 * to make the decision whether PIT should be initialized correct.
+	 */
+	x86_init.irqs.intr_mode_select();
+
+	/* Setup the legacy timers */
 	x86_init.timers.timer_init();
+
 	/*
-	 * After PIT/HPET timers init, select and setup
-	 * the final interrupt mode for delivering IRQs.
+	 * After PIT/HPET timers init, set up the final interrupt mode for
+	 * delivering IRQs.
 	 */
 	x86_init.irqs.intr_mode_init();
 	tsc_init();
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index ce89430..9a89261 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -80,6 +80,7 @@ struct x86_init_ops x86_init __initdata = {
 		.pre_vector_init	= init_ISA_irqs,
 		.intr_init		= native_init_IRQ,
 		.trap_init		= x86_init_noop,
+		.intr_mode_select	= apic_intr_mode_select,
 		.intr_mode_init		= apic_intr_mode_init
 	},
 
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index ae4a41c..1f756ff 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1205,6 +1205,7 @@ asmlinkage __visible void __init xen_start_kernel(void)
 	x86_platform.get_nmi_reason = xen_get_nmi_reason;
 
 	x86_init.resources.memory_setup = xen_memory_setup;
+	x86_init.irqs.intr_mode_select	= x86_init_noop;
 	x86_init.irqs.intr_mode_init	= x86_init_noop;
 	x86_init.oem.arch_setup = xen_arch_setup;
 	x86_init.oem.banner = xen_banner;

----- End forwarded message -----
