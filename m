Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223E63826E9
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbhEQI0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:26:43 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:53811 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbhEQI0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:26:43 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id DB27D9FB;
        Mon, 17 May 2021 04:25:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 17 May 2021 04:25:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Hsjhyv
        rjbL4jaBKywWpEBaeFqnVvppFE3kjoerW2gIo=; b=EFD9ZV0DJyRe6f6/hPAU2H
        bRNTX5gTP7BOawG0DYSFR/SUA3acfcYNLJz4lE7QsQ2Un+zRSqOdK1a13O7VXaFu
        saEXSnlXbmCeGQCIRRQZo6EPyJqhhe4Fg6WLbyOX8oXaB2ozwxdzfdoOo+3O1p0x
        cnfGnRRwPZ/tP8DVvXgTjUZktMqjcy+PUYNTNRO7g0tjES+Go1hSZv+EfgwSXsli
        ci1R5exmBD3hNkaC+6H7qfX/o70cj+6fhXmC6CbIcd4eMScksDJYpk8hRAYj0Fcl
        rI4Wt4ZZnwbXsWgRKZnywpJqoyeWMb9eVe9zn9EzCblPqJjIe9BkrwSl7TxgCc/A
        ==
X-ME-Sender: <xms:diiiYI9A0yoN8mo88B9dbJksEtlYlQGVmk6gOm_p8HNImUMsfoKWkg>
    <xme:diiiYAsTvdV9nXkF3oxSXvzs2U0P8PcpsTkPEvb4rcVy3VqQnl0gNpRg0hiMp0oKO
    Y1H92FH-QBqTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:diiiYOBVIfADf4CkgVLdrlbi8gun66hpOm_WiWmaJ1ilwdChqdR_JA>
    <xmx:diiiYIc8vODT3dmYNweGLTmaUhpfxYr_aSSvVLA4egY-pSus9RH9Sg>
    <xmx:diiiYNPTPuk3xWBZxEwSjrB_lqmaDRJQHInjOEVJJzuB2hnbh0EXwQ>
    <xmx:diiiYL2xtZVervmrGGU75p2PI9JT_lk1ZiwuHdtpF141rq0yiD0B5MS_TaA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:25:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Move RDPID emulation intercept to its own enum" failed to apply to 4.4-stable tree
To:     seanjc@google.com, jmattson@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:25:24 +0200
Message-ID: <16212399243499@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

