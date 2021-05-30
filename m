Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF254395079
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 12:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhE3Ks7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 06:48:59 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:35563 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229550AbhE3Ks7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 06:48:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 499201940181;
        Sun, 30 May 2021 06:47:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 30 May 2021 06:47:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IHkZgz
        k4PMl1deebbEfXIUZUrDYhzZOubGdwb5xBrTk=; b=irTyBSJWKrDATjJlOFkrgF
        9VtJSfKg7SsW7+AJVZuNBABOJ7AXSq6zuxDq2OXUN9iGlozcJe+dQAbHx064t9nM
        s2jhmTYm6dc5NGHkx9BHd0lhWDpIgnDB9ZwU1P5+YYiGVOGTClli6wFfNHd3v6Dn
        8W7NGn9LNQQdmUO2g94xVfhX1DTTuqYi/or4xYQaQ7EBdBavUZcIOCEHVXjoTxVg
        nswzfx60Ko6ucncB97NE6T9EGCKb+zWlYzOK6Hzml1kT3eDPqhdebrSkSrjIYADQ
        YFlEnt49dXVvuOpQ0JpCd7uILw5XnJRr+jgwoySx04Uqvk3qs80vHYVYilXI30Sw
        ==
X-ME-Sender: <xms:OW2zYL-BH0sADMOsjvI_uLzaqHO_xMCzyzg0chfymFaDNAGPTjUpfw>
    <xme:OW2zYHv0BdHixhzS8dd_2bLaPKPmzt8-0-OAQ1f7dlcVQ3baeYSTO3uf2ee88eflD
    ldvBGCY-oSthw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:OW2zYJDy81tPZd4gWHkJ6f6DH3extW-Ycmgws6L6uBZc9IJMRvxaCA>
    <xmx:OW2zYHcTbxTXE-HWvofQYFxicIyIvxPTcku2G4hN5S9mcR8NP_qEMQ>
    <xmx:OW2zYAP4v95cziXOCgXKQUO2nLp9sj8wRdGRAcOEyPy2HcjG2NlvRQ>
    <xmx:OW2zYKXRNgXYhfHPZ8Bg1zqPsQw8HTaoRADhjX1LHoUNUOtF5Ph7Fg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 06:47:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Fix debug register indexing" failed to apply to 5.10-stable tree
To:     maz@kernel.org, ricarkol@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 12:47:09 +0200
Message-ID: <162237162910458@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cb853ded1d25e5b026ce115dbcde69e3d7e2e831 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Fri, 14 May 2021 09:05:41 +0100
Subject: [PATCH] KVM: arm64: Fix debug register indexing

Commit 03fdfb2690099 ("KVM: arm64: Don't write junk to sysregs on
reset") flipped the register number to 0 for all the debug registers
in the sysreg table, hereby indicating that these registers live
in a separate shadow structure.

However, the author of this patch failed to realise that all the
accessors are using that particular index instead of the register
encoding, resulting in all the registers hitting index 0. Not quite
a valid implementation of the architecture...

Address the issue by fixing all the accessors to use the CRm field
of the encoding, which contains the debug register index.

Fixes: 03fdfb2690099 ("KVM: arm64: Don't write junk to sysregs on reset")
Reported-by: Ricardo Koller <ricarkol@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 76ea2800c33e..1a7968ad078c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -399,14 +399,14 @@ static bool trap_bvr(struct kvm_vcpu *vcpu,
 		     struct sys_reg_params *p,
 		     const struct sys_reg_desc *rd)
 {
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
 
 	if (p->is_write)
 		reg_to_dbg(vcpu, p, rd, dbg_reg);
 	else
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
-	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
+	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
 
 	return true;
 }
@@ -414,7 +414,7 @@ static bool trap_bvr(struct kvm_vcpu *vcpu,
 static int set_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -424,7 +424,7 @@ static int set_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -434,21 +434,21 @@ static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static void reset_bvr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
-	vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg] = rd->val;
+	vcpu->arch.vcpu_debug_state.dbg_bvr[rd->CRm] = rd->val;
 }
 
 static bool trap_bcr(struct kvm_vcpu *vcpu,
 		     struct sys_reg_params *p,
 		     const struct sys_reg_desc *rd)
 {
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
+	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
 
 	if (p->is_write)
 		reg_to_dbg(vcpu, p, rd, dbg_reg);
 	else
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
-	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
+	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
 
 	return true;
 }
@@ -456,7 +456,7 @@ static bool trap_bcr(struct kvm_vcpu *vcpu,
 static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -467,7 +467,7 @@ static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -477,22 +477,22 @@ static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static void reset_bcr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
-	vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg] = rd->val;
+	vcpu->arch.vcpu_debug_state.dbg_bcr[rd->CRm] = rd->val;
 }
 
 static bool trap_wvr(struct kvm_vcpu *vcpu,
 		     struct sys_reg_params *p,
 		     const struct sys_reg_desc *rd)
 {
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
+	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
 
 	if (p->is_write)
 		reg_to_dbg(vcpu, p, rd, dbg_reg);
 	else
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
-	trace_trap_reg(__func__, rd->reg, p->is_write,
-		vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg]);
+	trace_trap_reg(__func__, rd->CRm, p->is_write,
+		vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm]);
 
 	return true;
 }
@@ -500,7 +500,7 @@ static bool trap_wvr(struct kvm_vcpu *vcpu,
 static int set_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -510,7 +510,7 @@ static int set_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -520,21 +520,21 @@ static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static void reset_wvr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
-	vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg] = rd->val;
+	vcpu->arch.vcpu_debug_state.dbg_wvr[rd->CRm] = rd->val;
 }
 
 static bool trap_wcr(struct kvm_vcpu *vcpu,
 		     struct sys_reg_params *p,
 		     const struct sys_reg_desc *rd)
 {
-	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
+	u64 *dbg_reg = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
 
 	if (p->is_write)
 		reg_to_dbg(vcpu, p, rd, dbg_reg);
 	else
 		dbg_to_reg(vcpu, p, rd, dbg_reg);
 
-	trace_trap_reg(__func__, rd->reg, p->is_write, *dbg_reg);
+	trace_trap_reg(__func__, rd->CRm, p->is_write, *dbg_reg);
 
 	return true;
 }
@@ -542,7 +542,7 @@ static bool trap_wcr(struct kvm_vcpu *vcpu,
 static int set_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
 
 	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -552,7 +552,7 @@ static int set_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
+	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm];
 
 	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
@@ -562,7 +562,7 @@ static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static void reset_wcr(struct kvm_vcpu *vcpu,
 		      const struct sys_reg_desc *rd)
 {
-	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg] = rd->val;
+	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->CRm] = rd->val;
 }
 
 static void reset_amair_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)

