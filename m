Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604BF37BAC7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhELKhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:37:52 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:48149 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhELKhw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:37:52 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 1741811ED;
        Wed, 12 May 2021 06:36:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 12 May 2021 06:36:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CEYtu9
        sRfDSM1hu7k4yClKTm6HhiJAGT5+xfMzjtvkw=; b=cy8MC9dfMDw2QZ/ejFnmg9
        p+Wiqytdsbon+4s9pZEYI8sbDJ4laVHUOinlX9EytoWXdrUlz+ks/9rlsQgvDYGe
        IUl6eOj1vfxXsYzWeNN+m8DvaTySIPgPRX+P89r0Gle16yWsU37IuGPrBAZHbY7U
        EHBY8CMKM3CkJgWrBCpgsxWHs+TZt+NNeEAN0cfX3eS+5d2T5391wQpsDp9h/dl/
        8HvLlZ+rThSbbMecCboo5H0PjYSpJVvC1Qu4SJ2WBmN3b5QrVR2Co7ISuyiMKK89
        R5wWGKUr0PeAg7wOLjBNZGyfvO/wfMEYl0PD6ZhkwQYTVqxGMbj8OUV6Ay9rPymA
        ==
X-ME-Sender: <xms:u6-bYATi6hZEs13YaTB8Xy9DbstGsAO6fA7nloHJzeA_bn1i-Mh3rw>
    <xme:u6-bYNzvt-Rp0ReAwDfCy7bkANCBFKAyfP91MnFkqPIWrx0NnY7IfXc1sS9pRTRTu
    qLEo9mpVdwIUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:u6-bYN0gAYKsy-owHSOyaAwfAwj0DwBlIfNOUlranqaFRcwJS0gB1w>
    <xmx:u6-bYED4oJTHdK9i0vTA-wcyJVMzLwvMlpFA-5fxHsAiJnZP8UT0XQ>
    <xmx:u6-bYJj31n6DJP53ByQQntAGpzMlxvQZYPhpz1kgfpSQK9Hg9-bdXw>
    <xmx:u6-bYJbLht9amFiT5AXyAyA3PMQkOABSDgItvk7hTjkh_4JR90BNzHtlxSw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:36:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Move RDPID emulation intercept to its own enum" failed to apply to 4.14-stable tree
To:     seanjc@google.com, jmattson@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:36:30 +0200
Message-ID: <1620815790226149@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2183de4161b90bd3851ccd3910c87b2c9adfc6ed Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 4 May 2021 10:17:23 -0700
Subject: [PATCH] KVM: x86: Move RDPID emulation intercept to its own enum

Add a dedicated intercept enum for RDPID instead of piggybacking RDTSCP.
Unlike VMX's ENABLE_RDTSCP, RDPID is not bound to SVM's RDTSCP intercept.

Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210504171734.1434054-5-seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 77e1c89a95a7..8a0ccdb56076 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4502,7 +4502,7 @@ static const struct opcode group8[] = {
  * from the register case of group9.
  */
 static const struct gprefix pfx_0f_c7_7 = {
-	N, N, N, II(DstMem | ModRM | Op3264 | EmulateOnUD, em_rdpid, rdtscp),
+	N, N, N, II(DstMem | ModRM | Op3264 | EmulateOnUD, em_rdpid, rdpid),
 };
 
 
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 0d359115429a..f016838faedd 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -468,6 +468,7 @@ enum x86_intercept {
 	x86_intercept_clgi,
 	x86_intercept_skinit,
 	x86_intercept_rdtscp,
+	x86_intercept_rdpid,
 	x86_intercept_icebp,
 	x86_intercept_wbinvd,
 	x86_intercept_monitor,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 46573b862638..4a625c748275 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7437,8 +7437,9 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	/*
 	 * RDPID causes #UD if disabled through secondary execution controls.
 	 * Because it is marked as EmulateOnUD, we need to intercept it here.
+	 * Note, RDPID is hidden behind ENABLE_RDTSCP.
 	 */
-	case x86_intercept_rdtscp:
+	case x86_intercept_rdpid:
 		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_RDTSCP)) {
 			exception->vector = UD_VECTOR;
 			exception->error_code_valid = false;

