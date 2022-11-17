Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9F562D689
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239888AbiKQJWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240020AbiKQJWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:22:04 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3217A697DA
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:00 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 186-20020a6301c3000000b0046fa202f720so954933pgb.20
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PfzQmsd9JQGxo5oXWXMgwE6A9kTIB2OQjpwiBwYjiFw=;
        b=m8tlRjylgELeuyD1YN7K7+0xoPgHu2XldfivTYLFXfKK21OFsjIwQm456TiOf3EzaH
         DkV905N2f/iVMZXg3fqinfG6Uf2QQa5BxcD6YLmKnehvHPl2Emj6Zzs/xhsr+TQLK/vx
         tB2LJFf+HU6nsQanFmHPv5G73uASmf9TZU1+bGSGr0aMrhUWJy4iWmGqjF48ANGOlLZE
         jDumn1i8eu+odnm4mBJFrAqRduin/t1k5hvzVFCFE1KIYPRFBBpBuSDfPcancoPjBN0T
         bwm6+23IWh5USgnlDdfaSZez1YCC6p+6SkhZ3kXvQUoH6KZRtrHeU3RyjjAnHAsQfnpR
         WdBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PfzQmsd9JQGxo5oXWXMgwE6A9kTIB2OQjpwiBwYjiFw=;
        b=THYv2wYAW8D414vo/JQiwmGz48DCcTWGGgz8tTAqlYpmUS9RtgdO6pvrDCUC4AK8mT
         fjKlx8tjBuWJxVWMyNjmQpw0aoEkOn/uBXc8KGur/QbjyMzigIa3Anmds/ddTnCMZPXp
         YXdYSEVwa4xp2LrLy3veK5UbHtlC1YQR1oqOsauD2FX1hw5Tmuqu9AlkP9SK+sU9QcNY
         0iGUK38jMzcab5f47h77bezusx88H9VqLJLYKeZ87xC2kPqah8u3irOD7qA0zMkCqbHH
         EmfFYiTsGXHSozXUmZODJu3oxEnV3kLbQYUcnd6ALJmIyoTaH7749Qz+7TxizcbhdbSa
         99cw==
X-Gm-Message-State: ANoB5pnwL0qRNjfkawFTLQc000dfV6aV2qBVbwUkPxIb/D4BNi0dZhxF
        0GHUTa8XON2/5qXjaumu+4dOsj/i6EypkKMcQ3ynehOUiPaOH9e0XKmwANQ+lGBipzFFmLTaJ1W
        xRFf7NxOwn3p8aSn+BNWZ+eACP8ZRTeUg/twgIA1NkOZ3VVFDHWDFBmAvFdRQU1d9La4=
X-Google-Smtp-Source: AA0mqf7pl/8zaGuaBeYRN2WlLflo7MnEIATI7g8ZHl97ItCLj+c8vR0YwEetO+P8Kj3f7gXFy0FmBdsrJGTZZw==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a17:902:ec01:b0:183:6f0e:3b3a with SMTP
 id l1-20020a170902ec0100b001836f0e3b3amr1784369pld.145.1668676919495; Thu, 17
 Nov 2022 01:21:59 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:43 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-26-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 25/34] KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit fc02735b14fff8c6678b521d324ade27b1a3d4cf upstream.

On eIBRS systems, the returns in the vmexit return path from
__vmx_vcpu_run() to vmx_vcpu_run() are exposed to RSB poisoning attacks.

Fix that by moving the post-vmexit spec_ctrl handling to immediately
after the vmexit.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[ bp: Adjust for the fact that vmexit is in inline assembly ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/nospec-branch.h |  3 +-
 arch/x86/kernel/cpu/bugs.c           |  4 +++
 arch/x86/kvm/vmx.c                   | 46 ++++++++++++++++++++++++----
 3 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index c990c3b2ada5..3e1d2389c00d 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -271,7 +271,7 @@ extern char __indirect_thunk_end[];
  * retpoline and IBRS mitigations for Spectre v2 need this; only on future
  * CPUs with IBRS_ALL *might* it be avoided.
  */
-static inline void vmexit_fill_RSB(void)
+static __always_inline void vmexit_fill_RSB(void)
 {
 #ifdef CONFIG_RETPOLINE
 	unsigned long loops;
@@ -306,6 +306,7 @@ static inline void indirect_branch_prediction_barrier(void)
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
+extern u64 x86_spec_ctrl_current;
 extern void write_spec_ctrl_current(u64 val, bool force);
 extern u64 spec_ctrl_current(void);
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 95d8b517cf4d..022b9f31333f 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -185,6 +185,10 @@ void __init check_bugs(void)
 #endif
 }
 
+/*
+ * NOTE: For VMX, this function is not called in the vmexit path.
+ * It uses vmx_spec_ctrl_restore_host() instead.
+ */
 void
 x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
 {
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 952a58cad25f..951cec231e7f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10760,10 +10760,31 @@ static void vmx_update_hv_timer(struct kvm_vcpu *vcpu)
 	vmx->loaded_vmcs->hv_timer_armed = false;
 }
 
+u64 __always_inline vmx_spec_ctrl_restore_host(struct vcpu_vmx *vmx)
+{
+	u64 guestval, hostval = this_cpu_read(x86_spec_ctrl_current);
+
+	if (!cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL))
+		return 0;
+
+	guestval = __rdmsr(MSR_IA32_SPEC_CTRL);
+
+	/*
+	 * If the guest/host SPEC_CTRL values differ, restore the host value.
+	 */
+	if (guestval != hostval)
+		native_wrmsrl(MSR_IA32_SPEC_CTRL, hostval);
+
+	barrier_nospec();
+
+	return guestval;
+}
+
 static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4, evmcs_rsp;
+	u64 spec_ctrl;
 
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
@@ -10989,6 +11010,24 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 #endif
 	      );
 
+	/*
+	 * IMPORTANT: RSB filling and SPEC_CTRL handling must be done before
+	 * the first unbalanced RET after vmexit!
+	 *
+	 * For retpoline, RSB filling is needed to prevent poisoned RSB entries
+	 * and (in some cases) RSB underflow.
+	 *
+	 * eIBRS has its own protection against poisoned RSB, so it doesn't
+	 * need the RSB filling sequence.  But it does need to be enabled
+	 * before the first unbalanced RET.
+	 *
+	 * So no RETs before vmx_spec_ctrl_restore_host() below.
+	 */
+	vmexit_fill_RSB();
+
+	/* Save this for below */
+	spec_ctrl = vmx_spec_ctrl_restore_host(vmx);
+
 	vmx_enable_fb_clear(vmx);
 
 	/*
@@ -11007,12 +11046,7 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 * save it.
 	 */
 	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
-		vmx->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
-
-	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
-
-	/* Eliminate branch target predictions from guest mode */
-	vmexit_fill_RSB();
+		vmx->spec_ctrl = spec_ctrl;
 
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs))
-- 
2.38.1.431.g37b22c650d-goog

