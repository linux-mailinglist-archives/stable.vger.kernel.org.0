Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350D663D59D
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 13:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbiK3Mas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 07:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbiK3Mas (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 07:30:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29FE450A0
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 04:30:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93C8AB81B30
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 12:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EB8C433C1;
        Wed, 30 Nov 2022 12:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669811444;
        bh=Gf/4vj8pLrsgZILB5J/Y9Jn8ElbtuGxLmsB7lLb3MLw=;
        h=Subject:To:Cc:From:Date:From;
        b=QiFnm8dawAZiet0mdFfpYAYvlSOEcUuujK6kQ09wDQU6CJtDN6xkc0QCYuAl875d0
         ssmfWXRs2n75BbbZE6g0o1ZwD2obe3IbpnVZ1O6l9aXi0BNq6Mtby0juJjZvDCU9zb
         rYQPnUfGxwT2J03u0flqxqBcsNXjHF040u3KvlQo=
Subject: FAILED: patch "[PATCH] x86/pm: Add enumeration check before spec MSRs save/restore" failed to apply to 4.9-stable tree
To:     pawan.kumar.gupta@linux.intel.com, bp@suse.de,
        dave.hansen@linux.intel.com, hdegoede@redhat.com,
        rafael.j.wysocki@intel.com, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 30 Nov 2022 13:30:41 +0100
Message-ID: <16698114414161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

50bcceb7724e ("x86/pm: Add enumeration check before spec MSRs save/restore setup")
2632daebafd0 ("x86/cpu: Restore AMD's DE_CFG MSR after resume")
e2a1256b17b1 ("x86/speculation: Restore speculation related MSRs during S3 resume")
46a010dd6896 ("kVM SVM: Move SVM related files to own sub-directory")
444e2ff34df8 ("tools arch x86: Grab a copy of the file containing the MSR numbers")
87a682a7c4e7 ("perf build: Ignore intentional differences for the x86 insn decoder")
00a263902ac3 ("perf intel-pt: Use shared x86 insn decoder")
f1da0a6c1365 ("perf intel-pt: Remove inat.c from build dependency list")
8520a98dbab6 ("perf debug: Remove needless include directives from debug.h")
0ac25fd0a04d ("perf tools: Remove perf.h from source files not needing it")
c1a604dff486 ("perf tools: Remove needless perf.h include directive from headers")
91854f9a077e ("perf tools: Move everything related to sys_perf_event_open() to perf-sys.h")
0ac1dd5b4a70 ("perf timechart: Refactor svg_build_topology_map()")
2da39f1cc36b ("perf evlist: Remove needless util.h from evlist.h")
efa73d37c11a ("perf tools: Remove needless util.h include from builtin.h")
185bcb92c80e ("perf sort: Remove needless headers from sort.h, provide fwd struct decls")
97b9d866a66c ("perf srcline: Add missing srcline.h header to files needing its defs")
125009026bfc ("perf cacheline: Move cacheline related routines to separate files")
aeb00b1aeab6 ("perf record: Move record_opts and other record decls out of perf.h")
8db5957bc736 ("Merge tag 'v5.3-rc6' into perf/core, to pick up fixes")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 50bcceb7724e471d9b591803889df45dcbb584bc Mon Sep 17 00:00:00 2001
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Date: Tue, 15 Nov 2022 11:17:06 -0800
Subject: [PATCH] x86/pm: Add enumeration check before spec MSRs save/restore
 setup

pm_save_spec_msr() keeps a list of all the MSRs which _might_ need
to be saved and restored at hibernate and resume. However, it has
zero awareness of CPU support for these MSRs. It mostly works by
unconditionally attempting to manipulate these MSRs and relying on
rdmsrl_safe() being able to handle a #GP on CPUs where the support is
unavailable.

However, it's possible for reads (RDMSR) to be supported for a given MSR
while writes (WRMSR) are not. In this case, msr_build_context() sees
a successful read (RDMSR) and marks the MSR as valid. Then, later, a
write (WRMSR) fails, producing a nasty (but harmless) error message.
This causes restore_processor_state() to try and restore it, but writing
this MSR is not allowed on the Intel Atom N2600 leading to:

  unchecked MSR access error: WRMSR to 0x122 (tried to write 0x0000000000000002) \
     at rIP: 0xffffffff8b07a574 (native_write_msr+0x4/0x20)
  Call Trace:
   <TASK>
   restore_processor_state
   x86_acpi_suspend_lowlevel
   acpi_suspend_enter
   suspend_devices_and_enter
   pm_suspend.cold
   state_store
   kernfs_fop_write_iter
   vfs_write
   ksys_write
   do_syscall_64
   ? do_syscall_64
   ? up_read
   ? lock_is_held_type
   ? asm_exc_page_fault
   ? lockdep_hardirqs_on
   entry_SYSCALL_64_after_hwframe

To fix this, add the corresponding X86_FEATURE bit for each MSR.  Avoid
trying to manipulate the MSR when the feature bit is clear. This
required adding a X86_FEATURE bit for MSRs that do not have one already,
but it's a small price to pay.

  [ bp: Move struct msr_enumeration inside the only function that uses it. ]

Fixes: 73924ec4d560 ("x86/pm: Save the MSR validity status at context setup")
Reported-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/c24db75d69df6e66c0465e13676ad3f2837a2ed8.1668539735.git.pawan.kumar.gupta@linux.intel.com

diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 4cd39f304e20..93ae33248f42 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -513,16 +513,23 @@ static int pm_cpu_check(const struct x86_cpu_id *c)
 
 static void pm_save_spec_msr(void)
 {
-	u32 spec_msr_id[] = {
-		MSR_IA32_SPEC_CTRL,
-		MSR_IA32_TSX_CTRL,
-		MSR_TSX_FORCE_ABORT,
-		MSR_IA32_MCU_OPT_CTRL,
-		MSR_AMD64_LS_CFG,
-		MSR_AMD64_DE_CFG,
+	struct msr_enumeration {
+		u32 msr_no;
+		u32 feature;
+	} msr_enum[] = {
+		{ MSR_IA32_SPEC_CTRL,	 X86_FEATURE_MSR_SPEC_CTRL },
+		{ MSR_IA32_TSX_CTRL,	 X86_FEATURE_MSR_TSX_CTRL },
+		{ MSR_TSX_FORCE_ABORT,	 X86_FEATURE_TSX_FORCE_ABORT },
+		{ MSR_IA32_MCU_OPT_CTRL, X86_FEATURE_SRBDS_CTRL },
+		{ MSR_AMD64_LS_CFG,	 X86_FEATURE_LS_CFG_SSBD },
+		{ MSR_AMD64_DE_CFG,	 X86_FEATURE_LFENCE_RDTSC },
 	};
+	int i;
 
-	msr_build_context(spec_msr_id, ARRAY_SIZE(spec_msr_id));
+	for (i = 0; i < ARRAY_SIZE(msr_enum); i++) {
+		if (boot_cpu_has(msr_enum[i].feature))
+			msr_build_context(&msr_enum[i].msr_no, 1);
+	}
 }
 
 static int pm_check_save_msr(void)

